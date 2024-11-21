import 'package:flutter/material.dart';
import 'package:general_insurance_management/marinepolicy/view_maeine_bill.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:general_insurance_management/model/marine_policy_model.dart';
import 'package:general_insurance_management/service/marine_bill_service.dart';
import 'package:general_insurance_management/service/marine_policy_service.dart';

class CreateMarineBill extends StatefulWidget {
  const CreateMarineBill({super.key});

  @override
  State<CreateMarineBill> createState() => _CreateMarineBillState();
}

class _CreateMarineBillState extends State<CreateMarineBill> {
  final TextEditingController marineRateController = TextEditingController();
  final TextEditingController warSrccRateController = TextEditingController();
  final TextEditingController netPremiumController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController stampDutyController = TextEditingController();
  final TextEditingController grossPremiumController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final MarineBillService marineBillService = MarineBillService();

  List<MarinePolicyModel> filteredPolicies = [];
  List<MarinePolicyModel> policies = [];
  List<String> uniqueBankNames = [];
  List<double> uniqueSumInsured = [];
  String? selectedPolicyholder;
  String? selectedBankName;
  double? selectedSumInsured;
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _fetchData();
    _setupListeners();
    searchController.addListener(_filterPolicyholders);
  }

  Future<void> _fetchData() async {
    try {
      filteredPolicies = List.from(policies); // Initialize with all policies
      policies = await MarinePolicyService().fetchMarinePolicies();
      uniqueBankNames = policies
          .map((policy) => policy.bankName)
          .where((bankName) => bankName != null)
          .cast<String>()
          .toSet()
          .toList();

      uniqueSumInsured = policies
          .map((policy) => policy.sumInsured)
          .where((sumInsured) => sumInsured != null)
          .cast<double>()
          .toSet()
          .toList();

      setState(() {
        if (policies.isNotEmpty) {
          selectedPolicyholder = policies.first.policyholder;
          selectedBankName = policies.first.bankName ?? uniqueBankNames.first;
          selectedSumInsured = policies.first.sumInsured ?? uniqueSumInsured.first;
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
  }

  void _filterPolicyholders() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredPolicies = policies.where((policy) {
        return policy.policyholder?.toLowerCase().contains(query) ?? false;
      }).toList();
    });
  }

  void _setupListeners() {
    marineRateController.addListener(_updateCalculatedFields);
    warSrccRateController.addListener(_updateCalculatedFields);
    taxController.addListener(_updateCalculatedFields);
    stampDutyController.addListener(_updateCalculatedFields);
  }

  void _updateCalculatedFields() {
    calculatePremiums();
  }

  void _createMarineBill() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final selectedPolicy = policies.firstWhere(
              (policy) => policy.policyholder == selectedPolicyholder,
          orElse: () => MarinePolicyModel(policyholder: '', id: null),
        );

        if (selectedPolicy.id == null) {
          _showErrorSnackBar('Selected policy does not have a valid ID');
          return;
        }

        await marineBillService.createMarineBill(
          MarineBillModel(
            marineRate: double.parse(marineRateController.text),
            warSrccRate: double.parse(warSrccRateController.text),
            netPremium: _parseControllerValue(netPremiumController.text),
            tax: _parseControllerValue(taxController.text),
            stampDuty: _parseControllerValue(stampDutyController.text),
            grossPremium: _parseControllerValue(grossPremiumController.text),
            marineDetails: selectedPolicy,
          ),
          selectedPolicy.id.toString(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Marine bill created successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllMarineBillView()),
        );
      } catch (error) {
        _showErrorSnackBar('Error: $error');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void calculatePremiums() {
    // Retrieve values from the form controllers
    double sumInsured = selectedSumInsured ?? 0.0;
    double marineRate = _parseControllerValue(marineRateController.text);
    double warSrccRate = _parseControllerValue(warSrccRateController.text);
    double stampDuty = _parseControllerValue(stampDutyController.text);
    const double taxRate = 15.0; // Fixed tax rate at 15%

    if (marineRate > 100 || warSrccRate > 100 || taxRate > 100) {
      _showErrorSnackBar('Rates must be less than or equal to 100%.');
      return;
    }

    // Calculate netPremium, tax, and grossPremium
    double netPremium = (sumInsured * (marineRate + warSrccRate)) / 100;
    double tax = taxRate;
    double grossPremium = netPremium + (netPremium * tax) / 100 + stampDuty;

    // Round netPremium and grossPremium according to the .50+ rule
    netPremium = (netPremium + 0.5).toInt().toDouble(); // Round up if >= 0.50
    grossPremium = (grossPremium + 0.5).toInt().toDouble(); // Round up if >= 0.50

    // Update form controllers with rounded values
    setState(() {
      netPremiumController.text = netPremium.toStringAsFixed(0); // No decimals after rounding
      taxController.text = tax.toStringAsFixed(2);  // Tax remains with 2 decimal places
      grossPremiumController.text = grossPremium.toStringAsFixed(0); // No decimals after rounding
    });
  }


  double _parseControllerValue(String value) {
    return double.tryParse(value) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Marine Bill Form'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.yellow.withOpacity(0.8),
                Colors.green.withOpacity(0.8),
                Colors.orange.withOpacity(0.8),
                Colors.red.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              _buildSearchField(),
               SizedBox(height: 20),
              _buildDropdownField(),
              SizedBox(height: 20),
              _buildDropdownBankNameField(),
              SizedBox(height: 20),
              _buildDropdownSumInsuredField(),
              SizedBox(height: 20),
              _buildTextField(marineRateController, 'Marine Rate', Icons.production_quantity_limits_outlined),
              SizedBox(height: 20),
              _buildTextField(warSrccRateController, 'War SRCC Rate', Icons.storage),
              SizedBox(height: 20),
              _buildReadOnlyField(netPremiumController, 'Net Premium', Icons.monetization_on),
              SizedBox(height: 20),
              _buildReadOnlyField(taxController, 'Tax', Icons.attach_money),
              SizedBox(height: 20),
              _buildTextField(stampDutyController, 'Stamp Duty', Icons.receipt),
              SizedBox(height: 20),
              _buildReadOnlyField(grossPremiumController, 'Gross Premium', Icons.monetization_on),
              SizedBox(height: 20),
              _buildSubmitButton(),
              SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      decoration: _buildInputDecoration('Search Policyholder',Icons.search),
    );
  }

  Widget _buildDropdownField() {
    final uniquePolicyholders = {
      for (var policy in filteredPolicies) policy.policyholder
    }.where((policyholder) => policyholder != null).cast<String>().toList();
    return DropdownButtonFormField<String>(
      value: uniquePolicyholders.contains(selectedPolicyholder) ? selectedPolicyholder : null,
      onChanged: isLoading ? null : (String? newValue) {
        setState(() {
          selectedPolicyholder = newValue;
          // Filter policies to get bankName and sumInsured for the selected policyholder
          final selectedPolicy = policies.firstWhere(
                (policy) => policy.policyholder == selectedPolicyholder,
            orElse: () => MarinePolicyModel(bankName: null, sumInsured: null),
          );
          // Update bankName and sumInsured based on selected policyholder
          selectedBankName = selectedPolicy.bankName;
          selectedSumInsured = selectedPolicy.sumInsured;
        });
      },
      decoration: _buildInputDecoration('Policy Holder', Icons.person),
      items: uniquePolicyholders.map<DropdownMenuItem<String>>((String policyholder) {
        return DropdownMenuItem<String>(
          value: policyholder,
          child: Text(policyholder,style: TextStyle(fontSize: 14)),
        );
      }).toList(),

    );
  }

  Widget _buildDropdownBankNameField() {
    return DropdownButtonFormField<String>(
      value: selectedBankName,
      onChanged: isLoading ? null : (String? newValue) {
        setState(() {
          selectedBankName = newValue;
        });
      },
      decoration: _buildInputDecoration('Bank Name', Icons.account_balance),
      items: uniqueBankNames.map<DropdownMenuItem<String>>((String bankName) {
        return DropdownMenuItem<String>(
          value: bankName,
          child: Text(bankName ,style: TextStyle(fontSize: 14)),
        );
      }).toList(),
    );
  }

  Widget _buildDropdownSumInsuredField() {
    return DropdownButtonFormField<double>(
      value: selectedSumInsured,
      onChanged: isLoading ? null : (double? newValue) {
        setState(() {
          selectedSumInsured = newValue;
        });
      },
      decoration: _buildInputDecoration('Sum Insured', Icons.account_balance_wallet),
      items: uniqueSumInsured.map<DropdownMenuItem<double>>((double sumInsured) {
        return DropdownMenuItem<double>(
          value: sumInsured,
          child: Text(sumInsured.toStringAsFixed(2)),
        );
      }).toList(),
    );
  }


  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: _buildInputDecoration(label, icon),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        return null;
      },
    );
  }

  Widget _buildReadOnlyField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: _buildInputDecoration(label, icon),
    );
  }


  bool _isHovered = false;
  Widget _buildSubmitButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ElevatedButton(
        onPressed: _createMarineBill,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isHovered ? Colors.green : Colors.blueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.pink,  // Shadow color
          elevation: _isHovered ? 12 : 4,  // Higher elevation on hover
        ),
        child: const Text(
          "Submit",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  InputDecoration _buildInputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        color: Colors.grey,
      ),
      prefixIcon: Icon(icon, color: Colors.green),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: const BorderSide(color: Colors.green, width: 1.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: const BorderSide(color: Colors.green, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
        borderSide: const BorderSide(color: Colors.purple, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      isDense: true,
    );
  }
}
