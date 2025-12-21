import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marine_trust/pages/authentication_page/login_page.dart';
import 'package:marine_trust/pages/authentication_page/register_page.dart';
import 'package:marine_trust/pages/navigation_pages/home_screen.dart';
import 'package:marine_trust/pages/navigation_pages/welcome_page.dart';

class StartingPage extends StatelessWidget {
  const StartingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF003049), Color(0xFF0077B6), Color(0xFF00B4D8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assests/images/logo-removebg-preview (1).png",
                  fit: BoxFit.cover,
                  height: 250,
                  width: 250,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Welcome to \n"
                      "Marine Biodiversity\n"
                      "Conservation",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Join our mission to protect marine life and explore the beauty of ocean biodiversity.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen();
                        },
                      ),
                    );
                     if (FirebaseAuth.instance.currentUser != null) {
                      Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => WelcomePage()),
                       );
                     } else {
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => LoginPage()),
                       );
                     }
                  },
                  child: const Text(
                    "Get Started →",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
