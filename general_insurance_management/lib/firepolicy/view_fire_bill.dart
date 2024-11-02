import 'package:flutter/material.dart';
import 'package:general_insurance_management/firepolicy/fire_bill_details.dart';
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

  @override
  void initState() {
    super.initState();
    final service = BillService();
    futureBills = service.fetchFirePolicies().then((bills) {
      allBills = bills; // Initialize allBills with fetched data
      filteredBills = allBills; // Initially show all bills
      return bills;
    });
  }

  void _filterBills(String query) {
    setState(() {
      searchQuery = query.toLowerCase(); // Update the search query
      // Filter the bills based on ID, policyholder, or bank name
      filteredBills = allBills.where((bill) {
        final policyholder = bill.policy?.policyholder?.toLowerCase() ?? '';
        final bankName = bill.policy?.bankName?.toLowerCase() ?? '';
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
              onChanged: _filterBills, // Call the filter function on text change
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
                  // Use filteredBills for the ListView
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
                                  'Bill No : ${bill.policy?.id ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  bill.policy?.bankName ?? 'Unnamed Policy',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  bill.policy?.policyholder ?? 'No policyholder available',
                                  style: commonStyle,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        bill.policy?.address ?? 'No address',
                                        style: commonStyle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Tk ${bill.policy?.sumInsured?.toString() ?? 'No sum'}',
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
                                    Text('Fire: ${bill.fire?.toString() ?? 'No data'}%', style: commonStyle),
                                    Text('RSD: ${bill.rsd?.toString() ?? 'No data'}%', style: commonStyle),
                                    Text('Net: ${bill.netPremium?.toString() ?? 'No data'}', style: commonStyle),
                                    Text('Tax: ${bill.tax?.toString() ?? 'No data'}%', style: commonStyle),
                                    Text('Gross: ${bill.grossPremium?.toString() ?? 'No data'}', style: commonStyle),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: 125,
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Navigate to AllFireBillDetails page with the selected bill
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => AllFireBillDetails(bill: bill), // Pass the selected bill
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.visibility),
                                        SizedBox(width: 8),
                                        Text('Details'),
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
