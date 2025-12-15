import 'package:flutter/material.dart';
import 'package:marine_trust/pages/navigation_pages/donate_screen.dart';

class SpeciesDetailPage extends StatelessWidget {
  final String name;
  final String image;
  final String description;
  final String status;
  final String category;
  final String lifeBefore;
  final String lifeAfter;

  const SpeciesDetailPage({
    super.key,
    required this.name,
    required this.image,
    required this.description,
    required this.status,
    required this.category,
    required this.lifeBefore,
    required this.lifeAfter,
  });

  // ---------------- STATUS COLOR ----------------
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'least concern':
        return Colors.greenAccent.shade400;
      case 'near threatened':
        return Colors.yellowAccent.shade700;
      case 'threatened':
      case 'vulnerable':
        return Colors.orangeAccent.shade700;
      case 'endangered':
      case 'critically endangered':
        return Colors.redAccent.shade700;
      default:
        return Colors.blueGrey;
    }
  }

  // ---------------- STATUS EXPLANATION ----------------
  String _statusExplanation(String s) {
    switch (s.toLowerCase()) {
      case 'least concern':
        return "This species is widespread and abundant. Continue protecting its habitat.";
      case 'near threatened':
        return "This species is close to qualifying for a threatened category. Early conservation helps.";
      case 'threatened':
      case 'vulnerable':
        return "This species faces a high risk of extinction in the wild.";
      case 'endangered':
        return "Faces a very high risk of extinction. Immediate conservation is needed.";
      case 'critically endangered':
        return "Extremely high risk of extinction. Urgent protection required.";
      default:
        return "Status information unavailable.";
    }
  }

  // ---------------- WHY LIFESPAN REDUCED ----------------
  String _lifespanReductionReason() {
    // Auto-generate reasons based on category
    switch (category.toLowerCase()) {
      case "fish":
        return "Fish species show reduced lifespan due to water pollution, microplastics, ocean acidification, and rising sea temperatures which damage their habitat and food chain.";
      case "mammal":
        return "Marine mammals face reduced lifespan mainly because of ship strikes, noise pollution, decreasing prey availability, climate change, and chemical accumulation in their bodies.";
      case "reptile":
        return "Marine reptiles such as turtles lose lifespan due to plastic ingestion, habitat destruction, and temperature rise affecting breeding patterns.";
      case "shark":
        return "Shark lifespan decreases due to overfishing, fin trade, habitat degradation, and low reproductive rates.";
      case "ray":
        return "Rays are affected by ocean pollution, habitat loss, and fishing nets which reduce survival years.";
      case "coral":
        return "Coral lifespan decline is caused by bleaching, warming oceans, chemical runoff, and sedimentation.";
      case "bird":
        return "Marine birds experience reduced lifespan due to plastic ingestion, oil spills, climate change, and overfishing reducing their food supply.";
      case "mollusc":
        return "Molluscs like octopus are affected by ocean acidification, warming seas, and habitat destruction.";
      default:
        return "Environmental changes, pollution, and climate impact have reduced the lifespan of this species.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(status);

    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0077B6),
        title: Text(name, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------------- IMAGE ----------------
            Hero(
              tag: name,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  image,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ---------------- NAME + STATUS ----------------
            Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              category,
              style: const TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 16),

            // ---------------- DESCRIPTION ----------------
            Text(
              description,
              style: const TextStyle(color: Colors.white70, height: 1.6),
            ),

            const SizedBox(height: 20),

            // ---------------- WHY STATUS ----------------
            Text(
              "Why this status matters",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _statusExplanation(status),
              style: const TextStyle(color: Colors.white70, height: 1.6),
            ),

            const SizedBox(height: 20),

            // ---------------- LIFESPAN ----------------
            Text(
              "Lifespan Comparison",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Before 2000:",
                      style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                  Text(lifeBefore,
                      style: const TextStyle(color: Colors.white70)),

                  const SizedBox(height: 10),

                  Text("After 2000:",
                      style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                  Text(lifeAfter,
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ---------------- LIFESPAN REDUCTION REASON ----------------
            Text(
              "Why Lifespan Reduced?",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              _lifespanReductionReason(),
              style: const TextStyle(color: Colors.white70, height: 1.6),
            ),

            const SizedBox(height: 30),

            // ---------------- DONATE BUTTON ----------------
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DonatePage()),
                  );
                },
                icon: const Icon(Icons.volunteer_activism, color: Colors.white),
                label: const Text(
                  "Support Conservation",
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
