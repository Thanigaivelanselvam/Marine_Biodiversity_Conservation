import 'package:flutter/material.dart';

class CancellationRefundPolicyPage extends StatelessWidget {
  const CancellationRefundPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Responsive padding
    double horizontalPadding = width < 600 ? 16 : 40;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0077B6),
        title: const Text(
          "Cancellation & Refund Policy",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 900), // Tablet/Web view
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
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
                      ResponsiveText(
                        "Cancellation & Refund Policy – Marine Biodiversity Conservation Trust (MBCT)",
                        fontSize: 18,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      ResponsiveText(
                        "Effective Date: 19 November 2025",
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                sectionTitle("1. Introduction"),
                sectionText(
                  "Marine Biodiversity Conservation Trust (MBCT) is a registered non-profit organization committed to marine and coastal ecosystem protection in India. This Cancellation & Refund Policy applies to all donations, membership fees, and contributions made through the app.",
                ),

                const SizedBox(height: 25),

                sectionTitle("2. Donation & Payment Policy"),
                sectionText(
                  "• All donations made to MBCT are voluntary and non-refundable.\n"
                      "• Payments are processed securely using Razorpay.\n"
                      "• MBCT does not store credit/debit card or banking details.\n"
                      "• Donations support ongoing and upcoming conservation programs.",
                ),

                const SizedBox(height: 25),

                sectionTitle("3. Membership Cancellation Policy"),
                sectionText(
                  "Membership or recurring contributions can be cancelled by emailing:\n"
                      "worldmarinebiodiversity@gmail.com\n\n"
                      "Cancellation must be requested within 7 days of joining or renewal. "
                      "After that period, fees are non-refundable.",
                ),

                const SizedBox(height: 25),

                sectionTitle("4. Refund Conditions"),
                sectionText(
                  "Refunds may be provided ONLY under these conditions:\n"
                      "• Duplicate payment\n"
                      "• Technical error during transaction\n"
                      "• Incorrect amount deducted\n"
                      "• Unauthorized transaction\n\n"
                      "Refund requests must be submitted within 7 working days.",
                ),

                const SizedBox(height: 25),

                sectionTitle("5. Duplicate or Error Transactions"),
                sectionText(
                  "In case of a duplicate or erroneous transaction, email MBCT immediately with:\n"
                      "• Transaction ID\n• Screenshot of payment\n• Payment method\n\n"
                      "Verified duplicate payments will be refunded.",
                ),

                const SizedBox(height: 25),

                sectionTitle("6. Refund Processing Time"),
                sectionText(
                  "Once approved, refunds are processed within 7–10 working days.\n"
                      "Refund amount will be credited back to the original mode of payment.",
                ),

                const SizedBox(height: 25),

                sectionTitle("7. Limitation of Liability"),
                sectionText(
                  "MBCT is not responsible for delays caused by banks, payment gateways, "
                      "or third-party systems.\nRefunds are subject to verification.",
                ),

                const SizedBox(height: 25),

                sectionTitle("8. Contact Information"),
                sectionText(
                  "For refund-related issues:\n"
                      "📧 Email: worldmarinebiodiversity@gmail.com\n"
                      "📞 Phone: +91 99944 01291\n"
                      "📍 Address: No 87/5, 5th Street, Sannithi Nagar, Chengalpattu District, Tamil Nadu – 603003.",
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // SIMPLE BUILDER FUNCTIONS

  Widget sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: ResponsiveText(
      text,
      fontSize: 20,
      weight: FontWeight.bold,
    ),
  );

  Widget sectionText(String text) => ResponsiveText(
    text,
    fontSize: 16,
    height: 1.5,
  );
}

// RESPONSIVE TEXT
class ResponsiveText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? weight;
  final Color? color;
  final double? height;

  const ResponsiveText(
      this.text, {
        super.key,
        required this.fontSize,
        this.weight,
        this.color,
        this.height,
      });

  @override
  Widget build(BuildContext context) {
    double scale = MediaQuery.of(context).size.width < 600 ? 1 : 1.2;

    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize * scale,
        fontWeight: weight,
        color: color,
        height: height,
      ),
    );
  }
}
