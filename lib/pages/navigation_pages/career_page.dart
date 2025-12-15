import 'package:flutter/material.dart';
import 'package:marine_trust/pages/others_page/join_volunteer_form.dart';
import 'package:url_launcher/url_launcher.dart';

class CareerPage extends StatelessWidget {
  const CareerPage({Key? key}) : super(key: key);

  static const supportEmail = 'dr.s.davidraj@gmail.com';
  final Color themeBlue = const Color(0xFF09B1EC);

  final List<_Opportunity> _internships = const [
    _Opportunity(
      title: 'Marine Awareness Content Intern',
      subtitle: 'Create educational articles, posts, and research-based content.',
      type: OpportunityType.internship,
      duration: '3 months',
      stipend: 'Unpaid / Certificate',
    ),
    _Opportunity(
      title: 'App Support Intern (Technical)',
      subtitle: 'Help test features, report bugs, and maintain documentation.',
      type: OpportunityType.internship,
      duration: '3 months',
      stipend: 'Stipend available',
    ),
  ];

  final List<_Opportunity> _jobs = const [
    _Opportunity(
      title: 'Flutter Developer',
      subtitle: 'Maintain and extend the mobile app, and implement new features.',
      type: OpportunityType.job,
      duration: 'Full-time',
      stipend: 'Paid',
    ),
    _Opportunity(
      title: 'Project Coordinator – Marine Conservation',
      subtitle: 'Manage outreach programs and coordinate conservation events.',
      type: OpportunityType.job,
      duration: 'Full-time',
      stipend: 'Paid',
    ),
  ];

  final List<_Opportunity> _volunteers = const [
    _Opportunity(
      title: 'Beach Clean-up Volunteer',
      subtitle: 'Participate in beach clean-up events and awareness programs.',
      type: OpportunityType.volunteer,
      duration: 'Event-based',
      stipend: 'Volunteer',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: themeBlue,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Career Opportunities',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 14),
        children: [
          SizedBox(height: 18),
          _Header(themeBlue: themeBlue, isTablet: isTablet),
          SizedBox(height: 24),

          _SectionTitle("Internships"),
          ..._internships.map((o) => _OpportunityCard(
            opportunity: o,
            isTablet: isTablet,
            themeBlue: themeBlue,
          )),

          SizedBox(height: 22),
          _SectionTitle("Jobs"),
          ..._jobs.map((o) => _OpportunityCard(
            opportunity: o,
            isTablet: isTablet,
            themeBlue: themeBlue,
          )),

          SizedBox(height: 22),
          _SectionTitle("Volunteer Programs"),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: themeBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VolunteerPage()),
            ),
            icon: Icon(Icons.volunteer_activism, size: isTablet ? 28 : 22),
            label: Text(
              'Become a Volunteer',
              style: TextStyle(fontSize: isTablet ? 18 : 15),
            ),
          ),

          ..._volunteers.map((o) => _OpportunityCard(
            opportunity: o,
            isTablet: isTablet,
            themeBlue: themeBlue,
          )),

          SizedBox(height: 25),
          _ApplyHelpCard(
            email: supportEmail,
            themeBlue: themeBlue,
            isTablet: isTablet,
          ),

          SizedBox(height: 40),
          _Footer(isTablet: isTablet),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool isTablet;
  final Color themeBlue;
  const _Header({required this.isTablet, required this.themeBlue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 22 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [themeBlue, themeBlue.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.work, color: Colors.white, size: isTablet ? 70 : 56),
          SizedBox(width: isTablet ? 24 : 16),
          Expanded(
            child: Text(
              'Conserve Marine Biodiversity\nJoin our team — internships, jobs, and volunteer roles available.',
              style: TextStyle(
                fontSize: isTablet ? 18 : 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Color(0xFF063970),
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final _Opportunity opportunity;
  final bool isTablet;
  final Color themeBlue;

  const _OpportunityCard({
    required this.opportunity,
    required this.isTablet,
    required this.themeBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: isTablet ? 12 : 8),
      padding: EdgeInsets.all(isTablet ? 20 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: themeBlue.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: themeBlue.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            opportunity.title,
            style: TextStyle(
              fontSize: isTablet ? 20 : 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: 6),
          Text(
            opportunity.subtitle,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Colors.black87,
            ),
          ),

          SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _chip(opportunity.duration),
              _chip(opportunity.stipend),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeBlue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 20 : 14,
                    vertical: isTablet ? 14 : 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(isTablet ? 14 : 10),
                  ),
                ),
                onPressed: () => _openApplySheet(context),
                child: Text(
                  "Apply",
                  style: TextStyle(fontSize: isTablet ? 16 : 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Chip(
      label: Text(text),
      backgroundColor: themeBlue.withOpacity(0.15),
      labelStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  void _openApplySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ApplyBottomSheet(
        opportunity: opportunity,
        isTablet: isTablet,
        themeBlue: themeBlue,
      ),
    );
  }
}

class _ApplyBottomSheet extends StatelessWidget {
  final _Opportunity opportunity;
  final bool isTablet;
  final Color themeBlue;

  const _ApplyBottomSheet({
    required this.opportunity,
    required this.isTablet,
    required this.themeBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Apply for ${opportunity.title}",
            style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),

          Text(
            "Send your resume and a short message to our recruitment team.",
            style: TextStyle(fontSize: isTablet ? 16 : 14),
          ),

          SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 18 : 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: Icon(Icons.email),
                  onPressed: () => _launchEmail(),
                  label: Text(
                    "Email Us",
                    style: TextStyle(fontSize: isTablet ? 16 : 14),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 18 : 14,
                    ),
                    side: BorderSide(color: themeBlue, width: 1.3),
                  ),
                  icon: Icon(Icons.chat, color: themeBlue),
                  onPressed: () => _launchWhatsapp(),
                  label: Text(
                    "WhatsApp",
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: themeBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel",
                  style: TextStyle(color: Colors.red)),
            ),
          )
        ],
      ),
    );
  }

  void _launchEmail() async {
    final subject = Uri.encodeComponent('Application: ${opportunity.title}');
    final body = Uri.encodeComponent(
        'Hello,\n\nI would like to apply for this role.\n\nRegards,\n');

    final uri =
    Uri.parse('mailto:dr.s.davidraj@gmail.com?subject=$subject&body=$body');

    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  void _launchWhatsapp() async {
    final uri = Uri.parse('https://wa.me/+919994401291');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }
}

class _ApplyHelpCard extends StatelessWidget {
  final String email;
  final bool isTablet;
  final Color themeBlue;

  const _ApplyHelpCard({
    required this.email,
    required this.isTablet,
    required this.themeBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 22 : 16),
      decoration: BoxDecoration(
        color: themeBlue.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How to Apply",
            style: TextStyle(
              fontSize: isTablet ? 20 : 16,
              fontWeight: FontWeight.bold,
              color: themeBlue,
            ),
          ),
          SizedBox(height: 10),

          Text("1. Click “Apply” on any role.",
              style: TextStyle(fontSize: isTablet ? 16 : 14)),
          Text("2. Email your resume to $email.",
              style: TextStyle(fontSize: isTablet ? 16 : 14)),
          Text("3. Add a brief note describing your interest.",
              style: TextStyle(fontSize: isTablet ? 16 : 14)),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final bool isTablet;
  const _Footer({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Skiez Technologies",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 18 : 14,
          ),
        ),
        SizedBox(height: 6),
        Text(
          "Conserve Marine Biodiversity",
          style: TextStyle(
            color: Colors.black54,
            fontSize: isTablet ? 16 : 13,
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}

class _Opportunity {
  final String title;
  final String subtitle;
  final OpportunityType type;
  final String duration;
  final String stipend;

  const _Opportunity({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.duration,
    required this.stipend,
  });
}

enum OpportunityType { internship, job, volunteer }
