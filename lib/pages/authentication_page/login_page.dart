import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marine_trust/pages/admin_page/manager_desk_page.dart';

final List<String> adminEmails =
const [
  "thanigaivelanselvam@gmail.com",
  "playreviewers@test.com",
].map((e) => e.toLowerCase().trim()).toList();


class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isVisible = false;
  bool _isLoading = false;

  // 🔐 ADMIN LOGIN
  Future<void> _loginAdmin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = emailController.text.trim().toLowerCase();
      final password = passwordController.text.trim();

      final userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      final loggedInEmail = user?.email?.toLowerCase().trim();

      if (loggedInEmail == null || !adminEmails.contains(loggedInEmail)) {
        await FirebaseAuth.instance.signOut();
        throw FirebaseAuthException(
          code: "unauthorized",
          message: "You are not authorized",
        );
      }


      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ManagerDeskPage()),
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case "user-not-found":
          message = "Admin account not found";
          break;
        case "wrong-password":
          message = "Incorrect password";
          break;
        case "invalid-email":
          message = "Invalid email";
          break;
        case "unauthorized":
          message = "Access denied";
          break;
        default:
          message = "Login failed";
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                  Image.asset(
                    "assests/images/logo-removebg-preview (1).png",
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Admin Login\nMarine Biodiversity Conservation",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
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
                      labelText: "Admin Email",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty
                        ? "Enter admin email"
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
                        ? "Enter password"
                        : null,
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _loginAdmin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0077B6),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login"),
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
