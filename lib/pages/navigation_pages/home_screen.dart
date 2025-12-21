import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marine_trust/pages/general_page/marine_quiz.dart';
import 'package:marine_trust/pages/general_page/ocean_life_page.dart';
import 'package:marine_trust/pages/general_page/ocean_threats_page.dart';
import 'package:marine_trust/pages/general_page/volunteer_activity_page.dart';
import 'package:marine_trust/pages/navigation_pages/career_page.dart';
import 'package:marine_trust/pages/navigation_pages/donate_screen.dart';
import 'package:marine_trust/pages/navigation_pages/events_page.dart';
import 'package:marine_trust/pages/navigation_pages/notice_page.dart';
import 'package:marine_trust/pages/others_page/explore_more_page.dart';
import 'package:marine_trust/pages/others_page/notification_page.dart';
import 'package:marine_trust/pages/policy-pages/membership_page.dart';
import 'package:marine_trust/pages/policy-pages/privacy_policy.dart';
import 'package:marine_trust/pages/policy-pages/refund_page.dart';
import 'package:marine_trust/pages/policy-pages/terms_conditions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> marineTask = [
    {
      "image": "assests/images/ocean.png",
      "topic": "Conservation & Protection",
      "text":
          "Protecting marine biodiversity helps sustain life on Earth. Conservation efforts aim to restore ecosystems, enforce sustainable fishing and reduce pollution.",
    },
    {
      "image": "assests/images/sustainable.png",
      "topic": "Sustainable Use",
      "text":
          "Responsible resource use ensures the balance between human needs and environmental preservation, promoting renewable energy and eco-conscious living.",
    },
    {
      "image": "assests/images/research.png",
      "topic": "Research & Monitoring",
      "text":
          "Data-driven research enables better decisions. Monitoring marine health ensures timely action to combat climate change and protect aquatic life.",
    },
    {
      "image": "assests/images/education.png",
      "topic": "Awareness & Education",
      "text":
          "Educating communities about ocean importance fosters sustainable habits and inspires future generations to protect marine ecosystems.",
    },
    {
      "image": "assests/images/collabration.png",
      "topic": "Collaboration",
      "text":
          "Global teamwork across nations and communities ensures innovation, shared responsibility and successful ocean protection.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF09b1ec),
        centerTitle: true,
        title: const Text(
          "Marine Biodiversity",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NotificationPage()),
              );
            },
            icon: Icon(Icons.notifications),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DonatePage()),
              );
            },
            icon: const FaIcon(FontAwesomeIcons.donate, color: Colors.white),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF003049), Color(0xFF0077B6), Color(0xFF00B4D8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeroSection(context),
              const SizedBox(height: 50),
              const Text(
                "Our Objectives",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildObjectivesSection(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      width: 250,
      child: ListView(
        children: [
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF09b1ec),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(70),
                  topLeft: Radius.circular(70),
                ),
                image: DecorationImage(
                  image: AssetImage("assests/images/logo1.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Text(""),
            ),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Ocean & Our Life "),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return OceanLifePage();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.report_problem_outlined),
            title: Text("Ocean Threats & Challenges"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return OceanThreatsPage();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.workspace_premium_outlined),
            title: Text("Ocean Volunteer"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return OceanHeroesUploadPage();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(FontAwesomeIcons.brain),
            title: Text("Marine Quiz"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MarineQuizPage();
                  },
                ),
              );
            },
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(FontAwesomeIcons.userTie),

              title: const Text("Manager Desk"),
              iconColor: Colors.black,
              collapsedIconColor: Colors.black,
              children: [
                ListTile(
                  leading: Icon(Icons.announcement_outlined),
                  title: Text("Notice"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NoticeUploadPage(isAdmin: true),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.event),
                  title: Text("Events"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventUploadPage(isAdmin: true),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          ListTile(
            leading: Icon(Icons.school),
            title: Text("Career Opportunities"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CareerPage();
                  },
                ),
              );
            },
          ),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Icon(Icons.shield_outlined),

              title: const Text("App Policies and Guidelines"),
              iconColor: Colors.black,
              collapsedIconColor: Colors.black,
              children: [
                ListTile(
                  leading: Icon(Icons.privacy_tip),
                  title: Text("Privacy and Policy"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PrivacyPolicyPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.text_snippet),
                  title: Text("Terms & Conditions"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TermsAndConditionsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.autorenew),
                  title: Text("Cancel & Refund"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CancellationRefundPolicyPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.card_membership_outlined),
                  title: Text("Membership"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MembershipAgreementPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Hero Section
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assests/images/home marine.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.3),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Marine Biodiversity\nConservation",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Our oceans are the lungs of our planet. Let’s unite to protect marine life for today and for generations to come.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ExploreMorePage();
                      },
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "Explore More ➡",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Responsive Objectives Section
  Widget _buildObjectivesSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth > 1200) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 800) {
          crossAxisCount = 2;
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            itemCount: marineTask.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final data = marineTask[index];
              return _objectiveCard(data);
            },
          ),
        );
      },
    );
  }

  // ✅ Individual Card Widget
  Widget _objectiveCard(Map<String, dynamic> data) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.asset(
                data["image"],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 12.0,
              ),
              child: Column(
                children: [
                  Text(
                    data["topic"],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    data["text"],
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
