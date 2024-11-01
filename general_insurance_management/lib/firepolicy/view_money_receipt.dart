import 'package:flutter/material.dart';
import 'package:general_insurance_management/firepolicy/print_fire_money_receipt.dart';
import 'package:general_insurance_management/firepolicy/print_fire_cover_note.dart';
import 'package:general_insurance_management/model/money_reciept_model.dart';
import 'package:general_insurance_management/service/money_receipt_service.dart';

class AllFireMoneyReceiptView extends StatefulWidget {
  const AllFireMoneyReceiptView({super.key});

  @override
  State<AllFireMoneyReceiptView> createState() => _AllFireMoneyReceiptViewState();
}

class _AllFireMoneyReceiptViewState extends State<AllFireMoneyReceiptView> {
  late Future<List<MoneyReceiptModel>> futureReceipts;
  final TextStyle commonStyle = TextStyle(fontSize: 14, color: Colors.grey[700]);

  // Variable to hold the original list of receipts
  List<MoneyReceiptModel> allReceipts = [];
  List<MoneyReceiptModel> filteredReceipts = [];

  @override
  void initState() {
    super.initState();
    final service = MoneyReceiptService();
    futureReceipts = service.fetchMoneyReceipts().then((receipts) {
      allReceipts = receipts;
      filteredReceipts = allReceipts; // Initialize filtered list
      return receipts;
    });
  }

  void _filterReceipts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredReceipts = allReceipts; // Reset to original list if query is empty
      } else {
        filteredReceipts = allReceipts.where((receipt) {
          return (receipt.bill?.policy?.policyholder ?? '').toLowerCase().contains(query.toLowerCase()) ||
              (receipt.bill?.policy?.bankName ?? '').toLowerCase().contains(query.toLowerCase()) ||
              (receipt.id.toString() ?? '').toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fire Money Receipt'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: _filterReceipts, // Call the filter function on text change
              decoration: InputDecoration(
                hintText: 'Search by ID, Policyholder, or Bank Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<MoneyReceiptModel>>(
              future: futureReceipts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || filteredReceipts.isEmpty) {
                  return const Center(child: Text('No receipts available'));
                } else {
                  return ListView.builder(
                    itemCount: filteredReceipts.length,
                    itemBuilder: (context, index) {
                      final receipt = filteredReceipts[index];
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red,
                              Colors.orange,
                              Colors.yellow,
                              Colors.green,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.all(10),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  receipt.bill?.policy?.bankName ?? 'Unnamed Policy',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  receipt.bill?.policy?.policyholder ?? 'No policyholder available',
                                  style: commonStyle,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        receipt.bill?.policy?.address ?? 'No address',
                                        style: commonStyle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Tk ${receipt.bill?.policy?.sumInsured?.toString() ?? 'No sum'}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Net: ${receipt.bill?.netPremium?.toString() ?? 'No data'}', style: commonStyle),
                                    Text('Tax: ${receipt.bill?.tax?.toString() ?? 'No data'}%', style: commonStyle),
                                    Text('Gross: ${receipt.bill?.grossPremium?.toString() ?? 'No data'}', style: commonStyle),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 125,
                                      height: 30,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PrintFireMoneyReceipt(moneyreceipt: receipt),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.visibility),
                                            SizedBox(width: 8),
                                            Text('Print'),
                                          ],
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 160,
                                      height: 30,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PrintFireCoverNote(moneyreceipt: receipt),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.note),
                                            SizedBox(width: 8),
                                            Text('Cover Note'),
                                          ],
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
