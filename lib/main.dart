import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:marine_trust/pages/navigation_pages/welcome_page.dart';
import 'package:marine_trust/pages/starting_page.dart';
import 'firebase_options.dart';

/// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Background message received: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Request notification permission (iOS)
    FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);

    // Subscribe to topic "allUsers"
    FirebaseMessaging.instance.subscribeToTopic("allUsers");


    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${message.notification!.title ?? ""}: ${message.notification!.body ?? ""}"),
          ),
        );
      }
    });

    // App opened from background/terminated via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification opened: ${message.notification?.title}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Marine Biodiversity Conservation",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0077B6),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: StartingPage(),
    );
  }
}
