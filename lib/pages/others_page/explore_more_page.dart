import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:marine_trust/pages/others_page/country_info_page.dart';

class ExploreMorePage extends StatefulWidget {
  const ExploreMorePage({super.key});

  @override
  State<ExploreMorePage> createState() => _ExploreMorePageState();
}

class _ExploreMorePageState extends State<ExploreMorePage>
    with TickerProviderStateMixin {

  final List<Map<String, String>> oceanCountries = [

    // 🌏 Oceania & Asia
    {
      "name": "Australia",
      "flag": "https://flagcdn.com/w320/au.png",
      "image": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
      "desc": "Home to the Great Barrier Reef, the largest coral ecosystem on Earth."
    },
    {
      "name": "Japan",
      "flag": "https://flagcdn.com/w320/jp.png",
      "image": "https://img.freepik.com/free-photo/aerial-view-tokyo-cityscape-with-fuji-mountain-japan_335224-148.jpg",
      "desc": "An island nation known for its deep-rooted respect for oceans."
    },
    {
      "name": "Indonesia",
      "flag": "https://flagcdn.com/w320/id.png",
      "image": "https://etimg.etb2bimg.com/photo/115997634.cms",
      "desc": "Located in the Coral Triangle with the highest marine diversity."
    },
    {
      "name": "Philippines",
      "flag": "https://flagcdn.com/w320/ph.png",
      "image": "https://etimg.etb2bimg.com/photo/95545719.cms",
      "desc": "Known for coral reefs, clear waters, and over 7,000 islands."
    },
    {
      "name": "New Zealand",
      "flag": "https://flagcdn.com/w320/nz.png",
      "image": "https://beantowntraveller.com/wp-content/uploads/2018/07/IMG_2484-scaled.jpg",
      "desc": "Famous for clean beaches and strong ocean conservation."
    },
    {
      "name": "Sri Lanka",
      "flag": "https://flagcdn.com/w320/lk.png",
      "image": "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0f/ed/85/6b/um-palacio-no-topo-da.jpg",
      "desc": "An island nation rich in corals, tropical fish, and coastal heritage."
    },
    {
      "name": "Maldives",
      "flag": "https://flagcdn.com/w320/mv.png",
      "image": "https://images.pexels.com/photos/1483053/pexels-photo-1483053.jpeg",
      "desc": "A coral paradise of turquoise waters and atolls."
    },
    {
      "name": "India",
      "flag": "https://flagcdn.com/w320/in.png",
      "image": "https://images.unsplash.com/photo-1576487248805-cf45f6bcc67f",
      "desc": "Bordered by three major water bodies and rich marine ecosystems."
    },
    {
      "name": "Malaysia",
      "flag": "https://flagcdn.com/w320/my.png",
      "image": "https://images.pexels.com/photos/22804/pexels-photo.jpg",
      "desc": "Known for mangroves, coral reefs, and the South China Sea biodiversity."
    },
    {
      "name": "Vietnam",
      "flag": "https://flagcdn.com/w320/vn.png",
      "image": "https://cdn.tourradar.com/s3/serp/original/5032_Gia44gKW.jpg",
      "desc": "Home to tropical coasts, mangroves, and rich marine life."
    },
    {
      "name": "Singapore",
      "flag": "https://flagcdn.com/w320/sg.png",
      "image": "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
      "desc": "Small island nation with coral nurseries and strong marine protection."
    },
    {
      "name": "Brunei",
      "flag": "https://flagcdn.com/w320/bn.png",
      "image": "https://images.squarespace-cdn.com/content/v1/58ce9b5d29687fc957d50613/1557624631230-B7KAS3S1A48Y20ZX55LG/Visiting+Brunei+-+Should+you+go%2C+and+what+to+do.jpg?format=1000w",
      "desc": "South China Sea coastline with mangroves and reef ecosystems."
    },
    {
      "name": "South Korea",
      "flag": "https://flagcdn.com/w320/kr.png",
      "image": "https://images.travelandleisureasia.com/wp-content/uploads/sites/2/2023/11/05145003/busan.jpeg",
      "desc": "Bordered by three seas with vibrant marine biodiversity."
    },

    // 🌍 Middle East
    {
      "name": "Oman",
      "flag": "https://flagcdn.com/w320/om.png",
      "image": "https://www.outlooktravelmag.com/media/oman-1-1587121317.profileImage.2x-jpg-webp.webp",
      "desc": "Famous for turtles, dolphins, and pristine Arabian Sea coasts."
    },
    {
      "name": "United Arab Emirates",
      "flag": "https://flagcdn.com/w320/ae.png",
      "image": "https://images.unsplash.com/photo-1504272017915-32d1bd315a59",
      "desc": "Protects coral reefs, seagrass, and mangrove forests along the Gulf."
    },
    {
      "name": "Saudi Arabia",
      "flag": "https://flagcdn.com/w320/sa.png",
      "image": "https://images.unsplash.com/photo-1518684079-3c830dcef090",
      "desc": "Home to Red Sea coral reefs with high heat tolerance."
    },

    // 🌍 Europe
    {
      "name": "United Kingdom",
      "flag": "https://flagcdn.com/w320/gb.png",
      "image": "https://plus.unsplash.com/premium_photo-1661962726504-fa8f464a1bb8",
      "desc": "An island nation with strong ocean research and conservation efforts."
    },
    {
      "name": "Greece",
      "flag": "https://flagcdn.com/w320/gr.png",
      "image": "https://images.pexels.com/photos/1010640/pexels-photo-1010640.jpeg",
      "desc": "Surrounded by the Mediterranean Sea with ancient maritime heritage."
    },
    {
      "name": "Italy",
      "flag": "https://flagcdn.com/w320/it.png",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhv_kuK614syoOc6eBp9JV8R3ZLpq3ov79Lg&s",
      "desc": "Coasts touching three seas with beautiful marine ecosystems."
    },
    {
      "name": "Spain",
      "flag": "https://flagcdn.com/w320/es.png",
      "image": "https://www.cuddlynest.com/blog/wp-content/uploads/2021/01/shutterstock_662563231-1.jpg",
      "desc": "Bordered by both the Mediterranean Sea and the Atlantic Ocean."
    },
    {
      "name": "Croatia",
      "flag": "https://flagcdn.com/w320/hr.png",
      "image": "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
      "desc": "Adriatic Sea coastline with 1,000+ islands and clear blue waters."
    },
    {
      "name": "Ireland",
      "flag": "https://flagcdn.com/w320/ie.png",
      "image": "https://assets.cntraveller.in/photos/66e67ae07488d7df93854de3/16:9/w_1024%2Cc_limit/GettyImages-1962772436.jpg",
      "desc": "An island nation with cold-water coral reefs and marine sanctuaries."
    },
    {
      "name": "Sweden",
      "flag": "https://flagcdn.com/w320/se.png",
      "image": "https://images.unsplash.com/photo-1510798831971-661eb04b3739",
      "desc": "Baltic Sea coastline known for protected marine areas."
    },
    {
      "name": "Denmark",
      "flag": "https://flagcdn.com/w320/dk.png",
      "image": "https://explore-live.s3.eu-west-1.amazonaws.com/medialibraries/explore/explore-media/destinations/europe/denmark/denmark-main.jpg?ext=.jpg&width=1920&format=webp&quality=80&v=201704280926%201920w",
      "desc": "Bordered by Baltic & North Sea with strong marine policies."
    },

    // 🌍 Africa
    {
      "name": "South Africa",
      "flag": "https://flagcdn.com/w320/za.png",
      "image": "https://afar.brightspotcdn.com/dims4/default/f3f7b7d/2147483647/strip/false/crop/1440x764+0+0/resize/1440x764!/quality/90/?url=https%3A%2F%2Fk3-prod-afar-media.s3.us-west-2.amazonaws.com%2Fbrightspot%2F86%2Fba%2F808972c94fb289b1cc2819f4defb%2Fsouthafrica-marcreation-unsplash.jpg",
      "desc": "Where the Indian & Atlantic Oceans meet, home to great marine wildlife."
    },
    {
      "name": "Kenya",
      "flag": "https://flagcdn.com/w320/ke.png",
      "image": "https://f7c6x3u6.delivery.rocketcdn.me/wp-content/uploads/2022/07/Hells-Gate-Kenya-Nataliya-Ulyanikhina-shutterstock_1112432165-1024x684.jpg",
      "desc": "Indian Ocean coastline with coral reefs & mangroves."
    },
    {
      "name": "Tanzania",
      "flag": "https://flagcdn.com/w320/tz.png",
      "image": "https://www.outlooktravelmag.com/media/tanzania-1-1582275012.profileImage.2x-1536x884.webp",
      "desc": "Zanzibar’s turquoise waters and coral gardens are world famous."
    },
    {
      "name": "Mozambique",
      "flag": "https://flagcdn.com/w320/mz.png",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUvC9L9PI3-Pdoeua-548HKzZyraoFu-e5oQ&s",
      "desc": "Whale sharks, coral reefs, and pristine Indian Ocean coastline."
    },
    {
      "name": "Madagascar",
      "flag": "https://flagcdn.com/w320/mg.png",
      "image": "https://www.wildvoyager.com/wp-content/uploads/2022/05/islands-1.jpg",
      "desc": "Unique coral reefs and endemic marine species surround the island."
    },

    // 🌎 North & South America
    {
      "name": "United States",
      "flag": "https://flagcdn.com/w320/us.png",
      "image": "https://static5.depositphotos.com/1030296/395/i/450/depositphotos_3958211-stock-photo-new-york.jpg",
      "desc": "Coasts on the Atlantic & Pacific with vast marine biodiversity."
    },
    {
      "name": "Canada",
      "flag": "https://flagcdn.com/w320/ca.png",
      "image": "https://www.gokitetours.com/wp-content/uploads/2024/04/The-amazing-places-to-visit-in-Canada-for-a-summer-vacation.webp",
      "desc": "Bordered by three oceans with rich cold-water ecosystems."
    },
    {
      "name": "Mexico",
      "flag": "https://flagcdn.com/w320/mx.png",
      "image": "https://www.gokitetours.com/wp-content/uploads/2024/04/The-amazing-places-to-visit-in-Canada-for-a-summer-vacation.webp",
      "desc": "Caribbean reefs, Pacific beaches & diverse marine habitats."
    },
    {
      "name": "Brazil",
      "flag": "https://flagcdn.com/w320/br.png",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLLQ7Z7TyTxZ-dB_D-eJXYb8Ja8FiswSxiBg&s",
      "desc": "Atlantic coastline featuring mangroves, reefs & warm waters."
    },
    {
      "name": "Colombia",
      "flag": "https://flagcdn.com/w320/co.png",
      "image": "https://images.unsplash.com/photo-1501594907352-04cda38ebc29",
      "desc": "Coastlines on both Pacific & Caribbean rich in marine biodiversity."
    },
    {
      "name": "Peru",
      "flag": "https://flagcdn.com/w320/pe.png",
      "image": "https://images.squarespace-cdn.com/content/v1/5acd5b31f407b409c638be6a/1570805136191-EAMNV29U8XRBG4YQ9UEE/machu-picchu-golden-hour.jpg",
      "desc": "Cold Pacific waters home to penguins and sea lions."
    },
    {
      "name": "Ecuador",
      "flag": "https://flagcdn.com/w320/ec.png",
      "image": "https://www.andbeyond.com/wp-content/uploads/sites/5/Virgin-of-Quito-Ecuador.jpg",
      "desc": "Home to the Galápagos Islands—marine life hotspot."
    },
    {
      "name": "Panama",
      "flag": "https://flagcdn.com/w320/pa.png",
      "image": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgpSjL16Vm0N0Odkh0Xmm5Jhw-kJyujarrcA&s",
      "desc": "Two-ocean country with reefs, mangroves, and abundant marine life."
    },
    {
      "name": "Chile",
      "flag": "https://flagcdn.com/w320/cl.png",
      "image": "https://www.grayline.com/wp-content/uploads/2025/01/Gray-Line-Chile-5-scaled.jpg",
      "desc": "Long Pacific coastline with penguins, whales, and cold-water reefs."
    },
    {
      "name": "Argentina",
      "flag": "https://flagcdn.com/w320/ar.png",
      "image": "https://images.squarespace-cdn.com/content/v1/58cf00b21b631bf52d2edc0e/1495020222866-T0IQ6FX4NB3OVIZMH3DS/buenos-aires-obelisk.jpg?format=2500w",
      "desc": "Atlantic coastline rich in seals, whales, and marine species."
    },

    // 🌊 Pacific Islands
    {
      "name": "Fiji",
      "flag": "https://flagcdn.com/w320/fj.png",
      "image": "https://cf.bstatic.com/xdata/images/hotel/max1024x768/475190955.jpg?k=969887d33a46868be809586de08b5227d8000c34b3ed734737030a4f9bca9685&o=",
      "desc": "A Pacific paradise with coral reefs, lagoons & rich marine life."
    },
    {
      "name": "Papua New Guinea",
      "flag": "https://flagcdn.com/w320/pg.png",
      "image": "https://images.unsplash.com/photo-1549880338-65ddcdfd017b",
      "desc": "Part of the Coral Triangle, home to incredible coral biodiversity."
    },
    {
      "name": "Samoa",
      "flag": "https://flagcdn.com/w320/ws.png",
      "image": "https://www.virginaustralia.com/content/dam/vaa/images/destinations/samoa/things-to-do/vaa-1440x620-samoa-things-to-do.jpg/_jcr_content/renditions/vaacore.web.720.0.jpg",
      "desc": "Coral reefs, lagoons, and strong traditional ocean conservation."
    },
    {
      "name": "Tonga",
      "flag": "https://flagcdn.com/w320/to.png",
      "image": "https://a.travel-assets.com/findyours-php/viewfinder/images/res70/213000/213688-Tonga.jpg",
      "desc": "Pacific islands known for whale migrations and clear waters."
    },

    {
      "name": "Norway",
      "flag": "https://flagcdn.com/w320/no.png",
      "image": "https://i.natgeofe.com/k/679e983c-4461-4398-bb6d-9b508fe3e4de/norway-northern-lights.jpg",
      "desc": "Known for fjords, Arctic ecosystems & rich marine life."
    },

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Explore More",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFF0077B6),
        centerTitle: true,
      ),

      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            baseColor: Colors.white,
            spawnMinSpeed: 5.0,
            spawnMaxSpeed: 15.0,
            spawnOpacity: 0.3,
            particleCount: 30,
            minOpacity: 0.2,
            maxOpacity: 0.7,
            spawnMaxRadius: 10.0,
            spawnMinRadius: 4.0,
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
                Color(0xFF90E0EF),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [

                const Text(
                  "Marine Biodiversity & Ocean Facts",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Marine biodiversity includes all living organisms in the ocean from tiny plankton to massive whales. Oceans regulate climate, produce oxygen and support human life.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.justify,
                ),

                const SizedBox(height: 25),

                // 🌐 Ocean Coverage
                _infoCard(
                  "🌐 Percentage of Ocean Coverage by Area",
                  "🌊 Pacific Ocean – 46%\n"
                      "🌊 Atlantic Ocean – 23%\n"
                      "🌊 Indian Ocean – 20%\n"
                      "🌊 Southern Ocean – 6%\n"
                      "🌊 Arctic Ocean – 5%\n\n"
                      "➡ Oceans cover 71% of Earth's surface and hold 97% of its water.",
                ),

                const SizedBox(height: 30),

                // 💧 How to Save Oceans
                _infoCard(
                  "💧 How Can We Save Marine Biodiversity?",
                  "🌱 Reduce plastic pollution\n"
                      "🐠 Support sustainable fishing\n"
                      "🌊 Protect coral reefs\n"
                      "♻ Recycle & conserve water\n"
                      "🚯 Join beach cleanups\n"
                      "📢 Spread awareness",
                ),

                const SizedBox(height: 40),

                const Text(
                  "Countries Surrounded by Oceans 🌏",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // 🌍 COUNTRIES LIST
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemCount: oceanCountries.length,
                  itemBuilder: (context, index) {
                    final c = oceanCountries[index];
                    return _countryCard(c);
                  },
                ),

                const SizedBox(height: 40),

                const Text(
                  "“The ocean stirs the heart, inspires the imagination, and brings eternal joy to the soul.”",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 60),

              ],
            ),
          ),
        ),
      ),
    );
  }

  // INFO CARD
  Widget _infoCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.7,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  // COUNTRY CARD
  Widget _countryCard(Map<String, String> data) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CountryInfoPage(
              name: data["name"]!,
              flag: data["flag"]!,
              image: data["image"]!,
              desc: data["desc"]!,
            ),
          ),
        );
      },

      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black12,
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),

          child: Stack(
            fit: StackFit.expand,
            children: [

              // 🌄 IMAGE WITH LOADER
              Image.network(
                data["image"]!,
                fit: BoxFit.cover,

                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  );
                },

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.black38,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),

              // 🌫 DARK OVERLAY
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.6),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // 📍 TEXT CONTENT
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(data["flag"]!),
                      radius: 28,
                    ),
                    const SizedBox(height: 10),

                    Text(
                      data["name"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      data["desc"]!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 17,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
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
}
