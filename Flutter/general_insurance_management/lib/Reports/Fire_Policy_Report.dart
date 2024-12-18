import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates
import 'package:general_insurance_management/model/policy_model.dart';
import 'package:general_insurance_management/service/policy_service.dart';

class FirePolicyReportPage extends StatefulWidget {
  @override
  State<FirePolicyReportPage> createState() => _FirePolicyReportPageState();
}

class _FirePolicyReportPageState extends State<FirePolicyReportPage> {
  late int policyCount = 0;
  late double totalSumInsurd = 0.0;

  List<PolicyModel> allPolicy = [];
  List<PolicyModel> filteredPolicy = [];

  DateTime? startDate;
  DateTime? endDate;

  bool isLoading = true; // Track loading state
  bool isError = false; // Track error state

  double _buttonScale = 1.0; // For Button Animation

  @override
  void initState() {
    _fetchAllPolicy();
    super.initState();
  }

  _fetchAllPolicy() async {
    try {
      allPolicy = await PolicyService().fetchPolicies();
      setState(() {
        filteredPolicy = allPolicy; // Initially show all bills
        _updateStatistics();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      print('Error fetching bills: $e');
    }
  }

  _updateStatistics() {
    policyCount = filteredPolicy.length;
    totalSumInsurd = calculateTotalSumInsurd();
  }

  _filterBillsByDateRange(DateTime start, DateTime end) {
    setState(() {
      filteredPolicy = allPolicy.where((policy) {
        DateTime? billDate = policy.date;
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

  double calculateTotalSumInsurd() {
    return filteredPolicy.fold(0.0, (sum, policy) => sum + (policy.sumInsured ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fire Policy Report'),
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
                      onPressed: isLoading ? null : () {
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
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : isError
                  ? const Center(child: Text('Error fetching data.'))
                  : filteredPolicy.isEmpty
                  ? const Text('No policies found for the selected date range.')
                  : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCard('Fire Policy', policyCount.toDouble(), Colors.blue),
                      _buildStatCard('Total Sum Insured', totalSumInsurd, Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              const SizedBox(height: 200),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
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
            // Shadow effect is removed as it's not used
          });
        },
        onExit: (_) {
          setState(() {
            // Shadow effect is removed as it's not used
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
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
                    style: const TextStyle(
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
