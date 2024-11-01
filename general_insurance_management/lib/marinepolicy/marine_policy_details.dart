import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:general_insurance_management/model/marine_policy_model.dart';

class AllMarinePolicyDetails extends StatelessWidget {
  final MarinePolicyModel policy;

  const AllMarinePolicyDetails({super.key, required this.policy});

  // Define a constant for the font size
  static const double _fontSize = 14;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.greenAccent,
                Colors.deepOrangeAccent,
                Colors.cyan,
                Colors.amber,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text('Marine Policy Details'),
            centerTitle: true,
            backgroundColor: Colors.transparent, // Make the AppBar transparent
            elevation: 0, // Remove shadow
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blueAccent,
              Colors.greenAccent,
              Colors.yellowAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row for ID and formatted Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bill No: ${policy.id?.toString() ?? 'No ID'}',
                          style: TextStyle(fontSize: _fontSize, color: Colors.black),
                        ),
                        Text(
                          'Date: ${policy.date != null ? DateFormat('dd/MM/yyyy').format(policy.date!) : 'No date'}', // Format the date
                          style: TextStyle(fontSize: _fontSize, color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Bank Name: ${policy.bankName ?? 'Unnamed'}',
                      style: TextStyle(fontSize: _fontSize, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Policyholder: ${policy.policyholder ?? 'No policyholder'}',
                      style: TextStyle(fontSize: _fontSize, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Address: ${policy.address ?? 'No address'}',
                      style: TextStyle(fontSize: _fontSize, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Voyage From: ${policy.voyageFrom ?? 'Not specified'}',
                      style: TextStyle(fontSize: _fontSize, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Voyage To: ${policy.voyageTo ?? 'Not specified'}',
                      style: TextStyle(fontSize: _fontSize, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Via: ${policy.via ?? 'Not specified'}',
                      style: TextStyle(fontSize: _fontSize, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Stock Item: ${policy.stockItem ?? 'Not specified'}',
                      style: TextStyle(fontSize: _fontSize, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sum Insured Usd:  ${policy.sumInsuredUsd?.toString() ?? 'No sum'}',
                      style: TextStyle(fontSize: _fontSize, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Usd Rate: ${policy.usdRate ?? 'Not specified'}',
                      style: TextStyle(fontSize: _fontSize, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sum Insured:  Tk ${policy.sumInsured?.toString() ?? 'No sum'}',
                      style: TextStyle(fontSize: _fontSize, color: Colors.black),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Coverage: ${policy.coverage ?? 'Not specified'}',
                      style: TextStyle(fontSize: _fontSize, color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
