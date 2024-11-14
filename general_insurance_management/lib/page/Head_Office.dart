import 'package:flutter/material.dart';
import 'package:general_insurance_management/model/bill_model.dart';
import 'package:general_insurance_management/service/bill_service.dart';

class HeadOffice extends StatefulWidget {
  const HeadOffice({Key? key}) : super(key: key);

  @override
  State<HeadOffice> createState() => _HeadOfficeState();
}

class _HeadOfficeState extends State<HeadOffice> {
  late int billCount = 0;
  late double totalNetPremium = 0.0;
  late double totalTax = 0.0;
  late double totalGrossPremium = 0.0;

  List<BillModel> allBills = [];

  @override
  void initState() {
    super.initState();
    _fetchAllBills();
  }

  Future<void> _fetchAllBills() async {
    try {
      allBills = await BillService().fetchFireBill();
      setState(() {
        billCount = allBills.length;
        totalNetPremium = calculateTotalNetPremium();
        totalTax = calculateTotalTax();
        totalGrossPremium = calculateTotalGrossPremium();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching bills: $error')),
      );
    }
  }

  double calculateTotalNetPremium() {
    return allBills.fold(0.0, (total, bill) => total + (bill.netPremium ?? 0.0));
  }

  double calculateTotalTax() {
    return totalNetPremium * 0.15; // 15% tax of the total net premium
  }

  double calculateTotalGrossPremium() {
    return allBills.fold(0.0, (total, bill) => total + (bill.grossPremium ?? 0.0));
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _editAction(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: const Text('Edit functionality goes here.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAction(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete $title'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add delete functionality here
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'ইসলামী ইন্স্যুরেন্স কোম্পানী বাংলাদেশ লিমিটেড',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            Text('mdkutub150@gmail.com, +8801763001787',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.blue, Colors.lightGreen, Colors.teal],
            ),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQntUidjT9ib73xOZ_LYOvhZg9bSvlU9hOGjaWbTALttUeqeEjJUWKJHbT4r1UqjFM3caQ&usqp=CAU',
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: allBills.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // Wrap the content with SingleChildScrollView
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Head Office',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildStatCard('Bills', billCount.toDouble(), Colors.pink),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard('Net Premium', totalNetPremium, Colors.blue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard('Total Tax', totalTax, Colors.orange),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard('Gross Premium', totalGrossPremium, Colors.green),
                ),
              ],
            ),

            const SizedBox(height: 25),
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildActionCard('Manage Policies', Icons.policy, Colors.purple),
                _buildActionCard('View Reports', Icons.analytics, Colors.cyan),
                _buildActionCard('Employee Directory', Icons.people, Colors.teal),
                _buildActionCard('Settings', Icons.settings, Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, dynamic value, Color color) {
    return Container(
      constraints: const BoxConstraints(minHeight: 120, maxHeight: 120), // Fixed height
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value is int ? value.toString() : value.toStringAsFixed(2),
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: GestureDetector(
        onTap: () {
          if (title == 'Manage Policies') {
            Navigator.of(context).pushNamed('/home');
          } else if (title == 'View Reports') {
            Navigator.of(context).pushNamed('/viewcombindreports');
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () => _editAction(title),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteAction(title),
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
