import 'package:flutter/material.dart';
import 'package:general_insurance_management/firepolicy/view_money_receipt.dart';
import 'package:general_insurance_management/model/bill_model.dart';
import 'package:general_insurance_management/model/money_receipt_model.dart';
import 'package:general_insurance_management/service/bill_service.dart';
import 'package:general_insurance_management/service/money_receipt_service.dart';
import 'package:intl/intl.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:general_insurance_management/model/marine_money_receipt_model.dart';
import 'package:general_insurance_management/service/marine_bill_service.dart';

class CreateFireMoneyReceipt extends StatefulWidget {
  const CreateFireMoneyReceipt({Key? key}) : super(key: key);

  @override
  State<CreateFireMoneyReceipt> createState() => _CreateFireMoneyReceiptState();
}

class _CreateFireMoneyReceiptState extends State<CreateFireMoneyReceipt> {
  final TextEditingController issuingOfficeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController modeOfPaymentController = TextEditingController();
  final TextEditingController issuedAgainstController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final MoneyReceiptService moneyReceiptService = MoneyReceiptService();

  List<BillModel> bills = [];
  List<String> uniqueBankNames = [];
  List<double> uniqueSumInsured = [];
  String? selectedPolicyholder;
  String? selectedBankName;
  double? selectedSumInsured;
  String? selectedClassOfInsurance;
  String? selectedModeOfPayment;
  bool isLoading = false;

  final List<String> classOfInsuranceOptions = [
    'Marine Insrurance',
    'Fire Insrurance',
    'Motor Insrurance'
  ];

  final List<String> modeOfPaymentOptions = [
    'Cash',
    'Credit Card',
    'Bank Transfer',
    'Cheque'
  ];

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
      bills = await BillService().fetchFireBill();
      uniqueBankNames = bills
          .map((bill) => bill.policy.bankName)
          .whereType<String>()
          .toSet()
          .toList();
      uniqueSumInsured = bills
          .map((bill) => bill.policy.sumInsured)
          .whereType<double>()
          .toSet()
          .toList();

      if (bills.isNotEmpty) {
        setState(() {
          selectedPolicyholder = bills.first.policy.policyholder;
          selectedBankName =
              bills.first.policy.bankName ?? uniqueBankNames.first;
          selectedSumInsured = bills.first.policy.sumInsured ??
              uniqueSumInsured.first;
        });
      }
    } catch (error) {
      _showErrorSnackBar('Error fetching data: $error');
      print('Error fetching data: $error'); // Log the error for debugging
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _createMoneyReceipt() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final selectedPolicy = bills.firstWhere(
              (bill) =>
              bill.policy.policyholder == selectedPolicyholder,
        );

        if (selectedPolicy.id == null) {
          _showErrorSnackBar('Selected policy does not have a valid ID');
          return;
        }

        await moneyReceiptService.createMoneyReceipt(
          MoneyReceiptModel(
            issuingOffice: issuingOfficeController.text,
            classOfInsurance: selectedClassOfInsurance!,
            modeOfPayment: selectedModeOfPayment!,
            date: dateController.text,
            issuedAgainst: issuedAgainstController.text,
            bill: selectedPolicy,
          ),
          selectedPolicy.id.toString(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Marine Money Receipt created successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AllFireMoneyReceiptView()),
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Fire Money Receipt")),
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
              _buildTextField(issuingOfficeController, 'Issuing Office',
                  Icons.production_quantity_limits_outlined),
              SizedBox(height: 20),
              _buildClassOfInsuranceDropdown(),
              SizedBox(height: 20),
              _buildDateField(),
              SizedBox(height: 20),
              _buildModeOfPaymentDropdown(),
              // Icons.attach_money),
              SizedBox(height: 20),
              _buildTextField(issuedAgainstController, 'Issued Against',
                  Icons.receipt),
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
      onPressed: isLoading ? null : _createMoneyReceipt,
      child: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text("Create Fire Money Receipt",
          style: TextStyle(fontWeight: FontWeight.w600)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: selectedPolicyholder,
      onChanged: isLoading
          ? null
          : (String? newValue) {
        setState(() {
          selectedPolicyholder = newValue;
          final selectedPolicy = bills.firstWhere(
                (bill) =>
            bill.policy.policyholder == newValue,
          );
          selectedSumInsured = selectedPolicy.policy.sumInsured;
          selectedBankName = selectedPolicy.policy.bankName;
        });
      },
      decoration: _inputDecoration('Policyholder', Icons.person),
      items: bills
          .map<DropdownMenuItem<String>>((BillModel bill) {
        return DropdownMenuItem<String>(
          value: bill.policy.policyholder,
          child: Text(bill.policy.policyholder ?? ''),
        );
      }).toList(),
    );
  }

  Widget _buildDropdownBankNameField() {
    return DropdownButtonFormField<String>(
      value: selectedBankName,
      onChanged: isLoading
          ? null
          : (String? newValue) {
        setState(() {
          selectedBankName = newValue;
        });
      },
      decoration: _inputDecoration('Bank Name', Icons.account_balance),
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
      onChanged: isLoading
          ? null
          : (double? newValue) {
        setState(() {
          selectedSumInsured = newValue;
        });
      },
      decoration: _inputDecoration('Sum Insured', Icons.monetization_on),
      items:
      uniqueSumInsured.map<DropdownMenuItem<double>>((double sumInsured) {
        return DropdownMenuItem<double>(
          value: sumInsured,
          child: Text(sumInsured.toString()),
        );
      }).toList(),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label, icon),
      validator: (value) =>
      value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: dateController,
      decoration: _inputDecoration('Date', Icons.date_range),
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
          setState(() {
            dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
      validator: (value) =>
      value == null || value.isEmpty ? 'Please select a date' : null,
    );
  }

  Widget _buildClassOfInsuranceDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedClassOfInsurance,
      onChanged: (String? newValue) {
        setState(() {
          selectedClassOfInsurance = newValue;
        });
      },
      decoration: _inputDecoration('Class of Insurance', Icons.category),
      items:
      classOfInsuranceOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) =>
      value == null || value.isEmpty ? 'Please select a class' : null,
    );
  }

  Widget _buildModeOfPaymentDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedModeOfPayment,
      onChanged: (String? newValue) {
        setState(() {
          selectedModeOfPayment = newValue;
        });
      },
      decoration: _inputDecoration('Mode of Payment', Icons.category),
      items: modeOfPaymentOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) =>
      value == null || value.isEmpty ? 'Please select a Payment' : null,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      isDense: true,
      contentPadding:
      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
