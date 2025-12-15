import 'package:flutter/material.dart';
import 'package:marine_trust/pages/general_page/marine_quiz.dart';
import 'package:marine_trust/pages/navigation_pages/about_screen.dart';
import 'package:marine_trust/pages/navigation_pages/contact_page.dart';
import 'package:marine_trust/pages/navigation_pages/home_screen.dart';
import 'package:marine_trust/pages/navigation_pages/marine_species_page.dart';
import 'package:marine_trust/pages/navigation_pages/navitems_page.dart';
import 'package:marine_trust/pages/navigation_pages/notifier_page.dart';
import 'package:marine_trust/pages/navigation_pages/projects_page.dart';
import 'package:unicons/unicons.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List pages = [
    HomeScreen(),
    AboutScreen(),
    MarineSpeciesPage(),
    ProjectsPage(),
    ContactPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navitems(),
      body: ValueListenableBuilder(
        valueListenable: selectPageNotifier,
        builder: (context, selectPage, child) {
          return pages.elementAt(selectPage);
        },
      ),
    );
  }
}
