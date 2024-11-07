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
    double tax = taxRate / 100;
    double grossPremium = netPremium+(netPremium * tax )+ stampDuty;

    // Update form controllers with calculated values
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
      appBar: AppBar(title: Text("Create Marine Bill")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              ElevatedButton(
                onPressed: isLoading ? null : _createMarineBill,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Create Marine Bill", style: TextStyle(fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
              ),
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
      decoration: InputDecoration(
        labelText: 'Policyholder',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
        labelStyle: TextStyle(color: Colors.black, fontSize: 16), // Updated label style
        isDense: true, // Dense style for less height
        contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 8), // Content padding
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey), // Border color
        ),
      ),
      items: policies.map<DropdownMenuItem<String>>((MarinePolicyModel policy) {
        return DropdownMenuItem<String>(
          value: policy.policyholder,
          child: Text(policy.policyholder!),
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
          final selectedPolicy = policies.firstWhere(
                (policy) => policy.bankName == newValue,
            orElse: () => MarinePolicyModel(policyholder: '', id: null, sumInsured: 0.0, bankName: ''),
          );
          selectedSumInsured = selectedPolicy.sumInsured;
        });
      },
      decoration: InputDecoration(
        labelText: 'Bank Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.account_balance),
        labelStyle: TextStyle(color: Colors.black, fontSize: 16), // Updated label style
        isDense: true, // Dense style for less height
        contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 8), // Content padding
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey), // Border color
        ),
      ),
      items: uniqueBankNames.map<DropdownMenuItem<String>>((String bankName) {
        return DropdownMenuItem<String>(
          value: bankName,
          child: Text(bankName),
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
      decoration: InputDecoration(
        labelText: 'Sum Insured',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.money),
        labelStyle: TextStyle(color: Colors.black, fontSize: 16), // Updated label style
        isDense: true, // Dense style for less height
        contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 8), // Content padding
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey), // Border color
        ),
      ),
      items: uniqueSumInsured.map<DropdownMenuItem<double>>((double sumInsured) {
        return DropdownMenuItem<double>(
          value: sumInsured,
          child: Text(sumInsured.toString()),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
        labelStyle: TextStyle(color: Colors.black, fontSize: 16), // Updated label style
        isDense: true, // Dense style for less height
        contentPadding: EdgeInsets.symmetric(vertical: 3, horizontal: 8), // Content padding
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey), // Border color
        ),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildReadOnlyField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        isDense: true, // Dense style for less height
        contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );


  }
}