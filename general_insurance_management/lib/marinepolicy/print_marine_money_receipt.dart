import 'package:flutter/material.dart';
import 'package:general_insurance_management/model/marine_money_receipt_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PrintMarineMoneyReceipt extends StatelessWidget {
  final MarineMoneyReceiptModel moneyreceipt;

  const PrintMarineMoneyReceipt({super.key, required this.moneyreceipt});

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
              _buildPremiumAndTaxDetails(),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'marine_bill_moneyreceipt.pdf',
    );
  }

  // Helper methods for building PDF sections
  pw.Widget _buildHeader() {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text("ইসলামী ইন্স্যুরেন্স কোম্পানী বাংলাদেশ লিমিটেড", style: _headerTextStyle(fontSize: 18)),
          pw.Text("Islami Insurance Com. Bangladesh Ltd", style: _headerTextStyle(fontSize: 18)),
          pw.Text("DR Tower (14th floor), 65/2/2, Box Culvert Road, Purana Paltan, Dhaka-1000.", style: _textStyle()),
          pw.Text("Tel: 02478853405, Mob: 01763001787", style: _textStyle()),
          pw.Text("Fax: +88 02 55112742", style: _textStyle()),
          pw.Text("Email: infociclbd.com", style: _textStyle()),
          pw.Text("Web: www.islamiinsurance.com", style: _textStyle()),
        ],
      ),
    );
  }

  pw.Widget _buildFireBillInfo() {
    return pw.Table.fromTextArray(
      data: [
        [
          'Fire Bill No', moneyreceipt.marinebill?.marineDetails.id ?? "N/A",
          'Issue Date', formatDate(moneyreceipt.marinebill?.marineDetails.date as DateTime?) ?? "N/A"
        ],
      ],

    );
  }

  pw.Widget _buildInsuredDetails() {
    return pw.Table.fromTextArray(
      data: [
        ['Issuing Office', moneyreceipt.issuingOffice ?? "N/A"],
        ['Money Receipt No', moneyreceipt.id ?? "N/A"],
        ['Class of Insurance', moneyreceipt.classOfInsurance ?? "N/A"],
        [
          'Received with thanks from',
          '${moneyreceipt.marinebill?.marineDetails.bankName ?? "N/A"}\n'
              '${moneyreceipt.marinebill?.marineDetails.policyholder ?? "N/A"}\n'
              '${moneyreceipt.marinebill?.marineDetails.address ?? "N/A"}'
        ],
        ['The sum USD', '${moneyreceipt.marinebill?.marineDetails.sumInsuredUsd ?? "N/A"} USD'],
        ['Rate', '${moneyreceipt.marinebill?.marineDetails.usdRate ?? "N/A"} TK'],
        ['The sum of', '${moneyreceipt.marinebill?.marineDetails.sumInsured ?? "N/A"} TK'],
        ['Mode Of Payment', moneyreceipt.modeOfPayment ?? "N/A"],
        ['Issued Against', moneyreceipt.issuedAgainst ?? "N/A"],
      ],
      headerStyle: _headerTextStyle(),
      cellStyle: _textStyle(),
    );
  }

  // Premium and Tax details section for the PDF
  pw.Widget _buildPremiumAndTaxDetails() {
    final commonTextStyle = pw.TextStyle(fontSize: 12);

    return pw.Table(
      border: pw.TableBorder.all(width: 0.5),
      children: [
        // Header row with bold style
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildCell('Net Premium', style: commonTextStyle.copyWith(fontWeight: pw.FontWeight.bold)),
            _buildCell('BDT', style: commonTextStyle.copyWith(fontWeight: pw.FontWeight.bold)),
            _buildCell(getTotalPremium().toStringAsFixed(2), style: commonTextStyle.copyWith(fontWeight: pw.FontWeight.bold)),
          ],
        ),
        // Tax row
        pw.TableRow(
          children: [
            _buildCell('Tax', style: commonTextStyle),
            _buildCell('BDT', style: commonTextStyle),
            _buildCell(getTotalTax().toStringAsFixed(2), style: commonTextStyle),
          ],
        ),
        // Gross Premium row
        pw.TableRow(
          children: [
            _buildCell('Gross Premium', style: commonTextStyle),
            _buildCell('BDT', style: commonTextStyle),
            _buildCell(getTotalPremiumWithTax().toStringAsFixed(2), style: commonTextStyle),
          ],
        ),
      ],
    );
  }

  // Helper method to create a cell with consistent padding
  pw.Widget _buildCell(String text, {pw.TextStyle? style}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Center(child: pw.Text(text, style: style)),
    );
  }

  pw.TextStyle _headerTextStyle({double fontSize = 14}) {
    return pw.TextStyle(fontSize: fontSize, fontWeight: pw.FontWeight.bold);
  }

  pw.TextStyle _textStyle() {
    return pw.TextStyle(fontSize: _fontSize);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marine Money Receipt'),
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
            ..._buildInfoRows(),
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

  List<Widget> _buildInfoRows() {
    return [
      _buildRow('Fire Bill No:', '${moneyreceipt.marinebill?.marineDetails.id ?? "N/A"}'),
      _buildRow('Issue Date:', formatDate(moneyreceipt.marinebill?.marineDetails.date as DateTime?) ?? "N/A"),
      _buildRow('Issuing Office:', '${moneyreceipt.issuingOffice ?? "N/A"}'),
      _buildRow('Money Receipt No:', '${moneyreceipt.id ?? "N/A"}'),
      _buildRow('Class of Insurance:', '${moneyreceipt.classOfInsurance ?? "N/A"}'),
      _buildRow('Bank Name:', '${moneyreceipt.marinebill?.marineDetails.bankName ?? "N/A"}'),
      _buildRow('Policyholder:', '${moneyreceipt.marinebill?.marineDetails.policyholder ?? "N/A"}'),
      _buildRow('Address:', '${moneyreceipt.marinebill?.marineDetails.address ?? "N/A"}'),
      _buildRow('Sum Insured USD:', '${moneyreceipt.marinebill?.marineDetails.sumInsuredUsd ?? "N/A"} USD'),
      _buildRow('Rate:', '${moneyreceipt.marinebill?.marineDetails.usdRate ?? "N/A"} TK'),
      _buildRow('Sum Insured:', '${moneyreceipt.marinebill?.marineDetails.sumInsured ?? "N/A"} TK'),
      _buildRow('Mode Of Payment:', '${moneyreceipt.modeOfPayment ?? "N/A"}'),
      _buildRow('Issued Against:', '${moneyreceipt.issuedAgainst ?? "N/A"}'),
    ];
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
  double getTotalFire() {
    return ((moneyreceipt.marinebill?.marineDetails.sumInsured ?? 0) *
        (moneyreceipt.marinebill?.marineRate ?? 0) /
        100).roundToDouble();
  }

  double getTotalRsd() {
    return ((moneyreceipt.marinebill?.marineDetails.sumInsured ?? 0) *
        (moneyreceipt.marinebill?.warSrccRate ?? 0) /
        100).roundToDouble();
  }

  double getTotalPremium() {
    return (getTotalFire() + getTotalRsd()).roundToDouble();
  }

  double getTotalTax() {
    return (getTotalPremium() * 0.15).roundToDouble(); // Tax is set at 15%
  }

  double getTotalPremiumWithTax() {
    return (getTotalPremium() + getTotalTax()).roundToDouble();
  }

  // Function to format date to a readable string
  String formatDate(DateTime? date) {
    if (date == null) return "N/A";
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(date);
  }
}
