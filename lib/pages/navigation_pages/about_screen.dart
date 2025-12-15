import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  VideoPlayerController? _controller;
  double playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset(
      "assests/videos/marine_video.mp4",
    )..initialize().then((_) {
      setState(() {});
    });

    // 🔥 FIXED: Video UI updates while playing
    _controller!.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  // FORMAT DURATION
  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, "0");
    return "${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}";
  }

  // ------------------------  VIDEO CONTROLS  ------------------------
  Widget _videoControls() {
    bool isPlaying = _controller!.value.isPlaying;
    bool isMuted = _controller!.value.volume == 0;
    Duration position = _controller!.value.position;
    Duration total = _controller!.value.duration;

    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.black.withOpacity(0.35),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---- TOP ROW: Play / Mute / Fullscreen ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Play / Pause
              IconButton(
                icon: Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: Colors.white,
                  size: 35,
                ),
                onPressed: () {
                  setState(() {
                    isPlaying ? _controller!.pause() : _controller!.play();
                  });
                },
              ),

              // Volume
              IconButton(
                icon: Icon(
                  isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  setState(() {
                    _controller!.setVolume(isMuted ? 1.0 : 0.0);
                  });
                },
              ),

              // Playback Speed Menu
              PopupMenuButton<double>(
                onSelected: (value) {
                  setState(() {
                    playbackSpeed = value;
                    _controller!.setPlaybackSpeed(value);
                  });
                },
                color: Colors.black87,
                itemBuilder: (_) => [
                  const PopupMenuItem(
                      value: 0.5, child: Text("0.5x", style: TextStyle(color: Colors.white))),
                  const PopupMenuItem(
                      value: 1.0, child: Text("1.0x", style: TextStyle(color: Colors.white))),
                  const PopupMenuItem(
                      value: 1.5, child: Text("1.5x", style: TextStyle(color: Colors.white))),
                  const PopupMenuItem(
                      value: 2.0, child: Text("2.0x", style: TextStyle(color: Colors.white))),
                ],
                child: const Icon(Icons.speed, color: Colors.white, size: 26),
              ),

              // Fullscreen
              IconButton(
                icon: const Icon(Icons.fullscreen, color: Colors.white, size: 28),
                onPressed: () => _openFullscreen(),
              ),
            ],
          ),

          // ---- Seekbar ----
          VideoProgressIndicator(
            _controller!,
            allowScrubbing: true,
            colors: const VideoProgressColors(
              playedColor: Colors.lightBlueAccent,
              backgroundColor: Colors.white24,
              bufferedColor: Colors.white54,
            ),
          ),

          // ---- Duration Row ----
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _format(position),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              Text(
                _format(total),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------ FULLSCREEN MODE ------------------------
  void _openFullscreen() async {
    // Allow portrait + landscape
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Hide system UI
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                  _videoControls(),
                ],
              ),
            ),
          ),
        ),
      ),
    ).then((_) async {
      // Restore settings
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    });
  }

  // ------------------------ MAIN UI ------------------------
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF006994),
        automaticallyImplyLeading: false,
        title: const Text(
          "About Us",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 48,
          vertical: 24,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _visionMessage(),
                const SizedBox(height: 30),

                _ourStorySection(),
                const SizedBox(height: 30),

                // ⭐ VIDEO BETWEEN STORY AND FACTS
                _videoSection(),
                const SizedBox(height: 30),

                _oceanFactsNewsSection(),
                const SizedBox(height: 30),

                _whoWeAreSection(),
                const SizedBox(height: 30),

                _missionImageSection(),
                const SizedBox(height: 20),

                _missionSection(),
                const SizedBox(height: 30),

                _ourValuesSection(),   // ⭐ ADD THIS LINE
                const SizedBox(height: 30),

                _visionImageSection(),
                const SizedBox(height: 20),

                _visionSection(),
                const SizedBox(height: 30),

                // ⭐ WHAT WE DO (ORIGINAL — UNCHANGED)
                _whatWeDoSection(),
                const SizedBox(height: 30),

                _joinSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------ VIDEO SECTION ------------------------
  Widget _videoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "What Our Manager Done While in Service.",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006994),
          ),
        ),
        const SizedBox(height: 12),

        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AspectRatio(
                aspectRatio: _controller!.value.isInitialized
                    ? _controller!.value.aspectRatio
                    : 16 / 9,
                child: _controller!.value.isInitialized
                    ? VideoPlayer(_controller!)
                    : const Center(child: CircularProgressIndicator()),
              ),
              if (_controller!.value.isInitialized) _videoControls(),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------ TEXT SECTIONS ------------------------

  Widget _ourValuesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Our Values",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF006994),
          ),
        ),
        const SizedBox(height: 15),

        _valueCard(
          icon: Icons.eco,               // FaLeaf alternative
          title: "Sustainability",
          desc:
          "Balancing human needs with healthy ecosystems — sustainable fisheries, responsible development and long-term conservation.",
          color: Colors.green,
        ),

        const SizedBox(height: 12),

        _valueCard(
          icon: Icons.science,          // FaMicroscope alternative
          title: "Science-Based",
          desc:
          "We use research, monitoring and data to guide restoration projects and policy decisions for measurable impact.",
          color: Colors.lightBlue,
        ),

        const SizedBox(height: 12),

        _valueCard(
          icon: Icons.menu_book,       // FaBookOpen alternative
          title: "Education",
          desc:
          "Workshops, school programs and campaigns to build ocean literacy and empower local stewards of the sea.",
          color: Colors.orange,
        ),

        const SizedBox(height: 12),

        _valueCard(
          icon: Icons.handshake,       // FaHandshake alternative (Material 3)
          title: "Collaboration",
          desc:
          "Partnering with governments, NGOs, communities and scientists to scale conservation across regions.",
          color: Colors.amber,
        ),
      ],
    );
  }

  Widget _visionMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF006994),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 6),
        ],
      ),
      child: const Text(
        "“Our oceans are the lungs of our planet. Let’s unite to protect marine life for today and for generations to come.”",
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontStyle: FontStyle.italic,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _ourStorySection() {
    return _buildSection(
      title: "Our Story",
      content:
      "We have witnessed many marine species collapse due to pollution from plastics, oil spills, chemicals and microplastics destroying food chains.\n\n"
          "Overfishing and destructive methods like trawling and ghost nets wipe out species faster than they can recover.\n\n"
          "Climate change fuels coral bleaching, ocean acidification and melting ice, disrupting entire ecosystems.\n\n"
          "Habitat destruction from coastal development, mining, anchoring and dredging destroys reefs, mangroves and seagrass beds.\n\n"
          "Invasive species, oil and gas exploration, ship noise and vessel strikes further destabilize marine life.\n\n"
          "Tourism, agricultural runoff and extreme climate events create dead zones and intensify ocean habitat loss.",
    );
  }

  Widget _oceanFactsNewsSection() {
    return _buildSection(
      title: "Facts or News About Oceans",
      content:
      "About 71% of the Earth is covered with water, while land occupies only 29%. However, human activities on this small portion of land significantly impact the oceans.\n\n"
          "Millions of sharks are killed each year for their fins, especially in regions where shark fin soup is considered a delicacy. Despite protections, illegal finning continues worldwide.\n\n"
          "Over recent decades, carbon dioxide levels have risen dramatically. Oceans absorb much of this CO₂, causing ocean acidification a chemical imbalance that threatens marine species and entire ecosystems.\n\n"
          "Dead zones are ocean areas with extremely low oxygen levels where marine life cannot survive. One major dead zone forms annually near the Gulf of Mexico due to agricultural runoff.\n\n"
          "The Great Pacific Garbage Patch is a massive floating island of plastic waste estimated to be nearly twice the size of Texas.\n\n"
          "In the 1950s, Minamata, Japan suffered severe mercury poisoning from industrial dumping. Recent studies show that mercury levels in oceans continue to rise globally.",
    );
  }

  Widget _whoWeAreSection() {
    return _buildSection(
      title: "Who We Are",
      content:
      "The Marine Biodiversity Conservation Trust (MBCT) is a non-profit organization focused on protecting, restoring and sustaining marine ecosystems.\n\n"
          "We unite passionate individuals students, scientists, environmentalists and volunteers to work toward a sustainable blue planet.",
    );
  }

  Widget _missionImageSection() => _imageBanner("assests/images/mission.png");

  Widget _missionSection() {
    return _buildSection(
      title: "Our Mission",
      content:
      "To create widespread awareness about the importance of conserving marine biodiversity by educating, empowering and engaging youth and the public.",
    );
  }

  Widget _visionImageSection() => _imageBanner("assests/images/vision.png");

  Widget _visionSection() {
    return _buildSection(
      title: "Our Vision",
      content:
      "A clean, vibrant, and life-rich ocean protected by an aware and active generation that values marine biodiversity as the lifeline of our planet.",
    );
  }

  Widget _whatWeDoSection() {
    return _buildSection(
      title: "What We Do",
      content:
      "Conduct awareness programs in schools and communities.\n\n"
          "Organize beach cleanups and mangrove restoration drives.\n\n"
          "Provide eco-education workshops.\n\n"
          "Build digital platforms connecting global volunteers.\n\n"
          "Partner with government bodies, NGOs and research institutions.",
    );
  }

  Widget _joinSection() {
    return _buildSection(
      title: "Join the Movement",
      content:
      "We welcome everyone students, educators and citizens to join as volunteers.\n\n"
          "Together, we can protect marine life, promote sustainable living and inspire future generations.",
    );
  }

  // ------------------------ REUSABLE SECTION ------------------------
  Widget _imageBanner(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        path,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF006994),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: const TextStyle(
              color: Colors.black87,
              height: 1.6,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
  Widget _valueCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
