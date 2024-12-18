import 'package:flutter/material.dart';
import 'package:general_insurance_management/model/bill_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AllFireBillDetails extends StatelessWidget {
  final BillModel bill;

  const AllFireBillDetails({super.key, required this.bill});

  static const double _fontSize = 14;

  // Function to create PDF with table format
  Future<pw.Document> _generatePdf(BuildContext context) async {
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

    return pdf;
  }

  // Helper methods for building PDF sections
  pw.Widget _buildHeader() {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text("Islami Insurance Company Bangladesh Ltd",
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.Text("DR Tower (14th floor), 65/2/2, Purana Paltan, Dhaka-1000."),
          pw.Text("Tel: 02478853405, Mob: 01763001787"),
          pw.Text("Fax: +88 02 55112742"),
          pw.Text("Email: infociclbd.com"),
          pw.Text("Web: www.islamiinsurance.com"),
        ],
      ),
    );
  }



  pw.Widget _buildFireBillInfo() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text("Fire Bill Information", style: _headerTextStyle()),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          data: [
          ['Fire Bill No', '${bill.policy.id ?? "N/A"}', 'Issue Date', '${formatDate(bill.policy.date)}'],
          ],
        ),
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
            ['Bank Name', '${bill.policy.bankName ?? "N/A"}'],
            ['Policyholder', '${bill.policy.policyholder ?? "N/A"}'],
            ['Address', '${bill.policy.address ?? "N/A"}'],
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
            ['Stock Insured', '${bill.policy.stockInsured ?? "N/A"}'],
            ['Sum Insured', 'TK. ${bill.policy.sumInsured ?? "N/A"}'],
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
            ['Interest Insured', '${bill.policy.interestInsured ?? "N/A"}'],
            ['Coverage', '${bill.policy.coverage ?? "N/A"}'],
            ['Location', '${bill.policy.location ?? "N/A"}'],
            ['Construction', '${bill.policy.construction ?? "N/A"}'],
            ['Owner', '${bill.policy.owner ?? "N/A"}'],
            ['Used As', '${bill.policy.usedAs ?? "N/A"}'],
            ['Period From', '${formatDate(bill.policy.periodFrom)}'],
            ['Period To', '${formatDate(bill.policy.periodTo)}'],
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
          headers: ['Description', 'Rate', 'BDT', 'Amount'],
          data: [
            ['Fire Rate', '${bill.fire ?? 0}% on ${bill.policy.sumInsured ?? "N/A"}', 'TK', '${getTotalFire().toStringAsFixed(2)}'],
            ['Rsd Rate', '${bill.rsd ?? 0}% on ${bill.policy.sumInsured ?? "N/A"}', 'TK', '${getTotalRsd().toStringAsFixed(2)}'],
            ['Net Premium (Fire + RSD)', '', 'TK', '${getTotalPremium().toStringAsFixed(2)}'],
            ['Tax on Net Premium', '${bill.tax ?? 0}% on ${getTotalPremium().toStringAsFixed(2)}', 'TK', '${getTotalTax().toStringAsFixed(2)}'],
            ['Gross Premium with Tax', '', 'TK', '${getTotalPremiumWithTax().toStringAsFixed(2)}'],
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
        title: const Center(child: Text('Fire Bill Details')),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildRow('Fire Bill No:', '${bill.policy.id ?? "N/A"}'),
            _buildRow('Issue Date:', '${formatDate(bill.policy.date)}'),
            _buildRow('Bank Name:', '${bill.policy.bankName ?? "N/A"}'),
            _buildRow('Policyholder:', '${bill.policy.policyholder ?? "N/A"}'),
            _buildRow('Address:', '${bill.policy.address ?? "N/A"}'),
            _buildRow('Stock Insured:', '${bill.policy.stockInsured ?? "N/A"}'),
            _buildRow('Sum Insured:', '${bill.policy.sumInsured ?? "N/A"} TK'),
            _buildRow('Interest Insured:', '${bill.policy.interestInsured ?? "N/A"}'),
            _buildRow('Coverage:', '${bill.policy.coverage ?? "N/A"}'),
            _buildRow('Location:', '${bill.policy.location ?? "N/A"}'),
            _buildRow('Construction:', '${bill.policy.construction ?? "N/A"}'),
            _buildRow('Owner:', '${bill.policy.owner ?? "N/A"}'),
            _buildRow('Used As:', '${bill.policy.usedAs ?? "N/A"}'),
            _buildRow('Period From:', '${formatDate(bill.policy.periodFrom)}'),
            _buildRow('Period To:', '${formatDate(bill.policy.periodTo)}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pdf = await _generatePdf(context);  // Generate PDF
                final pdfBytes = await pdf.save(); // Get the bytes of the generated PDF

                await Printing.sharePdf(
                  bytes: pdfBytes,
                  filename: 'fire_bill_information.pdf',
                );
              },
              child: const Text('Download PDF'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
                  final pdf = await _generatePdf(context);  // Generate PDF
                  return pdf.save();  // Return the saved bytes for printing
                });
              },
              child: const Text('Print View'),
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

  String formatDate(DateTime? date) {
    return date != null ? DateFormat('dd-MM-yyyy').format(date) : "N/A";
  }

  double getTotalFire() {
    return bill.fire != null && bill.policy.sumInsured != null
        ? (bill.fire! / 100) * bill.policy.sumInsured!
        : 0.0;
  }

  double getTotalRsd() {
    return bill.rsd != null && bill.policy.sumInsured != null
        ? (bill.rsd! / 100) * bill.policy.sumInsured!
        : 0.0;
  }

  double getTotalPremium() {
    return getTotalFire() + getTotalRsd();
  }

  double getTotalTax() {
    return (bill.tax != null ? bill.tax! / 100 : 0.0) * getTotalPremium();
  }

  double getTotalPremiumWithTax() {
    return getTotalPremium() + getTotalTax();
  }
}
