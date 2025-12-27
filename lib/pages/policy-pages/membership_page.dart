import 'package:flutter/material.dart';

class MembershipAgreementPage extends StatelessWidget {
  const MembershipAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isLarge = width > 600;

    final titleSize = isLarge ? 22.0 : 18.0;
    final headerTitleSize = isLarge ? 26.0 : 20.0;
    final textSize = isLarge ? 17.0 : 15.0;
    final padding = isLarge ? 28.0 : 16.0;
    final sectionSpacing = isLarge ? 28.0 : 20.0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Membership Agreement",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0077B6),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isLarge ? 28 : 20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Membership Agreement – Marine Biodiversity Conservation Trust (MBCT)",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: headerTitleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Effective Date: 19 November 2025",
                    style: TextStyle(color: Colors.white70, fontSize: textSize),
                  ),
                ],
              ),
            ),

            SizedBox(height: sectionSpacing),

            Container(
              padding: EdgeInsets.all(isLarge ? 18 : 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "On this page",
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...[
                    "1. Introduction",
                    "2. Membership Overview",
                    "3. Eligibility & Registration",
                    "4. Membership Fees & Renewal",
                    "5. Member Rights & Benefits",
                    "6. Member Responsibilities",
                    "7. Cancellation & Termination",
                    "8. Data Privacy & Communication Consent",
                    "9. Limitation of Liability",
                    "10. Governing Law",
                    "11. Contact Information",
                  ].map((e) => Text(e, style: TextStyle(fontSize: textSize))),
                ],
              ),
            ),

            SizedBox(height: sectionSpacing),

            buildTitle("1. Introduction", titleSize),
            buildPara(
              "This Membership Agreement (“Agreement”) outlines the rights and responsibilities of members of Marine Biodiversity Conservation Trust (MBCT). Membership is voluntary and reflects our commitment to protect and conserve marine biodiversity.",
              textSize,
            ),

            buildTitle("2. Membership Overview", titleSize),
            buildBullet([
              "Membership with MBCT is open to individuals and organizations who share our mission.",
              "Membership is voluntary and non-transferable.",
            ], textSize),

            buildTitle("3. Eligibility & Registration", titleSize),
            buildBullet([
              "Applicant must be at least 18 years old.",
              "Membership is subject to approval by MBCT management.",
              "MBCT reserves the right to request verification documents.",
            ], textSize),

            buildTitle("4. Membership Fees & Renewal", titleSize),
            buildBullet([
              "Membership fees, if applicable, are collected via Razorpay or other approved payment gateways.",
              "Fees are non-refundable except in cases of duplicate payments or system errors.",
              "Renewal reminders will be sent via registered email.",
            ], textSize),

            buildTitle("5. Member Rights & Benefits", titleSize),
            buildBullet([
              "Participation in MBCT programs, events, and campaigns.",
              "Access to newsletters, project updates, and training sessions.",
              "Recognition as a supporting member on official platforms (if opted).",
            ], textSize),

            buildTitle("6. Member Responsibilities", titleSize),
            buildBullet([
              "Act in accordance with MBCT's values, ethics, and conservation goals.",
              "Provide accurate personal information.",
              "Avoid misuse of MBCT's name, logo, or materials without written permission.",
            ], textSize),

            buildTitle("7. Cancellation & Termination", titleSize),
            buildBullet([
              "Members may cancel by emailing: worldmarinebiodiversity@gmail.com",
              "MBCT reserves the right to terminate membership for violations or misconduct.",
            ], textSize),

            buildTitle("8. Data Privacy & Communication Consent", titleSize),
            buildPara(
              "By registering as a member, you consent to receive updates, newsletters, and communication from MBCT. Personal data is handled in compliance with our Privacy Policy.",
              textSize,
            ),

            buildTitle("9. Limitation of Liability", titleSize),
            buildPara(
              "MBCT is not responsible for personal, financial, or technical losses resulting from membership, website use, or project involvement.",
              textSize,
            ),

            buildTitle("10. Governing Law", titleSize),
            buildPara(
              "This Agreement is governed by the laws of India. Disputes fall under the jurisdiction of Tamil Nadu, India.",
              textSize,
            ),

            buildTitle("11. Contact Information", titleSize),
            buildPara(
              "For membership-related queries, contact:\nEmail: worldmarinebiodiversity@gmail.com\nPhone: +91 9994401291\nAddress: No.12 First Main Street, Sivaaji Nagar, Chengalpattu, Tamil Nadu - 603001",
              textSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(String text, double size) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
    ),
  );

  Widget buildPara(String text, double size) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(text, style: TextStyle(fontSize: size, height: 1.5)),
  );

  Widget buildBullet(List<String> items, double size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          items
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("• "),
                      Expanded(
                        child: Text(
                          e,
                          style: TextStyle(fontSize: size, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }
}
