import 'package:flutter/material.dart';
import 'package:general_insurance_management/model/bill_model.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:general_insurance_management/service/bill_service.dart';
import 'package:general_insurance_management/service/marine_bill_service.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

class CombinedReport extends StatefulWidget {
  const CombinedReport({super.key});

  @override
  State<CombinedReport> createState() => _CombinedReportState();
}

class _CombinedReportState extends State<CombinedReport> {
  bool isLoading = true;
  bool isError = false;

  // Fire Bill State
  int fireBillCount = 0;
  double fireTotalNetPremium = 0.0;
  double fireTotalTax = 0.0;
  double fireTotalGrossPremium = 0.0;
  List<BillModel> fireBills = [];
  List<BillModel> filteredFireBills = [];

  // Marine Bill State
  int marineBillCount = 0;
  double marineTotalNetPremium = 0.0;
  double marineTotalTax = 0.0;
  double marineTotalStumpDuty = 0.0;
  double marineTotalGrossPremium = 0.0;
  List<MarineBillModel> marineBills = [];
  List<MarineBillModel> filteredMarineBills = [];

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _fetchAllBills();
  }

  Future<void> _fetchAllBills() async {
    try {
      fireBills = await BillService().fetchFireBill();
      marineBills = await MarineBillService().fetchMarineBills();
      setState(() {
        filteredFireBills = fireBills;
        filteredMarineBills = marineBills;
        _updateStatistics();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
    }
  }

  void _updateStatistics() {
    fireBillCount = filteredFireBills.length;
    fireTotalNetPremium =
        _calculateTotal(filteredFireBills, (bill) => bill.netPremium ?? 0);
    fireTotalTax = fireTotalNetPremium * 0.15;
    fireTotalGrossPremium =
        _calculateTotal(filteredFireBills, (bill) => bill.grossPremium ?? 0);

    marineBillCount = filteredMarineBills.length;
    marineTotalNetPremium = _calculateTotal(
        filteredMarineBills, (marineBill) => marineBill.netPremium ?? 0);
    marineTotalTax = marineTotalNetPremium * 0.15;
    marineTotalStumpDuty = _calculateTotal(
        filteredMarineBills, (marineBill) => marineBill.stampDuty ?? 0);
    marineTotalGrossPremium = _calculateTotal(
        filteredMarineBills, (marineBill) => marineBill.grossPremium ?? 0);
  }

  double _calculateTotal<T>(List<T> items, double Function(T) field) {
    return items.fold(0.0, (total, item) => total + field(item));
  }

  void _filterBillsByDateRange(DateTime start, DateTime end) {
    setState(() {
      filteredFireBills = fireBills.where((bill) {
        final date = bill.policy.date;
        return date != null && date.isAfter(start) && date.isBefore(end);
      }).toList();

      filteredMarineBills = marineBills.where((marineBill) {
        final date = marineBill.marineDetails.date;
        return date != null && date.isAfter(start) && date.isBefore(end);
      }).toList();
      _updateStatistics();
    });
  }

  Future<void> _selectDateRange() async {
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedRange != null) {
      setState(() {
        startDate = pickedRange.start;
        endDate = pickedRange.end;
        _filterBillsByDateRange(startDate!, endDate!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (isError) {
      return const Center(child: Text('Error fetching data.'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Combined Bill Report'),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Display selected date range
          if (startDate != null && endDate != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                ' Date Range: ${DateFormat('yyyy-MM-dd').format(startDate!)} to ${DateFormat('yyyy-MM-dd').format(endDate!)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

          // Combined Pie Chart
          _buildCombinedPieChart(),
          const SizedBox(height: 16),
          // Fire Bill Report Section
          _buildReportSection('Fire Bill Report', fireBillCount,
              fireTotalNetPremium, fireTotalTax, 0.0, fireTotalGrossPremium),
          const SizedBox(height: 16),
          // Marine Bill Report Section
          _buildReportSection(
              'Marine Bill Report',
              marineBillCount,
              marineTotalNetPremium,
              marineTotalTax,
              marineTotalStumpDuty,
              marineTotalGrossPremium),
        ],
      ),
    );
  }

  Widget _buildCombinedPieChart() {
    final combinedData = {
      "Fire Net Premium": fireTotalNetPremium,
      "Fire Tax (15%)": fireTotalTax,
      "Fire Gross Premium": fireTotalGrossPremium,
      "Marine Net Premium": marineTotalNetPremium,
      "Marine Tax (15%)": marineTotalTax,
      "Marine Stump Duty": marineTotalStumpDuty,
      "Marine Gross Premium": marineTotalGrossPremium,
    };

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Combined Bill Report', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            SizedBox(
              height: 500, // Set the same height as other pie charts
              width: double.infinity, // Make the chart expand to full width
              child: PieChart(
                dataMap: combinedData,
                chartType: ChartType.disc,
                colorList: [
                  Colors.orange, // Fire Net Premium
                  Colors.red, // Fire Tax
                  Colors.green, // Fire Gross Premium
                  Colors.blue, // Marine Net Premium
                  Colors.purple, // Marine Tax
                  Colors.brown, // Marine Stump Duty
                  Colors.cyan, // Marine Gross Premium
                ],
                legendOptions: const LegendOptions(legendPosition: LegendPosition.bottom),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildReportSection(String title, int count, double net, double tax,
      double stumpDuty, double gross) {
    final dataMap = {
      "Net Premium": net,
      "Tax (15%)": tax,
      if (stumpDuty > 0) "Stump Duty": stumpDuty,
      "Gross Premium": gross,
    };

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Bills', count.toDouble(), Colors.blue),
                _buildStatCard('Net Premium', net, Colors.orange),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Tax (15%)', tax, Colors.red),
                if (stumpDuty > 0)
                  _buildStatCard('Stump Duty', stumpDuty, Colors.purple),
                _buildStatCard('Gross Premium', gross, Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            if (net > 0 || tax > 0 || gross > 0)
              SizedBox(
                height: 400, // Same height as the combined pie chart
                width: double.infinity, // Make the chart expand to full width
                child: PieChart(
                  dataMap: dataMap,
                  chartType: ChartType.disc,
                  colorList: [
                    Colors.orange,
                    Colors.red,
                    Colors.purple,
                    Colors.green
                  ],
                  legendOptions: const LegendOptions(legendPosition: LegendPosition.bottom),
                ),
              )
            else
              const Center(child: Text('No data available for visualization.')),
          ],
        ),
      ),
    );
  }



  Widget _buildStatCard(String title, double value, Color color) {
    final formattedValue = NumberFormat("#,##0.00").format(value);
    return Expanded(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(title,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(formattedValue, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
