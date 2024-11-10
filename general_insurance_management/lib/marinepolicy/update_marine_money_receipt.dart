import 'package:flutter/material.dart';
import 'package:general_insurance_management/marinepolicy/view_marine_money_receipt.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:general_insurance_management/model/marine_policy_model.dart';
import 'package:general_insurance_management/model/marine_money_receipt_model.dart';
import 'package:general_insurance_management/service/marine_bill_service.dart';
import 'package:general_insurance_management/service/marine_money_receipt_service.dart';
import 'package:intl/intl.dart';


class UpdateMarineMoneyReceipt extends StatefulWidget {
  const UpdateMarineMoneyReceipt({Key? key,required this.moneyreceipt}) : super(key: key);

  final MarineMoneyReceiptModel moneyreceipt ;

  @override
  State<UpdateMarineMoneyReceipt> createState() => _UpdateMarineMoneyReceiptState();
}

class _UpdateMarineMoneyReceiptState extends State<UpdateMarineMoneyReceipt> {
  final TextEditingController issuingOfficeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController issuedAgainstController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final MarineMoneyReceiptService marineMarineMoneyReceiptService = MarineMoneyReceiptService();

  List<MarineBillModel> marinebills = [];
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

    // Set the current date to the dateController
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }


  void _populateInitialData() {
    selectedClassOfInsurance = widget.moneyreceipt.classOfInsurance ?? '';
    selectedModeOfPayment = widget.moneyreceipt.modeOfPayment ?? '';
    issuingOfficeController.text = widget.moneyreceipt.issuingOffice ?? '';
    dateController.text = widget.moneyreceipt.date?.toString() ?? '';
    issuedAgainstController.text = widget.moneyreceipt.issuedAgainst ?? '';

    // Check if bill and policy are not null before accessing their fields
    selectedPolicyholder = widget.moneyreceipt.marinebill?.marineDetails.policyholder ?? '';
    selectedBankName = widget.moneyreceipt.marinebill?.marineDetails.bankName ?? '';
    selectedSumInsured = widget.moneyreceipt.marinebill?.marineDetails.sumInsured ?? 0.0;
  }
  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      marinebills = await MarineBillService().getMarineBills();
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
      print('Error fetching data: $error');
    } finally {
      setState(() => isLoading = false);
    }
  }



  void _updateMarineMoneyReceipt() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final selectedPolicy = marinebills.firstWhere(
              (marinebill) => marinebill.marineDetails.policyholder == selectedPolicyholder,
        );

        if (selectedPolicy.id == null) {
          _showErrorSnackBar('Selected marineDetails does not have a valid ID');
          return;
        }

        await marineMarineMoneyReceiptService.updateMarineMoneyReceipt( widget.moneyreceipt.id!,
          MarineMoneyReceiptModel(
            issuingOffice: issuingOfficeController.text,
            classOfInsurance: selectedClassOfInsurance!,
            modeOfPayment: selectedModeOfPayment!,
            date: DateTime.parse(dateController.text),
            issuedAgainst: issuedAgainstController.text,
            marinebill: selectedPolicy,
          ),

        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Marine Money Receipt Updated successfully!')),
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
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Marine Money Receipt Form'),
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
        onPressed: _updateMarineMoneyReceipt,
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

          // Find the first marinebill with the selected marineDetailsholder
          final selectedBill = marinebills.firstWhere(
                (marinebill) => marinebill.marineDetails.policyholder == selectedPolicyholder,
            orElse: () => MarineBillModel(
              marineDetails: MarinePolicyModel(bankName: null, sumInsured: null),
              marineRate: 0.0, // Default value
              warSrccRate: 0.0, // Default value
              netPremium: 0.0, // Default value
              tax: 0.0, // Default value
              stampDuty: 0.0, // Default value
              grossPremium: 0.0, // Default value
            ),
          );

          // Update bankName and sumInsured based on selected marineDetailsholder's marineDetails
          selectedSumInsured = selectedBill.marineDetails.sumInsured;
          selectedBankName = selectedBill.marineDetails.bankName;
        });
      },
      decoration: _inputDecoration('Policyholder', Icons.person),
      items: marinebills.map<DropdownMenuItem<String>>((MarineBillModel marinebill) {
        return DropdownMenuItem<String>(
          value: marinebill.marineDetails.policyholder,
          child: Text(marinebill.marineDetails.policyholder?? '', style: const TextStyle(fontSize: 14)),
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
