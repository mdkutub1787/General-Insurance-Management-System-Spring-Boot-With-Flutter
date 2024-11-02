import 'package:flutter/material.dart';
import 'package:general_insurance_management/firepolicy/fire_policy_details.dart';
import 'package:general_insurance_management/firepolicy/create_fire_policy.dart';
import 'package:general_insurance_management/model/policy_model.dart';
import '../service/policy_service.dart';

class AllFirePolicyView extends StatefulWidget {
  const AllFirePolicyView({super.key});

  @override
  State<AllFirePolicyView> createState() => _AllFirePolicyViewState();
}

class _AllFirePolicyViewState extends State<AllFirePolicyView> {
  late Future<List<PolicyModel>> futurePolicies;
  final PolicyService policyService = PolicyService();
  final TextStyle commonStyle = TextStyle(fontSize: 14, color: Colors.black);
  String searchTerm = '';
  List<PolicyModel> allPolicies = [];

  @override
  void initState() {
    super.initState();
    loadPolicies(); // Load policies on initialization
  }

  Future<void> loadPolicies() async {
    futurePolicies = policyService.fetchFirePolicies();
    setState(() {}); // Update the UI after fetching
  }

  Future<void> _deletePolicy(int policyId) async {
    try {
      await policyService.deletePolicy(policyId);
      await loadPolicies(); // Refresh the policy list after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Policy deleted successfully'), duration: Duration(seconds: 2)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting policy: $e'), duration: Duration(seconds: 2)),
      );
    }
  }

  void _filterPolicies(String query) {
    setState(() {
      searchTerm = query.toLowerCase(); // Update the search query
    });
  }

  List<PolicyModel> _getFilteredPolicies() {
    if (searchTerm.isEmpty) {
      return allPolicies; // Return all policies if search is empty
    }
    return allPolicies.where((policy) {
      final policyholder = policy.policyholder?.toLowerCase() ?? '';
      final bankName = policy.bankName?.toLowerCase() ?? '';
      final id = policy.id.toString();
      return policyholder.contains(searchTerm) ||
          bankName.contains(searchTerm) ||
          id.contains(searchTerm);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fire Policy List'),
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
              onChanged: _filterPolicies, // Call the filter function on text change
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
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<PolicyModel>>(
              future: futurePolicies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No policy available'));
                } else {
                  allPolicies = snapshot.data!;
                  final filteredPolicies = _getFilteredPolicies();
                  return ListView.builder(
                    itemCount: filteredPolicies.length,
                    itemBuilder: (context, index) {
                      final policy = filteredPolicies[index];
                      return _buildPolicyCard(policy);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateFirePolicy()));
          loadPolicies(); // Refresh after returning from create page
        },
        tooltip: 'Create Fire Policy',
        child: const Icon(Icons.add, color: Colors.blue),
      ),
    );
  }

  Widget _buildPolicyCard(PolicyModel policy) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.5),
            Colors.orange.withOpacity(0.5),
            Colors.yellow.withOpacity(0.5),
            Colors.green.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.all(10),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bill No : ${policy.id ?? 'N/A'}', // Displaying the Policy ID
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              Text(
                policy.bankName ?? 'Unnamed Policy',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(policy.policyholder ?? 'No policyholder available', style: commonStyle),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(policy.address ?? 'No address', style: commonStyle)),
                  const SizedBox(width: 10),
                  Text('Tk ${policy.sumInsured ?? 'No sum'}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
              const SizedBox(height: 16),
              _buildActionButtons(policy),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(PolicyModel policy) {
    return Row(
      children: [
        SizedBox(
          width: 125,
          height: 30,
          child: ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllFirePolicyDetails(policy: policy)),
              );
              loadPolicies(); // Refresh after returning from details
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _deletePolicy(policy.id!);
          },
          tooltip: 'Delete Policy',
        ),
      ],
    );
  }
}
