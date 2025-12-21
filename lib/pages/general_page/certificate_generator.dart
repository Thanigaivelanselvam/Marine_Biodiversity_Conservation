import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class CertificateGeneratorPage extends StatelessWidget {
  final String name;
  final String country;
  final String activity;
  final double latitude;
  final double longitude;

  const CertificateGeneratorPage({
    super.key,
    required this.name,
    required this.country,
    required this.activity,
    required this.latitude,
    required this.longitude,
  });

  // 📄 Generate PDF & save to Downloads
  Future<File> _generatePdf() async {
    final pdf = pw.Document();
    final date = DateFormat('dd MMM yyyy').format(DateTime.now());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (_) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(32),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blue, width: 4),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  "CERTIFICATE OF APPRECIATION",
                  style: pw.TextStyle(
                    fontSize: 30,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),
                pw.SizedBox(height: 20),

                pw.Text("This certificate is proudly presented to",
                    style: pw.TextStyle(fontSize: 16)),

                pw.SizedBox(height: 12),

                pw.Text(
                  name,
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 10),
                pw.Text("From $country", style: pw.TextStyle(fontSize: 16)),

                pw.SizedBox(height: 20),
                pw.Text("For actively participating in",
                    style: pw.TextStyle(fontSize: 16)),

                pw.SizedBox(height: 8),
                pw.Text(
                  activity,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green,
                  ),
                ),

                pw.SizedBox(height: 18),
                pw.Text(
                  "and contributing towards marine biodiversity conservation.",
                  textAlign: pw.TextAlign.center,
                ),

                pw.SizedBox(height: 30),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text("Date: $date"),
                    pw.Text(
                      "Lat: ${latitude.toStringAsFixed(4)}  "
                          "Lng: ${longitude.toStringAsFixed(4)}",
                      style:
                      pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                    ),
                  ],
                ),

                pw.SizedBox(height: 20),
                pw.Text(
                  "Ocean Heroes Program",
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    // 📁 Save to Downloads
    final downloadDir = Directory('/storage/emulated/0/Download');
    final file = File(
      "${downloadDir.path}/Ocean_Hero_Certificate_${name.replaceAll(' ', '_')}.pdf",
    );

    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // 🧱 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077B6),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Your Certificate",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.workspace_premium,
                  size: 90, color: Colors.amber),
              const SizedBox(height: 16),

              const Text(
                "Congratulations 🎉",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Your Certificate of Appreciation is ready.",
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                icon: const Icon(Icons.download),
                label: const Text("Download to Downloads"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                onPressed: () async {
                  final file = await _generatePdf();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                      Text("Saved to Downloads:\n${file.path}"),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              ElevatedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text("Share Certificate"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                onPressed: () async {
                  final file = await _generatePdf();
                  await Printing.sharePdf(
                    bytes: await file.readAsBytes(),
                    filename: file.path.split('/').last,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
