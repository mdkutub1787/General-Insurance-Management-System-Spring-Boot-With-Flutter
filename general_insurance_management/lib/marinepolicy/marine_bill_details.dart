// all_marine_bill_details.dart
import 'package:flutter/material.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AllMarineBillDetails extends StatelessWidget {
  final MarineBillModel marineBill;

  const AllMarineBillDetails({super.key, required this.marineBill});

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
      headers: ['Marine Bill No', 'Issue Date'],
      data: [
        ['${marineBill.marineDetails?.id ?? "N/A"}', '${marineBill.marineDetails?.date ?? "N/A"}'],
      ],
    );
  }

  pw.Widget _buildInsuredDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("Insured Details", style: _headerTextStyle()),
        pw.Table.fromTextArray(
          data: [
            ['Bank Name', '${marineBill.marineDetails?.bankName ?? "N/A"}'],
            ['Policyholder', '${marineBill.marineDetails?.policyholder ?? "N/A"}'],
            ['Address', '${marineBill.marineDetails?.address ?? "N/A"}'],
          ],
        ),
      ],
    );
  }

  pw.Widget _buildSumInsuredDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("Segregation of The Sum Insured", style: _headerTextStyle()),
        pw.Table.fromTextArray(
          data: [
            ['Sum Insured Usd', '${marineBill.marineDetails?.sumInsuredUsd ?? "N/A"} Usd'],
            ['Usd Rate', '${marineBill.marineDetails?.usdRate ?? "N/A"} '],
            ['Sum Insured', '${marineBill.marineDetails?.sumInsured ?? "N/A"} TK'],
          ],
        ),
      ],
    );
  }

  pw.Widget _buildSituationDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("Situation", style: _headerTextStyle()),
        pw.Table.fromTextArray(
          data: [
            ['Voyage From', '${marineBill.marineDetails?.voyageFrom ?? "N/A"}'],
            ['Voyage To', '${marineBill.marineDetails?.voyageTo ?? "N/A"}'],
            ['Interest Insured', '${marineBill.marineDetails?.via ?? "N/A"}'],
            ['Coverage', '${marineBill.marineDetails?.coverage ?? "N/A"}'],
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPremiumAndTaxDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text("Premium and Tax", style: _headerTextStyle()),
        pw.Table.fromTextArray(
          headers: ['Description', 'Rate', 'Currency', 'Amount'],
          data: [
            ['Marine Rate', '${marineBill.marineRate ?? 0}% on ${marineBill.marineDetails?.sumInsured ?? "N/A"}', 'TK', '${getTotalMarine().toStringAsFixed(2)}'],
            ['War/SRCC Rate', '${marineBill.warSrccRate ?? 0}% on ${marineBill.marineDetails?.sumInsured ?? "N/A"}', 'TK', '${getTotalwarSrcc().toStringAsFixed(2)}'],
            ['Net Premium', '', 'TK', '${getTotalPremium().toStringAsFixed(2)}'],
            ['Tax on Net Premium', '${marineBill.tax ?? 0}% on ${getTotalPremium().toStringAsFixed(2)}', 'TK', '${getTotalTax().toStringAsFixed(2)}'],
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
            _buildRow('Fire Bill No:', '${marineBill.marineDetails?.id ?? "N/A"}'),
            _buildRow('Issue Date:', '${marineBill.marineDetails?.date ?? "N/A"}'),
            _buildRow('Bank Name:', '${marineBill.marineDetails?.bankName ?? "N/A"}'),
            _buildRow('Policyholder:', '${marineBill.marineDetails?.policyholder ?? "N/A"}'),
            _buildRow('Address:', '${marineBill.marineDetails?.address ?? "N/A"}'),
            _buildRow('Sum Insured Usd:', '${marineBill.marineDetails?.sumInsuredUsd ?? "N/A"} Usd'),
            _buildRow('Usd Rate:', '${marineBill.marineDetails?.usdRate ?? "N/A"}'),
            _buildRow('Sum Insured:', '${marineBill.marineDetails?.sumInsured ?? "N/A"} TK'),
            _buildRow('Voyage From:', '${marineBill.marineDetails?.voyageFrom ?? "N/A"}'),
            _buildRow('Voyage To:', '${marineBill.marineDetails?.voyageTo ?? "N/A"}'),
            _buildRow('Via:', '${marineBill.marineDetails?.via ?? "N/A"}'),
            _buildRow('Coverage:', '${marineBill.marineDetails?.coverage ?? "N/A"}'),
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
  double getTotalMarine() {
    double marineRateValue = (marineBill.marineRate ?? 0).toDouble();
    double sumInsuredValue = (marineBill.marineDetails?.sumInsured ?? 0).toDouble();
    return (sumInsuredValue * (marineRateValue / 100)).roundToDouble();
  }

  double getTotalwarSrcc() {
    double warSrccRateValue = (marineBill.warSrccRate ?? 0).toDouble();
    double sumInsuredValue = (marineBill.marineDetails?.sumInsured ?? 0).toDouble();
    return (sumInsuredValue * (warSrccRateValue / 100)).roundToDouble();
  }

  double getTotalPremium() {
    return (getTotalMarine() + getTotalwarSrcc()).roundToDouble();
  }

  double getTotalTax() {
    return (getTotalPremium() * ((marineBill.tax ?? 0).toDouble() / 100)).roundToDouble();
  }

  double getTotalstampDuty() {
    return (marineBill.stampDuty ?? 0).toDouble().roundToDouble();
  }

  double getTotalPremiumWithTax() {
    return (getTotalPremium() + getTotalTax() + getTotalstampDuty()).roundToDouble();
  }

}
