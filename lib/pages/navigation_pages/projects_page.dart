import 'package:flutter/material.dart';
import 'package:marine_trust/pages/navigation_pages/donate_screen.dart';
import 'package:marine_trust/pages/others_page/join_volunteer_form.dart';


class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final List<Map<String, dynamic>> demoProjects = [
    {
      "title": "Coral Reef Restoration — Lakshadweep",
      "category": "Restoration",
      "description":
      "Supporting coral growth and marine biodiversity through reef restoration in Lakshadweep.",
      "imageUrl": "assests/images/coral leaf restoration.jpg",
      "raised": 120000,
      "goal": 200000,
      "location": "Lakshadweep, India",
    },
    {
      "title": "Mangrove Awareness — Goa",
      "category": "Awareness",
      "description":
      "Educating local communities and promoting mangrove protection through workshops and cleanup drives.",
      "imageUrl": "assests/images/mangrove-restoration-4.jpg",
      "raised": 60000,
      "goal": 150000,
      "location": "Goa, India",
    },
    {
      "title": "Marine Life Research — Andaman",
      "category": "Research",
      "description":
      "Studying fish population and coral health to guide conservation policies and sustainable fishing practices.",
      "imageUrl": "assests/images/guide-exploring-marine-life-andaman-islands.webp",
      "raised": 57500,
      "goal": 100000,
      "location": "Andaman & Nicobar Islands",
    },
  ];

  String searchQuery = '';
  String selectedCategory = 'All';

  List<Map<String, dynamic>> get filteredProjects {
    return demoProjects.where((p) {
      final matchesSearch = p['title'].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchesCategory =
          selectedCategory == 'All' || p['category'] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final isMobile = screenW < 700;
    final horizontalPadding = isMobile ? 16.0 : 48.0;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff04364f),
        title: Text(
          'All Projects',
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 22 : 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF022C43), Color(0xFF053D57), Color(0xFF022C43)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search + Filter row (pinned)
                _buildSearchAndFilter(context, isMobile, screenW),

                const SizedBox(height: 18),

                // Expanded scrollable area (GridView) — prevents bottom white-space
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Decide columns: 1 mobile, 2 medium, 3 large
                      int crossAxisCount = 1;
                      if (constraints.maxWidth >= 1200) {
                        crossAxisCount = 3;
                      } else if (constraints.maxWidth >= 800) {
                        crossAxisCount = 2;
                      } else {
                        crossAxisCount = 1;
                      }

                      final items = filteredProjects;

                      if (items.isEmpty) {
                        return _buildEmptyState();
                      }

                      // Use GridView.builder so it scrolls correctly and adapts height
                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          // childAspectRatio tuned for card look on mobile/desktop
                          childAspectRatio: (crossAxisCount == 1) ? 0.78 : 0.95,
                        ),
                        itemCount: items.length,
                        itemBuilder:
                            (context, index) => _buildProjectCard(
                          context,
                          items[index],
                          isMobile,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(
      BuildContext context,
      bool isMobile,
      double screenW,
      ) {
    // When wide, show inline; when narrow, stacked
    final searchWidth = isMobile ? screenW : 380.0;

    return isMobile
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSearchBox(width: searchWidth),
        const SizedBox(height: 10),
        Align(alignment: Alignment.centerLeft, child: _buildDropdown()),
      ],
    )
        : Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSearchBox(width: searchWidth),
        const SizedBox(width: 12),
        _buildDropdown(),
      ],
    );
  }

  Widget _buildSearchBox({required double width}) {
    return SizedBox(
      width: width,
      child: TextField(
        onChanged: (v) => setState(() => searchQuery = v),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Search projects...',
          filled: true,
          fillColor: Colors.white.withOpacity(0.95),
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF053D57),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: const Color(0xff04364f),
          value: selectedCategory,
          items: const [
            DropdownMenuItem(value: 'All', child: Text('All')),
            DropdownMenuItem(value: 'Restoration', child: Text('Restoration')),
            DropdownMenuItem(value: 'Awareness', child: Text('Awareness')),
            DropdownMenuItem(value: 'Research', child: Text('Research')),
          ],
          onChanged:
              (value) => setState(() => selectedCategory = value ?? 'All'),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.filter_alt_off, size: 48, color: Colors.white70),
          const SizedBox(height: 12),
          const Text(
            "No projects found",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            "Try a different filter or search term.",
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(
      BuildContext context,
      Map<String, dynamic> project,
      bool isMobile,
      ) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(project['imageUrl'], fit: BoxFit.cover),
          ),

          // content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  project['location'],
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  project['description'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.visibility, color: Colors.white),
                      label: const Text(
                        'View',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        elevation: 0,
                      ),
                      onPressed: () => _showDetails(context, project),
                    ),
                    OutlinedButton.icon(
                      icon: const Icon(
                        Icons.volunteer_activism,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Volunteer',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xff09b1ec),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return VolunteerPage();
                        },));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Details dialog (unchanged logic)
  void _showDetails(BuildContext context, Map<String, dynamic> project) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
        title: Text(project['title']),
        content: Text(project['description']),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff09b1ec),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DonatePage()),
              );
            },
            child: const Text(
              'Donate',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Volunteer dialog (keeps the responsive approach)
  void _showVolunteer(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: '',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        final width = MediaQuery.of(context).size.width;
        final isMobile = width < 700;

        return Center(
          child: Container(
            width: isMobile ? double.infinity : 720,
            height: isMobile ? double.infinity : 480,
            margin: EdgeInsets.symmetric(
              horizontal: isMobile ? 0 : 24,
              vertical: isMobile ? 0 : 36,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isMobile ? 0 : 16),
            ),
            clipBehavior: Clip.antiAlias,
            child:
            isMobile
                ? _buildVolunteerMobileLayout(context)
                : _buildVolunteerWebLayout(context),
          ),
        );
      },
      transitionBuilder:
          (context, anim1, anim2, child) => FadeTransition(
        opacity: anim1,
        child: ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: child,
        ),
      ),
    );
  }

  Widget _buildVolunteerWebLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A1F2B), Color(0xFF113B63)],
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.volunteer_activism, color: Colors.white, size: 48),
                SizedBox(height: 16),
                Text(
                  'Join Our Mission',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Become a volunteer and help us protect marine life through awareness and restoration activities.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7A1CAC), Color(0xFFBE39C3)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Volunteer Form',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildVolunteerField('Full Name'),
                _buildVolunteerField('Email'),
                _buildVolunteerField('Phone Number'),
                _buildVolunteerField('City'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.purple,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: const Text(
                    'Send OTP',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVolunteerMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1F2B),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Volunteer Sign-Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7A1CAC), Color(0xFFBE39C3)],
                  ),
                ),
                child: Column(
                  children: [
                    _buildVolunteerField('Full Name', light: true),
                    _buildVolunteerField('Email', light: true),
                    _buildVolunteerField('Phone Number', light: true),
                    _buildVolunteerField('City', light: true),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple,
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: const Text(
                        'Send OTP',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVolunteerField(String label, {bool light = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        style: TextStyle(color: light ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: light ? Colors.white70 : Colors.black),
          filled: true,
          fillColor: light ? Colors.white.withOpacity(0.12) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}