import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class MarineQuizPage extends StatefulWidget {
  const MarineQuizPage({super.key});

  @override
  State<MarineQuizPage> createState() => _MarineQuizPageState();
}

class _MarineQuizPageState extends State<MarineQuizPage> {
  int currentIndex = 0;
  int score = 0;
  bool answered = false;
  String? selectedAnswer;

  final List<Map<String, dynamic>> quiz = [
    {
      "question": "Which is the largest animal on Earth?",
      "options": ["Shark", "Blue Whale", "Elephant", "Sperm Whale"],
      "answer": "Blue Whale",
      "explanation":
          "The blue whale is the largest animal ever known to have lived on Earth.",
    },
    {
      "question": "What do corals mainly suffer from due to climate change?",
      "options": ["Bleaching", "Explosions", "Overfeeding", "Extra Growth"],
      "answer": "Bleaching",
      "explanation":
          "Rising sea temperatures cause corals to expel algae, leading to bleaching.",
    },
    {
      "question": "Which of these is NOT a source of ocean pollution?",
      "options": ["Plastic", "Oil Spills", "Coral Reefs", "Chemicals"],
      "answer": "Coral Reefs",
      "explanation":
          "Coral reefs are natural ecosystems and do not pollute oceans.",
    },
    {
      "question": "Sea turtles often mistake which object as food?",
      "options": ["Shells", "Jellyfish", "Plastic bags", "Crabs"],
      "answer": "Plastic bags",
      "explanation":
          "Plastic bags resemble jellyfish, causing turtles to ingest them.",
    },
    {
      "question": "What is the biggest threat to marine life today?",
      "options": ["Plastic", "Coral Reefs", "Clean Water", "Sunlight"],
      "answer": "Plastic",
      "explanation":
          "Plastic pollution causes ingestion, entanglement, and habitat damage.",
    },
  ];

  double rs(BuildContext context, double mobile, double tablet) =>
      MediaQuery.of(context).size.width > 600 ? tablet : mobile;

  void checkAnswer(String selected) {
    if (answered) return;

    setState(() {
      answered = true;
      selectedAnswer = selected;
      if (selected == quiz[currentIndex]["answer"]) score++;
    });
  }

  void goNext() {
    if (currentIndex < quiz.length - 1) {
      setState(() {
        currentIndex++;
        answered = false;
        selectedAnswer = null;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultPage(score: score, total: quiz.length),
        ),
      );
    }
  }

  void goPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        answered = false;
        selectedAnswer = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = quiz[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Marine Quiz",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0077B6),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(rs(context, 16, 24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${currentIndex + 1}/${quiz.length}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: rs(context, 16, 22),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              q["question"],
              style: TextStyle(
                color: Colors.white,
                fontSize: rs(context, 20, 26),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            ...q["options"].map<Widget>((opt) {
              final isCorrect = opt == q["answer"];
              final isSelected = opt == selectedAnswer;

              Color bg = Colors.white.withOpacity(0.1);
              if (answered && isCorrect) bg = Colors.green.withOpacity(0.7);
              if (answered && isSelected && !isCorrect) {
                bg = Colors.red.withOpacity(0.7);
              }

              return GestureDetector(
                onTap: () => checkAnswer(opt),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: EdgeInsets.all(rs(context, 14, 20)),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24, width: 2),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: rs(context, 16, 20),
                    ),
                  ),
                ),
              );
            }).toList(),

            if (answered) ...[
              const SizedBox(height: 12),
              Text(
                "🧠 Explanation",
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(q["explanation"], style: TextStyle(color: Colors.white70)),
            ],

            const SizedBox(height: 30),

            // ⬅➡ NAVIGATION BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: currentIndex == 0 ? null : goPrevious,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Previous"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: answered ? goNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      currentIndex == quiz.length - 1 ? "Finish" : "Next",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= RESULT PAGE ================= */
class QuizResultPage extends StatefulWidget {
  final int score;
  final int total;

  const QuizResultPage({super.key, required this.score, required this.total});

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  late ConfettiController _confettiController;

  bool get isPassed => (widget.score / widget.total) >= 0.5;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    // 🎉 Play confetti only if score > 50%
    if (isPassed) {
      Future.delayed(const Duration(milliseconds: 400), () {
        _confettiController.play();
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String getBadgeTitle() {
    if (widget.score == widget.total) return "Ocean Guardian 🌊";
    if (widget.score >= widget.total - 1) return "Sea Explorer 🐬";
    if (widget.score >= 2) return "Ocean Learner 🌱";
    return "Beginner Explorer 📘";
  }

  @override
  Widget build(BuildContext context) {
    final percent = ((widget.score / widget.total) * 100).round();
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFF001F3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0077B6),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          "Quiz Result",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 🎊 CONFETTI
          if (isPassed)
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                emissionFrequency: 0.05,
                numberOfParticles: 25,
                gravity: 0.2,
                colors: const [
                  Colors.green,
                  Colors.cyan,
                  Colors.blue,
                  Colors.yellow,
                  Colors.white,
                ],
              ),
            ),

          // MAIN CONTENT
          Center(
            child: SingleChildScrollView(
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
                      "${widget.score} / ${widget.total}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 48 : 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "$percent%",
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: isTablet ? 22 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🎉 CONGRATS TEXT (already exists)
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
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
                            isPassed ? "🎉 Congratulations! 🎉" : "Good Try 👍",
                            style: TextStyle(
                              fontSize: isTablet ? 28 : 22,
                              fontWeight: FontWeight.bold,
                              color:
                                  isPassed
                                      ? Colors.greenAccent
                                      : Colors.orangeAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "You earned the badge:",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isTablet ? 18 : 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            getBadgeTitle(),
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: isTablet ? 22 : 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 40 : 24,
                          vertical: isTablet ? 18 : 12,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MarineQuizPage(),
                          ),
                        );
                      },
                      child: const Text("Play Again"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
