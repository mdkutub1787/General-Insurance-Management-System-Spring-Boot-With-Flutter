import 'package:flutter/material.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:general_insurance_management/model/marine_money_receipt_model.dart';
import 'package:general_insurance_management/service/marine_bill_service.dart';
import 'package:general_insurance_management/service/marine_money_receipt_service.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';

class MarineMoneyReceiptReportPage extends StatefulWidget {
  @override
  State<MarineMoneyReceiptReportPage> createState() => _MarineMoneyReceiptReportPageState();
}

class _MarineMoneyReceiptReportPageState extends State<MarineMoneyReceiptReportPage> {
  late int billCount = 0;
  late double totalNetPremium = 0.0;
  late double totalTax = 0.0;
  late double totalStampDuty = 0.0;
  late double totalGrossPremium = 0.0;

  List<MarineMoneyReceiptModel> allBills = [];
  List<MarineMoneyReceiptModel> filteredBills = [];

  DateTime? startDate;
  DateTime? endDate;

  double _shadowScale = 1.0;
  double _buttonScale = 1.0; // For Button Animation

  @override
  void initState() {
    _fetchAllBills();
    super.initState();
  }

  _fetchAllBills() async {
    allBills = await MarineMoneyReceiptService().fetchMarineMoneyReceipts();

    setState(() {
      filteredBills = allBills; // Initially show all bills
      _updateStatistics();
    });
  }

  _updateStatistics() {
    billCount = filteredBills.length;
    totalNetPremium = calculateTotalNetPremium();
    totalTax = calculateTotalTax();
    totalStampDuty = calculateTotalStampDuty();
    totalGrossPremium = calculateTotalGrossPremium();
  }

  double calculateTotalNetPremium() {
    return filteredBills.fold(0.0, (total, moneyreceipt) => total + (moneyreceipt.marinebill?.netPremium ?? 0));
  }

  double calculateTotalTax() {
    return totalNetPremium * 0.15; // 15% tax
  }

  double calculateTotalStampDuty() {
    return filteredBills.fold(0.0, (total, moneyreceipt) => total + (moneyreceipt.marinebill?.stampDuty ?? 0));
  }

  double calculateTotalGrossPremium() {
    return filteredBills.fold(0.0, (total, moneyreceipt) => total + (moneyreceipt.marinebill?.grossPremium ?? 0));
  }

  _filterBillsByDateRange(DateTime start, DateTime end) {
    setState(() {
      filteredBills = allBills.where((marinemoneyreceipt) {
        DateTime? billDate = marinemoneyreceipt.date;
        if (billDate == null) return false;
        return billDate.isAfter(start.subtract(const Duration(days: 1))) &&
            billDate.isBefore(end.add(const Duration(days: 1)));
      }).toList();
      _updateStatistics();
    });
  }

  _selectDateRange() async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedRange != null) {
      setState(() {
        startDate = pickedRange.start;
        endDate = pickedRange.end;
      });
      _filterBillsByDateRange(startDate!, endDate!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Net Premium": totalNetPremium,
      "Tax (15%)": totalTax,
      "Stamp Duty": totalStampDuty,
      "Gross Premium": totalGrossPremium,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marine Money Receipt Report'),
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedScale(
                    duration: const Duration(milliseconds: 300),
                    scale: _buttonScale,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _buttonScale = 1.1;
                        });
                        _selectDateRange();
                      },
                      onHover: (isHovered) {
                        setState(() {
                          _buttonScale = isHovered ? 1.1 : 1.0;
                        });
                      },
                      child: const Text('Date Wise Report'),
                    ),
                  ),
                  if (startDate != null && endDate != null)
                    Text(
                      "From: ${DateFormat('yyyy-MM-dd').format(startDate!)} To: ${DateFormat('yyyy-MM-dd').format(endDate!)}",
                      style: const TextStyle(fontSize: 14),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              filteredBills.isEmpty
                  ? const Text('No bills found for the selected date range.')
                  : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                          'Marine Money Receipt', billCount.toDouble(), Colors.blue),
                      _buildStatCard(
                          'Net Premium', totalNetPremium, Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard(
                          'Tax (15%)', totalTax, Colors.red),
                      _buildStatCard(
                          'Stamp Duty', totalStampDuty, Colors.green),
                      _buildStatCard('Gross Premium',
                          totalGrossPremium, Colors.pinkAccent),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Premium Distribution',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _shadowScale = 1.1; // Increase scale on hover
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _shadowScale = 1.0; // Reset scale when the mouse leaves
                        });
                      },
                      child: PieChart(
                        key: ValueKey(_shadowScale),
                        dataMap: dataMap,
                        animationDuration: const Duration(milliseconds: 800),
                        chartType: ChartType.disc,
                        chartRadius: MediaQuery.of(context).size.width / 2.5,
                        colorList: [
                          Colors.orange,
                          Colors.red,
                          Colors.green,
                          Colors.pinkAccent,
                        ],
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValuesInPercentage: true,
                        ),
                        legendOptions: const LegendOptions(
                          showLegends: true,
                          legendPosition: LegendPosition.right,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              AnimatedScale(
                duration: const Duration(milliseconds: 300),
                scale: _buttonScale,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/home');
                  },
                  child: const Text('Go to Home',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
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
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _shadowScale = 1.1;
          });
        },
        onExit: (_) {
          setState(() {
            _shadowScale = 1.0;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()..scale(_shadowScale, _shadowScale),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                offset: const Offset(0, 5),
                blurRadius: 15,
                spreadRadius: 3,
              ),
            ],
          ),
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
        ),
      ),
    );
  }
}
