import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:marine_trust/pages/others_page/join_volunteer_form.dart';

class CountryInfoPage extends StatefulWidget {
  final String name;
  final String flag;
  final String image;
  final String desc;

  const CountryInfoPage({
    super.key,
    required this.name,
    required this.flag,
    required this.image,
    required this.desc,
  });

  @override
  State<CountryInfoPage> createState() => _CountryInfoPageState();
}

class _CountryInfoPageState extends State<CountryInfoPage>
    with TickerProviderStateMixin {

  // ------------------ OCEAN FACTS ------------------
  String getCountryOceanInfo(String country) {
    switch (country.toLowerCase()) {
      case 'india':
        return '''
🇮🇳 **India's Oceanic Wonders**
• Surrounded by the Indian Ocean, Arabian Sea & Bay of Bengal  
• Famous seashores: Goa, Marina Beach, Kovalam, Rameswaram  
• The Andaman & Nicobar Islands have rich coral reefs  
• India supports blue economy and marine conservation
''';

      case 'australia':
        return '''
🇦🇺 **Australia's Oceanic Heritage**
• Surrounded by the Pacific & Indian Oceans  
• Home to the Great Barrier Reef  
• Beautiful beaches: Bondi, Whitehaven  
• Global leader in marine protection
''';

      default:
        return '''
🌍 This country protects marine biodiversity through coral reef programs and ocean research.
''';
    }
  }


  // ------------------ MARINE BIODIVERSITY INFO (NEW) ------------------
  String getMarineBiodiversityInfo(String country) {
    switch (country.toLowerCase()) {

      case 'india':
        return '''
🇮🇳 **Marine Biodiversity of India**
• Rich coral reefs in Andaman, Nicobar & Lakshadweep  
• World's largest mangrove forest — Sundarbans  
• Marine species: Dugong, Olive Ridley Turtles, Whale Sharks  
• Over 7,500 km of coastline  
• Hotspots: Gulf of Mannar, Andaman Sea
''';

      case 'australia':
        return '''
🇦🇺 **Marine Biodiversity of Australia**
• Largest coral ecosystem — Great Barrier Reef  
• Species: Manta rays, turtles, reef sharks, colorful corals  
• Huge marine protected areas  
• Famous whale migration routes
''';

      case 'japan':
        return '''
🇯🇵 **Marine Biodiversity of Japan**
• Over 30,000+ marine species  
• Coral reefs in Okinawa  
• Species: Tuna, dolphins, sea turtles  
• Productive fishing zones & deep-sea ecosystems
''';

      case 'indonesia':
        return '''
🇮🇩 **Marine Biodiversity of Indonesia**
• Center of the Coral Triangle  
• 76% of Earth's coral species live here  
• Amazing spots: Raja Ampat, Bali Sea  
• Species: Whale sharks, manta rays, rare corals
''';

      case 'maldives':
        return '''
🇲🇻 **Marine Biodiversity of Maldives**
• Coral atolls surrounded by clear lagoons  
• Species: Whale sharks, manta rays, reef fish  
• Coral reefs facing bleaching but under recovery
''';

      default:
        return '''
🐬 This country contributes to marine biodiversity through protected coasts, coral reef conservation and sustainable fishing.
''';
    }
  }


  @override
  Widget build(BuildContext context) {
    final oceanFacts = getCountryOceanInfo(widget.name);
    final marineInfo = getMarineBiodiversityInfo(widget.name);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0077B6),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            baseColor: Colors.white,
            spawnMinSpeed: 5,
            spawnMaxSpeed: 15,
            particleCount: 30,
          ),
        ),
        vsync: this,

        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF001F3F),
                Color(0xFF0077B6),
                Color(0xFF00B4D8),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // ---------- MAIN IMAGE ----------
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.image,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 20),

                // ---------- FLAG ----------
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.flag),
                  radius: 40,
                ),

                const SizedBox(height: 15),

                // ---------- NAME ----------
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                // ---------- DESCRIPTION ----------
                Text(
                  widget.desc,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),
                const Divider(color: Colors.white38),
                const SizedBox(height: 20),


                // *************** OCEAN FACTS ***************
                const Text(
                  "🌊 Ocean Facts & Famous Shores",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  oceanFacts,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),

                const SizedBox(height: 30),
                const Divider(color: Colors.white24),
                const SizedBox(height: 20),


                // *************** MARINE BIODIVERSITY (NEW) ***************
                const Text(
                  "🐬 Marine Biodiversity Information",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  marineInfo,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),

                const SizedBox(height: 30),
                const Divider(color: Colors.white24),
                const SizedBox(height: 20),


                // *************** CONTRIBUTION SECTION ***************
                const Text(
                  "🌿 Contribution to Marine Biodiversity",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                const Text(
                  "Every coastal nation contributes to ocean conservation through coral reef protection, marine reserves, and sustainable fishing efforts.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),


                const SizedBox(height: 40),

                // *************** VOLUNTEER BUTTON ***************
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VolunteerPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "🤝 Join as a Volunteer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
