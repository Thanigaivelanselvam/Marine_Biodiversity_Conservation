import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marine_trust/pages/authentication_page/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------
  // 🔥 REGISTER USER (GOOGLE PLAY SAFE VERSION)
  // -------------------------------------------------------------
  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final name = nameController.text.trim();
      final email = emailController.text.trim().toLowerCase();
      final password = passwordController.text.trim();

      // 1️⃣ Create Firebase Auth user
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      await user.updateDisplayName(name);

      // 2️⃣ ALWAYS assign "user" role (admin via Firebase console only)
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set({
        "uid": user.uid,
        "name": name,
        "email": email,
        "role": "user",
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      // 3️⃣ Success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account created successfully"),
          backgroundColor: Colors.green,
        ),
      );

      // 4️⃣ Navigate to Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case "email-already-in-use":
          message = "This email is already registered";
          break;
        case "invalid-email":
          message = "Invalid email address";
          break;
        case "weak-password":
          message = "Password must be at least 6 characters";
          break;
        case "network-request-failed":
          message = "Check your internet connection";
          break;
        default:
          message = "Registration failed. Try again";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unexpected error occurred"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // -------------------------------------------------------------
  // UI
  // -------------------------------------------------------------
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
                    height: 180,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Create an Account",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0077B6),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // NAME
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Enter your name" : null,
                  ),

                  const SizedBox(height: 15),

                  // EMAIL
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your email";
                      }
                      if (!value.contains("@")) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a password";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton(
                    onPressed: _isLoading ? null : registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0077B6),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Sign Up"),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text("Already have an account? Login"),
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