import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLarge = width > 600;

    final titleSize = isLarge ? 28.0 : 22.0;
    final sectionTitleSize = isLarge ? 22.0 : 18.0;
    final textSize = isLarge ? 18.0 : 16.0;
    final padding = isLarge ? 32.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Privacy Policy",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Privacy Policy",
              style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Text(
              "Marine Biodiversity Conservation (“we”, “our”, “us”) operates a mobile application "
                  "that enables users to volunteer, donate, and participate in marine conservation "
                  "activities such as beach cleanups, restoration programs, and awareness campaigns.\n\n"
                  "We are committed to protecting your personal information.",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),

            Text(
              "Information We Collect",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "• Name\n"
                  "• Email address\n"
                  "• Phone number\n"
                  "• Payment information (securely processed by Razorpay)\n"
                  "• Volunteer registration details\n"
                  "• Donation history",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),

            Text(
              "How We Use Your Information",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "We use your information to:\n"
                  "• Register volunteers for conservation events\n"
                  "• Collect donations\n"
                  "• Provide receipts and notifications\n"
                  "• Maintain donor/volunteer records\n"
                  "• Improve our conservation services",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),

            Text(
              "Sharing of Information",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "We DO NOT share your personal data with any third parties except:\n"
                  "• Razorpay for secure payment processing\n"
                  "• Government agencies only if legally required",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),

            Text(
              "Data Security",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "We use industry-standard measures to protect your data.\n"
                  "Payment information is NOT stored by us and is handled securely by Razorpay.",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),

            Text(
              "Your Rights",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "You have the right to:\n"
                  "• Request access to your data\n"
                  "• Request correction or deletion\n"
                  "• Opt-out of communication",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),

            Text(
              "Contact",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "For privacy-related concerns:\n"
                  "📧 Email: worldmarinebiodiversity@gmail.com\n"
                  "📞 Phone: +91 9994401291",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
