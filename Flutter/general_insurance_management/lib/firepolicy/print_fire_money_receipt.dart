import 'package:flutter/material.dart';
import 'package:general_insurance_management/model/money_receipt_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PrintFireMoneyReceipt extends StatelessWidget {
  final MoneyReceiptModel moneyreceipt;

  const PrintFireMoneyReceipt({super.key, required this.moneyreceipt});

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
              pw.SizedBox(height: 20),
              _buildPremiumAndTaxDetails(),
              pw.SizedBox(height: 20),
              _buildContactInfo(),
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
          pw.Text("Islami Insurance Com. Bangladesh Ltd", style: _headerTextStyle(fontSize: 20)),
          pw.Text("DR Tower (14th floor), 65/2/2,Purana Paltan, Dhaka-1000.", style: _textStyle()),
          pw.Text("Tel: 02478853405, Mob: 01763001787", style: _textStyle()),
          pw.Text("Fax: +88 02 55112742", style: _textStyle()),
          pw.Text("Email: infociclbd.com", style: _textStyle()),
          pw.Text("Web: www.islamiinsurance.com", style: _textStyle()),
        ],
      ),
    );
  }

  pw.Widget _buildFireBillInfo() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text("Fire Money Receipt", style: _headerTextStyle()),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          data: [
            [
              'Fire Bill No', moneyreceipt.bill?.policy.id ?? "N/A",
              'Date', formatDate(moneyreceipt.date as DateTime?) ?? "N/A"
            ],
          ],
        ),
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
          '${moneyreceipt.bill?.policy.bankName ?? "N/A"}\n'
              '${moneyreceipt.bill?.policy.policyholder ?? "N/A"}'
              '${moneyreceipt.bill?.policy.address ?? "N/A"}'
        ],
        ['The sum of', '${moneyreceipt.bill?.policy.sumInsured ?? "N/A"} TK'],
        ['Mode Of Payment', moneyreceipt.modeOfPayment ?? "N/A"],
        ['Issued Against', moneyreceipt.issuedAgainst ?? "N/A"],
      ],
      headerStyle: _headerTextStyle(),
      cellStyle: _textStyle(),
    );
  }


  // Premium and Tax details section for the PDF
  pw.Widget _buildPremiumAndTaxDetails() {
    final commonTextStyle = pw.TextStyle(fontSize: 12); // Adjust font size as needed

    return pw.Table(
      border: pw.TableBorder.all(width: 0.5), // Add small border around the entire table
      children: [
        // Header row with bold style
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300), // Header background color
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

  pw.Widget _buildContactInfo() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.SizedBox(height: 20),  // Spacer for top margin
        pw.Text(
          "This receipt is computer-generated; an authorized signature is not required.",
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 12,
          ),
        ),
        pw.SizedBox(height: 5),  // Spacer between paragraphs
        pw.Text(
          "Receipt is valid subject to the encashment of cheque/P.O./D.D.",
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 12,
          ),
        ),
        pw.SizedBox(height: 5),  // Spacer between paragraphs
        pw.Text(
          "Note: For any complaints regarding insurance, please call 16130.",
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 12,
          ),
        ),
        pw.SizedBox(height: 20),  // Spacer for bottom margin
      ],
    );
  }


  // Helper method to create a cell with consistent padding
  pw.Widget _buildCell(String text, {pw.TextStyle? style}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8), // Consistent padding for all cells
      child: pw.Center(child: pw.Text(text, style: style)), // Center the text
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
        title: const Center(child: Text('Fire Money Receipt')),
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
            ..._buildInfoRows(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pdf = await _generatePdf(context);  // Generate PDF
                final pdfBytes = await pdf.save(); // Get the bytes of the generated PDF

                await Printing.sharePdf(
                  bytes: pdfBytes,
                  filename: 'fire_bill_moneyreceipt.pdf',
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

  List<Widget> _buildInfoRows() {
    return [
      _buildRow('Fire Bill No:', '${moneyreceipt.bill?.policy.id ?? "N/A"}'),
      _buildRow(' Date:', formatDate(moneyreceipt.date as DateTime?) ?? "N/A"),
      _buildRow('Issuing Office:', '${moneyreceipt.issuingOffice ?? "N/A"}'),
      _buildRow('Money Receipt No:', '${moneyreceipt.id ?? "N/A"}'),
      _buildRow('Class of Insurance:', '${moneyreceipt.classOfInsurance ?? "N/A"}'),
      _buildRow('Bank Name:', '${moneyreceipt.bill?.policy.bankName ?? "N/A"}'),
      _buildRow('Policyholder:', '${moneyreceipt.bill?.policy.policyholder ?? "N/A"}'),
      _buildRow('Address:', '${moneyreceipt.bill?.policy.address ?? "N/A"}'),
      _buildRow('Sum Insured:', '${moneyreceipt.bill?.policy.sumInsured ?? "N/A"} TK'),
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
    return double.parse(((moneyreceipt.bill?.policy.sumInsured ?? 0) * (moneyreceipt.bill?.fire ?? 0) / 100).toStringAsFixed(2));
  }

  double getTotalRsd() {
    return double.parse(((moneyreceipt.bill?.policy.sumInsured ?? 0) * (moneyreceipt.bill?.rsd ?? 0) / 100).toStringAsFixed(2));
  }

  double getTotalPremium() {
    return getTotalFire() + getTotalRsd();
  }

  double getTotalTax() {
    return getTotalPremium() * 0.15; // Tax fixed at 15%
  }

  double getTotalPremiumWithTax() {
    return getTotalPremium() + getTotalTax();
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return "N/A";
    }
    // Format the date as desired
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }
}
