import 'package:flutter/material.dart';
import 'package:general_insurance_management/marinepolicy/create_marine_policy.dart';
import 'package:general_insurance_management/marinepolicy/marine_policy_details.dart';
import 'package:general_insurance_management/model/marine_policy_model.dart';
import 'package:general_insurance_management/service/marine_policy_service.dart';

class AllMarinePolicyView extends StatefulWidget {
  const AllMarinePolicyView({super.key});

  @override
  State<AllMarinePolicyView> createState() => _AllMarinePolicyViewState();
}

class _AllMarinePolicyViewState extends State<AllMarinePolicyView> {
  late Future<List<MarinePolicyModel>> futurePolicies;
  List<MarinePolicyModel> filteredPolicies = [];
  final TextEditingController searchController = TextEditingController();

  final TextStyle commonStyle = TextStyle(fontSize: 14, color: Colors.black);
  final MarinePolicyService marinePolicyService = MarinePolicyService();

  @override
  void initState() {
    super.initState();
    futurePolicies = marinePolicyService.fetchMarinePolicies();
    futurePolicies.then((policies) {
      setState(() {
        filteredPolicies = policies;
      });
    });
  }

  void _filterPolicies(String query) {
    futurePolicies.then((policies) {
      setState(() {
        filteredPolicies = policies.where((policy) {
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
        SnackBar(content: Text('Marine Policy deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting Marine Policy: $e')),
      );
    }
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
                  final policies = filteredPolicies.isNotEmpty ? filteredPolicies : snapshot.data!;
                  return ListView.builder(
                    itemCount: policies.length,
                    itemBuilder: (context, index) {
                      final policy = policies[index];
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
                                  style: TextStyle(
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
                                  style: commonStyle,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        policy.address ?? 'No address',
                                        style: commonStyle,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // View button with only an icon
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
                                    const SizedBox(width: 8), // Space between icons
                                    // Delete button with only an icon
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _deletePolicy(policy.id!);
                                      },
                                    ),
                                  ],
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
