import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String> downloadPDF(String url) async {
  final response = await http.get(Uri.parse(url));

  final dir = await getTemporaryDirectory();
  final file = File("${dir.path}/temp.pdf");

  await file.writeAsBytes(response.bodyBytes);
  return file.path;
}
