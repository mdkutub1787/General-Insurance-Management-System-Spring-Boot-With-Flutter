import 'package:flutter/material.dart';
import 'package:general_insurance_management/firepolicy/view_fire_bill.dart';
import 'package:general_insurance_management/model/bill_model.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:general_insurance_management/model/marine_policy_model.dart';
import 'package:general_insurance_management/service/marine_bill_service.dart';
import 'package:general_insurance_management/service/marine_policy_service.dart';

class UpdateFireBill extends StatefulWidget {
  const UpdateFireBill({super.key, required this.bill, });

  final BillModel bill;

  @override
  State<UpdateFireBill> createState() => _CreateMarineBillState();
}

class _CreateMarineBillState extends State<UpdateFireBill> {
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
    // marineRateController.text = widget.marineBill.marineRate.toString();
    // warSrccRateController.text = widget.marineBill.warSrccRate.toString();
    // netPremiumController.text = widget.marineBill.netPremium.toString();
    // taxController.text = widget.marineBill.tax.toString();
    // stampDutyController.text = widget.marineBill.stampDuty.toString();
    // grossPremiumController.text = widget.marineBill.grossPremium.toString();
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
        final selectedPolicy = policies.firstWhere(
              (policy) => policy.policyholder == selectedPolicyholder,
          orElse: () => MarinePolicyModel(policyholder: '', id: null),
        );

        if (selectedPolicy.id == null) {
          _showErrorSnackBar('Selected policy does not have a valid ID');
          return;
        }

        await marineBillService.updateMarineBill(
          MarineBillModel(
            marineRate: double.parse(marineRateController.text),
            warSrccRate: double.parse(warSrccRateController.text),
            netPremium: double.parse(netPremiumController.text),
            tax: double.parse(taxController.text),
            stampDuty: double.parse(stampDutyController.text),
            grossPremium:double.parse(grossPremiumController.text),
            marineDetails: selectedPolicy,
          ) as int,
          selectedPolicy.id.toString() as MarineBillModel,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Marine bill updated successfully!')),
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
      appBar: AppBar(title: Text("Update Marine Bill")),
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
                onPressed: isLoading ? null : _updateMarineBill,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Update Marine Bill", style: TextStyle(fontWeight: FontWeight.w600)),
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
      ),
      items: policies.map<DropdownMenuItem<String>>((MarinePolicyModel policy) {
        return DropdownMenuItem<String>(
          value: policy.policyholder,
          child: Text(policy.policyholder ?? ''),
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
      decoration: InputDecoration(
        labelText: 'Bank Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.food_bank),
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
        prefixIcon: Icon(Icons.attach_money),
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
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid value';
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
      ),
      keyboardType: TextInputType.number,
    );
  }
}
