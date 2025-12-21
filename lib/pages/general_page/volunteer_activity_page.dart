import 'dart:io';
import 'package:exif/exif.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marine_trust/pages/general_page/certificate_generator.dart';

class OceanHeroesUploadPage extends StatefulWidget {
  const OceanHeroesUploadPage({super.key});

  @override
  State<OceanHeroesUploadPage> createState() => _OceanHeroesUploadPageState();
}

class _OceanHeroesUploadPageState extends State<OceanHeroesUploadPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final countryCtrl = TextEditingController();

  String? selectedActivity;
  File? activityImage;

  double? latitude;
  double? longitude;

  final ImagePicker _picker = ImagePicker();

  final List<String> activities = [
    "Beach Cleaning",
    "Marine Animal Rescue",
    "Coral Protection",
    "Awareness Program",
    "Other Marine Activity",
  ];

  // --------------------------------------------------
  // 🔹 GPS HELPERS
  // --------------------------------------------------

  double _convertToDecimal(List values) {
    final d = values[0].numerator / values[0].denominator;
    final m = values[1].numerator / values[1].denominator;
    final s = values[2].numerator / values[2].denominator;
    return d + (m / 60) + (s / 3600);
  }

  Future<bool> extractGps(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final data = await readExifFromBytes(bytes);

    final latIfd = data['GPS GPSLatitude'];
    final lonIfd = data['GPS GPSLongitude'];
    final latRef = data['GPS GPSLatitudeRef']?.printable;
    final lonRef = data['GPS GPSLongitudeRef']?.printable;

    if (latIfd == null || lonIfd == null) return false;

    final latValues = latIfd.values.toList();
    final lonValues = lonIfd.values.toList();

    double lat = _convertToDecimal(latValues);
    double lon = _convertToDecimal(lonValues);

    if (latRef == 'S') lat = -lat;
    if (lonRef == 'W') lon = -lon;

    latitude = lat;
    longitude = lon;

    return true;
  }

  // --------------------------------------------------
  // 📸 PICK IMAGE (CAMERA / GALLERY)
  // --------------------------------------------------

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (image == null) return;

    final file = File(image.path);
    final hasGps = await extractGps(file);

    if (!hasGps) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "GPS data not found.\nPlease select a GPS-enabled photo.",
          ),
        ),
      );
      return;
    }

    setState(() => activityImage = file);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("GPS photo verified ✅")),
    );
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Capture with Camera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 🏆 SUBMIT
  // --------------------------------------------------

  void submitActivity() {
    if (!_formKey.currentState!.validate()) return;

    if (activityImage == null || latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload a valid GPS photo")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CertificateGeneratorPage(
          name: nameCtrl.text.trim(),
          country: countryCtrl.text.trim(),
          activity: selectedActivity!,
          latitude: latitude!,
          longitude: longitude!,
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 🧱 UI
  // --------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077B6),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Ocean Heroes Program",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🌍 PAGE INFO
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Text(
                  "If you have participated in marine conservation activities "
                      "with family or friends (beach cleaning, animal rescue, awareness, etc.), "
                      "upload a GPS-enabled photo to receive a Certificate of Appreciation.",
                  style: TextStyle(color: Colors.white70, height: 1.5),
                ),
              ),

              const SizedBox(height: 24),

              _inputField(
                controller: nameCtrl,
                label: "Volunteer / Group Name",
                icon: Icons.group,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              _inputField(
                controller: countryCtrl,
                label: "Country",
                icon: Icons.public,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: _inputDecoration("Marine Activity Type", Icons.eco),
                dropdownColor: const Color(0xFF001F3F),
                items: activities
                    .map(
                      (e) => DropdownMenuItem(
                    value: e,
                    child:
                    Text(e, style: const TextStyle(color: Colors.white)),
                  ),
                )
                    .toList(),
                onChanged: (v) => selectedActivity = v,
                validator: (v) => v == null ? "Select activity" : null,
              ),

              const SizedBox(height: 24),

              GestureDetector(
                onTap: _showImagePickerOptions,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: activityImage == null
                      ? const Center(
                    child: Text(
                      "Tap to upload GPS photo\n(Camera / Gallery)",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      activityImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.workspace_premium,color: Colors.white,),
                  label: const Text("Generate Certificate"),
                  onPressed: submitActivity,
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.white,backgroundColor: Colors.green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------
  // 🔹 REUSABLE INPUTS
  // --------------------------------------------------

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label, icon),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.cyanAccent),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.cyanAccent),
      ),
    );
  }
}
