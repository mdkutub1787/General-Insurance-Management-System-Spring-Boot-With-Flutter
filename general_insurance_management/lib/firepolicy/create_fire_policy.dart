import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:general_insurance_management/firepolicy/view_fire_policy.dart';
import 'package:general_insurance_management/model/policy_model.dart';
import 'package:general_insurance_management/service/policy_service.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class CreateFirePolicy extends StatefulWidget {
  const CreateFirePolicy({Key? key}) : super(key: key);

  @override
  _CreateFirePolicyState createState() => _CreateFirePolicyState();
}

class _CreateFirePolicyState extends State<CreateFirePolicy> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateTEC = TextEditingController();
  final TextEditingController bankNameTEC = TextEditingController();
  final TextEditingController policyholderTEC = TextEditingController();
  final TextEditingController addressTEC = TextEditingController();
  final TextEditingController stockInsuredTEC = TextEditingController();
  final TextEditingController sumInsuredTEC = TextEditingController();
  final TextEditingController interestInsuredTEC = TextEditingController();
  final TextEditingController coverageTEC = TextEditingController();
  final TextEditingController locationTEC = TextEditingController();
  final TextEditingController constructionTEC = TextEditingController();
  final TextEditingController ownerTEC = TextEditingController();
  final TextEditingController usedAsTEC = TextEditingController();
  final TextEditingController periodFromTEC = TextEditingController();
  final TextEditingController periodToTEC = TextEditingController();

  DateTime? selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    dateTEC.text = DateFormat('dd-MM-yyyy').format(selectedDate!);
  }

  void createFirePolicy() async {
    if (_formKey.currentState!.validate()) {
      // Ensure numerical input for sumInsured
      if (int.tryParse(sumInsuredTEC.text) == null) {
        _showSnackBar('Please enter a valid number for Sum Insured', Colors.red);
        return;
      }

      PolicyModel policy = PolicyModel(
        date: DateFormat('dd-MM-yyyy').parse(dateTEC.text),
        bankName: bankNameTEC.text,
        policyholder: policyholderTEC.text,
        address: addressTEC.text,
        stockInsured: stockInsuredTEC.text,
        sumInsured: int.parse(sumInsuredTEC.text),
        interestInsured: interestInsuredTEC.text,
        coverage: coverageTEC.text,
        location: locationTEC.text,
        construction: constructionTEC.text,
        owner: ownerTEC.text,
        usedAs: usedAsTEC.text,
        periodFrom: DateFormat('dd-MM-yyyy').parse(periodFromTEC.text),
        periodTo: DateFormat('dd-MM-yyyy').parse(periodToTEC.text),
      );

      setState(() {
        _isLoading = true;
      });

      try {
        String? token = await _retrieveToken(); // Implement token retrieval

        final response = await PolicyService().createFirePolicy(policy, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

        if (response.statusCode == 201 || response.statusCode == 200) {
          _showSnackBar('Policy created successfully!', Colors.green);
          _clearFormFields();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AllFirePolicyView()),
          );
        } else {
          _handleResponseError(response.statusCode);
        }
      } catch (e) {
        _showSnackBar('An error occurred: ${e.toString()}', Colors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String?> _retrieveToken() async {
    // Implement your logic to retrieve the stored token securely
    return 'your_actual_token_here';
  }

  void _clearFormFields() {
    bankNameTEC.clear();
    policyholderTEC.clear();
    addressTEC.clear();
    stockInsuredTEC.clear();
    sumInsuredTEC.clear();
    interestInsuredTEC.clear();
    coverageTEC.clear();
    locationTEC.clear();
    constructionTEC.clear();
    ownerTEC.clear();
    usedAsTEC.clear();
    periodFromTEC.clear();
    periodToTEC.clear();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller, {bool isPeriodFrom = false}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
        if (isPeriodFrom) {
          final DateTime periodToDate = DateTime(picked.year + 1, picked.month, picked.day);
          periodToTEC.text = DateFormat('dd-MM-yyyy').format(periodToDate);
        }
      });
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color, duration: const Duration(seconds: 3)),
    );
  }

  void _handleResponseError(int statusCode) {
    String message;
    switch (statusCode) {
      case 403:
        message = 'Access denied: You do not have permission to perform this action.';
        break;
      case 409:
        message = 'Policy already exists!';
        break;
      default:
        message = 'Policy creation failed with status: $statusCode';
    }
    _showSnackBar(message, Colors.red);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Fire Policy Form"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: dateTEC,
                label: 'Date',
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: (context) => _selectDate(context, dateTEC),
              ),
              CustomTextField(
                controller: bankNameTEC,
                label: 'Bank Name',
                icon: Icons.business,
              ),
              CustomTextField(
                controller: policyholderTEC,
                label: 'Policyholder',
                icon: Icons.person,
              ),
              CustomTextField(
                controller: addressTEC,
                label: 'Address',
                icon: Icons.location_on,
              ),
              CustomTextField(
                controller: stockInsuredTEC,
                label: 'Stock Insured',
                icon: Icons.monetization_on,
              ),
              CustomTextField(
                controller: sumInsuredTEC,
                label: 'Sum Insured',
                icon: Icons.attach_money,
              ),
              CustomTextField(
                controller: interestInsuredTEC,
                label: 'Interest Insured',
                icon: Icons.money,
              ),
              CustomTextField(
                controller: coverageTEC,
                label: 'Coverage',
                icon: Icons.check_circle,
              ),
              CustomTextField(
                controller: locationTEC,
                label: 'Location',
                icon: Icons.map,
              ),
              CustomTextField(
                controller: constructionTEC,
                label: 'Construction Type',
                icon: Icons.house,
              ),
              CustomTextField(
                controller: ownerTEC,
                label: 'Owner',
                icon: Icons.person_add,
              ),
              CustomTextField(
                controller: usedAsTEC,
                label: 'Used As',
                icon: Icons.business_center,
              ),
              CustomTextField(
                controller: periodFromTEC,
                label: 'Period From',
                icon: Icons.date_range,
                readOnly: true,
                onTap: (context) => _selectDate(context, periodFromTEC, isPeriodFrom: true),
              ),
              CustomTextField(
                controller: periodToTEC,
                label: 'Period To',
                icon: Icons.date_range,
                readOnly: true,
              ),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : createFirePolicy,
                  icon: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool readOnly;
  final Function(BuildContext)? onTap;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.icon,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(context);
        }
      },
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
