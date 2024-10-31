import 'package:flutter/material.dart';
import 'package:general_insurance_management/marinepolicy/marine_bill_details.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:general_insurance_management/service/marine_bill_service.dart';

class AllMarineBillView extends StatefulWidget {
  const AllMarineBillView({super.key});

  @override
  State<AllMarineBillView> createState() => _AllMarineBillViewState();
}

class _AllMarineBillViewState extends State<AllMarineBillView> {
  late Future<List<MarineBillModel>> fetchMarineBills;
  final TextStyle commonStyle = TextStyle(fontSize: 14, color: Colors.grey[700]);
  final TextStyle boldStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    final service = MarineBillService();
    fetchMarineBills = service.fetchMarineBills();
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
      body: FutureBuilder<List<MarineBillModel>>(
        future: fetchMarineBills,
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
                final marineBill = snapshot.data![index];
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
                            marineBill.marineDetails?.bankName ?? 'Unnamed Policy',
                            style: boldStyle,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            marineBill.marineDetails?.policyholder ?? 'No policyholder available',
                            style: commonStyle,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  marineBill.marineDetails?.address ?? 'No address',
                                  style: commonStyle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Tk ${marineBill.marineDetails?.sumInsured?.toString() ?? 'No sum'}',
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
                              Text('Marine: ${marineBill.marineRate?.toString() ?? 'No data'}%', style: commonStyle),
                              Text('War SRCC: ${marineBill.warSrccRate?.toString() ?? 'No data'}%', style: commonStyle),
                              Text('Net: Tk ${marineBill.netPremium?.toString() ?? 'No data'}', style: commonStyle),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tax: ${marineBill.tax?.toString() ?? 'No data'}%', style: commonStyle),
                              Text('Stamp: Tk ${marineBill.stampDuty?.toString() ?? 'No data'}', style: commonStyle),
                              Text('Gross: Tk ${marineBill.grossPremium?.toString() ?? 'No data'}', style: commonStyle),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: 125,
                            height: 30,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllMarineBillDetails(marineBill: marineBill), // Use marineBill here
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
