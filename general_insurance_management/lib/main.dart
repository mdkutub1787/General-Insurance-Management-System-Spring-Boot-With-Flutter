import 'package:flutter/material.dart';
import 'package:general_insurance_management/firepolicy/Total_Fire_Bill_Report_Page.dart';
import 'package:general_insurance_management/firepolicy/view_fire_bill.dart';
import 'package:general_insurance_management/firepolicy/view_fire_policy.dart';
import 'package:general_insurance_management/marinepolicy/Total_Marine_Bill_Report.dart';
import 'package:general_insurance_management/marinepolicy/view_maeine_bill.dart';
import 'package:general_insurance_management/marinepolicy/view_marine_money_receipt.dart';
import 'package:general_insurance_management/marinepolicy/view_marine_policy.dart';
import 'package:general_insurance_management/page/Head_Office.dart';
import 'package:general_insurance_management/page/Home.dart';
import 'package:general_insurance_management/page/User.dart';
import 'package:general_insurance_management/page/login.dart';
import 'package:general_insurance_management/page/registration.dart';
import 'firepolicy/view_money_receipt.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _hoverIndex = -1;  // Variable to track hover state

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomePage(),
        '/login': (context) => Login(),
        '/registration': (context) => Registration(),
        '/viewfirepolicy': (context) => AllFirePolicyView(),
        '/viewfirebill': (context) => AllFireBillView(),
        '/viewfiremoneyreceipt': (context) => AllFireMoneyReceiptView(),
        '/viewmarinepolicy': (context) => AllMarinePolicyView(),
        '/viewmarinebill': (context) => AllMarineBillView(),
        '/viewmarinemoneyreceipt': (context) => AllMarineMoneyReceiptView(),
        '/viewfirereports': (context) => FireBillReportPage(),
        '/viewmarinereports': (context) => MarineBillReportPage(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Page Not Found")),
          body: const Center(child: Text("The page you're looking for doesn't exist.")),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('General Insurance Management')),
        body: const HeadOffice(),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavButton(context, 'Head Office', Icons.location_city_rounded, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const HeadOffice()));
          }),
          _buildBottomNavButton(context, 'Local Office', Icons.location_city, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const User()));
          }),
          _buildBottomNavButton(context, 'Home', Icons.home, () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const HomePage()));
          }),
          _buildBottomNavButton(context, 'Search', Icons.search, () {}),
          _buildBottomNavButton(context, 'Notifications', Icons.notifications, () {}),
        ],
      ),
    );
  }

  Widget _buildBottomNavButton(
      BuildContext context, String label, IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: MouseRegion(
        onEnter: (_) => setState(() {
          _hoverIndex = label.hashCode;  // Use a unique hash for each label
        }),
        onExit: (_) => setState(() {
          _hoverIndex = -1;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()
            ..scale(_hoverIndex == label.hashCode ? 1.2 : 1.0), // Scale on hover
          decoration: BoxDecoration(
            boxShadow: [
              if (_hoverIndex == label.hashCode)
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.2), // Light blue shadow on hover
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: _hoverIndex == label.hashCode ? Colors.green : Colors.blue,
                size: _hoverIndex == label.hashCode ? 30 : 24, // Increase icon size on hover
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _hoverIndex == label.hashCode ? Colors.pinkAccent : Colors.blue,
                  fontStyle: _hoverIndex == label.hashCode ? FontStyle.italic : FontStyle.normal, // Optional italic on hover
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
