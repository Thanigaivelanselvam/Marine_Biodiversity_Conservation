import 'package:flutter/material.dart';
import 'package:marine_trust/pages/general_page/ocean_threats_page.dart';

class OceanLifePage extends StatefulWidget {
  const OceanLifePage({super.key});

  @override
  State<OceanLifePage> createState() => _OceanLifePageState();
}

class _OceanLifePageState extends State<OceanLifePage> {
  double rs(BuildContext context, double mobile, double tablet) {
    return MediaQuery.of(context).size.width > 600 ? tablet : mobile;
  }
  void _showPledgeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF001F3F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Ocean Protection Pledge",
            style: TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "I pledge to:\n\n"
                "• Reduce plastic use\n"
                "• Respect marine life\n"
                "• Spread awareness\n"
                "• Protect oceans for future generations\n\n"
                "Because the ocean is our life, not a resource.",
            style: TextStyle(
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                _showThankYou(context);
              },
              child: const Text("I Pledge"),
            ),
          ],
        );
      },
    );
  }
  void _showThankYou(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF001F3F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.eco, color: Colors.greenAccent, size: 50),
              SizedBox(height: 12),
              Text(
                "Thank You ",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Your small promise today\ncreates a better ocean tomorrow.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Continue",
                  style: TextStyle(color: Colors.cyanAccent),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077B6),
        title: const Text(
          "Ocean & Our Life",
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

          // 🌊 HERO QUOTE
          Container(
            padding: EdgeInsets.all(rs(context, 16, 20)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.cyan.withOpacity(0.25),
                  Colors.blue.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.cyanAccent),
            ),
            child: Column(
              children: [
                Text(
                  "“The ocean is not a place we visit.\nIt is our home.”",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: rs(context, 18, 22),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 🌊 HEADER MESSAGE
          Text(
            "Our Life, Our Ocean, Our Responsibility",
            style: TextStyle(
              color: Colors.white,
              fontSize: rs(context, 24, 30),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Every breath we take, every drop of rain and much of the food we eat comes from the ocean.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: rs(context, 15, 18),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 30),

          // 🌬 OXYGEN CARD
          _LifeCard(
            icon: Icons.air,
            title: "Oxygen for Life",
            description:
            "Phytoplankton in the ocean produce over 50% of the oxygen we breathe.",
            color: Colors.cyanAccent,
          ),
          const SizedBox(height: 16),

          _LifeCard(
            icon: Icons.cloud,
            title: "Climate Balance",
            description:
            "Oceans regulate Earth’s temperature and reduce climate extremes.",
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 16),

          _LifeCard(
            icon: Icons.restaurant,
            title: "Food & Livelihood",
            description:
            "Over 3 billion people rely on oceans for food and employment.",
            color: Colors.greenAccent,
          ),
          const SizedBox(height: 16),

          _LifeCard(
            icon: Icons.medical_services,
            title: "Medicine & Biodiversity",
            description:
            "Marine life contributes to medicines used for cancer and pain relief.",
            color: Colors.purpleAccent,
          ),

          const SizedBox(height: 30),

          // 📊 DAILY LIFE IMPACT
          _ImpactRow(),

          const SizedBox(height: 30),

          // 🌱 FUTURE GENERATION MESSAGE
          Container(
            padding: EdgeInsets.all(rs(context, 16, 20)),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "For Future Generations",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: rs(context, 20, 24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Protecting the ocean today ensures clean air, food security and a stable climate for our children tomorrow.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: rs(context, 14, 16),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ✋ PERSONAL PLEDGE (INNOVATIVE)
          Container(
            padding: EdgeInsets.all(rs(context, 16, 20)),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.greenAccent),
            ),
            child: Column(
              children: [
                Text(
                  "My Promise to the Ocean",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: rs(context, 20, 24),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "I will reduce plastic use, respect marine life and inspire others to protect our oceans.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: rs(context, 14, 16),
                  ),
                ),
                const SizedBox(height: 14),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _showPledgeDialog(context),
                  child: const Text("I Take This Pledge"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // ➡ NEXT STEP CTA
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyan,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: rs(context, 14, 18),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.arrow_forward),
            label: Text(
              "See Threats to Our Oceans",
              style: TextStyle(
                fontSize: rs(context, 16, 18),
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OceanThreatsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

/* ================= LIFE CARD ================= */

class _LifeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _LifeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
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
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= IMPACT ROW ================= */

class _ImpactRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _ImpactItem(icon: Icons.air, label: "Every Breath"),
        _ImpactItem(icon: Icons.water_drop, label: "Rain Cycle"),
        _ImpactItem(icon: Icons.restaurant, label: "Daily Food"),
      ],
    );
  }
}

class _ImpactItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ImpactItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 30),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
