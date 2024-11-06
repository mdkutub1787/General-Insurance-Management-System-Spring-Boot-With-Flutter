import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:general_insurance_management/model/policy_model.dart';
import 'package:general_insurance_management/service/policy_service.dart';
import 'package:general_insurance_management/firepolicy/view_fire_policy.dart';

class UpdateFirePolicy extends StatefulWidget {
  const UpdateFirePolicy({super.key, required this.policy});

  final PolicyModel policy;

  @override
  State<UpdateFirePolicy> createState() => _UpdateFirePolicyState();
}

class _UpdateFirePolicyState extends State<UpdateFirePolicy> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController policyholderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController stockInsuredController = TextEditingController();
  final TextEditingController sumInsuredController = TextEditingController();
  final TextEditingController interestInsuredController = TextEditingController();
  final TextEditingController coverageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController periodFromController = TextEditingController();
  final TextEditingController periodToController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final PolicyService policyService = PolicyService();

  final List<String> constructionTypes = ['1st Class', '2nd Class', '3rd Class'];
  final List<String> usageTypes = ['Shop Only', 'Godown Only', 'Shop-Cum-Godown only'];

  String? selectedConstruction;
  String? selectedUsage;

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    selectedConstruction = widget.policy.construction;
    selectedUsage = widget.policy.usedAs;
    dateController.text = widget.policy.date != null
        ? DateFormat('yyyy-MM-dd').format(widget.policy.date!)
        : '';
    bankNameController.text = widget.policy.bankName ?? '';
    policyholderController.text = widget.policy.policyholder ?? '';
    addressController.text = widget.policy.address ?? '';
    stockInsuredController.text = widget.policy.stockInsured ?? '';
    sumInsuredController.text = widget.policy.sumInsured?.toString() ?? '';
    interestInsuredController.text = widget.policy.interestInsured ?? '';
    coverageController.text = widget.policy.coverage ?? '';
    locationController.text = widget.policy.location ?? '';
    ownerController.text = widget.policy.owner ?? '';
    periodFromController.text = widget.policy.periodFrom != null
        ? DateFormat('yyyy-MM-dd').format(widget.policy.periodFrom!)
        : '';
    periodToController.text = widget.policy.periodTo != null
        ? DateFormat('yyyy-MM-dd').format(widget.policy.periodTo!)
        : '';
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
    ownerController.dispose();
    periodFromController.dispose();
    periodToController.dispose();
    super.dispose();
  }

  void _updateFirePolicy() async {
    if (_formKey.currentState!.validate()) {
      int? id = widget.policy.id;
      PolicyModel policy = PolicyModel(
        id: id,
        date: DateTime.parse(dateController.text),
        bankName: bankNameController.text,
        policyholder: policyholderController.text,
        address: addressController.text,
        stockInsured: stockInsuredController.text,
        sumInsured: double.tryParse(sumInsuredController.text) ?? 0,
        interestInsured: interestInsuredController.text,
        coverage: coverageController.text,
        location: locationController.text,
        construction: selectedConstruction ?? '',
        owner: ownerController.text,
        usedAs: selectedUsage ?? '',
        periodFrom: DateTime.parse(periodFromController.text),
        periodTo: DateTime.parse(periodToController.text),
      );

      try {
        await policyService.updateFirePolicy(id!, policy);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AllFirePolicyView()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fire Policy updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating Fire Policy: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Fire Policy Form'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.pinkAccent,
                Colors.blue,
                Colors.green,
                Colors.orange,
                Colors.purple
              ],
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
                SizedBox(height: 20),
                _buildDateTextField(dateController, 'Date', 'Please select a date'),
                SizedBox(height: 20),
                _buildTextField(
                    bankNameController,
                    'Bank Name',
                    Icons.account_balance,
                    'Please enter a bank name'
                ),
                SizedBox(height: 20),
                _buildTextField(
                    policyholderController,
                    'Policyholder',
                    Icons.person,
                    'Please enter the policyholder name'
                ),
                SizedBox(height: 20),
                _buildTextField(
                    addressController,
                    'Address',
                    Icons.location_on,
                    'Please enter an address'
                ),
                SizedBox(height: 20),
                _buildTextField(
                    stockInsuredController,
                    'Stock Insured',
                    Icons.inventory,
                    'Please enter the stock insured'
                ),
                SizedBox(height: 20),
                _buildNumberTextField(
                    sumInsuredController,
                    'Sum Insured',
                    Icons.money,
                    'Please enter the sum insured'
                ),
                SizedBox(height: 20),
                _buildTextField(
                    interestInsuredController,
                    'Interest Insured',
                    Icons.info,
                    'Please enter interest insured details'
                ),
                SizedBox(height: 20),
                _buildTextField(
                    coverageController,
                    'Coverage',
                    Icons.assignment,
                    'Please enter the coverage details',
                    readOnly: true
                ),
                SizedBox(height: 20),
                _buildTextField(
                    locationController,
                    'Location',
                    Icons.location_city,
                    'Please enter the location'
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedConstruction,
                  decoration: _buildInputDecoration('Construction Type', Icons.build),
                  items: constructionTypes.map((type) {
                    return DropdownMenuItem<String>(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedConstruction = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a construction type' : null,
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedUsage,
                  decoration: _buildInputDecoration('Used As', Icons.business),
                  items: usageTypes.map((type) {
                    return DropdownMenuItem<String>(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedUsage = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select how it is used' : null,
                ),
                SizedBox(height: 20),
                _buildTextField(
                    ownerController,
                    'Owner',
                    Icons.person,
                    'Please enter the owner name',
                    readOnly: true
                ),
                SizedBox(height: 20),
                _buildDateTextField(periodFromController, 'Period From', 'Please enter a valid date', isPeriodFrom: true),
                SizedBox(height: 20),
                _buildDateTextField(periodToController, 'Period To', 'Please enter a valid date'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateFirePolicy,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Update Fire Policy",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color:Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label, IconData icon, String errorMsg, {bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      decoration: _buildInputDecoration(label, icon),
      validator: (value) => value!.isEmpty ? errorMsg : null,
    );
  }

  TextFormField _buildNumberTextField(TextEditingController controller, String label, IconData icon, String errorMsg) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: _buildInputDecoration(label, icon),
      validator: (value) => value!.isEmpty || double.tryParse(value) == null ? errorMsg : null,
    );
  }

  TextFormField _buildDateTextField(TextEditingController controller, String label, String errorMsg, {bool isPeriodFrom = false}) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: _buildInputDecoration(label, Icons.calendar_today),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: isPeriodFrom ? DateTime.now() : DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
      validator: (value) => value!.isEmpty ? errorMsg : null,
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
