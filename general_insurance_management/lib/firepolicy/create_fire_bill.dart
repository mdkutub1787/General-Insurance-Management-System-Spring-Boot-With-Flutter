import 'package:flutter/material.dart';
import 'package:general_insurance_management/firepolicy/view_fire_bill.dart';
import 'package:general_insurance_management/model/bill_model.dart';
import 'package:general_insurance_management/model/policy_model.dart';
import 'package:general_insurance_management/service/bill_service.dart';
import 'package:general_insurance_management/service/policy_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateFireBill extends StatefulWidget {
  const CreateFireBill({super.key});

  @override
  State<CreateFireBill> createState() => _CreateFireBillState();
}

class _CreateFireBillState extends State<CreateFireBill> {
  final TextEditingController fireController = TextEditingController();
  final TextEditingController rsdController = TextEditingController();
  final TextEditingController netPremiumController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController grossPremiumController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final BillService billService = BillService();

  List<PolicyModel> policies = [];
  List<PolicyModel> filteredPolicies = [];
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
      policies = await PolicyService().fetchPolicies();
      filteredPolicies = List.from(policies); // Initialize with all policies
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
    fireController.addListener(_updateCalculatedFields);
    rsdController.addListener(_updateCalculatedFields);
    taxController.addListener(_updateCalculatedFields);

  }

  void _updateCalculatedFields() {
    calculatePremiums();
  }

  void _CreateFireBill() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      try {
        final selectedPolicy = policies.firstWhere(
              (policy) => policy.policyholder == selectedPolicyholder,
          orElse: () => PolicyModel(policyholder: '', id: null),
        );

        if (selectedPolicy.id == null) {
          _showErrorSnackBar('Selected policy does not have a valid ID');
          return;
        }

        await billService.createFireBill(
          BillModel(
            fire: double.parse(fireController.text),
            rsd: double.parse(rsdController.text),
            netPremium: _parseControllerValue(netPremiumController.text),
            tax: _parseControllerValue(taxController.text),
            grossPremium: _parseControllerValue(grossPremiumController.text),
            policy: selectedPolicy,
          ),
          selectedPolicy.id.toString(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fire  Bill Created Successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllFireBillView()),
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
    double fire = _parseControllerValue(fireController.text);
    double rsd = _parseControllerValue(rsdController.text);
    const double taxRate = 15.0; // Fixed tax rate at 15%

    if (fire > 100 || rsd > 100 || taxRate > 100) {
      _showErrorSnackBar('Rates must be less than or equal to 100%.');
      return;
    }

    // Calculate netPremium, tax, and grossPremium
    double netPremium = (sumInsured * (fire + rsd)) / 100;
    double tax = taxRate;
    double grossPremium = netPremium + (netPremium * taxRate) / 100;

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
        title: const Text('Create Fire Bill Form'),
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
              const SizedBox(height: 20),
              _buildDropdownField(),
              const SizedBox(height: 20),
              _buildDropdownBankNameField(),
              SizedBox(height: 20),
              _buildDropdownSumInsuredField(),
              SizedBox(height: 20),
              _buildTextField(fireController, 'Fire Rate', Icons.production_quantity_limits_outlined),
              SizedBox(height: 20),
              _buildTextField(rsdController, ' Rsd Rate', Icons.storage),
              SizedBox(height: 20),
              _buildReadOnlyField(netPremiumController, 'Net Premium', Icons.monetization_on),
              SizedBox(height: 20),
              _buildReadOnlyField(taxController, 'Tax  Rate', Icons.attach_money),
              SizedBox(height: 20),
              _buildReadOnlyField(grossPremiumController, 'Gross Premium', Icons.monetization_on),
              SizedBox(height: 20),
              _buildSubmitButton(),
              const SizedBox(height: 20),
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
            orElse: () => PolicyModel(bankName: null, sumInsured: null),
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
          child: Text(policyholder,  style: TextStyle(fontSize: 14)),
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
        onPressed: _CreateFireBill,
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
          "Create Fire Bill",
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
