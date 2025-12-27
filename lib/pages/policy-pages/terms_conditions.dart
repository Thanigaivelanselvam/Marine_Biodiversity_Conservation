import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

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
          "Terms & Conditions",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Terms & Conditions",
              style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Text(
              "These Terms & Conditions govern the use of the Marine Biodiversity Conservation mobile application (\"App\", \"we\", \"our\", \"us\"). By using our app, you agree to the following terms.",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),
            Text(
              "1. Use of the App",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "• The app provides services related to marine conservation, volunteering, event participation, and donations.\n"
                  "• You agree to use the app only for lawful purposes and not to misuse any features.",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),
            Text(
              "2. Volunteer Participation",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "• Volunteers must provide accurate details.\n"
                  "• Participation in events such as beach cleanups or restoration activities is at your own risk.\n"
                  "• We are not responsible for injuries, losses, or damages during events.",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),
            Text(
              "3. Donations",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "• All donations are voluntary.\n"
                  "• Payments are processed securely through Razorpay.\n"
                  "• We do not store your card or bank information.\n"
                  "• Donation amounts are non-refundable except in rare valid cases.",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),
            Text(
              "4. User Responsibilities",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "You agree not to:\n"
                  "• Provide false information\n"
                  "• Misuse app features\n"
                  "• Attempt to damage, hack, or disrupt the app",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),
            Text(
              "5. Data Protection",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Your personal information is handled as per our Privacy Policy.\n"
                  "We take reasonable security measures to protect your data.",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),
            Text(
              "6. Limitation of Liability",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "We are not liable for:\n"
                  "• Any damages caused by misuse of the app\n"
                  "• Issues caused by third-party services like Razorpay\n"
                  "• Physical injuries during volunteer events",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),
            Text(
              "7. Updates to Terms",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "We may update these Terms & Conditions at any time. Continued use of the app means you accept the new terms.",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 20),
            Text(
              "8. Contact",
              style: TextStyle(fontSize: sectionTitleSize, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "For questions about these Terms:\n"
                  "📧 Email: worldmarinebiodiversity@gmail.com\n"
                  "📞 Phone:  +91 9994401291",
              style: TextStyle(fontSize: textSize, height: 1.5),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}