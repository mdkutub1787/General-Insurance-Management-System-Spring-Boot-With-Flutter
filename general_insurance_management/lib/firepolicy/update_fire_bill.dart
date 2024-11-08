// import 'package:flutter/material.dart';
// import 'package:general_insurance_management/firepolicy/view_fire_bill.dart';
// import 'package:general_insurance_management/model/bill_model.dart';
// import 'package:general_insurance_management/model/policy_model.dart';
// import 'package:general_insurance_management/service/bill_service.dart';
// import 'package:general_insurance_management/service/policy_service.dart';
//
// class UpdateFireBill extends StatefulWidget {
//   const UpdateFireBill({super.key, required this.bill});
//
//   final BillModel bill;
//
//   @override
//   State<UpdateFireBill> createState() => _UpdateFireBillState();
// }
//
// class _UpdateFireBillState extends State<UpdateFireBill> {
//   final TextEditingController fireController = TextEditingController();
//   final TextEditingController rsdController = TextEditingController();
//   final TextEditingController netPremiumController = TextEditingController();
//   final TextEditingController taxController = TextEditingController();
//   final TextEditingController grossPremiumController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//   final BillService billService = BillService();
//
//   List<PolicyModel> policies = [];
//   List<String> uniqueBankNames = [];
//   List<double> uniqueSumInsured = [];
//   String? selectedPolicyholder;
//   String? selectedBankName;
//   double? selectedSumInsured;
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchData();
//     _setupListeners();
//     _populateInitialData();
//   }
//
//   void _populateInitialData() {
//     fireController.text = widget.bill.fire.toString();
//     rsdController.text = widget.bill.rsd.toString();
//     netPremiumController.text = widget.bill.netPremium.toString();
//     taxController.text = widget.bill.tax.toString();
//     grossPremiumController.text = widget.bill.grossPremium.toString();
//   }
//
//   Future<void> _fetchData() async {
//     try {
//       policies = await PolicyService().fetchPolicies();
//       uniqueBankNames = policies
//           .map((policy) => policy.bankName)
//           .where((bankName) => bankName != null)
//           .cast<String>()
//           .toSet()
//           .toList();
//
//       uniqueSumInsured = policies
//           .map((policy) => policy.sumInsured)
//           .where((sumInsured) => sumInsured != null)
//           .cast<double>()
//           .toSet()
//           .toList();
//
//       setState(() {
//         if (policies.isNotEmpty) {
//           selectedPolicyholder = policies.first.policyholder;
//           selectedBankName = policies.first.bankName ?? uniqueBankNames.first;
//           selectedSumInsured = policies.first.sumInsured ?? uniqueSumInsured.first;
//         }
//       });
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching data: $error')),
//       );
//     }
//   }
//
//   void _setupListeners() {
//     fireController.addListener(_updateCalculatedFields);
//     rsdController.addListener(_updateCalculatedFields);
//     taxController.addListener(_updateCalculatedFields);
//   }
//
//   void _updateCalculatedFields() {
//     calculatePremiums();
//   }
//
//   void _updateBill() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         isLoading = true;
//       });
//
//       try {
//         final selectedPolicy = policies.firstWhere(
//               (policy) => policy.policyholder == selectedPolicyholder,
//           orElse: () => PolicyModel(policyholder: '', id: null),
//         );
//
//         // Check if selectedPolicy is valid
//         if (selectedPolicy.id == null) {
//           _showErrorSnackBar('Selected policy does not have a valid ID');
//           return;
//         }
//
//         await billService.updateBill(
//           BillModel(
//             fire: double.parse(fireController.text),
//             rsd: double.parse(rsdController.text),
//             netPremium: double.parse(netPremiumController.text),
//             tax: double.parse(taxController.text),
//             grossPremium:double.parse(grossPremiumController.text),
//             policy: selectedPolicy,
//           ) as int,
//           selectedPolicy.id.toString() as BillModel,
//         );
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Fire Bill Updated Successfully!')),
//         );
//
//         // Navigate to the Fire Bill View
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => AllFireBillView()),
//         );
//       } catch (error) {
//         _showErrorSnackBar('Error: $error');
//       } finally {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }
//
//   void _showErrorSnackBar(String message) {
//     setState(() {
//       isLoading = false;
//     });
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//
//
//   void calculatePremiums() {
//     double sumInsured = selectedSumInsured ?? 0.0;
//     double fire = _parseControllerValue(fireController.text);
//     double rsd = _parseControllerValue(rsdController.text);
//     const double taxRate = 15.0; // Fixed tax rate at 15%
//
//     if (fire > 100 || rsd > 100 || taxRate > 100) {
//       _showErrorSnackBar('Rates must be less than or equal to 100%');
//       return;
//     }
//
//     // Calculate netPremium, tax, and grossPremium
//     double netPremium = (sumInsured * (fire + rsd)) / 100;
//     double tax = taxRate;
//     double grossPremium = netPremium + (netPremium * taxRate) / 100;
//
//     setState(() {
//       netPremiumController.text = netPremium.toStringAsFixed(2);
//       taxController.text = tax.toStringAsFixed(2);
//       grossPremiumController.text = grossPremium.toStringAsFixed(2);
//     });
//   }
//
//   double _parseControllerValue(String value) {
//     return double.tryParse(value) ?? 0.0;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Update Fire Bill Form")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               _buildDropdownField(),
//               SizedBox(height: 20),
//               _buildDropdownBankNameField(),
//               SizedBox(height: 20),
//               _buildDropdownSumInsuredField(),
//               SizedBox(height: 20),
//               _buildTextField(fireController, 'Fire Rate', Icons.fire_extinguisher),
//               SizedBox(height: 20),
//               _buildTextField(rsdController, 'Rsd Rate', Icons.dangerous),
//               SizedBox(height: 20),
//               _buildReadOnlyField(netPremiumController, 'Net Premium', Icons.monetization_on),
//               SizedBox(height: 20),
//               _buildReadOnlyField(taxController, 'Tax', Icons.money),
//               SizedBox(height: 20),
//               _buildReadOnlyField(grossPremiumController, 'Gross Premium', Icons.monetization_on),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: isLoading ? null : _updateBill,
//                 child: isLoading
//                     ? CircularProgressIndicator(color: Colors.white)
//                     : Text("Update Fire Bill", style: TextStyle(fontWeight: FontWeight.w600)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blueAccent,
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDropdownField() {
//     return DropdownButtonFormField<String>(
//       value: selectedPolicyholder,
//       onChanged: isLoading ? null : (String? newValue) {
//         setState(() {
//           selectedPolicyholder = newValue;
//           final selectedPolicy = policies.firstWhere(
//                 (policy) => policy.policyholder == newValue,
//             orElse: () => PolicyModel(policyholder: '', id: null, sumInsured: 0.0, bankName: ''),
//           );
//           selectedSumInsured = selectedPolicy.sumInsured;
//           selectedBankName = selectedPolicy.bankName;
//         });
//       },
//       decoration: InputDecoration(
//         labelText: 'Policyholder',
//         border: OutlineInputBorder(),
//         prefixIcon: Icon(Icons.person),
//       ),
//       items: policies.map<DropdownMenuItem<String>>((PolicyModel policy) {
//         return DropdownMenuItem<String>(
//           value: policy.policyholder,
//           child: Text(policy.policyholder ?? ''),
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildDropdownBankNameField() {
//     return DropdownButtonFormField<String>(
//       value: selectedBankName,
//       onChanged: isLoading ? null : (String? newValue) {
//         setState(() {
//           selectedBankName = newValue;
//         });
//       },
//       decoration: InputDecoration(
//         labelText: 'Bank Name',
//         border: OutlineInputBorder(),
//         prefixIcon: Icon(Icons.food_bank),
//       ),
//       items: uniqueBankNames.map<DropdownMenuItem<String>>((String bankName) {
//         return DropdownMenuItem<String>(
//           value: bankName,
//           child: Text(bankName),
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildDropdownSumInsuredField() {
//     return DropdownButtonFormField<double>(
//       value: selectedSumInsured,
//       onChanged: isLoading ? null : (double? newValue) {
//         setState(() {
//           selectedSumInsured = newValue;
//         });
//       },
//       decoration: InputDecoration(
//         labelText: 'Sum Insured',
//         border: OutlineInputBorder(),
//         prefixIcon: Icon(Icons.money),
//       ),
//       items: uniqueSumInsured.map<DropdownMenuItem<double>>((double sumInsured) {
//         return DropdownMenuItem<double>(
//           value: sumInsured,
//           child: Text(sumInsured.toString()),
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildTextField(
//       TextEditingController controller, String label, IconData icon) {
//     return TextFormField(
//       controller: controller,
//       keyboardType: TextInputType.numberWithOptions(decimal: true),
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(),
//         prefixIcon: Icon(icon),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'This field cannot be empty';
//         }
//         return null;
//       },
//     );
//   }
//
//   Widget _buildReadOnlyField(
//       TextEditingController controller, String label, IconData icon) {
//     return TextFormField(
//       controller: controller,
//       readOnly: true,
//       decoration: InputDecoration(
//         labelText: label,
//         border: OutlineInputBorder(),
//         prefixIcon: Icon(icon),
//       ),
//     );
//   }
// }
//
//
