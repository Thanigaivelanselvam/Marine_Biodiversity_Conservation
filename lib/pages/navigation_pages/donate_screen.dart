// lib/screens/donate_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class DonatePage extends StatefulWidget {
  const DonatePage({super.key});

  @override
  State<DonatePage> createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  final TextEditingController _amountController = TextEditingController();

  final List<String> _currencies = [
    'USD',
    'INR',
    'EUR',
    'CNY',
    'RUB',
    'GBP',
    'AUD',
    'JPY',
  ];

  String _fromCurrency = 'USD';
  final String _toCurrency = 'INR';

  double _rateToINR = 83.0; // fallback
  bool _loadingRate = false;

  bool _isPaying = false;

  final NumberFormat _nf = NumberFormat("#,##0.00");

  Razorpay? _razorpay; // <-- make non-nullable

  @override
  void initState() {
    super.initState();
    _fetchRateFor(_fromCurrency);

    // Razorpay initialization
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _razorpay!.clear(); // Remove all listeners
    super.dispose();
  }

  Future<void> _fetchRateFor(String base) async {
    setState(() => _loadingRate = true);

    try {
      final url = Uri.parse('https://api.exchangerate-api.com/v4/latest/$base');
      final res = await http.get(url).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final rate = (data["rates"]?[_toCurrency]) ?? data["rates"]?["INR"];
        if (rate != null) {
          setState(() => _rateToINR = rate.toDouble());
        }
      }
    } catch (_) {} finally {
      setState(() => _loadingRate = false);
    }
  }

  double get _amountInINR {
    final v =
        double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;
    return v * _rateToINR;
  }

  // ---------------- RAZORPAY INTEGRATION ----------------

  Future<void> _onDonatePressed() async {
    final entered =
        double.tryParse(_amountController.text.replaceAll(',', '')) ?? 0.0;

    if (entered <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount.")),
      );
      return;
    }

    final int amountInPaise = (_amountInINR * 100).toInt();

    var options = {
      'key': 'rzp_test_1234567890', // <-- Replace with your Razorpay key
      'amount': amountInPaise,
      'name': 'Conserve Marine Biodiversity',
      'description': 'Donation',
      'prefill': {
        'contact': '+91 9994401291',
        'email': 'dr.s.davidraj@gmail.com',
      },
      'currency': 'INR',
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint("Razorpay Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e")),
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final verified = await _verifyPaymentWithBackend(
      response.paymentId ?? "",
      response.orderId ?? "",
      response.signature ?? "",
    );

    verified ? _showVerifiedThankYou() : _showUnverifiedWarning();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  // Backend verification
  Future<bool> _verifyPaymentWithBackend(
      String paymentId,
      String orderId,
      String signature,
      ) async {
    try {
      final uri = Uri.parse('https://your-backend.example.com/verify-payment');

      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'razorpay_payment_id': paymentId,
          'razorpay_order_id': orderId,
          'razorpay_signature': signature,
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data['success'] == true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  void _showVerifiedThankYou() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Thank you! 🌊"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Your payment is verified and will support marine conservation.",
            ),
            const SizedBox(height: 12),
            Text(
              "Amount paid: ${_nf.format(_amountInINR)} INR",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showUnverifiedWarning() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Payment verification failed"),
        content: const Text(
          "We could not verify the payment. If the amount was deducted, contact support.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ------------------ UI CODE REMAINS UNCHANGED ------------------
  @override
  Widget build(BuildContext context) {
    // Screen width-based responsive scaling
    final width = MediaQuery.of(context).size.width;

    final bool isMobile = width < 600;
    final bool isTablet = width >= 600 && width < 1100;

    final double bannerHeight = isMobile ? 180 : isTablet ? 240 : 300;
    final double cardPadding = isMobile ? 16 : 24;

    final double titleFont = isMobile ? 20 : isTablet ? 24 : 28;
    final double subtitleFont = isMobile ? 13 : isTablet ? 15 : 16;

    return Scaffold(
      backgroundColor: const Color(0xFF022C43),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Donate',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff04364f),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 14 : isTablet ? 60 : 180,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ------------------ TOP BANNER ------------------
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1500&q=80',
                    height: bannerHeight,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: bannerHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.12),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    left: isMobile ? 16 : 32,
                    bottom: isMobile ? 16 : 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Support Marine Biodiversity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleFont,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isMobile ? 6 : 10),
                        Text(
                          'Protect coral reefs, sea turtles & ecosystems.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: subtitleFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ------------------ CARD ------------------
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 800),
              padding: EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.07),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Make a Donation',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 18 : 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Enter amount in your currency. We will convert & process in INR.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isMobile ? 13 : 15,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // AMOUNT + DROPDOWN
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _amountController,
                          onChanged: (_) => setState(() {}),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Amount',
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.white12,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _fromCurrency,
                              dropdownColor: const Color(0xff04364f),
                              style: const TextStyle(color: Colors.white),
                              items: _currencies
                                  .map(
                                    (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c),
                                ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _fromCurrency = value);
                                  _fetchRateFor(value);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  _loadingRate
                      ? const LinearProgressIndicator()
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1 $_fromCurrency = ${_rateToINR.toStringAsFixed(4)} INR",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isMobile ? 12 : 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Payable in INR: ₹ ${_nf.format(_amountInINR)}",
                        style: TextStyle(
                          color: Colors.cyanAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 16 : 20,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // DONATE BUTTON
                  SizedBox(
                    height: isMobile ? 50 : 58,
                    child: ElevatedButton(
                      onPressed: _onDonatePressed,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isPaying
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Ink(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff09b1ec),
                              Color(0xff007ea7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            "Donate Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "We process payments securely. Receipt will be given after verification.",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: isMobile ? 11 : 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _presetButton(String label) {
    return GestureDetector(
      onTap: () {
        _amountController.text = label;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
