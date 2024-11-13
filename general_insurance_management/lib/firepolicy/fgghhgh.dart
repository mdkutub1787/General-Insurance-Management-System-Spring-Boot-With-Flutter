import 'package:flutter/material.dart';
import 'package:general_insurance_management/model/marine_bill_model.dart';
import 'package:general_insurance_management/service/marine_bill_service.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class MarineBillReportPage extends StatefulWidget {
  @override
  State<MarineBillReportPage> createState() => _MarineBillReportPageState();
}

class _MarineBillReportPageState extends State<MarineBillReportPage> {
  late int billCount = 0;
  late double totalNetPremium = 0.0;
  late double totalTax = 0.0;
  late double totalGrossPremium = 0.0;

  List<MarineBillModel> allBills = [];

  @override
  void initState() {
    _fetchAllBills();
    super.initState();
  }

  _fetchAllBills() async {
    allBills = await MarineBillService().getMarineBills();

    setState(() {
      billCount = allBills.length;
      totalNetPremium = calculateTotalNetPremium();
      totalTax = calculateTotalTax();
      totalGrossPremium = calculateTotalGrossPremium();
    });
  }

  // Method to calculate the total number of bills
  int calculateBillCount() {
    return allBills.length; // Simply count the number of filtered bills
  }

  double calculateTotalNetPremium() {
    // Assuming filteredBills contains the bills you want to sum up
    return allBills.fold(0.0, (total, bill) => total + (bill.netPremium ?? 0));
  }

  double calculateTotalTax() {
    double totalNetPremium = calculateTotalNetPremium();
    return totalNetPremium * 0.15; // 15% tax of the total net premium
  }

  double calculateTotalGrossPremium() {
    // Sum up the gross premium of all filtered bills
    return allBills.fold(
        0.0, (total, bill) => total + (bill.grossPremium ?? 0));
  }

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
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
                children: [
                  _buildPdfRow('Total Marine Bills', billCount.toString(),
                      isBillCount: true),
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

  // Function to download the PDF
  Future<void> _downloadPdf(BuildContext context) async {
    final pdf = _createPdfDocument();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // Function to print the PDF
  Future<void> _printPdf(BuildContext context) async {
    final pdf = _createPdfDocument();

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'marine_bill_report.pdf');
  }

  // Helper function to build PDF table rows
  pw.TableRow _buildPdfRow(String label, dynamic value,
      {bool isBillCount = false}) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 16)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8.0),
          child: isBillCount
              ? pw.Text('ID')
              : pw.Text('Tk', style: const pw.TextStyle(fontSize: 16)),
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
                  _buildTableRow('Total Marine Bills', billCount.toString(),
                      isBillCount: true),
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
                  onPressed: () => _downloadPdf(context),
                  child: const Text('Print View'),
                ),
                ElevatedButton(
                  onPressed: () => _printPdf(context),
                  child: const Text('Download PDF'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build table rows
  TableRow _buildTableRow(String label, dynamic value,
      {bool isBillCount = false}) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: const TextStyle(fontSize: 18)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: isBillCount
              ? const Text('ID')
              : const Text('Tk', style: TextStyle(fontSize: 18)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
              value is double ? value.toStringAsFixed(2) : value.toString(),
              style: const TextStyle(fontSize: 18)),
        ),
      ],
    );
  }
}
