import 'package:flutter/material.dart';
import 'package:general_insurance_management/firepolicy/Total_Fire_Bill_Report_Page.dart';
import 'package:general_insurance_management/firepolicy/fgghhgh.dart';
import 'package:general_insurance_management/firepolicy/view_fire_bill.dart';
import 'package:general_insurance_management/firepolicy/view_fire_policy.dart';
import 'package:general_insurance_management/marinepolicy/view_maeine_bill.dart';
import 'package:general_insurance_management/marinepolicy/view_marine_money_receipt.dart';
import 'package:general_insurance_management/marinepolicy/view_marine_policy.dart';
import 'package:general_insurance_management/page/Home.dart';
import 'package:general_insurance_management/page/login.dart';
import 'package:general_insurance_management/page/registration.dart';
import 'firepolicy/view_money_receipt.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: HomePage(),
    );
  }
}
