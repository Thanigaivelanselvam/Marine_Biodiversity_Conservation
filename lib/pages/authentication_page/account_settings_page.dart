import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_page.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  // 🔐 LOGOUT
  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
      );
    }
  }

  // 🗑️ REQUEST ACCOUNT DELETION (Google Play compliant)
  Future<void> _requestAccountDeletion(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      // Store deletion request
      await FirebaseFirestore.instance
          .collection('deletion_requests')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'email': user.email,
        'requestedAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      // Sign out user after request (recommended)
      await FirebaseAuth.instance.signOut();

      if (context.mounted) {
        _showSuccessDialog(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: $e')),
        );
      }
    }
  }

  // ✅ SUCCESS DIALOG
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Deletion Request Submitted"),
        content: const Text(
          "A confirmation email will be sent to your registered email address.\n\n"
              "Your account and all associated data will be permanently deleted after confirmation.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
              );
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // 🔔 LOGOUT CONFIRMATION
  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _logout(context);
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  // 🔔 DELETE CONFIRMATION
  void _showDeleteConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "You will receive a confirmation email.\n\n"
              "Your account will only be deleted after you confirm the request.\n\n"
              "This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _requestAccountDeletion(context);
            },
            child: const Text("Request Deletion"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => _showLogoutConfirmDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text(
              "Delete Account",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text("Request account deletion via email"),
            onTap: () => _showDeleteConfirmDialog(context),
          ),
        ],
      ),
    );
  }
}
