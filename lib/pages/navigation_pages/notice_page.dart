import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

const String adminEmail = "thanigaivelanselvam@gmail.com";

class NoticeUploadPage extends StatefulWidget {
  const NoticeUploadPage({super.key});

  @override
  State<NoticeUploadPage> createState() => _NoticeUploadPageState();
}

class _NoticeUploadPageState extends State<NoticeUploadPage> {
  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  File? selectedFile;
  bool isUploading = false;
  bool isAuthorized = false;

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
  }

  void _checkAdminAccess() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email == adminEmail) {
      setState(() => isAuthorized = true);
    } else {
      Future.microtask(() {
        Navigator.pop(context);
      });
    }
  }

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
      "uploadedBy": adminEmail,
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
    if (!isAuthorized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
            const SizedBox(height: 20),
            TextField(
              controller: _messageCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Notice Message *",
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedFile == null
                        ? "No file selected"
                        : selectedFile!.path.split('/').last,
                  ),
                ),
                ElevatedButton(
                  onPressed: pickFile,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Choose File"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: isUploading ? null : uploadNotice,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, width * 0.13),
              ),
              child:
                  isUploading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Upload Notice"),
            ),
          ],
        ),
      ),
    );
  }
}
