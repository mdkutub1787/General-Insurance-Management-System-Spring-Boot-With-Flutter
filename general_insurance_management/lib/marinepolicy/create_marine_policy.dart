import 'package:flutter/material.dart';
import 'package:general_insurance_management/marinepolicy/view_marine_policy.dart';
import 'package:general_insurance_management/model/marine_policy_model.dart';
import 'package:general_insurance_management/service/marine_policy_service.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateMarinePolicy extends StatefulWidget {
  const CreateMarinePolicy({super.key});

  @override
  State<CreateMarinePolicy> createState() => _CreateMarinePolicyState();
}

class _CreateMarinePolicyState extends State<CreateMarinePolicy> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController policyholderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController voyageFromController = TextEditingController();
  final TextEditingController voyageToController = TextEditingController();
  final TextEditingController viaController = TextEditingController();
  final TextEditingController stockItemController = TextEditingController();
  final TextEditingController sumInsuredUsdController = TextEditingController();
  final TextEditingController usdRateController = TextEditingController();
  final TextEditingController sumInsuredController = TextEditingController();
  final TextEditingController coverageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final MarinePolicyService marinePolicyService = MarinePolicyService();

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fetchUsdRate();
    sumInsuredUsdController.addListener(_updateSumInsured);
    usdRateController.addListener(_updateSumInsured);
    coverageController.text = "Lorry Risk Only"; // Set default coverage
  }

  Future<void> fetchUsdRate() async {
    try {
      final response = await http.get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rate = data['rates']['BDT']; // Assuming you want the rate for BDT
        usdRateController.text = rate.toString();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to fetch exchange rate.'))
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching USD rate: $e'))
      );
    }
  }

  @override
  void dispose() {
    sumInsuredUsdController.removeListener(_updateSumInsured);
    usdRateController.removeListener(_updateSumInsured);
    dateController.dispose();
    bankNameController.dispose();
    policyholderController.dispose();
    addressController.dispose();
    voyageFromController.dispose();
    voyageToController.dispose();
    viaController.dispose();
    stockItemController.dispose();
    sumInsuredUsdController.dispose();
    usdRateController.dispose();
    sumInsuredController.dispose();
    coverageController.dispose();
    super.dispose();
  }

  void _updateSumInsured() {
    final usdValue = double.tryParse(sumInsuredUsdController.text) ?? 0;
    final usdRate = double.tryParse(usdRateController.text) ?? 0.0;
    final localCurrencyValue = (usdValue * usdRate).round();
    sumInsuredController.text = localCurrencyValue.toString();
  }

  void _createMarinePolicy() async {
    if (_formKey.currentState!.validate()) {
      MarinePolicyModel marinePolicy = MarinePolicyModel(
        date: DateTime.parse(dateController.text),
        bankName: bankNameController.text,
        policyholder: policyholderController.text,
        address: addressController.text,
        voyageFrom: voyageFromController.text,
        voyageTo: voyageToController.text,
        via: viaController.text,
        stockItem: stockItemController.text,
        sumInsuredUsd: double.tryParse(sumInsuredUsdController.text) ?? 0,
        usdRate: double.tryParse(usdRateController.text) ?? 0.0,
        sumInsured: double.tryParse(sumInsuredController.text) ?? 0,
        coverage: coverageController.text,
      );

      final response = await marinePolicyService.createMarinePolicy(marinePolicy);

      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AllMarinePolicyView()),
        );
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Marine Policy already exists!'))
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed with status: ${response.statusCode}'))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Marine Policy Form'),
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
                _buildTextField(voyageFromController, 'Voyage From', Icons.navigation, 'Please enter the voyage start location'),
                const SizedBox(height: 20),
                _buildTextField(voyageToController, 'Voyage To', Icons.navigation, 'Please enter the voyage end location'),
                const SizedBox(height: 20),
                _buildTextField(viaController, 'Via', Icons.airplanemode_active, 'Please enter the route of the voyage'),
                const SizedBox(height: 20),
                _buildTextField(stockItemController, 'Stock Item', Icons.business, 'Please enter the stock item'),
                const SizedBox(height: 20),
                _buildNumberTextField(sumInsuredUsdController, 'Sum Insured (USD)', Icons.monetization_on, 'Please enter a sum insured value'),
                const SizedBox(height: 20),
                _buildNumberTextField(usdRateController, 'USD Rate', Icons.money, 'Auto-updated rate', readOnly: true),
                const SizedBox(height: 20),
                _buildNumberTextField(sumInsuredController, 'Sum Insured (Local Currency)', Icons.monetization_on, 'Auto-calculated value', readOnly: true),
                const SizedBox(height: 20),
                _buildTextField(coverageController, 'Coverage', Icons.assignment, 'Please enter the coverage details', readOnly: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createMarinePolicy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Create Marine Policy",
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

  Widget _buildDateTextField() {
    return TextFormField(
      controller: dateController,
      decoration: _buildInputDecoration('Date (yyyy-mm-dd)', Icons.date_range),
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
          dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
        }
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, IconData icon, String validationMessage, {bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: _buildInputDecoration(labelText, icon),
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
      decoration: _buildInputDecoration(labelText, icon),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
      keyboardType: TextInputType.number,
    );
  }

  InputDecoration _buildInputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
    );
  }


}
