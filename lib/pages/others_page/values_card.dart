import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


const Color darkBlueTitle = Color(0xFF023E8A);
const Color cardBgYellow = Color(0xFFFACC15);
const Color textEmerald = Color(0xFF10B981);
const Color textSky = Color(0xFF0EA5E9);
const Color textOrangeLight = Color(0xFFFB923C);
const Color textOrangeDark = Color(0xFFEA580C);
const Color textGray = Color(0xFF4B5563);
const Color bgGray = Color(0xFFF9FAFB);

// --- 1. Data Model ---
class ValueCardData {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color accentColor;
  final Color titleColor;
  final Color bgColor;

  ValueCardData({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.titleColor,
    required this.bgColor,
  });
}

// --- 2. Data Definition ---
final List<ValueCardData> values = [
  ValueCardData(
    id: "sustainability",
    title: "Sustainability",
    description: "Our holistic approach ensures sustainable fisheries and responsible coastal development go hand-in-hand with long-term marine conservation. We balance human needs with the necessity of healthy ecosystems.",
    icon: FontAwesomeIcons.leaf,
    accentColor: textEmerald,
    titleColor: textOrangeDark,
    bgColor: cardBgYellow,
  ),
  ValueCardData(
    id: "science",
    title: "Science-Based",
    description: "We don't guess, we use science. We leverage cutting-edge research, reliable monitoring, and robust data to guide all restoration projects and policy decisions for measurable impact.",
    icon: FontAwesomeIcons.microscope,
    accentColor: textSky,
    titleColor: textOrangeDark,
    bgColor: cardBgYellow,
  ),
  ValueCardData(
    id: "education",
    title: "Education",
    description: "We're passionate about ocean literacy! We host hands-on workshops, creative school programs, and targeted campaigns designed to empower the next generation of local marine stewards.",
    icon: FontAwesomeIcons.bookOpen,
    accentColor: textOrangeLight,
    titleColor: textOrangeDark,
    bgColor: cardBgYellow,
  ),
  ValueCardData(
    id: "collaboration",
    title: "Collaboration",
    description: "Conservation is a team sport. We forge powerful partnerships with governments, NGOs, local communities, and leading scientists to effectively scale conservation solutions across all regions.",
    icon: FontAwesomeIcons.handshake,
    accentColor: darkBlueTitle,
    titleColor: textOrangeDark,
    bgColor: cardBgYellow,
  ),
];

// --- 3. Card Widget (Single Card) ---
class ValueCard extends StatelessWidget {
  final ValueCardData data;
  const ValueCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: data.bgColor,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 2.0,
      child: InkWell(
        onTap: () => debugPrint('Tapped on ${data.title}'),
        borderRadius: BorderRadius.circular(12.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48.0,
                height: 48.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.0),
                ),
                alignment: Alignment.center,
                child: FaIcon(
                  data.icon,
                  size: 24.0,
                  color: data.accentColor,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: data.titleColor,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      data.description,
                      style: const TextStyle(
                        fontSize: 17.0,
                        color: textGray,
                        height: 1.5,
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
}

// --- 4. Main Responsive Component (ValuesCardsWidget) ---
// --- 4. Main Component (ValuesCardsWidget) ---
class ValuesCardsWidget extends StatelessWidget {
  const ValuesCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgGray,
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Our Values",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: darkBlueTitle,
                  ),
                ),
                const SizedBox(height: 32.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: values.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: ValueCard(data: values[index]),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}