import 'package:flutter/material.dart';
import 'package:general_insurance_management/firepolicy/view_money_receipt.dart';
import 'package:general_insurance_management/model/bill_model.dart';
import 'package:general_insurance_management/model/money_receipt_model.dart';
import 'package:general_insurance_management/model/policy_model.dart';
import 'package:general_insurance_management/service/bill_service.dart';
import 'package:general_insurance_management/service/money_receipt_service.dart';
import 'package:intl/intl.dart';


class UpdateFireMoneyReceipt extends StatefulWidget {
  const UpdateFireMoneyReceipt({Key? key,required this.moneyreceipt}) : super(key: key);

  final MoneyReceiptModel moneyreceipt ;

  @override
  State<UpdateFireMoneyReceipt> createState() => _UpdateFireMoneyReceiptState();
}

class _UpdateFireMoneyReceiptState extends State<UpdateFireMoneyReceipt> {
  final TextEditingController issuingOfficeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
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
    'Fire Insurance',
    'Marine Insurance',
    'Motor Insurance'
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
    _populateInitialData();
  }

  void _populateInitialData() {
    selectedClassOfInsurance = widget.moneyreceipt.classOfInsurance ?? '';
    selectedModeOfPayment = widget.moneyreceipt.modeOfPayment ?? '';
    issuingOfficeController.text = widget.moneyreceipt.issuingOffice ?? '';
    dateController.text = widget.moneyreceipt.date != null
        ? DateFormat('yyyy-MM-dd').format(widget.moneyreceipt.date!)
        : '';
    issuedAgainstController.text = widget.moneyreceipt.issuedAgainst ?? '';

    // Check if bill and policy are not null before accessing their fields
    selectedPolicyholder = widget.moneyreceipt.bill?.policy.policyholder ?? '';
    selectedBankName = widget.moneyreceipt.bill?.policy.bankName ?? '';
    selectedSumInsured = widget.moneyreceipt.bill?.policy.sumInsured ?? 0.0;
  }



  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      bills = await BillService().fetchFireBill();
      uniqueBankNames = bills.map((bill) => bill.policy.bankName).whereType<String>().toSet().toList();
      uniqueSumInsured = bills.map((bill) => bill.policy.sumInsured).whereType<double>().toSet().toList();

      if (bills.isNotEmpty) {
        setState(() {
          selectedPolicyholder = bills.first.policy.policyholder;
          selectedBankName = bills.first.policy.bankName ?? uniqueBankNames.first;
          selectedSumInsured = bills.first.policy.sumInsured ?? uniqueSumInsured.first;
        });
      }
    } catch (error) {
      _showErrorSnackBar('Error fetching data: $error');
      print('Error fetching data: $error');
    } finally {
      setState(() => isLoading = false);
    }
  }



  void _updateMoneyReceipt() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final selectedPolicy = bills.firstWhere(
              (bill) => bill.policy.policyholder == selectedPolicyholder,
        );

        if (selectedPolicy.id == null) {
          _showErrorSnackBar('Selected policy does not have a valid ID');
          return;
        }

        await moneyReceiptService.updateMoneyReceipt( widget.moneyreceipt.id!,
          MoneyReceiptModel(
            issuingOffice: issuingOfficeController.text,
            classOfInsurance: selectedClassOfInsurance?? '',
            modeOfPayment: selectedModeOfPayment?? '',
            date: DateTime.parse(dateController.text),
            issuedAgainst: issuedAgainstController.text,
            bill: selectedPolicy,
          ),

        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fire Money Receipt Updated successfully!')),
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
      appBar: AppBar(
        title: const Text('Update Fire Money Receipt Form'),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
              _buildSubmitButton()
            ],
          ),
        ),
      ),
    );
  }

  bool _isHovered = false;
  Widget _buildSubmitButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ElevatedButton(
        onPressed: _updateMoneyReceipt,
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
          "Update ",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
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

          // Find the first bill with the selected policyholder
          final selectedBill = bills.firstWhere(
                (bill) => bill.policy.policyholder == selectedPolicyholder,
            orElse: () => BillModel(
              policy: PolicyModel(bankName: null, sumInsured: null),
              fire: 0.0, // Default value
              rsd: 0.0, // Default value
              netPremium: 0.0, // Default value
              tax: 0.0, // Default value
              grossPremium: 0.0, // Default value
            ),
          );

          // Update bankName and sumInsured based on selected policyholder's policy
          selectedSumInsured = selectedBill.policy.sumInsured;
          selectedBankName = selectedBill.policy.bankName;
        });
      },
      decoration: _inputDecoration('Policyholder', Icons.person),
      items: bills.map<DropdownMenuItem<String>>((BillModel bill) {
        return DropdownMenuItem<String>(
          value: bill.policy.policyholder,
          child: Text(bill.policy.policyholder?? '', style: const TextStyle(fontSize: 14)),
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
          child: Text(bankName,  style: TextStyle(fontSize: 14)),
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
      decoration: _inputDecoration('Sum Insured', Icons.account_balance_wallet),
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
          initialDate: widget.moneyreceipt.date ?? DateTime.now(),
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
      fillColor: Colors.white,
    );
  }


}
