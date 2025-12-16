import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NoticeUploadPage extends StatefulWidget {
  final bool isAdmin; // comes from login page
  const NoticeUploadPage({super.key, required this.isAdmin});

  @override
  State<NoticeUploadPage> createState() => _NoticeUploadPageState();
}

class _NoticeUploadPageState extends State<NoticeUploadPage> {
  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  File? selectedFile;
  bool isUploading = false;

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() => selectedFile = File(result.files.single.path!));
    }
  }

  Future<String?> uploadFile(File file) async {
    try {
      final ext = file.path.split('.').last;
      final ref = FirebaseStorage.instance.ref().child(
        "noticeFiles/${DateTime.now().millisecondsSinceEpoch}.$ext",
      );

      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("File Upload Error: $e");
      return null;
    }
  }

  Future<void> uploadNotice() async {
    if (_titleCtrl.text.trim().isEmpty || _messageCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Title and Message cannot be empty")),
      );
      return;
    }

    setState(() => isUploading = true);

    String? fileUrl;
    if (selectedFile != null) {
      fileUrl = await uploadFile(selectedFile!);
    }

    await FirebaseFirestore.instance.collection("notices").add({
      "title": _titleCtrl.text.trim(),
      "message": _messageCtrl.text.trim(),
      "fileUrl": fileUrl ?? "",
      "createdAt": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Notice Uploaded Successfully")),
    );

    _titleCtrl.clear();
    _messageCtrl.clear();

    setState(() {
      selectedFile = null;
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAdmin) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Access Denied — Admin Only",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upload Notice",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Notice Title *",
              ),
            ),

            SizedBox(height: 20),

            TextField(
              controller: _messageCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Notice Message *",
              ),
            ),

            SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedFile == null
                        ? "No file selected"
                        : selectedFile!.path.split('/').last,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                ElevatedButton(
                  onPressed: pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Choose File"),
                ),
              ],
            ),

            SizedBox(height: 30),

            ElevatedButton(
              onPressed: isUploading ? null : uploadNotice,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, width * 0.13),
              ),
              child:
                  isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        "Upload Notice",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
