import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // 👈 Add this package

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // 👇 WhatsApp number (with country code, no + symbol)
  final String whatsappNumber = "+91 99944 01291"; // Example: +91 98765 43210

  // ✅ Function to open WhatsApp chat
  Future<void> openWhatsApp() async {
    final String message = Uri.encodeComponent(
      "Hello Marine biodiversity 👋\nI’d like to know more!",
    );
    final Uri whatsappUrl = Uri.parse(
      "https://wa.me/$whatsappNumber?text=$message",
    );

    if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not open WhatsApp")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Contact Us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0077B6),
        centerTitle: true,
      ),

      // ✅ Floating WhatsApp Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: openWhatsApp,
        child: const Icon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
          size: 30,
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF003049), Color(0xFF0077B6), Color(0xFF00B4D8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Get in Touch",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // Contact Info
              _contactCard(
                icon: FontAwesomeIcons.envelope,
                title: "Email",
                detail: "worldmarinebiodiversity@gmail.com",
              ),
              _contactCard(
                icon: FontAwesomeIcons.phone,
                title: "Phone",
                detail: "+919994401291",
              ),
              _contactCard(
                icon: FontAwesomeIcons.mapMarkerAlt,
                title: "Address",
                detail: "81/5, 6th street,Shanthi Nagar,Chengalpattu District,Tamilnadu 603 003, India"
              ),

              const SizedBox(height: 30),

              const Text(
                "Send us a message",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _inputField("Your Name", nameController),
                    const SizedBox(height: 15),
                    _inputField(
                      "Your Email",
                      emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    _inputField("Message", messageController, maxLines: 5),
                    const SizedBox(height: 20),

                    ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Message sent successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          nameController.clear();
                          emailController.clear();
                          messageController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: const Text(
                        "Send Message",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String detail,
  }) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 28),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          detail,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }

  Widget _inputField(
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Please enter $hint' : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
