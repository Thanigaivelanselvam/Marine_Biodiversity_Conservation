// volunteer_page.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_functions/cloud_functions.dart';

class VolunteerPage extends StatefulWidget {
  const VolunteerPage({super.key});

  @override
  State<VolunteerPage> createState() => _VolunteerPageState();
}

class _VolunteerPageState extends State<VolunteerPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final mobileCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final messageCtrl = TextEditingController();

  String? selectedGender;
  String? selectedOccupation;

  // Interests
  Map<String, bool> interests = {
    "Awareness": false,
    "Beach Cleanups": false,
    "Digital Media": false,
    "Education": false,
    "Research": false,
    "Fundraising": false,
  };

  // Image picker & upload state
  final ImagePicker _picker = ImagePicker();
  File? pickedImage;
  String? uploadedImageUrl;
  double uploadProgress = 0.0;
  bool isUploading = false;

  // Animation controller
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    nameCtrl.dispose();
    ageCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    addressCtrl.dispose();
    messageCtrl.dispose();
    super.dispose();
  }

  // -------------------- Image pick --------------------
  Future<void> _showPickOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: 180,
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Text(
                  "Select Photo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take Photo"),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? file =
                    await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                    if (file != null) {
                      setState(() => pickedImage = File(file.path));
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Choose from Gallery"),
                  onTap: () async {
                    Navigator.pop(context);
                    final XFile? file =
                    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                    if (file != null) {
                      setState(() => pickedImage = File(file.path));
                    }
                  },
                ),
                if (pickedImage != null)
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text("Remove Photo"),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        pickedImage = null;
                        uploadedImageUrl = null;
                        uploadProgress = 0.0;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // -------------------- Upload to Firebase --------------------
  Future<void> _uploadImageToFirebase() async {
    if (pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick a photo first.")),
      );
      return;
    }

    try {
      setState(() {
        isUploading = true;
        uploadProgress = 0.0;
      });

      final fileName =
          "Volunteer_profile_images/${DateTime.now().microsecondsSinceEpoch}.jpg";
      final ref = FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = ref.putFile(pickedImage!);

      uploadTask.snapshotEvents.listen((event) {
        final prog = event.bytesTransferred / event.totalBytes;
        setState(() => uploadProgress = prog);
      });

      final snapshot = await uploadTask.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();

      setState(() {
        uploadedImageUrl = url;
        isUploading = false;
        uploadProgress = 1.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully.")),
      );
    } catch (e) {
      setState(() => isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload error: $e")),
      );
    }
  }

  // -------------------- Generate Volunteer ID --------------------
  Future<String> _generateVolunteerId() async {
    final countersRef =
    FirebaseFirestore.instance.collection('counters').doc('volunteers');

    return FirebaseFirestore.instance.runTransaction((tx) async {
      final snapshot = await tx.get(countersRef);
      int next = 1;

      if (!snapshot.exists) {
        tx.set(countersRef, {'count': next});
      } else {
        next = (snapshot.data()?['count'] ?? 0) + 1;
        tx.update(countersRef, {'count': next});
      }

      final padded = next.toString().padLeft(4, '0');
      return "MBCT-$padded";
    });
  }

  // ----------------------------------------------------------------
  // -------------------- Submit Form (UPDATED) ---------------------
  // ----------------------------------------------------------------
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete required fields.")),
      );
      return;
    }

    if (uploadedImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please upload your photo before submitting."),
        ),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // ⭐⭐⭐ NEW: CHECK IF USER ALREADY REGISTERED ⭐⭐⭐
      final existingEmail = await FirebaseFirestore.instance
          .collection('volunteers')
          .where('email', isEqualTo: emailCtrl.text.trim())
          .get();

      final existingPhone = await FirebaseFirestore.instance
          .collection('volunteers')
          .where('mobile', isEqualTo: mobileCtrl.text.trim())
          .get();

      if (existingEmail.docs.isNotEmpty || existingPhone.docs.isNotEmpty) {
        Navigator.of(context).pop(); // close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You have already registered as a volunteer."),
          ),
        );
        return;
      }

      // Now safe to proceed
      final volId = await _generateVolunteerId();

      final selectedInterests =
      interests.entries.where((e) => e.value).map((e) => e.key).toList();

      await FirebaseFirestore.instance.collection('volunteers').doc().set({
        'volunteerId': volId,
        'name': nameCtrl.text.trim(),
        'age': ageCtrl.text.trim(),
        'gender': selectedGender,
        'email': emailCtrl.text.trim(),
        'mobile': mobileCtrl.text.trim(),
        'address': addressCtrl.text.trim(),
        'occupation': selectedOccupation,
        'message': messageCtrl.text.trim(),
        'interests': selectedInterests,
        'imageUrl': uploadedImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await sendWelcomeEmail(
          volId, nameCtrl.text.trim(), emailCtrl.text.trim());

      Navigator.of(context).pop(); // close dialog
      await _showSuccessDialog(volId);

      setState(() {
        nameCtrl.clear();
        ageCtrl.clear();
        emailCtrl.clear();
        mobileCtrl.clear();
        addressCtrl.clear();
        messageCtrl.clear();
        selectedGender = null;
        selectedOccupation = null;
        interests.updateAll((key, value) => false);
        pickedImage = null;
        uploadedImageUrl = null;
        uploadProgress = 0.0;
      });
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Submit error: $e")),
      );
    }
  }

  // -------------------- Send Email --------------------
  Future<void> sendWelcomeEmail(String volId, String name, String email) async {
    try {
      final callable = FirebaseFunctions.instance
          .httpsCallable('sendVolunteerWelcomeEmail');

      await callable.call({
        'volunteerId': volId,
        'name': name,
        'email': email,
      });

      print("Email sent successfully!");
    } catch (e) {
      print("Email send error: $e");
    }
  }

  // -------------------- Success Dialog --------------------
  Future<void> _showSuccessDialog(String volunteerId) async {
    await _animController.forward();
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, __, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: _animController,
            curve: Curves.elasticOut,
          ),
          child: Center(
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_outline,
                        size: 72, color: Colors.blue),
                    const SizedBox(height: 12),
                    const Text("Thank you for joining!",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text("Your Volunteer ID"),
                    const SizedBox(height: 6),
                    Text(
                      volunteerId,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    await _animController.reverse();
  }

  // -------------------- UI BUILD --------------------
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isWide = w >= 800;
    final horizontalPadding = isWide ? w * 0.12 : 18.0;
    final avatarRadius = isWide ? w * 0.08 : 55.0;
    final titleSize = isWide ? 32.0 : 26.0;
    final subtitleSize = isWide ? 18.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white)),
        title: const Text(
          "Become a Marine Volunteer",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assests/images/pexels-ron-lach-9037205.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.65),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Join as a Volunteer",
                        style: TextStyle(
                            fontSize: titleSize,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Be a part of the movement to save our oceans!",
                        style: TextStyle(fontSize: subtitleSize),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: isWide
                      ? _buildTwoColumnLayout(avatarRadius)
                      : _buildSingleColumnLayout(avatarRadius),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------- Single Column Layout --------------------
  Widget _buildSingleColumnLayout(double avatarRadius) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: InkWell(
            onTap: _showPickOptions,
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: Colors.blue.shade100,
              backgroundImage:
              pickedImage != null ? FileImage(pickedImage!) : null,
              child: pickedImage == null
                  ? const Icon(Icons.camera_alt_outlined,
                  size: 48, color: Colors.white)
                  : null,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _showPickOptions,
              icon: const Icon(Icons.photo_camera),
              label: const Text("Pick Photo"),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: (pickedImage != null && !isUploading)
                  ? _uploadImageToFirebase
                  : null,
              icon: isUploading
                  ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
                  : const Icon(Icons.cloud_upload),
              label: Text(
                  isUploading ? "${(uploadProgress * 100).toStringAsFixed(0)}%" : "Upload"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (isUploading) LinearProgressIndicator(value: uploadProgress),
        const SizedBox(height: 12),
        _buildInput("Full Name", nameCtrl, required: true),
        _buildInput("Age", ageCtrl, keyboard: TextInputType.number),
        _buildDropdown("Gender", selectedGender,
            ["Male", "Female", "Other"], (v) => setState(() => selectedGender = v)),
        _buildInput("Email", emailCtrl,
            required: true, keyboard: TextInputType.emailAddress),
        _buildInput("Mobile Number", mobileCtrl,
            required: true, keyboard: TextInputType.phone),
        _buildTextArea("Address (City / District / State)", addressCtrl),
        _buildDropdown(
            "Occupation",
            selectedOccupation,
            ["Student", "Teacher", "NGO Member", "Public", "Other"],
                (v) => setState(() => selectedOccupation = v)),
        const SizedBox(height: 12),
        const Text("Area of Interest",
            style: TextStyle(fontWeight: FontWeight.w600)),
        Column(
          children: interests.keys.map((k) {
            return CheckboxListTile(
              title: Text(k),
              value: interests[k],
              onChanged: (val) => setState(() => interests[k] = val ?? false),
            );
          }).toList(),
        ),
        _buildTextArea("Message / Reason to Join", messageCtrl),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: isUploading ? null : _handleSubmit,
            style: ElevatedButton.styleFrom(
              padding:
              const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
            ),
            child: Text(isUploading ? "Uploading..." : "Join the Blue Mission"),
          ),
        ),
      ],
    );
  }

  // -------------------- Two Column Layout --------------------
  Widget _buildTwoColumnLayout(double avatarRadius) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar column
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Center(
                    child: InkWell(
                      onTap: _showPickOptions,
                      child: CircleAvatar(
                        radius: avatarRadius,
                        backgroundColor: Colors.blue.shade100,
                        backgroundImage: pickedImage != null
                            ? FileImage(pickedImage!)
                            : null,
                        child: pickedImage == null
                            ? const Icon(Icons.camera_alt_outlined,
                            size: 48, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _showPickOptions,
                        icon: const Icon(Icons.photo_camera),
                        label: const Text("Pick Photo"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed:
                        (pickedImage != null && !isUploading)
                            ? _uploadImageToFirebase
                            : null,
                        icon: isUploading
                            ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                            : const Icon(Icons.cloud_upload),
                        label: Text(
                          isUploading
                              ? "${(uploadProgress * 100).toStringAsFixed(0)}%"
                              : "Upload",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (isUploading)
                    LinearProgressIndicator(value: uploadProgress),
                ],
              ),
            ),

            const SizedBox(width: 24),

            // Right column fields
            Expanded(
              flex: 8,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: _buildInput("Full Name", nameCtrl,
                              required: true)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildInput("Age", ageCtrl,
                              keyboard: TextInputType.number)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildDropdown(
                              "Gender",
                              selectedGender,
                              ["Male", "Female", "Other"],
                                  (v) => setState(() => selectedGender = v))),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildDropdown(
                              "Occupation",
                              selectedOccupation,
                              ["Student", "Teacher", "NGO Member", "Public", "Other"],
                                  (v) => setState(() => selectedOccupation = v))),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: _buildInput("Email", emailCtrl,
                              required: true,
                              keyboard: TextInputType.emailAddress)),
                      const SizedBox(width: 12),
                      Expanded(
                          child: _buildInput("Mobile Number", mobileCtrl,
                              required: true,
                              keyboard: TextInputType.phone)),
                    ],
                  ),
                  _buildTextArea(
                      "Address (City / District / State)", addressCtrl),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Area of Interest",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  Column(
                    children: interests.keys.map((k) {
                      return CheckboxListTile(
                        title: Text(k),
                        value: interests[k],
                        onChanged: (val) =>
                            setState(() => interests[k] = val ?? false),
                      );
                    }).toList(),
                  ),
                  _buildTextArea(
                      "Message / Reason to Join", messageCtrl),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: isUploading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 14),
                        ),
                        child: Text(
                            isUploading ? "Uploading..." : "Join the Blue Mission"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // -------------------- Reusable Widgets --------------------
  Widget _buildInput(String label, TextEditingController ctrl,
      {bool required = false, TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
        validator: required
            ? (v) =>
        v == null || v.trim().isEmpty ? "$label is required" : null
            : null,
      ),
    );
  }

  Widget _buildTextArea(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        controller: ctrl,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items,
      void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
