// lib/pages/navigation_pages/marine_species_page.dart
import 'package:flutter/material.dart';
import 'package:marine_trust/pages/others_page/species_details_page.dart';

class MarineSpeciesPage extends StatefulWidget {
  const MarineSpeciesPage({super.key});

  @override
  State<MarineSpeciesPage> createState() => _MarineSpeciesPageState();
}

class _MarineSpeciesPageState extends State<MarineSpeciesPage> {
  // ---- Data ----
  final List<Map<String, String>> _allSpecies = [
    {
      "name": "Clownfish",
      "image":
          "https://c.files.bbci.co.uk/73e5/live/c5cad050-3559-11f0-bf15-094eef773db0.jpg",
      "desc":
          "Clownfish live among sea anemones and are known for their bright orange color. They help maintain reef ecosystems.",
      "status": "Least Concern",
      "category": "Fish",
      "lifeBefore": "10–12 years",
      "lifeAfter": "6–8 years",
    },
    {
      "name": "Blue Whale",
      "image":
          "https://a-z-animals.com/media/2021/04/Biggest-Whale-header-1024x439.jpg",
      "desc":
          "The largest animal on Earth. Blue whales help regulate the ocean’s carbon cycle.",
      "status": "Endangered",
      "category": "Mammal",
      "lifeBefore": "70–90 years",
      "lifeAfter": "60–70 years",

    },
    {
      "name": "Green Sea Turtle",
      "image":
          "https://www.napaliriders.com/wp-content/uploads/sites/6990/2023/11/IMG_9281.jpg?w=700&h=700&zoom=2",
      "desc":
          "These turtles maintain seagrass beds and coral reef health. Threatened by plastic waste and poaching.",
      "status": "Threatened",
      "category": "Reptile",
      "lifeBefore": "70–80 years",
      "lifeAfter": "50–60 years",

    },
    {
      "name": "Manta Ray",
      "image":
          "https://mantarayadvocates.com/wp-content/uploads/2024/03/spotted-eagle-ray-a-common-type-of-ray.jpeg",
      "desc":
          "Manta rays are gentle giants of the ocean and play an important role in balancing marine ecosystems.",
      "status": "Vulnerable",
      "category": "Ray",
      "lifeBefore": "40–50 years",
      "lifeAfter": "25–35 years",

    },
    {
      "name": "Great White Shark",
      "image":
          "https://www.australiangeographic.com.au/wp-content/uploads/2022/07/shutterstock_383911432-1800x1350.jpg",
      "desc":
          "Apex predator essential for maintaining the species balance in the ocean’s food chain.",
      "status": "Vulnerable",
      "category": "Shark",
      "lifeBefore": "60–70 years",
      "lifeAfter": "40–50 years",

    },
    {
      "name": "Leatherback Turtle",
      "image":
          "https://cdn.shortpixel.ai/spai2/q_glossy+w_1082+to_auto+ret_img/www.fauna-flora.org/wp-content/uploads/2023/05/Nature-PL-1615709-scaled-e1654872668433.jpg",
      "desc":
          "Largest sea turtle that undertakes transoceanic migrations. Threatened by fishing gear and pollution.",
      "status": "Vulnerable",
      "category": "Reptile",
      "lifeBefore": "50–60 years",
      "lifeAfter": "30–45 years",

    },
    {
      "name": "Humpback Whale",
      "image":
          "https://images.newscientist.com/wp-content/uploads/2024/02/21143758/SEI_192557721.jpg",
      "desc":
          "Known for their songs and acrobatic breaches. Populations recovering in some regions but still protected.",
      "status": "Least Concern",
      "category": "Mammal",
      "lifeBefore": "60–80 years",
      "lifeAfter": "50–60 years",

    },
    {
      "name": "Dugong",
      "image":
          "https://th-thumbnailer.cdn-si-edu.com/I-RWJ7SYSAPKiTaodBZlOHgPKJg=/750x500/filters:focal(2688x2022:2689x2023)/https://tf-cmsv2-smithsonianmag-media.s3.amazonaws.com/filer_public/a9/48/a9486d72-2527-43f1-8fe2-7eeef50bb800/mar2024_b01_heroesofthewilddugong.jpg",
      "desc":
          "Herbivorous marine mammal that feeds on seagrass; threatened by habitat loss and boat strikes.",
      "status": "Vulnerable",
      "category": "Mammal",
      "lifeBefore": "55–65 years",
      "lifeAfter": "40–50 years",

    },
    {
      "name": "Sea Otter",
      "image":
          "https://marinesanctuary.org/wp-content/uploads/2020/03/MBNMS-SouthernSeaOtter-BigFlippers-DouglasCroft-700x700.jpg",
      "desc":
          "Keystone species of kelp forests, they control sea urchin populations and protect kelp beds.",
      "status": "Endangered",
      "category": "Mammal",
      "lifeBefore": "15–20 years",
      "lifeAfter": "10–15 years",

    },
    {
      "name": "Coral (Staghorn)",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/3/30/Staghorn-coral-1.jpg",
      "desc":
          "Fast-growing branching coral important for reef structure. Severely impacted by bleaching and storms.",
      "status": "Endangered",
      "category": "Coral",
      "lifeBefore": "Hundreds of years",
      "lifeAfter": "50–100 years",

    },
    {
      "name": "Emperor Penguin",
      "image":
          "https://www.worldatlas.com/r/w1200/upload/31/e8/b8/shutterstock-1214030362.jpg",
      "desc":
          "Largest penguin species that breeds on Antarctic sea ice; vulnerable to climate-driven habitat changes.",
      "status": "Near Threatened",
      "category": "Bird",
      "lifeBefore": "20–25 years",
      "lifeAfter": "12–18 years",

    },
    {
      "name": "Loggerhead Turtle",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwOMcrS-9rbLr7_-qjW6a7E14tuoFT3nYAZQ&s",
      "desc":
          "Common in temperate and subtropical seas. Faces threats from fisheries bycatch and coastal development.",
      "status": "Threatened",
      "category": "Reptile",
      "lifeBefore": "20–25 years",
      "lifeAfter": "12–18 years",

    },
    {
      "name": "Tiger Shark",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/3/39/Tiger_shark.jpg",
      "desc":
          "Powerful predator that helps maintain healthy marine ecosystems; vulnerable in some regions.",
      "status": "Near Threatened",
      "category": "Shark",
      "lifeBefore": "30–40 years",
      "lifeAfter": "20–30 years",

    },
    {
      "name": "Hammerhead Shark",
      "image":
          "https://www.popsci.com/wp-content/uploads/2025/08/great-hammerhead-swimming.png?quality=85",
      "desc":
          "Distinctive T-shaped head; many species are threatened by overfishing.",
      "status": "Endangered",
      "category": "Shark",
      "lifeBefore": "25–30 years",
      "lifeAfter": "15–20 years",

    },
    {
      "name": "Whale Shark",
      "image":
          "https://www.scubadiving.com/sites/default/files/styles/655_1x_/public/trevor/spd0615_species_ceg28eweb.jpg?itok=l7C0bsrd",
      "desc":
          "World’s largest fish, filter-feeder; threatened by fisheries and boat strikes.",
      "status": "Vulnerable",
      "category": "Fish",
      "lifeBefore": "80–120 years",
      "lifeAfter": "60–80 years",

    },
    {
      "name": "Seahorse",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8__X4KO_9wY1BIczwDg5_nSduD4W5lkyY4A&s",
      "desc":
          "Small fish that clings to seagrass and corals; collected for aquarium trade and traditional medicine.",
      "status": "Threatened",
      "category": "Fish",
      "lifeBefore": "3–5 years",
      "lifeAfter": "1–2 years",

    },
    {
      "name": "Orca (Killer Whale)",
      "image":
          "https://i.natgeofe.com/n/87a36612-27e8-4e6b-b188-82c37a8dd95a/NationalGeographic_2772395_16x9.jpg?w=1200",
      "desc":
          "Apex predator with complex social structures; some populations are at risk from toxins and prey loss.",
      "status": "Near Threatened",
      "category": "Mammal",
      "lifeBefore": "60–90 years",
      "lifeAfter": "40–60 years",

    },
    {
      "name": "Sperm Whale",
      "image":
          "https://oceanconservancy.org/wp-content/uploads/2017/04/Sperm-Whale_OceanImageBank_EllenCuylaerts_01-scaled-1.webp",
      "desc":
          "Deep-diving whale important for ocean nutrient cycles; populations recovering slowly after whaling.",
      "status": "Vulnerable",
      "category": "Mammal",
      "lifeBefore": "60–70 years",
      "lifeAfter": "50–60 years",

    },
    {
      "name": "Octopus",
      "image":
          "https://worldanimalfoundation.org/wp-content/uploads/2022/07/Octopuses-review.jpg",
      "desc":
          "Highly intelligent cephalopod that plays a role in food webs; sensitive to water quality changes.",
      "status": "Least Concern",
      "category": "Mollusc",
      "lifeBefore": "2–3 years",
      "lifeAfter": "1–2 years",

    },
    {
      "name": "Bluefin Tuna",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2UE1SQsaTUny66d5VSY7sQoDFKi_GxH5URA&s",
      "desc":
          "Highly valued fish that has declined due to overfishing; strict fisheries management needed.",
      "status": "Endangered",
      "category": "Fish",
      "lifeBefore": "35–40 years",
      "lifeAfter": "20–25 years",

    },
  ];

  // ---- UI state ----
  bool _grid = false;
  String _search = "";
  String _statusFilter = "All";
  String _categoryFilter = "All";

  // ---- Helpers ----
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'least concern':
        return Colors.greenAccent.shade400;
      case 'near threatened':
        return Colors.lime.shade700;
      case 'threatened':
        return Colors.orange.shade700;
      case 'vulnerable':
        return Colors.yellow.shade700;
      case 'endangered':
      case 'critically endangered':
        return Colors.redAccent.shade700;
      default:
        return Colors.blueGrey;
    }
  }

  List<Map<String, String>> _applyFilters() {
    final q = _search.trim().toLowerCase();
    return _allSpecies.where((s) {
      final name = s['name']!.toLowerCase();
      final status = s['status']!;
      final category = s['category']!;
      if (_statusFilter != 'All' && status != _statusFilter) return false;
      if (_categoryFilter != 'All' && category != _categoryFilter) return false;
      if (q.isEmpty) return true;
      return name.contains(q) || s['desc']!.toLowerCase().contains(q);
    }).toList();
  }

  // ---- Build ----
  @override
  Widget build(BuildContext context) {
    final results = _applyFilters();
    final categories =
        <String>{
          'All',
          ..._allSpecies.map((e) => e['category']!).toSet(),
        }.toList();
    final statusOptions =
        <String>{
          'All',
          ..._allSpecies.map((e) => e['status']!).toSet(),
        }.toList();

    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Marine Species',
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0077B6),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: "Toggle Grid/List",
            onPressed: () => setState(() => _grid = !_grid),
            icon: Icon(_grid ? Icons.view_list : Icons.grid_view,color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.black54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration.collapsed(
                                hintText: "Search species or keywords",
                              ),
                              onChanged: (v) => setState(() => _search = v),
                            ),
                          ),
                          if (_search.isNotEmpty)
                            GestureDetector(
                              onTap: () => setState(() => _search = ""),
                              child: const Icon(
                                Icons.clear,
                                color: Colors.black45,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filters: category + status
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            categories.map((c) {
                              final selected = c == _categoryFilter;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ChoiceChip(
                                  label: Text(c),
                                  selected: selected,
                                  onSelected:
                                      (_) =>
                                          setState(() => _categoryFilter = c),
                                  selectedColor: Colors.cyan,
                                  backgroundColor: Colors.white12,
                                  labelStyle: TextStyle(
                                    color:
                                        selected
                                            ? Colors.white
                                            : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: _statusFilter,
                      underline: const SizedBox(),
                      dropdownColor: const Color(0xFF003b5c),
                      style: const TextStyle(color: Colors.white),
                      items:
                          statusOptions
                              .map(
                                (s) =>
                                    DropdownMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                      onChanged:
                          (v) => setState(() => _statusFilter = v ?? 'All'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Result count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Text(
                    "${results.length} species found",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const Spacer(),
                  const Text(
                    "Tap a card to view details",
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _grid ? _buildGrid(results) : _buildList(results),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Map<String, String>> items) {
    return ListView.separated(
      key: const ValueKey('list'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, idx) {
        final s = items[idx];
        return _speciesCard(s, isGrid: false);
      },
    );
  }

  Widget _buildGrid(List<Map<String, String>> items) {
    return GridView.builder(
      key: const ValueKey('grid'),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).size.width > 800
                ? 3
                : (MediaQuery.of(context).size.width > 500 ? 2 : 1),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: items.length,
      itemBuilder: (_, idx) => _speciesCard(items[idx], isGrid: true),
    );
  }

  Widget _speciesCard(Map<String, String> s, {required bool isGrid}) {
    final name = s['name']!;
    final image = s['image']!;
    final status = s['status']!;
    final category = s['category']!;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SpeciesDetailPage(
              name: name,
              image: image,
              description: s['desc']!,
              status: status,
              category: category,
              lifeBefore: s["lifeBefore"] ?? "Unknown",
              lifeAfter: s["lifeAfter"] ?? "Unknown",
            ),
          ),
        );
      }
,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white12),
        ),
        padding: const EdgeInsets.all(10),
        child:
            isGrid
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _cardChildren(
                    name,
                    image,
                    status,
                    category,
                    isGrid,
                  ),
                )
                : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _cardChildren(
                    name,
                    image,
                    status,
                    category,
                    isGrid,
                  ),
                ),
      ),
    );
  }

  List<Widget> _cardChildren(
    String name,
    String image,
    String status,
    String category,
    bool isGrid,
  ) {
    final img = Hero(
      tag: name,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          image,
          width: isGrid ? double.infinity : 96,
          height: isGrid ? 110 : 96,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => Container(
                width: isGrid ? double.infinity : 96,
                height: isGrid ? 110 : 96,
                color: Colors.grey,
                child: const Icon(Icons.broken_image, color: Colors.white),
              ),
        ),
      ),
    );

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _statusColor(status),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );

    final texts = Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: isGrid ? 0 : 12, top: isGrid ? 8 : 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              category,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                badge,
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.white24,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (isGrid) {
      return [img, const SizedBox(height: 8), texts];
    } else {
      return [img, texts];
    }
  }
}
