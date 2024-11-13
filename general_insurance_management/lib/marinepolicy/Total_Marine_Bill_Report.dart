import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MarineBillReportPage extends StatelessWidget {
  final int billCount;
  final double totalNetPremium;
  final double totalTax;
  final double totalGrossPremium;

  const MarineBillReportPage({
    super.key,
    required this.billCount,
    required this.totalNetPremium,
    required this.totalTax,
    required this.totalGrossPremium,
  });

  // Function to create the PDF document
  pw.Document _createPdfDocument() {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'Total Marine Bill Report',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
                children: [
                  _buildPdfRow('Total Marine Bills', billCount.toString(), isBillCount: true),
                  _buildPdfRow('Total Net Premium', totalNetPremium),
                  _buildPdfRow('Total Tax', totalTax),
                  _buildPdfRow('Total Gross Premium', totalGrossPremium),
                ],
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  // Function to handle PDF generation with error handling
  Future<void> _generateAndDownloadPdf() async {
    try {
      final pdf = _createPdfDocument();

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      debugPrint('Error generating PDF: $e');
    }
  }

  // Function to handle Print Preview
  Future<void> _printPreview() async {
    try {
      final pdf = _createPdfDocument();

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: 'marine_bill_report.pdf',
      );
    } catch (e) {
      debugPrint('Error printing PDF: $e');
    }
  }

  // Helper function to build PDF table rows
  pw.TableRow _buildPdfRow(String label, dynamic value, {bool isBillCount = false}) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 16)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: isBillCount ? pw.Text('ID') : pw.Text('Tk', style: const pw.TextStyle(fontSize: 16)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Text(
            value is double ? value.toStringAsFixed(2) : value.toString(),
            style: const pw.TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  // Helper function to build on-screen table rows
  TableRow _buildTableRow(String label, dynamic value, {bool isBillCount = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: const TextStyle(fontSize: 18)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: isBillCount ? const Text('ID') : const Text('Tk', style: TextStyle(fontSize: 18)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value is double ? value.toStringAsFixed(2) : value.toString(), style: const TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Marine Bill Report'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Table(
                border: TableBorder.all(color: Colors.black),
                columnWidths: const {
                  0: FixedColumnWidth(200),
                  1: FixedColumnWidth(50),
                  2: FlexColumnWidth(),
                },
                children: [
                  _buildTableRow('Total Marine Bills', billCount.toString(), isBillCount: true),
                  _buildTableRow('Total Net Premium', totalNetPremium),
                  _buildTableRow('Total Tax', totalTax),
                  _buildTableRow('Total Gross Premium', totalGrossPremium),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _printPreview,
                  child: const Text('Download PDF'),
                ),
                ElevatedButton(
                  onPressed: _generateAndDownloadPdf,
                  child: const Text('Print View'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
