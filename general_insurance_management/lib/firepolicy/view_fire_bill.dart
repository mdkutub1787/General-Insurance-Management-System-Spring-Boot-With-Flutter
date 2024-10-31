import 'package:flutter/material.dart';
import 'package:general_insurance_management/firepolicy/fire_bill_details.dart';
import 'package:general_insurance_management/model/bill_model.dart';
import '../service/bill_service.dart';

class AllFireBillView extends StatefulWidget {
  const AllFireBillView({super.key});

  @override
  State<AllFireBillView> createState() => _AllFireBillViewState();
}

class _AllFireBillViewState extends State<AllFireBillView> {
  late Future<List<BillModel>> futureBills;
  final TextStyle commonStyle = TextStyle(fontSize: 14, color: Colors.grey[700]);

  @override
  void initState() {
    super.initState();
    final service = BillService();
    futureBills = service.fetchFirePolicies();
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
      body: FutureBuilder<List<BillModel>>(
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
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final bill = snapshot.data![index];
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
                            bill.policy?.bankName ?? 'Unnamed Policy',
                            style: const TextStyle(
                              fontSize: 18,
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
    );
  }
}
