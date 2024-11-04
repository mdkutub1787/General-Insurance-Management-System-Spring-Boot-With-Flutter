// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:general_insurance_management/model/policy_model.dart';
// import 'package:general_insurance_management/service/create_policy_service.dart';
// import 'package:intl/intl.dart';
// import 'package:dio/dio.dart';
//
// class CreateFirePolicy extends StatefulWidget {
//   const CreateFirePolicy({Key? key}) : super(key: key);
//
//   @override
//   State<CreateFirePolicy> createState() => _CreateFirePolicyState();
// }
//
// class _CreateFirePolicyState extends State<CreateFirePolicy> {
//   // Controllers for each input field
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController bankNameController = TextEditingController();
//   final TextEditingController policyholderController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController stockInsuredController = TextEditingController();
//   final TextEditingController sumInsuredController = TextEditingController();
//   final TextEditingController interestInsuredController = TextEditingController();
//   final TextEditingController coverageController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//   final TextEditingController constructionController = TextEditingController();
//   final TextEditingController ownerController = TextEditingController();
//   final TextEditingController usedAsController = TextEditingController();
//   final TextEditingController periodFromController = TextEditingController();
//   final TextEditingController periodToController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>(); // Global key for form state
//
//   // Function to create a new fire policy
//   Future<void> _createFirePolicy() async {
//     if (_formKey.currentState!.validate()) {
//       // Validate sum insured is a valid number
//       if (double.tryParse(sumInsuredController.text) == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Sum Insured must be a valid number.')),
//         );
//         return;
//       }
//
//       try {
//         // Use DateFormat to parse the date from your custom format
//         final dateFormat = DateFormat('dd-MM-yyyy'); // Adjust to your input format
//         DateTime date = dateFormat.parse(dateController.text);
//         DateTime periodFrom = dateFormat.parse(periodFromController.text);
//         DateTime periodTo = dateFormat.parse(periodToController.text);
//
//         // Create policy model instance
//         final policy = PolicyModel(
//           id: 0,
//           date: date,
//           bankName: bankNameController.text,
//           policyholder: policyholderController.text,
//           address: addressController.text,
//           stockInsured: stockInsuredController.text,
//           sumInsured: double.parse(sumInsuredController.text),
//           interestInsured: interestInsuredController.text,
//           coverage: coverageController.text,
//           location: locationController.text,
//           construction: constructionController.text,
//           owner: ownerController.text,
//           usedAs: usedAsController.text,
//           periodFrom: periodFrom,
//           periodTo: periodTo,
//         );
//
//         // Call the service to create the policy
//         await CreateFirePolicyService().createFirePolicy(policy);
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Policy added successfully!')),
//         );
//
//         // Clear all fields after successful creation
//         _clearForm();
//       } catch (e) {
//         print('Error adding policy: $e'); // General error logging
//
//         // If using Dio for HTTP requests, you can check for DioError
//         if (e is DioError) {
//           print('Response data: ${e.response?.data}');
//           print('Response status: ${e.response?.statusCode}');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error adding policy: ${e.response?.data ?? e.message}')),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error adding policy: ${e.toString()}')),
//           );
//         }
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please complete the form.')),
//       );
//     }
//   }
//
//   // Function to clear the form fields
//   void _clearForm() {
//     dateController.clear();
//     bankNameController.clear();
//     policyholderController.clear();
//     addressController.clear();
//     stockInsuredController.clear();
//     sumInsuredController.clear();
//     interestInsuredController.clear();
//     coverageController.clear();
//     locationController.clear();
//     constructionController.clear();
//     ownerController.clear();
//     usedAsController.clear();
//     periodFromController.clear();
//     periodToController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Add New Policy')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // All the text fields with validators
//               TextFormField(
//                 controller: dateController,
//                 decoration: InputDecoration(labelText: 'Date (dd-MM-yyyy)'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter date' : null,
//               ),
//               TextFormField(
//                 controller: bankNameController,
//                 decoration: InputDecoration(labelText: 'Bank Name'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter bank name' : null,
//               ),
//               TextFormField(
//                 controller: policyholderController,
//                 decoration: InputDecoration(labelText: 'Policyholder'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter policyholder' : null,
//               ),
//               TextFormField(
//                 controller: addressController,
//                 decoration: InputDecoration(labelText: 'Address'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter address' : null,
//               ),
//               TextFormField(
//                 controller: stockInsuredController,
//                 decoration: InputDecoration(labelText: 'Stock Insured'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter stock insured' : null,
//               ),
//               TextFormField(
//                 controller: sumInsuredController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(labelText: 'Sum Insured'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter sum insured' : null,
//               ),
//               TextFormField(
//                 controller: interestInsuredController,
//                 decoration: InputDecoration(labelText: 'Interest Insured'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter interest insured' : null,
//               ),
//               TextFormField(
//                 controller: coverageController,
//                 decoration: InputDecoration(labelText: 'Coverage'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter coverage' : null,
//               ),
//               TextFormField(
//                 controller: locationController,
//                 decoration: InputDecoration(labelText: 'Location'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter location' : null,
//               ),
//               TextFormField(
//                 controller: constructionController,
//                 decoration: InputDecoration(labelText: 'Construction'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter construction type' : null,
//               ),
//               TextFormField(
//                 controller: ownerController,
//                 decoration: InputDecoration(labelText: 'Owner'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter owner' : null,
//               ),
//               TextFormField(
//                 controller: usedAsController,
//                 decoration: InputDecoration(labelText: 'Used As'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter usage' : null,
//               ),
//               TextFormField(
//                 controller: periodFromController,
//                 decoration: InputDecoration(labelText: 'Period From (dd-MM-yyyy)'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter period from' : null,
//               ),
//               TextFormField(
//                 controller: periodToController,
//                 decoration: InputDecoration(labelText: 'Period To (dd-MM-yyyy)'),
//                 validator: (value) => value == null || value.isEmpty ? 'Enter period to' : null,
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: _createFirePolicy,
//                 child: Text('Save Policy'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
