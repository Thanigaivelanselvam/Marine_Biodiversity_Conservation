import 'package:flutter/material.dart';
import 'package:marine_trust/pages/navigation_pages/donate_screen.dart';

class CtaSection extends StatefulWidget {
  const CtaSection({super.key});

  @override
  State<CtaSection> createState() => _CtaSectionState();
}

class _CtaSectionState extends State<CtaSection> {
  // Equivalent of React's useState(false)
  bool _isOpen = false;

  void _openVolunteerList() {
    setState(() {
      _isOpen = true;
    });

    // In a real Flutter app, we typically use showDialog for modals:
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Pass the state control to the modal
        return VolunteerListModal(
          onClose: () {
            Navigator.of(context).pop(); // Close the dialog
            setState(() {
              _isOpen = false;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen width for responsive text sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800; // Define a desktop breakpoint

    return Center(
      // Centers the CTA section on the page
      child: Container(
        // Equivalent of: bg-gradient-to-r from-[#0077b6] to-[#00b4d8]
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0), // rounded-2xl
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0077b6), // from-[#0077b6]
              Color(0xFF00b4d8), // to-[#00b4d8]
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: const EdgeInsets.all(32.0),
        // p-8
        margin: EdgeInsets.symmetric(
          horizontal: isDesktop ? screenWidth * 0.1 : 16.0,
        ),

        // Responsive margin
        child: Column(
          mainAxisSize: MainAxisSize.min, // Wrap content height
          children: <Widget>[
            // Heading: Join our effort
            Text(
              "Join our effort",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize:
                    isDesktop ? 30 : 24, // Responsive text-2xl md:text-3xl
              ),
            ),

            const SizedBox(height: 12),
            // Equivalent of mt-3

            // Subtitle: Volunteer, donate or partner...
            Container(
              constraints: const BoxConstraints(maxWidth: 512), // max-w-2xl
              child: Text(
                "Volunteer, donate or partner with us. Small contributions add up to real change for our oceans.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFb3e5fc).withOpacity(0.9),
                  // text-sky-100/90
                  fontSize: isDesktop ? 16 : 14,
                ),
              ),
            ),

            const SizedBox(height: 24),
            // Equivalent of mt-6

            // Buttons: Row for desktop, Column for narrow screens (optional, kept as Row for simplicity)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 1. See Volunteers Button (State-triggering button)
                _CtaButton(
                  text: "See Volunteers",
                  backgroundColor: Colors.white,
                  textColor: const Color(0xFF0077b6),
                  onPressed: _openVolunteerList,
                ),

                const SizedBox(width: 16), // gap-4
                // 2. Donate Button (Navigation button)
                _CtaButton(
                  text: "Donate",
                  backgroundColor: Colors.black.withOpacity(0.1),
                  // bg-black/10
                  textColor: Colors.white,
                  borderColor: Colors.white.withOpacity(0.2),
                  // border border-white/20
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DonatePage();
                        },
                      ),
                    );
                    // Flutter navigation equivalent to href="/donate"
                    // Example: Navigator.pushNamed(context, '/donate');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- Reusable Button Widget for Hover/Transition Effect ---

class _CtaButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  const _CtaButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Flutter's elevated button handles a clean tap and elevation effect
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        // Text color
        backgroundColor: backgroundColor,
        // Button color
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        // px-6 py-3
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // rounded-full
          side:
              borderColor != null
                  ? BorderSide(color: borderColor!, width: 1.0)
                  : BorderSide.none,
        ),
        // Hover/Scale-105 transition would require a custom button using a GestureDetector
        // and an AnimatedContainer, but ElevatedButton provides good default transitions.
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600, // font-semibold
          color: textColor,
        ),
      ),
    );
  }
}

// --- Dummy Modal Component (Equivalent of VolunteerList) ---
// This is placed in a separate file (e.g., volunteer_list_modal.dart)

class VolunteerListModal extends StatelessWidget {
  final VoidCallback onClose;

  const VolunteerListModal({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Current Volunteers"),
      content: const Text("No Active Volunteers"),
      actions: <Widget>[
        TextButton(
          onPressed: onClose, // Calls the function to close the dialog
          child: const Text("Close"),
        ),
      ],
    );
  }
}
