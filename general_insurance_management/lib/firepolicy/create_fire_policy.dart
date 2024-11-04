import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:general_insurance_management/firepolicy/view_fire_policy.dart';
import 'package:general_insurance_management/model/policy_model.dart';
import 'package:general_insurance_management/service/create_policy_service.dart';
import 'package:intl/intl.dart';

class CreateFirePolicy extends StatefulWidget {
  const CreateFirePolicy({Key? key}) : super(key: key);

  @override
  State<CreateFirePolicy> createState() => _CreateFirePolicyState();
}

class _CreateFirePolicyState extends State<CreateFirePolicy> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController policyholderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController stockInsuredController = TextEditingController();
  final TextEditingController sumInsuredController = TextEditingController();
  final TextEditingController interestInsuredController = TextEditingController();
  final TextEditingController coverageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController constructionController = TextEditingController();
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController usedAsController = TextEditingController();
  final TextEditingController periodFromController = TextEditingController();
  final TextEditingController periodToController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final CreateFirePolicyService firePolicyService = CreateFirePolicyService();

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    dateController.dispose();
    bankNameController.dispose();
    policyholderController.dispose();
    addressController.dispose();
    stockInsuredController.dispose();
    sumInsuredController.dispose();
    interestInsuredController.dispose();
    coverageController.dispose();
    locationController.dispose();
    constructionController.dispose();
    ownerController.dispose();
    usedAsController.dispose();
    periodFromController.dispose();
    periodToController.dispose();
    super.dispose();
  }

  void _createFirePolicy() async {
    if (_formKey.currentState!.validate()) {
      PolicyModel policy = PolicyModel(
        date: DateTime.parse(dateController.text),
        bankName: bankNameController.text,
        policyholder: policyholderController.text,
        address: addressController.text,
        stockInsured: stockInsuredController.text,
        sumInsured: double.tryParse(sumInsuredController.text) ?? 0,
        interestInsured: interestInsuredController.text,
        coverage: coverageController.text,
        location: locationController.text,
        construction: constructionController.text,
        owner: ownerController.text,
        usedAs: usedAsController.text,
        periodFrom: DateTime.parse(periodFromController.text),
        periodTo: DateTime.parse(periodToController.text),
      );

      try {
        await firePolicyService.createFirePolicy(policy);
        // If successful, navigate to the next page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AllFirePolicyView()),
        );
      } catch (e) {
        // Display the error message in a Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Fire Policy Form'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.blue, Colors.green, Colors.orange, Colors.purple],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildDateTextField(),
                const SizedBox(height: 20),
                _buildTextField(bankNameController, 'Bank Name', Icons.account_balance, 'Please enter a bank name'),
                const SizedBox(height: 20),
                _buildTextField(policyholderController, 'Policyholder', Icons.person, 'Please enter the policyholder name'),
                const SizedBox(height: 20),
                _buildTextField(addressController, 'Address', Icons.location_on, 'Please enter an address'),
                const SizedBox(height: 20),
                _buildNumberTextField(stockInsuredController, 'Stock Insured', Icons.monetization_on, 'Please enter the stock insured'),
                const SizedBox(height: 20),
                _buildNumberTextField(sumInsuredController, 'Sum Insured', Icons.monetization_on, 'Please enter the sum insured'),
                const SizedBox(height: 20),
                _buildTextField(interestInsuredController, 'Interest Insured', Icons.info, 'Please enter interest insured details'),
                const SizedBox(height: 20),
                _buildTextField(coverageController, 'Coverage', Icons.assignment, 'Please enter the coverage details'),
                const SizedBox(height: 20),
                _buildTextField(locationController, 'Location', Icons.location_city, 'Please enter the location'),
                const SizedBox(height: 20),
                _buildTextField(constructionController, 'Construction Type', Icons.build, 'Please enter the construction type'),
                const SizedBox(height: 20),
                _buildTextField(ownerController, 'Owner', Icons.person, 'Please enter the owner name'),
                const SizedBox(height: 20),
                _buildTextField(usedAsController, 'Used As', Icons.business, 'Please enter how it is used'),
                const SizedBox(height: 20),
                _buildDateTextField(periodFromController, 'Period From'),
                const SizedBox(height: 20),
                _buildDateTextField(periodToController, 'Period To'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createFirePolicy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Create Fire Policy",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateTextField([TextEditingController? controller, String? labelText]) {
    final TextEditingController effectiveController = controller ?? dateController;
    final String effectiveLabel = labelText ?? 'Date (yyyy-mm-dd)';

    return TextFormField(
      controller: effectiveController,
      decoration: InputDecoration(
        labelText: effectiveLabel,
        border: OutlineInputBorder(),
        prefixIcon: const Icon(Icons.date_range),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a date';
        }
        return null;
      },
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          effectiveController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, String validationMessage) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  Widget _buildNumberTextField(TextEditingController controller, String labelText, IconData icon, String validationMessage, {bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }
}
