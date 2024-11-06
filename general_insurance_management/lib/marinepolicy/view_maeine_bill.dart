import 'package:flutter/material.dart';
import 'package:general_insurance_management/marinepolicy/create_marine_bill.dart';
import 'package:general_insurance_management/marinepolicy/marine_bill_details.dart';
import 'package:general_insurance_management/marinepolicy/update_marine_bill.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:general_insurance_management/service/marine_bill_service.dart';

class AllMarineBillView extends StatefulWidget {
  const AllMarineBillView({super.key});

  @override
  State<AllMarineBillView> createState() => _AllMarineBillViewState();
}

class _AllMarineBillViewState extends State<AllMarineBillView> {
  late Future<List<MarineBillModel>> fetchMarineBills;
  List<MarineBillModel> allBills = [];
  List<MarineBillModel> filteredBills = [];
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  final TextStyle commonStyle = TextStyle(fontSize: 14, color: Colors.black);
  final TextStyle boldStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    fetchMarineBills = _loadMarineBills();
  }

  Future<List<MarineBillModel>> _loadMarineBills() async {
    final service = MarineBillService();
    final bills = await service.getMarineBills();
    setState(() {
      allBills = bills; // Store all fetched bills
      filteredBills = bills; // Initialize filtered bills with all fetched bills
    });
    return bills;
  }

  void filterBills(String query) {
    setState(() {
      searchQuery = query;
      if (query.isNotEmpty) {
        filteredBills = allBills.where((bill) {
          return bill.marineDetails.policyholder?.toLowerCase().contains(query.toLowerCase()) == true ||
              bill.marineDetails.bankName?.toLowerCase().contains(query.toLowerCase()) == true ||
              bill.id.toString().contains(query); // Assuming id is a property of MarineBillModel
        }).toList();
      } else {
        filteredBills = allBills; // Reset to all bills if query is empty
      }
    });
  }

  void _deleteMarineBill(int billId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Bill'),
        content: const Text('Are you sure you want to delete this bill?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final service = MarineBillService();
              try {
                await service.deleteMarineBill(billId); // Assuming this method exists
                setState(() {
                  // Remove the bill from both lists
                  allBills.removeWhere((bill) => bill.id == billId);
                  filteredBills.removeWhere((bill) => bill.id == billId);
                });
                // Reload bills to ensure the list is updated
                await _loadMarineBills();
                Navigator.of(context).pop(); // Close the dialog
              } catch (e) {
                Navigator.of(context).pop(); // Close the dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Error'),
                    content: Text('Failed to delete bill: $e'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marine Bill List'),
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
              onChanged: filterBills,
              decoration: InputDecoration(
                hintText: 'Search by Bill No, Policyholder, or Bank Name',
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
            child: FutureBuilder<List<MarineBillModel>>(
              future: fetchMarineBills,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No bills available'));
                } else {
                  // Use filteredBills for display
                  final billsToShow = filteredBills.isNotEmpty ? filteredBills : snapshot.data!;
                  return ListView.builder(
                    itemCount: billsToShow.length,
                    itemBuilder: (context, index) {
                      final marineBill = billsToShow[index];
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
                                  'Bill No : ${marineBill.marineDetails.id ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  marineBill.marineDetails.bankName ?? 'Unnamed Policy',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  marineBill.marineDetails.policyholder ?? 'No policyholder available',
                                  style: commonStyle,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        marineBill.marineDetails.address ?? 'No address',
                                        style: commonStyle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Tk ${marineBill.marineDetails.sumInsured?.toString() ?? 'No sum'}',
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
                                    Text('Marine: ${marineBill.marineRate.toString() ?? 'No data'}%', style: commonStyle),
                                    Text('War SRCC: ${marineBill.warSrccRate.toString() ?? 'No data'}%', style: commonStyle),
                                    Text('Net: Tk ${marineBill.netPremium.toString() ?? 'No data'}', style: commonStyle),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Tax: ${marineBill.tax.toString() ?? 'No data'}%', style: commonStyle),
                                    Text('Stamp: Tk ${marineBill.stampDuty.toString() ?? 'No data'}', style: commonStyle),
                                    Text('Gross: Tk ${marineBill.grossPremium.toString() ?? 'No data'}', style: commonStyle),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisSize: MainAxisSize.min, // Minimize the row's size
                                  mainAxisAlignment: MainAxisAlignment.start, // Align the icons to the start
                                  children: [
                                    // View button with only an icon
                                    IconButton(
                                      icon: const Icon(Icons.visibility, color: Colors.blue),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AllMarineBillDetails(marineBill: marineBill),
                                          ),
                                        );
                                      },
                                    ),
                                    // Add a small space between the icons
                                    const SizedBox(width: 8), // You can adjust the width as needed
                                    // Delete button with only an icon
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        if (marineBill.id != null) {
                                          _deleteMarineBill(marineBill.id!); // Use null assertion
                                        } else {
                                          // Handle the case when id is null
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Cannot delete bill without ID')),
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.cyan),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UpdateMarineBill(marineBill: marineBill),
                                          ),
                                        );
                                      },
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateMarineBill()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
