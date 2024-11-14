import 'package:flutter/material.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:general_insurance_management/model/marine_money_receipt_model.dart';
import 'package:intl/intl.dart'; // Ensure you have this package for date formatting
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintMarineCoverNote extends StatelessWidget {
  final MarineMoneyReceiptModel moneyreceipt;

  const PrintMarineCoverNote({super.key, required this.moneyreceipt});

  static const double _fontSize = 14;

  // Function to create PDF with table format
  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              pw.SizedBox(height: 10),
              _buildFireBillInfo(),
              pw.SizedBox(height: 10),
              _buildInsuredDetails(),
              pw.SizedBox(height: 10),
              _buildSumInsuredDetails(),
              pw.SizedBox(height: 10),
              _buildSituationDetails(),
              pw.SizedBox(height: 10),
              _buildPremiumAndTaxDetails(),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'marine_bill_information.pdf',
    );
  }

  // Helper methods for building PDF sections
  pw.Widget _buildHeader() {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text("ইসলামী ইন্স্যুরেন্স কোম্পানী বাংলাদেশ লিমিটেড",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Text("Islami Insurance Com. Bangladesh Ltd",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Text("DR Tower (14th floor), 65/2/2, Box Culvert Road, Purana Paltan, Dhaka-1000."),
          pw.Text("Tel: 02478853405, Mob: 01763001787"),
          pw.Text("Fax: +88 02 55112742"),
          pw.Text("Email: infociclbd.com"),
          pw.Text("Web: www.islamiinsurance.com"),
        ],
      ),
    );
  }


  pw.Widget _buildFireBillInfo() {
    return pw.Table.fromTextArray(
      data: [
        ['Marine Bill No','${moneyreceipt.marinebill?.marineDetails.id ?? "N/A"}','Issue Date', '${formatDate(moneyreceipt.marinebill?.marineDetails.date)}'],
      ],
    );
  }

  pw.Widget _buildInsuredDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Table.fromTextArray(
          data: [
            ['Bank Name', '${moneyreceipt.marinebill?.marineDetails?.bankName ?? "N/A"}'],
            ['Policyholder', '${moneyreceipt.marinebill?.marineDetails?.policyholder ?? "N/A"}'],
            ['Address', '${moneyreceipt.marinebill?.marineDetails?.address ?? "N/A"}'],
          ],
        ),
      ],
    );
  }

  pw.Widget _buildSumInsuredDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Table.fromTextArray(
          data: [
            ['Sum Insured Usd', '${moneyreceipt.marinebill?.marineDetails?.sumInsuredUsd ?? "N/A"} Usd'],
            ['Usd Rate', '${moneyreceipt.marinebill?.marineDetails?.usdRate ?? "N/A"} '],
            ['Sum Insured', '${moneyreceipt.marinebill?.marineDetails?.sumInsured ?? "N/A"} TK'],
          ],
        ),
      ],
    );
  }

  pw.Widget _buildSituationDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Table.fromTextArray(
          data: [
            ['Voyage From', '${moneyreceipt.marinebill?.marineDetails?.voyageFrom ?? "N/A"}'],
            ['Voyage To', '${moneyreceipt.marinebill?.marineDetails?.voyageTo ?? "N/A"}'],
            ['Interest Insured', '${moneyreceipt.marinebill?.marineDetails?.via ?? "N/A"}'],
            ['Coverage', '${moneyreceipt.marinebill?.marineDetails?.coverage ?? "N/A"}'],
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPremiumAndTaxDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Table.fromTextArray(
          headers: ['Description', 'Rate', 'BDT', 'Amount'],
          data: [
            [
              'Marine Rate',
              '${moneyreceipt.marinebill?.marineRate ?? 0}% on ${moneyreceipt.marinebill?.marineDetails?.sumInsured ?? "N/A"}',
              'TK',
              '${getTotalMarine().toStringAsFixed(2)}'
            ],
            [
              'War/SRCC Rate',
              '${moneyreceipt.marinebill?.warSrccRate ?? 0}% on ${moneyreceipt.marinebill?.marineDetails?.sumInsured ?? "N/A"}',
              'TK',
              '${getTotalwarSrcc().toStringAsFixed(2)}'
            ],
            ['Net Premium', '', 'TK', '${getTotalPremium().toStringAsFixed(2)}'],
            ['Tax on Net Premium', '${moneyreceipt.marinebill?.tax ?? 0}% on ${getTotalPremium().toStringAsFixed(2)}', 'TK', '${getTotalTax().toStringAsFixed(2)}'],
            ['Stamp Duty', '', 'TK', '${getTotalstampDuty().toStringAsFixed(2)}'],
            ['Gross Premium', '', 'TK', '${getTotalPremiumWithTax().toStringAsFixed(2)}'],
          ],
        ),
      ],
    );
  }

  pw.TextStyle _headerTextStyle() {
    return pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Marine Bill Details')),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green, Colors.orange, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Marine Bill No:', '${moneyreceipt.marinebill?.marineDetails?.id ?? "N/A"}'),
            _buildRow('Issue Date:', '${formatDate(moneyreceipt.marinebill?.marineDetails?.date)}'),
            _buildRow('Bank Name:', '${moneyreceipt.marinebill?.marineDetails?.bankName ?? "N/A"}'),
            _buildRow('Policyholder:', '${moneyreceipt.marinebill?.marineDetails?.policyholder ?? "N/A"}'),
            _buildRow('Address:', '${moneyreceipt.marinebill?.marineDetails?.address ?? "N/A"}'),
            _buildRow('Sum Insured Usd:', '${moneyreceipt.marinebill?.marineDetails?.sumInsuredUsd ?? "N/A"} Usd'),
            _buildRow('Usd Rate:', '${moneyreceipt.marinebill?.marineDetails?.usdRate ?? "N/A"}'),
            _buildRow('Sum Insured:', '${moneyreceipt.marinebill?.marineDetails?.sumInsured ?? "N/A"} TK'),
            _buildRow('Voyage From:', '${moneyreceipt.marinebill?.marineDetails?.voyageFrom ?? "N/A"}'),
            _buildRow('Voyage To:', '${moneyreceipt.marinebill?.marineDetails?.voyageTo ?? "N/A"}'),
            _buildRow('Via:', '${moneyreceipt.marinebill?.marineDetails?.via ?? "N/A"}'),
            _buildRow('Coverage:', '${moneyreceipt.marinebill?.marineDetails?.coverage ?? "N/A"}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _generatePdf(context),
              child: const Text('Download PDF'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: _fontSize)),
        Text(value, style: const TextStyle(fontSize: _fontSize)),
      ],
    );
  }

  // Calculation Methods
  // Calculation Methods
  double getTotalMarine() {
    double marineRateValue = (moneyreceipt.marinebill?.marineRate ?? 0).toDouble();
    double sumInsuredValue = (moneyreceipt.marinebill?.marineDetails?.sumInsured ?? 0).toDouble();
    return (sumInsuredValue * (marineRateValue / 100)).roundToDouble();
  }

  double getTotalwarSrcc() {
    double warSrccRateValue = (moneyreceipt.marinebill?.warSrccRate ?? 0).toDouble();
    double sumInsuredValue = (moneyreceipt.marinebill?.marineDetails?.sumInsured ?? 0).toDouble();
    return (sumInsuredValue * (warSrccRateValue / 100)).roundToDouble();
  }

  double getTotalPremium() {
    return getTotalMarine() + getTotalwarSrcc();
  }

  double getTotalTax() {
    double netPremium = getTotalPremium();
    double taxRate = (moneyreceipt.marinebill?.tax ?? 0).toDouble();
    return (netPremium * (taxRate / 100)).roundToDouble();
  }

  double getTotalstampDuty() {
    return 25; // Set stamp duty as required
  }

  double getTotalPremiumWithTax() {
    return getTotalPremium() + getTotalTax() + getTotalstampDuty();
  }
  String formatDate(DateTime? date) {
    if (date == null) {
      return "N/A";
    }
    return DateFormat('dd-MM-yyyy').format(date);
  }
}
