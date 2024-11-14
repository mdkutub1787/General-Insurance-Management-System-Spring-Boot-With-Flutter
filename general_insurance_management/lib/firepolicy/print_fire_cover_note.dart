import 'package:flutter/material.dart';
import 'package:general_insurance_management/model/money_receipt_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintFireCoverNote extends StatelessWidget {
  final MoneyReceiptModel moneyreceipt;

  const PrintFireCoverNote({super.key, required this.moneyreceipt});

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
    return pw.Table.fromTextArray(
      data: [
        ['Fire Bill No', '${moneyreceipt.bill?.policy.id ?? "N/A"}', 'Issue Date', '${formatDate(moneyreceipt.bill?.policy.date)}'],
      ],
    );
  }

  pw.Widget _buildInsuredDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Table.fromTextArray(
          data: [
            ['Bank Name', '${moneyreceipt.bill?.policy.bankName ?? "N/A"}'],
            ['Policyholder', '${moneyreceipt.bill?.policy.policyholder ?? "N/A"}'],
            ['Address', '${moneyreceipt.bill?.policy.address ?? "N/A"}'],
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
            ['Stock Insured', '${moneyreceipt.bill?.policy.stockInsured ?? "N/A"}'],
            ['Sum Insured', 'TK. ${moneyreceipt.bill?.policy.sumInsured ?? "N/A"}'],
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
            ['Interest Insured', '${moneyreceipt.bill?.policy.interestInsured ?? "N/A"}'],
            ['Coverage', '${moneyreceipt.bill?.policy.coverage ?? "N/A"}'],
            ['Location', '${moneyreceipt.bill?.policy.location ?? "N/A"}'],
            ['Construction', '${moneyreceipt.bill?.policy.construction ?? "N/A"}'],
            ['Owner', '${moneyreceipt.bill?.policy.owner ?? "N/A"}'],
            ['Used As', '${moneyreceipt.bill?.policy.usedAs ?? "N/A"}'],
            ['Period From', '${formatDate(moneyreceipt.bill?.policy.periodFrom)}'],
            ['Period To', '${formatDate(moneyreceipt.bill?.policy.periodTo)}'],
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
            ['Fire Rate', '${moneyreceipt.bill?.fire ?? 0}% on ${moneyreceipt.bill?.policy.sumInsured ?? "N/A"}', 'TK', '${getTotalFire().toStringAsFixed(2)}'],
            ['Rsd Rate', '${moneyreceipt.bill?.rsd ?? 0}% on ${moneyreceipt.bill?.policy.sumInsured ?? "N/A"}', 'TK', '${getTotalRsd().toStringAsFixed(2)}'],
            ['Net Premium (Fire + RSD)', '', 'TK', '${getTotalPremium().toStringAsFixed(2)}'],
            ['Tax on Net Premium', '${moneyreceipt.bill?.tax ?? 0}% on ${getTotalPremium().toStringAsFixed(2)}', 'TK', '${getTotalTax().toStringAsFixed(2)}'],
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Fire Bill No:', '${moneyreceipt.bill?.policy.id ?? "N/A"}'),
            _buildRow('Issue Date:', '${formatDate(moneyreceipt.bill?.policy.date)}'),
            _buildRow('Bank Name:', '${moneyreceipt.bill?.policy.bankName ?? "N/A"}'),
            _buildRow('Policyholder:', '${moneyreceipt.bill?.policy.policyholder ?? "N/A"}'),
            _buildRow('Address:', '${moneyreceipt.bill?.policy.address ?? "N/A"}'),
            _buildRow('Stock Insured:', '${moneyreceipt.bill?.policy.stockInsured ?? "N/A"}'),
            _buildRow('Sum Insured:', '${moneyreceipt.bill?.policy.sumInsured ?? "N/A"} TK'),
            _buildRow('Interest Insured:', '${moneyreceipt.bill?.policy.interestInsured ?? "N/A"}'),
            _buildRow('Coverage:', '${moneyreceipt.bill?.policy.coverage ?? "N/A"}'),
            _buildRow('Location:', '${moneyreceipt.bill?.policy.location ?? "N/A"}'),
            _buildRow('Construction:', '${moneyreceipt.bill?.policy.construction ?? "N/A"}'),
            _buildRow('Owner:', '${moneyreceipt.bill?.policy.owner ?? "N/A"}'),
            _buildRow('Used As:', '${moneyreceipt.bill?.policy.usedAs ?? "N/A"}'),
            _buildRow('Period From:', '${formatDate(moneyreceipt.bill?.policy.periodFrom)}'),
            _buildRow('Period To:', '${formatDate(moneyreceipt.bill?.policy.periodTo)}'),
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
    if (moneyreceipt.bill?.fire != null && moneyreceipt.bill?.policy.sumInsured != null) {
      return (moneyreceipt.bill!.fire! / 100) * moneyreceipt.bill!.policy.sumInsured!;
    }
    return 0.0;  // Return 0.0 if either is null
  }

  double getTotalRsd() {
    if (moneyreceipt.bill?.rsd != null && moneyreceipt.bill?.policy.sumInsured != null) {
      return (moneyreceipt.bill!.rsd! / 100) * moneyreceipt.bill!.policy.sumInsured!;
    }
    return 0.0;  // Return 0.0 if either is null
  }

  double getTotalPremium() {
    return getTotalFire() + getTotalRsd();
  }

  double getTotalTax() {
    return (getTotalPremium() * (moneyreceipt.bill?.tax ?? 0)) / 100;
  }

  double getTotalPremiumWithTax() {
    return getTotalPremium() + getTotalTax();
  }
}
