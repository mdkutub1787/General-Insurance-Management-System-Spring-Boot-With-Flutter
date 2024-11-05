import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:general_insurance_management/marinepolicy/create_marine_policy.dart';
import 'package:general_insurance_management/marinepolicy/marine_policy_details.dart';
import 'package:general_insurance_management/marinepolicy/update_marine_policy.dart';
import 'package:general_insurance_management/model/marine_policy_model.dart';
import 'package:general_insurance_management/service/marine_policy_service.dart';

class AllMarinePolicyView extends StatefulWidget {
  const AllMarinePolicyView({Key? key}) : super(key: key);

  @override
  State<AllMarinePolicyView> createState() => _AllMarinePolicyViewState();
}

class _AllMarinePolicyViewState extends State<AllMarinePolicyView> {
  late Future<List<MarinePolicyModel>> futurePolicies;
  List<MarinePolicyModel> allPolicies = [];
  List<MarinePolicyModel> filteredPolicies = [];
  final TextEditingController searchController = TextEditingController();
  final MarinePolicyService marinePolicyService = MarinePolicyService();
  Timer? _debounce; // Timer for debouncing search input

  @override
  void initState() {
    super.initState();
    futurePolicies = marinePolicyService.fetchMarinePolicies();
    futurePolicies.then((policies) {
      setState(() {
        allPolicies = policies;
        filteredPolicies = policies; // Initialize filteredPolicies
      });
    });
  }

  void _filterPolicies(String query) {
    // Cancel the previous timer if it exists
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    // Start a new timer
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        filteredPolicies = allPolicies.where((policy) {
          return policy.policyholder!.toLowerCase().contains(query.toLowerCase()) ||
              policy.bankName!.toLowerCase().contains(query.toLowerCase()) ||
              policy.id.toString().contains(query);
        }).toList();
      });
    });
  }

  Future<void> _deletePolicy(int id) async {
    try {
      await marinePolicyService.deleteMarinePolicy(id);
      setState(() {
        filteredPolicies.removeWhere((policy) => policy.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marine Policy deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting Marine Policy: $e')),
      );
    }
  }

  Future<void> _updateMarinePolicy(int id) async {
    final policy = allPolicies.firstWhere((p) => p.id == id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateMarinePolicy(policy: policy),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose(); // Dispose of the controller
    _debounce?.cancel(); // Cancel the debounce timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marine Policy List'),
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
              onChanged: _filterPolicies,
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
            child: FutureBuilder<List<MarinePolicyModel>>(
              future: futurePolicies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No marine policy available'));
                } else {
                  return ListView.builder(
                    itemCount: filteredPolicies.length,
                    itemBuilder: (context, index) {
                      final policy = filteredPolicies[index];
                      return PolicyListItem(
                        policy: policy,
                        onDelete: () => _deletePolicy(policy.id!),
                        onUpdate: () => _updateMarinePolicy(policy.id!),
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
            MaterialPageRoute(builder: (context) => const CreateMarinePolicy()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class PolicyListItem extends StatelessWidget {
  final MarinePolicyModel policy;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const PolicyListItem({
    Key? key,
    required this.policy,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.8),
            Colors.orange.withOpacity(0.8),
            Colors.yellow.withOpacity(0.8),
            Colors.green.withOpacity(0.8),
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
                'Bill No : ${policy.id}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                policy.bankName ?? 'Unnamed Policy',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                policy.policyholder ?? 'No policyholder available',
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      policy.address ?? 'No address',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Tk ${policy.sumInsured ?? 'No sum'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllMarinePolicyDetails(policy: policy),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.cyan),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateMarinePolicy(policy: policy),
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
  }
}
