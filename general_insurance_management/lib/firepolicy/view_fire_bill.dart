import 'package:flutter/material.dart';
import 'package:general_insurance_management/firepolicy/create_fire_bill.dart';
import 'package:general_insurance_management/firepolicy/fire_bill_details.dart';
import 'package:general_insurance_management/firepolicy/update_fire_bill.dart';
import 'package:general_insurance_management/model/bill_model.dart';
import '../service/bill_service.dart';

class AllFireBillView extends StatefulWidget {
  const AllFireBillView({Key? key}) : super(key: key);

  @override
  State<AllFireBillView> createState() => _AllFireBillViewState();
}

class _AllFireBillViewState extends State<AllFireBillView> {
  late Future<List<BillModel>> futureBills;
  List<BillModel> allBills = []; // Store all bills
  List<BillModel> filteredBills = []; // Store filtered bills
  String searchQuery = ''; // Store the search query
  final TextStyle commonStyle = const TextStyle(fontSize: 14, color: Colors.black);
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final service = BillService();
    futureBills = service.fetchFireBill().then((bills) {
      allBills = bills; // Initialize allBills with fetched data
      filteredBills = allBills; // Initially show all bills
      return bills;
    });

    // Optional: Debounce search input to reduce the number of times filtering occurs
    searchController.addListener(() {
      Future.delayed(const Duration(milliseconds: 300), () {
        _filterBills(searchController.text);
      });
    });
  }

  void _filterBills(String query) {
    setState(() {
      searchQuery = query.toLowerCase(); // Update the search query
      // Filter the bills based on ID, policyholder, or bank name
      filteredBills = allBills.where((bill) {
        final policyholder = bill.policy.policyholder?.toLowerCase() ?? '';
        final bankName = bill.policy.bankName?.toLowerCase() ?? '';
        final id = bill.id.toString();
        return policyholder.contains(searchQuery) ||
            bankName.contains(searchQuery) ||
            id.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fire Bill List'),
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
          const SizedBox(height: 10), // Add some spacing below the search bar
          Expanded(
            child: FutureBuilder<List<BillModel>>(
              future: futureBills,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No bills available'));
                } else {
                  return ListView.builder(
                    itemCount: filteredBills.length,
                    itemBuilder: (context, index) {
                      final bill = filteredBills[index];
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
                                  'Bill No : ${bill.policy.id ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  bill.policy.bankName ?? 'Unnamed Policy',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  bill.policy.policyholder ?? 'No policyholder available',
                                  style: commonStyle,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        bill.policy.address ?? 'No address',
                                        style: commonStyle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Tk ${bill.policy.sumInsured?.toString() ?? 'No sum'}',
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
                                    Text('Fire: ${bill.fire.toString() ?? 'No data'}%', style: commonStyle),
                                    Text('RSD: ${bill.rsd.toString() ?? 'No data'}%', style: commonStyle),
                                    Text('Net: ${bill.netPremium.toString() ?? 'No data'}', style: commonStyle),
                                    Text('Tax: ${bill.tax.toString() ?? 'No data'}%', style: commonStyle),
                                    Text('Gross: ${bill.grossPremium.toString() ?? 'No data'}', style: commonStyle),
                                  ],
                                ),
                                _buildActionButtons(bill),
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
            MaterialPageRoute(builder: (context) => const CreateFireBill()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildActionButtons(BillModel bill) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.visibility, color: Colors.blue),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AllFireBillDetails(bill: bill)),
            );
          },
          tooltip: 'View Details',
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _confirmDeleteBill(bill.id!);
          },
          tooltip: 'Delete Bill',
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.cyan),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateFireBill(bill: bill),
              ),
            );
          },
          tooltip: 'Edit Bill',
        ),
      ],
    );
  }

  void _confirmDeleteBill(int billId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this bill?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteBill(billId);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteBill(int billId) async {
    final service = BillService();
    try {
      await service.deleteBill(billId); // Delete the bill
      setState(() {
        filteredBills.removeWhere((bill) => bill.id == billId); // Update the list
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fire  Bill Delete Successfully!')),
      );
    } catch (e) {
      // Handle errors if necessary
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error deleting bill: $e'),
      ));
    }
  }
}
