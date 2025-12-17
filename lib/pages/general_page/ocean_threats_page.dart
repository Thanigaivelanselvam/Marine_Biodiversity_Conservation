import 'package:flutter/material.dart';

class OceanThreatsPage extends StatelessWidget {
  const OceanThreatsPage({super.key});

  // 🔹 Static data (Firestore-ready)
  final List<Map<String, dynamic>> threats = const [
    {
      "title": "Plastic Pollution",
      "image": "assests/images/plastic_pollution.png",
      "icon": Icons.delete_outline,
      "color": Colors.redAccent,
      "description":
      "Millions of tons of plastic enter oceans every year, harming turtles, fish and seabirds.",
      "tip": "Avoid single-use plastics and recycle responsibly."
    },
    {
      "title": "Coral Bleaching",
      "image": "assests/images/coral_bleaching.png",
      "icon": Icons.waves,
      "color": Colors.orangeAccent,
      "description":
      "Rising sea temperatures cause corals to lose algae, turning reefs white and lifeless.",
      "tip": "Reduce carbon footprint and support reef conservation."
    },
    {
      "title": "Overfishing",
      "image": "assests/images/overfishing.png",
      "icon": Icons.phishing,
      "color": Colors.deepPurpleAccent,
      "description":
      "Unsustainable fishing reduces fish populations and disrupts ocean food chains.",
      "tip": "Choose sustainable seafood options."
    },
    {
      "title": "Oil Spills",
      "image": "assests/images/oil_spills.png",
      "icon": Icons.local_gas_station,
      "color": Colors.black87,
      "description":
      "Oil spills poison marine ecosystems and take decades to recover.",
      "tip": "Support clean energy initiatives."
    },
    {
      "title": "Climate Change",
      "image": "assests/images/climate_change.png",
      "icon": Icons.thermostat,
      "color": Colors.blueAccent,
      "description":
      "Global warming causes ocean warming, acidification, and rising sea levels.",
      "tip": "Save energy and reduce emissions."
    },
  ];

  double rs(BuildContext context, double mobile, double tablet) {
    return MediaQuery.of(context).size.width > 600 ? tablet : mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077B6),
        title: const Text(
          "Threats to Oceans",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(rs(context, 16, 24)),
        children: [
          // 🔹 Intro
          Text(
            "Major Threats to Marine Biodiversity",
            style: TextStyle(
              color: Colors.white,
              fontSize: rs(context, 22, 28),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Understanding these threats helps us protect marine life and oceans for future generations.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: rs(context, 14, 18),
            ),
          ),
          const SizedBox(height: 24),

          // 🔹 Threat Cards
          ...threats.map((threat) {
            return Container(
              margin: const EdgeInsets.only(bottom: 18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🖼 IMAGE
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      threat["image"],
                      height: rs(context, 140, 180),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(rs(context, 16, 20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                              (threat["color"] as Color).withOpacity(0.2),
                              child: Icon(
                                threat["icon"],
                                color: threat["color"],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                threat["title"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: rs(context, 18, 22),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Text(
                          threat["description"],
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: rs(context, 14, 18),
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // 💡 Tip
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.lightbulb_outline,
                                  color: Colors.yellowAccent),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  threat["tip"],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: rs(context, 13, 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),

          // 🌍 TAKE ACTION SECTION
          Container(
            padding: EdgeInsets.all(rs(context, 16, 20)),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueAccent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _ActionTile(
                  icon: Icons.delete_forever,
                  title: "Reduce Plastic Use",
                  subtitle:
                  "Carry cloth bags, bottles & avoid single-use plastics",
                  color: Colors.redAccent,
                ),
                SizedBox(height: 12),
                _ActionTile(
                  icon: Icons.volunteer_activism,
                  title: "Support Marine NGOs",
                  subtitle:
                  "Donate or volunteer for ocean conservation groups",
                  color: Colors.greenAccent,
                ),
                SizedBox(height: 12),
                _ActionTile(
                  icon: Icons.school,
                  title: "Educate Others",
                  subtitle:
                  "Share awareness about ocean threats with friends & family",
                  color: Colors.orangeAccent,
                ),
                SizedBox(height: 12),
                _ActionTile(
                  icon: Icons.share,
                  title: "Spread Awareness",
                  subtitle:
                  "Share this app and protect marine life together",
                  color: Colors.cyanAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= ACTION TILE ================= */

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style:
                  const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
