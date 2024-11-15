import 'package:flutter/material.dart';
import 'package:general_insurance_management/model/marine_money_receipt_model.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintMarineCoverNote extends StatelessWidget {
  final MarineMoneyReceiptModel moneyreceipt;

  const PrintMarineCoverNote({super.key, required this.moneyreceipt});

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
              _buildInsuredDetails(),
              _buildInsuredCondition(),
              _buildSumInsuredDetails(),
              _buildSituationDetails(),
              _buildPremiumAndTaxDetails(),
              pw.SizedBox(height: 20),
              _buildFooterDetails(),
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
          pw.Text("Islami Insurance Com. Bangladesh Ltd",
              style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.Text("DR Tower (14th floor), 65/2/2,Purana Paltan, Dhaka-1000."),
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
        pw.Text("Marine Cover Note", style: _headerTextStyle()),
        pw.SizedBox(height: 10),
        pw.Table.fromTextArray(
          data: [
            [
              'Marine Cover Note No',
              '${moneyreceipt.issuedAgainst ?? "N/A"}',
              'Marine Bill No',
              '${moneyreceipt.marinebill?.marineDetails.id ?? "N/A"}',
              ' Date',
              '${formatDate(moneyreceipt.marinebill?.marineDetails.date)}',
            ],
          ],
        ),
      ],
    );
  }


  pw.Widget _buildInsuredDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Table.fromTextArray(
          data: [
            ['The Insured Name & Address',
              '${moneyreceipt.marinebill?.marineDetails.bankName ?? "N/A"}\n${moneyreceipt.marinebill?.marineDetails.policyholder ?? "N/A"}\n${moneyreceipt.marinebill?.marineDetails.address ?? "N/A"}'],
          ],
        ),
      ],
    );
  }


  pw.Widget _buildInsuredCondition() {
    // Calculate the sum insured in words
    final sumInsuredInWords = convertToWords(moneyreceipt.marinebill?.marineDetails.sumInsured ?? 0);
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Table.fromTextArray(
          data: [
            [
              'Having this day proposed to effect an insurance against Lorry Risk Only from '
                  '${moneyreceipt.marinebill?.marineDetails.voyageFrom ?? "N/A"}'
                  ', To '
                  '${moneyreceipt.marinebill?.marineDetails.voyageTo ?? "N/A"}'
                  ', ${formatDate(moneyreceipt.marinebill?.marineDetails.date)}'
                  ', on the usual terms and conditions of the company\'s Marine Policy. Having paid the undernoted premium in cash/cheque/P.O/D.D./C.A, the following Property is hereby insured to the extent of '
                  '(${sumInsuredInWords}) Only in the manner specified below:'
            ],
          ],
        ),
      ],
    );
  }

  pw.Widget _buildSumInsuredDetails() {
    // Get the sum insured in words
    final sumInsuredInWords = convertToWords(moneyreceipt.marinebill?.marineDetails.sumInsured ?? 0);
    final sumInsuredUsd = moneyreceipt.marinebill?.marineDetails.sumInsuredUsd ?? 0;
    final usdRate = moneyreceipt.marinebill?.marineDetails.usdRate ?? 0;
    final sumInsuredInTaka = sumInsuredUsd * usdRate;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Table.fromTextArray(
          data: [
            ['Sum Insured Usd', '${sumInsuredUsd.toStringAsFixed(2)} Usd'],
            ['Usd Rate', '${usdRate.toStringAsFixed(2)}'],  // USD Rate
            ['Sum Insured in Taka', 'TK. ${sumInsuredInTaka.toStringAsFixed(2)}'],  // Sum Insured in Taka
            ['Sum Insured', 'TK. ${moneyreceipt.marinebill?.marineDetails.sumInsured ?? "N/A"} (${sumInsuredInWords})'], // Sum Insured in Words
          ],
        ),
      ],
    );
  }

  String convertToWords(double num) {
    const ones = [
      "", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine",
      "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen",
      "Eighteen", "Nineteen"
    ];
    const tens = [
      "", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"
    ];

    String numToWords(int n) {
      if (n == 0) return "";
      if (n < 20) return ones[n];
      if (n < 100) return tens[n ~/ 10] + (n % 10 != 0 ? " " + ones[n % 10] : "");
      if (n < 1000) return ones[n ~/ 100] + " Hundred" + (n % 100 != 0 ? " " + numToWords(n % 100) : "");
      if (n < 1000000) return numToWords(n ~/ 1000) + " Thousand" + (n % 1000 != 0 ? " " + numToWords(n % 1000) : "");
      if (n < 1000000000) return numToWords(n ~/ 1000000) + " Million" + (n % 1000000 != 0 ? " " + numToWords(n % 1000000) : "");
      return "";
    }

    return numToWords(num.toInt());
  }




  pw.Widget _buildSituationDetails() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Table.fromTextArray(
          data: [
            ['Voyage From', '${moneyreceipt.marinebill?.marineDetails.voyageFrom ?? "N/A"}'],
            ['Voyage To', '${moneyreceipt.marinebill?.marineDetails.voyageTo ?? "N/A"}'],
            ['Interest Insured', '${moneyreceipt.marinebill?.marineDetails.via ?? "N/A"}'],
            ['Coverage', '${moneyreceipt.marinebill?.marineDetails.coverage ?? "N/A"}'],
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
              '${moneyreceipt.marinebill?.marineRate ?? 0}% on ${moneyreceipt.marinebill?.marineDetails.sumInsured ?? "N/A"}',
              'TK',
              '${getTotalMarine().toStringAsFixed(2)}'
            ],
            [
              'War/SRCC Rate',
              '${moneyreceipt.marinebill?.warSrccRate ?? 0}% on ${moneyreceipt.marinebill?.marineDetails.sumInsured ?? "N/A"}',
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

  pw.Widget _buildFooterDetails() {
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Renewal No:'),
                  pw.Text('${moneyreceipt.issuedAgainst} / ${moneyreceipt.marinebill?.marineDetails.id ?? "N/A"} / ${formatDate(moneyreceipt.marinebill?.marineDetails.date)}'),
                  pw.Text('Checked by ________________'),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Text('Fully Re-insured with'),
                  pw.Text('Sadharan Bima Corporation'),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text('For & on behalf of'),
                  pw.Text('Islami Insurance Com. Ltd.'),
                  pw.Text('     Authorized Officer    ______________________'),
                ],
              ),
            ),
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
        title: const Center(child: Text('Marine Cover Note')),
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
            _buildRow('Marine Bill No:', '${moneyreceipt.marinebill?.marineDetails.id ?? "N/A"}'),
            _buildRow('Issue Date:', '${formatDate(moneyreceipt.marinebill?.marineDetails.date)}'),
            _buildRow('Bank Name:', '${moneyreceipt.marinebill?.marineDetails.bankName ?? "N/A"}'),
            _buildRow('Policyholder:', '${moneyreceipt.marinebill?.marineDetails.policyholder ?? "N/A"}'),
            _buildRow('Address:', '${moneyreceipt.marinebill?.marineDetails.address ?? "N/A"}'),
            _buildRow('Sum Insured Usd:', '${moneyreceipt.marinebill?.marineDetails.sumInsuredUsd ?? "N/A"} Usd'),
            _buildRow('Usd Rate:', '${moneyreceipt.marinebill?.marineDetails.usdRate ?? "N/A"}'),
            _buildRow('Sum Insured:', '${moneyreceipt.marinebill?.marineDetails.sumInsured ?? "N/A"} TK'),
            _buildRow('Voyage From:', '${moneyreceipt.marinebill?.marineDetails.voyageFrom ?? "N/A"}'),
            _buildRow('Voyage To:', '${moneyreceipt.marinebill?.marineDetails.voyageTo ?? "N/A"}'),
            _buildRow('Via:', '${moneyreceipt.marinebill?.marineDetails.via ?? "N/A"}'),
            _buildRow('Coverage:', '${moneyreceipt.marinebill?.marineDetails.coverage ?? "N/A"}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pdf = await _generatePdf(context);  // Generate PDF
                final pdfBytes = await pdf.save(); // Get the bytes of the generated PDF

                await Printing.sharePdf(
                  bytes: pdfBytes,
                  filename: 'marine_bill_covernote.pdf',
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

  // Calculation Methods
  double getTotalMarine() {
    double marineRateValue = (moneyreceipt.marinebill?.marineRate ?? 0).toDouble();
    double sumInsuredValue = (moneyreceipt.marinebill?.marineDetails.sumInsured ?? 0).toDouble();
    return (sumInsuredValue * (marineRateValue / 100)).roundToDouble();
  }

  double getTotalwarSrcc() {
    double warSrccRateValue = (moneyreceipt.marinebill?.warSrccRate ?? 0).toDouble();
    double sumInsuredValue = (moneyreceipt.marinebill?.marineDetails.sumInsured ?? 0).toDouble();
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
    double stampDuty = (moneyreceipt.marinebill?.stampDuty ?? 0).toDouble();
    return stampDuty.roundToDouble();
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
