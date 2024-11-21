import 'package:flutter/material.dart';
import 'package:general_insurance_management/model/marine_policy_model.dart';
import 'package:general_insurance_management/service/marine_policy_service.dart';
import 'package:intl/intl.dart'; // For formatting dates

class MarinePolicyReportPage extends StatefulWidget {
  @override
  State<MarinePolicyReportPage> createState() => _MarinePolicyReportPageState();
}

class _MarinePolicyReportPageState extends State<MarinePolicyReportPage> {
  List<MarinePolicyModel> allPolicy = [];
  List<MarinePolicyModel> filteredPolicy = [];
  bool isLoading = true;
  bool isError = false;
  DateTime? startDate;
  DateTime? endDate;

  double totalSumInsurdUsd = 0.0;
  double totalSumInsurd = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAllPolicy();
  }

  _fetchAllPolicy() async {
    try {
      allPolicy = await MarinePolicyService().fetchMarinePolicies();
      setState(() {
        filteredPolicy = allPolicy;
        _updateStatistics();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      print('Error fetching policies: $e');
    }
  }

  _updateStatistics() {
    totalSumInsurd = filteredPolicy.fold(0.0, (sum, policy) => sum + (policy.sumInsured ?? 0.0));
    totalSumInsurdUsd = filteredPolicy.fold(0.0, (sum, policy) => sum + (policy.sumInsuredUsd ?? 0.0));
  }

  _filterBillsByDateRange(DateTime start, DateTime end) {
    setState(() {
      filteredPolicy = allPolicy.where((policy) {
        DateTime? billDate = policy.date;
        return billDate != null && billDate.isAfter(start.subtract(Duration(days: 1))) && billDate.isBefore(end.add(Duration(days: 1)));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marine Policy Report'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.yellow.withOpacity(0.8), Colors.green.withOpacity(0.8), Colors.orange.withOpacity(0.8), Colors.red.withOpacity(0.8)],
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
                  ElevatedButton(
                    onPressed: isLoading ? null : _selectDateRange,
                    child: const Text('Date Wise Report'),
                  ),
                  if (startDate != null && endDate != null)
                    Text("From: ${DateFormat('yyyy-MM-dd').format(startDate!)} To: ${DateFormat('yyyy-MM-dd').format(endDate!)}", style: const TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : isError
                  ? const Center(child: Text('Error fetching data.'))
                  : filteredPolicy.isEmpty
                  ? const Text('No policies found for the selected date range.')
                  : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatCard('Marine Policy', filteredPolicy.length.toDouble(), Colors.blue),
                      _buildStatCard('Total Sum Insured Usd', totalSumInsurdUsd, Colors.orange),
                      _buildStatCard('Total Sum Insured Tk', totalSumInsurd, Colors.green),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/home'),
                child: const Text('Go to Home', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              if (startDate != null && endDate != null)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      startDate = null;
                      endDate = null;
                      filteredPolicy = allPolicy; // Show all policies again
                    });
                  },
                  child: const Text('Clear Date Filter'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, double value, Color color) {
    return Flexible(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 8),
              Text(value.toStringAsFixed(2), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
