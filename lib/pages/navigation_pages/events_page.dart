// event_upload_page.dart
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventUploadPage extends StatefulWidget {
  final bool isAdmin;
  const EventUploadPage({super.key, required this.isAdmin});

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

  String? selectedCategory;
  List<String> categories = [
    "Awareness",
    "Restoration",
    "Research",
    "Cleanup",
  ];

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
      final ref = FirebaseStorage.instance
          .ref()
          .child("$folder/${DateTime.now().millisecondsSinceEpoch}.$ext");

      UploadTask uploadTask = ref.putFile(file);

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
            content: Text("Title, Description & Category are required")),
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

  // ADD CATEGORY
  void addNewCategory() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Category name",
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) return;

              setState(() {
                categories.add(text);
                selectedCategory = text;
              });
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAdmin) {
      return const Scaffold(
        body: Center(
            child: Text(
              "Access Denied – Admin Only",
              style: TextStyle(fontSize: 18),
            )),
      );
    }

    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF09B1EC),
        title: const Text("Upload Event",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                // IMAGE PICKER CARD
                Text("Event Image (optional)",
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: isTablet ? 260 : 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3))
                      ],
                    ),
                    child: selectedImage == null
                        ? Center(
                      child: Text(
                        "Tap to choose image",
                        style: TextStyle(
                            fontSize: isTablet ? 18 : 14,
                            color: Colors.grey),
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(selectedImage!,
                          fit: BoxFit.cover, width: double.infinity),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // TITLE FIELD
                TextField(
                  controller: _titleCtrl,
                  decoration: inputBox("Event Title *"),
                ),
                const SizedBox(height: 18),

                // SUBTITLE
                TextField(
                  controller: _subtitleCtrl,
                  decoration: inputBox("Event Subtitle (optional)"),
                ),
                const SizedBox(height: 18),

                // CATEGORY
                Text("Category *",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: inputBox("Select Category"),
                        items: categories
                            .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) => setState(() => selectedCategory = val),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: addNewCategory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF09B1EC),
                      ),
                      child: const Text("+",
                          style: TextStyle(color: Colors.white, fontSize: 22)),
                    )
                  ],
                ),

                const SizedBox(height: 20),

                // DESCRIPTION
                TextField(
                  controller: _messageCtrl,
                  maxLines: 3,
                  decoration: inputBox("Event Description *"),
                ),

                const SizedBox(height: 20),

                // FILE PICKER
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedFile == null
                            ? "No document selected"
                            : selectedFile!.path.split('/').last,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: pickFile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white
                      ),
                      child: const Text("Select File",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // PROGRESS BAR
                if (uploadProgress > 0)
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: uploadProgress,
                        color: const Color(0xFF09B1EC),
                        minHeight: 6,
                        backgroundColor: Colors.black12,
                      ),
                      const SizedBox(height: 8),
                      Text("${(uploadProgress * 100).toStringAsFixed(0)}%"),
                    ],
                  ),

                const SizedBox(height: 30),

                // SUBMIT BUTTON
                Center(
                  child: SizedBox(
                    width: isTablet ? 260 : 180,
                    height: isTablet ? 55 : 48,
                    child: ElevatedButton(
                      onPressed: uploadEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF09B1EC),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        "Upload Event",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
