import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class CertificateGenerator {
  static Future<File> generate({
    required String name,
    required String badge,
    required int score,
    required int total,
  }) async {
    final pdf = pw.Document();

    final date = DateTime.now();
    final formattedDate = "${date.day}-${date.month}-${date.year}";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(40),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blue, width: 4),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(
                  "Certificate of Achievement",
                  style: pw.TextStyle(
                    fontSize: 32,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue,
                  ),
                ),

                pw.SizedBox(height: 30),

                pw.Text(
                  "This certifies that",
                  style: pw.TextStyle(fontSize: 18),
                ),

                pw.SizedBox(height: 12),

                pw.Text(
                  name,
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 20),

                pw.Text(
                  "has successfully completed the Marine Quiz",
                  style: pw.TextStyle(fontSize: 18),
                ),

                pw.SizedBox(height: 14),

                pw.Text(
                  "Score: $score / $total",
                  style: pw.TextStyle(fontSize: 18),
                ),

                pw.SizedBox(height: 10),

                pw.Text(
                  "Badge Earned: $badge",
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green,
                  ),
                ),

                pw.SizedBox(height: 30),

                pw.Text(
                  "Issued on: $formattedDate",
                  style: pw.TextStyle(fontSize: 14),
                ),

                pw.SizedBox(height: 40),

                pw.Text(
                  "🌊 Marine Biodiversity Conservation Initiative 🌍",
                  style: pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/Marine_Quiz_Certificate.pdf");

    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
