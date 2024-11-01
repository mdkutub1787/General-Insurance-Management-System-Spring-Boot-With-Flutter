import 'package:flutter/material.dart';
import 'package:general_insurance_management/marinepolicy/print_marine_cover_note.dart';
import 'package:general_insurance_management/marinepolicy/print_marine_money_receipt.dart';
import 'package:general_insurance_management/model/marine_money_receipt_model.dart';
import 'package:general_insurance_management/service/marine_money_receipt_service.dart';

class AllMarineMoneyReceiptView extends StatefulWidget {
  const AllMarineMoneyReceiptView({super.key});

  @override
  State<AllMarineMoneyReceiptView> createState() => _AllMarineMoneyReceiptViewState();
}

class _AllMarineMoneyReceiptViewState extends State<AllMarineMoneyReceiptView> {
  late Future<List<MarineMoneyReceiptModel>> fetchMarineMoneyReceipts;
  List<MarineMoneyReceiptModel> allMarineMoneyReceipts = [];
  List<MarineMoneyReceiptModel> filteredMarineMoneyReceipts = [];
  final TextStyle commonStyle = TextStyle(fontSize: 14, color: Colors.grey[700]);
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final service = MarineMoneyReceiptService();
    fetchMarineMoneyReceipts = service.fetchMarineMoneyReceipts().then((receipts) {
      allMarineMoneyReceipts = receipts;
      filteredMarineMoneyReceipts = receipts; // Initialize with all receipts
      return receipts;
    });
  }

  void filterReceipts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredMarineMoneyReceipts = allMarineMoneyReceipts;
      });
      return;
    }

    setState(() {
      filteredMarineMoneyReceipts = allMarineMoneyReceipts.where((receipt) {
        final bankName = receipt.marinebill?.marineDetails?.bankName?.toLowerCase() ?? '';
        final policyholder = receipt.marinebill?.marineDetails?.policyholder?.toLowerCase() ?? '';
        final id = receipt.id.toString(); // Assuming receipt has an 'id' property

        return bankName.contains(query.toLowerCase()) ||
            policyholder.contains(query.toLowerCase()) ||
            id.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marine Money Receipt'),
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
              controller: searchController,
              onChanged: filterReceipts, // Correctly call the filter function
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
          Expanded(
            child: FutureBuilder<List<MarineMoneyReceiptModel>>(
              future: fetchMarineMoneyReceipts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No bills available'));
                } else {
                  return ListView.builder(
                    itemCount: filteredMarineMoneyReceipts.length,
                    itemBuilder: (context, index) {
                      final marinemoneyreceipt = filteredMarineMoneyReceipts[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                marinemoneyreceipt.marinebill?.marineDetails?.bankName ?? 'Unnamed Policy',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                marinemoneyreceipt.marinebill?.marineDetails?.policyholder ?? 'No policyholder available',
                                style: commonStyle,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      marinemoneyreceipt.marinebill?.marineDetails?.address ?? 'No address',
                                      style: commonStyle,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Tk ${marinemoneyreceipt.marinebill?.marineDetails?.sumInsured?.round() ?? 'No sum'}',
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
                                  Text('Net: Tk ${marinemoneyreceipt.marinebill?.netPremium?.round() ?? 'No data'}', style: commonStyle),
                                  Text('Tax: ${marinemoneyreceipt.marinebill?.tax?.round() ?? 'No data'}%', style: commonStyle),
                                  Text('Stamp: Tk ${marinemoneyreceipt.marinebill?.stampDuty?.round() ?? 'No data'}', style: commonStyle),
                                  Text('Gross: Tk ${marinemoneyreceipt.marinebill?.grossPremium?.round() ?? 'No data'}', style: commonStyle),
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
                                            builder: (context) => PrintMarineMoneyReceipt(moneyreceipt: marinemoneyreceipt),
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
                                            builder: (context) => PrintMarineCoverNote(moneyreceipt: marinemoneyreceipt),
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
