import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marine_trust/pages/authentication_page/register_page.dart';
import 'package:marine_trust/pages/navigation_pages/notice_page.dart';
import 'package:marine_trust/pages/navigation_pages/welcome_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isVisible = false;
  bool _isLoading = false;

  // ---------------------------------------------------------
  // 🔥 LOGIN (SAFE VERSION)
  // ---------------------------------------------------------
  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = emailController.text.trim().toLowerCase();
      final password = passwordController.text.trim();

      // 1️⃣ Firebase Auth login
      final userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      String role = "user"; // default (VERY IMPORTANT)

      // 2️⃣ Read role from Firestore (SAFE)
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        role = doc.data()!["role"] ?? "user";
      }

      if (!mounted) return;

      // 3️⃣ Success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login successful"),
          backgroundColor: Colors.green,
        ),
      );

      // 4️⃣ Role-based navigation
      if (role == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const NoticeUploadPage(isAdmin: true),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case "user-not-found":
          message = "No account found with this email";
          break;
        case "wrong-password":
          message = "Incorrect password";
          break;
        case "invalid-email":
          message = "Invalid email address";
          break;
        case "too-many-requests":
          message =
          "Too many attempts. Please try again later or reset password.";
          break;
        default:
          message = "Login failed. Please try again";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------
  // UI
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset(
                    "assests/images/logo-removebg-preview (1).png",
                    height: 220,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Login to Marine\nBiodiversity Conservation",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0077B6),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // EMAIL
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty
                        ? "Enter your email"
                        : null,
                  ),

                  const SizedBox(height: 15),

                  // PASSWORD
                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isVisible,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setState(() => _isVisible = !_isVisible),
                      ),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty
                        ? "Enter your password"
                        : null,
                  ),

                  const SizedBox(height: 10),

                  // FORGOT PASSWORD
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        final email = emailController.text.trim();
                        if (email.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Enter your email first"),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email);

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password reset email sent"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text("Forgot Password?",style: TextStyle(color: Colors.black),),
                    ),
                  ),

                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: _isLoading ? null : loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0077B6),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login"),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text("Don’t have an account? Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}