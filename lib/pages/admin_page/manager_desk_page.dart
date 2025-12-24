import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marine_trust/pages/authentication_page/login_page.dart';

import 'package:marine_trust/pages/navigation_pages/notice_page.dart';
import 'package:marine_trust/pages/navigation_pages/events_page.dart';
import 'package:marine_trust/pages/navigation_pages/welcome_page.dart';

const String adminEmail = "thanigaivelanselvam@gmail.com";

class ManagerDeskPage extends StatefulWidget {
  const ManagerDeskPage({super.key});

  @override
  State<ManagerDeskPage> createState() => _ManagerDeskPageState();
}

class _ManagerDeskPageState extends State<ManagerDeskPage> {
  bool isAuthorized = false;

  @override
  void initState() {
    super.initState();
    _verifyAdmin();
  }

  void _verifyAdmin() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email == adminEmail) {
      setState(() => isAuthorized = true);
    } else {
      // 🚫 Show warning then redirect
      Future.microtask(() async {
        await showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Access Restricted"),
                content: const Text(
                  "Manager Desk is accessible only to the administrator.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],
              ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const WelcomePage()),
          (route) => false,
        );
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => AdminLoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isAuthorized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Manager Desk",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF09B1EC),
        actions: [
          IconButton(
            tooltip: "Logout",
            icon: const Icon(Icons.logout,color: Colors.white,),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _adminCard(
            icon: Icons.announcement_outlined,
            title: "Upload Notice",
            subtitle: "Post official announcements & notices",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NoticeUploadPage()),
              );
            },
          ),
          const SizedBox(height: 16),
          _adminCard(
            icon: Icons.event,
            title: "Upload Event",
            subtitle: "Create and manage marine events",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EventUploadPage()),
              );
            },
          ),
          const SizedBox(height: 16),
          _adminCard(
            icon: Icons.analytics_outlined,
            title: "Admin Tips",
            subtitle: "Analytics & reports can be added later",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Analytics module can be added later"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _adminCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 32, color: const Color(0xFF09B1EC)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
