import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marine_trust/pages/authentication_page/register_page.dart';
import 'package:marine_trust/pages/navigation_pages/home_screen.dart';
import 'package:marine_trust/pages/navigation_pages/notice_page.dart';

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
  // 🔥 LOGIN FUNCTION WITH ROLE CHECK
  // ---------------------------------------------------------
  Future<void> loginUser() async {
    try {
      setState(() => _isLoading = true);

      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      // Login via Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User user = userCredential.user!;

      // Read user role from Firestore
      final roleDoc =
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      if (!roleDoc.exists) {
        throw Exception("User role not found");
      }

      String role = roleDoc["role"];

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login Successful!"),
          backgroundColor: Colors.green,
        ),
      );

      // ---------------------------------------------------------
      // 🔥 ROLE BASED REDIRECTION
      // ---------------------------------------------------------
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
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login failed";

      switch (e.code) {
        case "user-not-found":
          message = "No user found with this email";
          break;
        case "wrong-password":
          message = "Incorrect password";
          break;
        case "invalid-email":
          message = "Invalid email format";
          break;
        case "too-many-requests":
          message =
          "Too many failed attempts. Try again later or reset your password.";
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unexpected Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
                  // ---------------------------------------------------------
                  // ✔ FIXED: Correct asset folder name
                  // ---------------------------------------------------------
                  Image.asset(
                    "assests/images/logo-removebg-preview (1).png",
                    fit: BoxFit.cover,
                    height: 250,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Login to Marine Trust",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0077B6),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ---------------------------------------------------------
                  // EMAIL
                  // ---------------------------------------------------------
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) => value!.isEmpty ? "Enter your email" : null,
                  ),

                  const SizedBox(height: 15),

                  // ---------------------------------------------------------
                  // PASSWORD
                  // ---------------------------------------------------------
                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isVisible,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed:
                            () => setState(() => _isVisible = !_isVisible),
                      ),
                    ),
                    validator:
                        (value) =>
                    value!.isEmpty ? "Enter your password" : null,
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () async {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: emailController.text.trim());
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Mail send Successfully"),
                                backgroundColor: Colors.green,
                              ),
                            );
                        },
                        child: Text(
                          "Forgot Password",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                  // ---------------------------------------------------------
                  // LOGIN BUTTON
                  // ---------------------------------------------------------
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0077B6),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed:
                    _isLoading
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        loginUser();
                      }
                    },
                    child:
                    _isLoading
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text("Login"),
                  ),

                  const SizedBox(height: 10),

                  // ---------------------------------------------------------
                  // GO TO REGISTER PAGE
                  // ---------------------------------------------------------
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
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
