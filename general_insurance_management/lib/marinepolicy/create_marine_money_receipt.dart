import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:general_insurance_management/marinepolicy/view_marine_money_receipt.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:general_insurance_management/model/marine_money_receipt_model.dart';
import 'package:general_insurance_management/service/marine_bill_service.dart';
import 'package:general_insurance_management/service/marine_money_receipt_service.dart';

class CreateMarineMoneyReceipt extends StatefulWidget {
  const CreateMarineMoneyReceipt({Key? key}) : super(key: key);

  @override
  State<CreateMarineMoneyReceipt> createState() => _CreateMarineMoneyReceiptState();
}

class _CreateMarineMoneyReceiptState extends State<CreateMarineMoneyReceipt> {
  final TextEditingController issuingOfficeController = TextEditingController();
  final TextEditingController classOfInsuranceController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController modeOfPaymentController = TextEditingController();
  final TextEditingController issuedAgainstController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final MarineMoneyReceiptService marineMoneyReceiptService = MarineMoneyReceiptService();

  List<MarineBillModel> marinebills = [];
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

    // Set the current date to the dateController
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      marinebills = await MarineBillService().getMarineBill();
      uniqueBankNames = marinebills.map((marinebill) => marinebill.marineDetails.bankName).whereType<String>().toSet().toList();
      uniqueSumInsured = marinebills.map((marinebill) => marinebill.marineDetails.sumInsured).whereType<double>().toSet().toList();

      if (marinebills.isNotEmpty) {
        setState(() {
          selectedPolicyholder = marinebills.first.marineDetails.policyholder;
          selectedBankName = marinebills.first.marineDetails.bankName ?? uniqueBankNames.first;
          selectedSumInsured = marinebills.first.marineDetails.sumInsured ?? uniqueSumInsured.first;
        });
      }
    } catch (error) {
      _showErrorSnackBar('Error fetching data: $error');
      print('Error fetching data: $error');  // Log the error for debugging
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _createMarineMoneyReceipt() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final selectedPolicy = marinebills.firstWhere(
              (marinebill) => marinebill.marineDetails.policyholder == selectedPolicyholder,

        );

        if (selectedPolicy.id == null) {
          _showErrorSnackBar('Selected policy does not have a valid ID');
          return;
        }


        await marineMoneyReceiptService.createMarineMoneyReceipt(
          MarineMoneyReceiptModel(
            issuingOffice: issuingOfficeController.text,
            classOfInsurance: classOfInsuranceController.text,
            date: DateTime.parse(dateController.text),
            modeOfPayment: modeOfPaymentController.text,
            issuedAgainst: issuedAgainstController.text,
            marinebill: selectedPolicy,
          ),
          selectedPolicy.id.toString(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Marine Money Receipt created successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllMarineMoneyReceiptView()),
        );
      } catch (error) {
        _showErrorSnackBar('Error: $error');
        print('Error creating receipt: $error');
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Marine Money Receipt")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
              _buildTextField(issuingOfficeController, 'Issuing Office', Icons.production_quantity_limits_outlined),
              SizedBox(height: 20),
              _buildTextField(classOfInsuranceController, 'Class of Insurance', Icons.storage),
              SizedBox(height: 20),
              _buildDateField(),
              SizedBox(height: 20),
              _buildTextField(modeOfPaymentController, 'Mode of Payment', Icons.attach_money),
              SizedBox(height: 20),
              _buildTextField(issuedAgainstController, 'Issued Against', Icons.receipt),
              SizedBox(height: 20),
              _buildCreateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : _createMarineMoneyReceipt,
      child: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text("Create Marine Money Receipt", style: TextStyle(fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: selectedPolicyholder,
      onChanged: isLoading ? null : (String? newValue) {
        setState(() {
          selectedPolicyholder = newValue;
          final selectedPolicy = marinebills.firstWhere(
                (marinebill) => marinebill.marineDetails.policyholder == newValue,

          );
          selectedSumInsured = selectedPolicy.marineDetails.sumInsured;
          selectedBankName = selectedPolicy.marineDetails.bankName;
        });
      },
      decoration: InputDecoration(
        labelText: 'Policyholder',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      items: marinebills.map<DropdownMenuItem<String>>((MarineBillModel marinebill) {
        return DropdownMenuItem<String>(
          value: marinebill.marineDetails.policyholder,
          child: Text(marinebill.marineDetails.policyholder ?? ''),
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
        prefixIcon: Icon(Icons.account_balance),
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
        prefixIcon: Icon(Icons.monetization_on),
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
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: dateController,
      decoration: InputDecoration(
        labelText: 'Date',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.date_range),
      ),
      readOnly: true,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode()); // Unfocus the field
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );

        if (pickedDate != null) {
          dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
    );
  }
}
