import 'package:flutter/material.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:general_insurance_management/service/marine_bill_service.dart';
import 'package:pie_chart/pie_chart.dart';

class MarineBillReportPage extends StatefulWidget {
  @override
  State<MarineBillReportPage> createState() => _MarineBillReportPageState();
}

class _MarineBillReportPageState extends State<MarineBillReportPage> {
  late int billCount = 0;
  late double totalNetPremium = 0.0;
  late double totalTax = 0.0;
  late double totalStampDuty = 0.0;
  late double totalGrossPremium = 0.0;

  List<MarineBillModel> allBills = [];

  @override
  void initState() {
    _fetchAllBills();
    super.initState();
  }

  _fetchAllBills() async {
    allBills = await MarineBillService().getMarineBills();

    setState(() {
      billCount = allBills.length;
      totalNetPremium = calculateTotalNetPremium();
      totalTax = calculateTotalTax();
      totalStampDuty = calculateTotalStampDuty(); // Corrected typo
      totalGrossPremium = calculateTotalGrossPremium();
    });
  }

  double calculateTotalNetPremium() {
    return allBills.isNotEmpty
        ? allBills.fold(0.0, (total, bill) => total + (bill.netPremium ?? 0))
        : 0.0;
  }

  double calculateTotalTax() {
    return totalNetPremium * 0.15; // 15% tax
  }

  double calculateTotalStampDuty() {
    return allBills.isNotEmpty
        ? allBills.fold(0.0, (total, bill) => total + (bill.stampDuty ?? 0))
        : 0.0;
  }

  double calculateTotalGrossPremium() {
    return allBills.isNotEmpty
        ? allBills.fold(0.0, (total, bill) => total + (bill.grossPremium ?? 0))
        : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Net Premium": totalNetPremium,
      "Tax (15%)": totalTax,
      "Stamp Duty": totalStampDuty, // Corrected typo
      "Gross Premium": totalGrossPremium,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marine Bill Report'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: allBills.isEmpty
            ? Center(child: CircularProgressIndicator()) // Loading indicator
            : SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('Bills', billCount.toDouble(), Colors.blue),
                  _buildStatCard(
                      'Net Premium', totalNetPremium, Colors.orange),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('Tax (15%)', totalTax, Colors.red),
                  _buildStatCard(
                      'Stamp Duty', totalStampDuty, Colors.green),
                  _buildStatCard(
                      'Gross Premium', totalGrossPremium, Colors.green),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Premium Distribution',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              PieChart(
                dataMap: dataMap,
                animationDuration: const Duration(milliseconds: 800),
                chartType: ChartType.disc,
                chartRadius: MediaQuery.of(context).size.width / 2.5,
                colorList: [Colors.orange, Colors.red, Colors.green],
                chartValuesOptions: const ChartValuesOptions(
                  showChartValuesInPercentage: true,
                ),
                legendOptions: const LegendOptions(
                  showLegends: true,
                  legendPosition: LegendPosition.right,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: const Text('Go to Home'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, double value, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
