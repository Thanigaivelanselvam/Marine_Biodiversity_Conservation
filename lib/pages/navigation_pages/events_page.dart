import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String adminEmail = "thanigaivelanselvam@gmail.com";

class EventUploadPage extends StatefulWidget {
  const EventUploadPage({super.key});

  @override
  State<EventUploadPage> createState() => _EventUploadPageState();
}

class _EventUploadPageState extends State<EventUploadPage> {
  final _titleCtrl = TextEditingController();
  final _subtitleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  File? selectedFile;
  File? selectedImage;

  double uploadProgress = 0;
  bool isAuthorized = false;

  String? selectedCategory;
  List<String> categories = ["Awareness", "Restoration", "Research", "Cleanup"];

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  void _checkAdmin() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email == adminEmail) {
      setState(() => isAuthorized = true);
    } else {
      Future.microtask(() => Navigator.pop(context));
    }
  }

  // PICK IMAGE
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => selectedImage = File(picked.path));
  }

  // PICK FILE
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'doc', 'docx'],
      type: FileType.custom,
    );
    if (result != null && result.files.single.path != null) {
      setState(() => selectedFile = File(result.files.single.path!));
    }
  }

  // UPLOAD WITH PROGRESS
  Future<String?> uploadFile(File file, String folder) async {
    try {
      final ext = file.path.split('.').last;
      final ref = FirebaseStorage.instance.ref().child(
        "$folder/${DateTime.now().millisecondsSinceEpoch}.$ext",
      );

      final uploadTask = ref.putFile(file);

      uploadTask.snapshotEvents.listen((event) {
        setState(() {
          uploadProgress = event.bytesTransferred / event.totalBytes;
        });
      });

      await uploadTask;
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("Upload error: $e");
      return null;
    }
  }

  // UPLOAD EVENT
  Future<void> uploadEvent() async {
    if (_titleCtrl.text.trim().isEmpty ||
        _messageCtrl.text.trim().isEmpty ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Title, Description & Category are required"),
        ),
      );
      return;
    }

    setState(() => uploadProgress = 0);

    String? imageUrl;
    String? fileUrl;

    if (selectedImage != null) {
      imageUrl = await uploadFile(selectedImage!, "eventImages");
    }

    if (selectedFile != null) {
      fileUrl = await uploadFile(selectedFile!, "eventFiles");
    }

    await FirebaseFirestore.instance.collection("notifications").add({
      "type": "event",
      "title": _titleCtrl.text.trim(),
      "subtitle":
          _subtitleCtrl.text.trim().isEmpty ? null : _subtitleCtrl.text.trim(),
      "message": _messageCtrl.text.trim(),
      "category": selectedCategory,
      "imageUrl": imageUrl ?? "",
      "fileUrl": fileUrl ?? "",
      "createdAt": FieldValue.serverTimestamp(),
      "uploadedBy": adminEmail,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Event Uploaded Successfully")),
    );

    _titleCtrl.clear();
    _subtitleCtrl.clear();
    _messageCtrl.clear();

    setState(() {
      selectedFile = null;
      selectedImage = null;
      selectedCategory = null;
      uploadProgress = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isAuthorized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF09B1EC),
        title: const Text(
          "Upload Event",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 32 : 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _imagePicker(isTablet),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleCtrl,
                  decoration: inputBox("Event Title *"),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _subtitleCtrl,
                  decoration: inputBox("Event Subtitle (optional)"),
                ),
                const SizedBox(height: 18),
                _categoryPicker(),
                const SizedBox(height: 20),
                TextField(
                  controller: _messageCtrl,
                  maxLines: 3,
                  decoration: inputBox("Event Description *"),
                ),
                const SizedBox(height: 20),
                _filePicker(),
                const SizedBox(height: 20),
                if (uploadProgress > 0) _progressBar(),
                const SizedBox(height: 30),
                _submitButton(isTablet),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePicker(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Event Image (optional)",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: pickImage,
          child: Container(
            height: isTablet ? 260 : 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child:
                selectedImage == null
                    ? const Center(child: Text("Tap to choose image"))
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(selectedImage!, fit: BoxFit.cover),
                    ),
          ),
        ),
      ],
    );
  }

  Widget _categoryPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Category *",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedCategory,
          decoration: inputBox("Select Category"),
          items:
              categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
          onChanged: (val) => setState(() => selectedCategory = val),
        ),
      ],
    );
  }

  Widget _filePicker() {
    return Row(
      children: [
        Expanded(
          child: Text(
            selectedFile == null
                ? "No document selected"
                : selectedFile!.path.split('/').last,
          ),
        ),
        ElevatedButton(
          onPressed: pickFile,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text("Select File"),
        ),
      ],
    );
  }

  Widget _progressBar() {
    return Column(
      children: [
        LinearProgressIndicator(value: uploadProgress),
        const SizedBox(height: 8),
        Text("${(uploadProgress * 100).toStringAsFixed(0)}%"),
      ],
    );
  }

  Widget _submitButton(bool isTablet) {
    return Center(
      child: SizedBox(
        width: isTablet ? 260 : 180,
        height: isTablet ? 55 : 48,
        child: ElevatedButton(
          onPressed: uploadEvent,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
          ),
          child: const Text(
            "Upload Event",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  InputDecoration inputBox(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
