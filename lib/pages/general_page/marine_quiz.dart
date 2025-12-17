import 'package:flutter/material.dart';
import 'package:marine_trust/utils/certificate_generator.dart';
import 'package:printing/printing.dart';

class MarineQuizPage extends StatefulWidget {
  const MarineQuizPage({super.key});

  @override
  State<MarineQuizPage> createState() => _MarineQuizPageState();
}

class _MarineQuizPageState extends State<MarineQuizPage> {
  int currentIndex = 0;
  int score = 0;
  bool answered = false;

  final List<Map<String, dynamic>> quiz = [
    {
      "question": "Which is the largest animal on Earth?",
      "options": ["Shark", "Blue Whale", "Elephant", "Sperm Whale"],
      "answer": "Blue Whale",
    },
    {
      "question": "What do corals mainly suffer from due to climate change?",
      "options": ["Bleaching", "Explosions", "Overfeeding", "Extra Growth"],
      "answer": "Bleaching",
    },
    {
      "question": "Which of these is NOT a source of ocean pollution?",
      "options": ["Plastic", "Oil Spills", "Coral Reefs", "Chemicals"],
      "answer": "Coral Reefs",
    },
    {
      "question": "Sea turtles often mistake which object as food?",
      "options": ["Shells", "Jellyfish", "Plastic bags", "Crabs"],
      "answer": "Plastic bags",
    },
    {
      "question": "What is the biggest threat to marine life today?",
      "options": ["Plastic", "Coral Reefs", "Clean Water", "Sunlight"],
      "answer": "Plastic",
    },
  ];

  void checkAnswer(String selected) {
    setState(() => answered = true);

    if (selected == quiz[currentIndex]["answer"]) {
      score++;
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (currentIndex < quiz.length - 1) {
        setState(() {
          currentIndex++;
          answered = false;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => QuizResultPage(score: score, total: quiz.length),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final q = quiz[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("Marine Quiz", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0077B6),
      ),
      body: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentIndex + 1}/${quiz.length}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: isTablet ? 22 : 16,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              q["question"],
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 26 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ...q["options"].map<Widget>((opt) {
              bool isCorrect = opt == q["answer"];
              bool showColor = answered;

              return GestureDetector(
                onTap: answered ? null : () => checkAnswer(opt),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: EdgeInsets.all(isTablet ? 20 : 14),
                  decoration: BoxDecoration(
                    color:
                        showColor
                            ? (isCorrect ? Colors.green : Colors.red)
                                .withOpacity(0.7)
                            : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          showColor
                              ? (isCorrect ? Colors.green : Colors.red)
                              : Colors.white24,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 20 : 16,
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

/* ================= RESULT PAGE ================= */

class QuizResultPage extends StatelessWidget {
  final int score;
  final int total;

  const QuizResultPage({super.key, required this.score, required this.total});

  String getBadgeTitle() {
    if (score == total) return "Ocean Guardian 🌊";
    if (score == total - 1) return "Sea Explorer 🐬";
    if (score == total - 2) return "Reef Protector 🐠";
    if (score >= 2) return "Ocean Learner 🌱";
    return "Beginner Explorer 📘";
  }

  String getMessage() {
    if (score == total) return "Amazing 🐋";
    if (score == total - 1) return "Excellent 🐢";
    if (score == total - 2) return "Good Job 👍";
    if (score >= 2) return "Nice Try 💪";
    return "Keep Learning 🌍";
  }

  int getStars() => ((score / total) * 5).round();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final percentage = ((score / total) * 100).round();
    final stars = getStars();

    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text("Quiz Result", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0077B6),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 32 : 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Your Score",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isTablet ? 26 : 20,
                ),
              ),
              const SizedBox(height: 10),

              Text(
                "$score / $total",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 48 : 36,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // ⭐ STARS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < stars ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: isTablet ? 32 : 24,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // 📊 PERCENTAGE
              Text(
                "$percentage%",
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: isTablet ? 22 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // 🏅 BADGE
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text(
                  getBadgeTitle(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 20 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // 🎉 MESSAGE
              Text(
                getMessage(),
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isTablet ? 18 : 14,
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 40 : 24,
                    vertical: isTablet ? 18 : 12,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MarineQuizPage()),
                  );
                },
                child: Text(
                  "Play Again",
                  style: TextStyle(
                    fontSize: isTablet ? 22 : 16,
                    color: Colors.black,
                  ),
                ),
              ),
          const SizedBox(height: 20),

          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 900),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                Text(
                  "🎉 Congratulations! 🎉",
                  style: TextStyle(
                    fontSize: isTablet ? 28 : 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                Text(
                  "You’ve successfully completed the Marine Quiz\nand earned the badge:",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isTablet ? 18 : 14,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 10),

                Text(
                  getBadgeTitle(),
                  style: TextStyle(
                    fontSize: isTablet ? 22 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
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
