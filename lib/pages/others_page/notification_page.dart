// notification_page.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  Future<void> openPdfFromUrl(String url, BuildContext context) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath =
          "${tempDir.path}/downloaded_${DateTime.now().millisecondsSinceEpoch}.pdf";

      final response = await http.get(Uri.parse(url));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      await OpenFile.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Unable to open file: $e")));
    }
  }

  // ------------------ DELETE FUNCTION ------------------
  Future<void> deleteItem(
    String id,
    String source,
    BuildContext context,
  ) async {
    try {
      await FirebaseFirestore.instance.collection(source).doc(id).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Deleted Successfully"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Delete Failed: $e")));
    }
  }

  void showDeleteDialog(BuildContext context, String id, String source) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Delete Notification"),
            content: const Text("Are you sure you want to delete this item?"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Delete"),
                onPressed: () {
                  Navigator.pop(context);
                  deleteItem(id, source, context);
                },
              ),
            ],
          ),
    );
  }

  DateTime _parseCreatedAt(dynamic createdAt) {
    if (createdAt == null) return DateTime.fromMillisecondsSinceEpoch(0);
    if (createdAt is Timestamp) return createdAt.toDate();
    if (createdAt is DateTime) return createdAt;
    try {
      return DateTime.parse(createdAt.toString());
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection("notifications")
                .orderBy("createdAt", descending: true)
                .snapshots(),
        builder: (context, eventSnapshot) {
          if (eventSnapshot.hasError) {
            return Center(child: Text("Error: ${eventSnapshot.error}"));
          }
          if (eventSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final eventDocs = eventSnapshot.data?.docs ?? [];

          return StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance
                    .collection("notices")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
            builder: (context, noticeSnapshot) {
              final noticeDocs = noticeSnapshot.data?.docs ?? [];

              final List<Map<String, dynamic>> items = [];

              for (final d in eventDocs) {
                final m = d.data() as Map<String, dynamic>;
                items.add({
                  "id": d.id,
                  "source": "notifications",
                  "type": m["type"] ?? "event",
                  "title": m["title"] ?? "",
                  "subtitle": m["subtitle"] ?? "",
                  "message": m["message"] ?? "",
                  "imageUrl": m["imageUrl"] ?? m["posterUrl"] ?? "",
                  "fileUrl": m["fileUrl"] ?? "",
                  "createdAt": _parseCreatedAt(m["createdAt"]),
                });
              }

              for (final d in noticeDocs) {
                final m = d.data() as Map<String, dynamic>;
                items.add({
                  "id": d.id,
                  "source": "notices",
                  "type": "notice",
                  "title": m["title"] ?? "",
                  "subtitle": "",
                  "message": m["message"] ?? "",
                  "imageUrl": m["imageUrl"] ?? "",
                  "fileUrl": m["fileUrl"] ?? "",
                  "createdAt": _parseCreatedAt(m["createdAt"]),
                });
              }

              // Sort by date
              items.sort(
                (a, b) =>
                    (b["createdAt"] as DateTime).compareTo(a["createdAt"]),
              );

              if (items.isEmpty) {
                return const Center(
                  child: Text(
                    "No Notifications",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: 12,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  return GestureDetector(
                    onLongPress:
                        () => showDeleteDialog(
                          context,
                          item["id"],
                          item["source"],
                        ),
                    child: Card(
                      margin: EdgeInsets.only(bottom: width * 0.03),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.03),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title + Type Badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item["title"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: width * 0.045,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        item["type"] == "event"
                                            ? Colors.green.shade100
                                            : Colors.orange.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    item["type"].toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Subtitle
                            if ((item["subtitle"] as String).isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  item["subtitle"],
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ),

                            SizedBox(height: width * 0.02),

                            // Message
                            Text(
                              item["message"],
                              style: TextStyle(fontSize: width * 0.04),
                            ),

                            // Image
                            if ((item["imageUrl"] as String).isNotEmpty) ...[
                              SizedBox(height: width * 0.03),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item["imageUrl"],
                                  width: double.infinity,
                                  height: width * 0.45,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],

                            // File Button
                            if ((item["fileUrl"] as String).isNotEmpty) ...[
                              SizedBox(height: width * 0.03),
                              ElevatedButton.icon(
                                onPressed:
                                    () => openPdfFromUrl(
                                      item["fileUrl"],
                                      context,
                                    ),
                                icon: const Icon(Icons.picture_as_pdf),
                                label: const Text("Open Attachment"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],

                            SizedBox(height: width * 0.02),

                            // Time
                            Text(
                              "${item["createdAt"]}".split(".").first,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: width * 0.032,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
