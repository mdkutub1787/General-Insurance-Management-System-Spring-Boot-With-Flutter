import 'package:flutter/material.dart';
import 'package:general_insurance_management/marinepolicy/view_maeine_bill.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:general_insurance_management/model/marine_policy_model.dart';
import 'package:general_insurance_management/service/marine_bill_service.dart';
import 'package:general_insurance_management/service/marine_policy_service.dart';

class UpdateMarineBill extends StatefulWidget {
  const UpdateMarineBill({super.key, required this.marineBill});

  final MarineBillModel marineBill;

  @override
  State<UpdateMarineBill> createState() => _CreateMarineBillState();
}

class _CreateMarineBillState extends State<UpdateMarineBill> {
  final TextEditingController marineRateController = TextEditingController();
  final TextEditingController warSrccRateController = TextEditingController();
  final TextEditingController netPremiumController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController stampDutyController = TextEditingController();
  final TextEditingController grossPremiumController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final MarineBillService marineBillService = MarineBillService();

  List<MarinePolicyModel> policies = [];
  List<String> uniqueBankNames = [];
  List<double> uniqueSumInsured = [];
  String? selectedPolicyholder;
  String? selectedBankName;
  double? selectedSumInsured;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _setupListeners();
    _populateInitialData();
  }

  void _populateInitialData() {
    marineRateController.text = widget.marineBill.marineRate.toString();
    warSrccRateController.text = widget.marineBill.warSrccRate.toString();
    netPremiumController.text = widget.marineBill.netPremium.toString();
    taxController.text = widget.marineBill.tax.toString();
    stampDutyController.text = widget.marineBill.stampDuty.toString();
    grossPremiumController.text = widget.marineBill.grossPremium.toString();
  }

  Future<void> _fetchData() async {
    try {
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

  void _setupListeners() {
    marineRateController.addListener(_updateCalculatedFields);
    warSrccRateController.addListener(_updateCalculatedFields);
    taxController.addListener(_updateCalculatedFields);
    stampDutyController.addListener(_updateCalculatedFields);
  }

  void _updateCalculatedFields() {
    calculatePremiums();
  }

  void _updateMarineBill() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        // Find the selected policy
        final selectedPolicy = policies.firstWhere(
              (policy) => policy.policyholder == selectedPolicyholder,
          orElse: () => MarinePolicyModel(policyholder: '', id: null),
        );

        // Ensure the policy has a valid ID
        if (selectedPolicy.id == null) {
          _showErrorSnackBar('Selected policy does not have a valid ID');
          return;
        }

        // Create a MarineBillModel instance with the input data
        MarineBillModel marineBill = MarineBillModel(
          marineRate: double.parse(marineRateController.text),
          warSrccRate: double.parse(warSrccRateController.text),
          netPremium: double.parse(netPremiumController.text),
          tax: double.parse(taxController.text),
          stampDuty: double.parse(stampDutyController.text),
          grossPremium: double.parse(grossPremiumController.text),
          marineDetails: selectedPolicy,
        );

        // Call the service to update the marine bill, passing correct parameters
        await marineBillService.updateMarineBill(selectedPolicy.id!, marineBill);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Marine bill updated successfully!')),
        );

        // Navigate back to the view
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllMarineBillView()),
        );
      } catch (error) {
        // Log the error and show it in a Snackbar
        print('Error updating marine bill: $error');
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
    double tax = taxRate / 100;
    double grossPremium = netPremium+(netPremium * tax )+ stampDuty;

    setState(() {
      netPremiumController.text = netPremium.toStringAsFixed(2);
      taxController.text = tax.toStringAsFixed(2);
      grossPremiumController.text = grossPremium.toStringAsFixed(2);
    });
  }

  double _parseControllerValue(String value) {
    return double.tryParse(value) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Marine Bill Form'),
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

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: selectedPolicyholder,
      onChanged: isLoading ? null : (String? newValue) {
        setState(() {
          selectedPolicyholder = newValue;
          final selectedPolicy = policies.firstWhere(
                (policy) => policy.policyholder == newValue,
            orElse: () => MarinePolicyModel(policyholder: '', id: null, sumInsured: 0.0, bankName: ''),
          );
          selectedSumInsured = selectedPolicy.sumInsured;
          selectedBankName = selectedPolicy.bankName;
        });
      },
      decoration: _buildInputDecoration('Policyholder', Icons.person),
      items: policies.map<DropdownMenuItem<String>>((MarinePolicyModel policy) {
        return DropdownMenuItem<String>(
          value: policy.policyholder,
          child: Text(policy.policyholder ?? '', style: TextStyle(fontSize: 14)),
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
      decoration: _buildInputDecoration('Bank Name', Icons.food_bank),
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
        onPressed: _updateMarineBill,
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
