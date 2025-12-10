import 'package:colearn/consts/consts.dart';
import 'package:colearn/services/api_service.dart'; // REQUIRED IMPORT
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> courseData;

  const CourseDetailsScreen({super.key, required this.courseData});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  late List<dynamic> modules;
  late String title;
  late String description;

  // Progress State
  double progressValue = 0.0;
  bool isCourseCompleted = false;

  @override
  void initState() {
    super.initState();
    modules = widget.courseData['modules'] ?? [];
    title = widget.courseData['title'] ?? "Cours Généré";
    description = widget.courseData['description'] ?? "Aucune description disponible.";

    // PROGRESS FIX: Check if course is already completed from DB
    // Note: The backend 'completed' field must be mapped to 'completed' in JSON
    isCourseCompleted = widget.courseData['completed'] ?? false;

    if (isCourseCompleted) {
       progressValue = 1.0;
    } else {
       _calculateProgress();
    }
  }

  void _calculateProgress() {
    if (modules.isEmpty) return;
    
    // If course is already marked completed, don't recalculate
    if (isCourseCompleted) {
        progressValue = 1.0;
        return;
    }

    // Count how many are unlocked
    int unlockedCount = modules.where((m) => m['locked'] == false).length;

    // Better Logic: Calculate based on previous step
    int completedSteps = 0;
    for (int i = 0; i < modules.length; i++) {
      if (i + 1 < modules.length && modules[i+1]['locked'] == false) {
        completedSteps++;
      }
    }

    setState(() {
      progressValue = completedSteps / modules.length;
    });
  }

  // --- LOGIC: FINISH LESSON & UPDATE PROGRESS & SAVE TO DB ---
  void _completeLesson(int index) async {
    // 1. Identify Next Module to Unlock
    if (index + 1 < modules.length) {
      var nextModule = modules[index + 1];
      int nextModuleId = nextModule['id'];

      // 2. CALL API TO SAVE "UNLOCKED" STATUS TO BACKEND
      await ApiService.unlockModule(nextModuleId);

      // 3. Update UI Locally
      setState(() {
        modules[index + 1]['locked'] = false;
        progressValue = (index + 1) / modules.length;
      });
    } else {
      // Last module finished - MARK COURSE AS COMPLETED
      int courseId = widget.courseData['id'];
      await ApiService.completeCourse(courseId);

      setState(() {
        progressValue = 1.0;
        isCourseCompleted = true;
      });
      _showCompletionCelebration();
    }
  }

  void _showCompletionCelebration() {
    Get.defaultDialog(
      title: "Félicitations ! 🎉",
      titleStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      content: Column(
        children: [
          const Icon(Icons.emoji_events, color: Colors.amber, size: 80),
          const SizedBox(height: 10),
          const Text(
            "Vous avez terminé ce cours !",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(backgroundColor: lightBlue),
            child: const Text("Réclamer mon Certificat", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER IMAGE ---
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  image: NetworkImage("https://images.unsplash.com/photo-1501504905252-473c47e087f8?q=80&w=1000&auto=format&fit=crop"),
                  fit: BoxFit.cover,
                  opacity: 0.4,
                ),
              ),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: isCourseCompleted
                    ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.greenAccent, size: 50),
                    SizedBox(height: 10),
                    Text("COURS TERMINÉ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22))
                  ],
                )
                    : Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 10, color: Colors.black, offset: Offset(2, 2))]
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --- PROGRESS BAR ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Progression", style: TextStyle(color: Colors.grey[400])),
                Text("${(progressValue * 100).toInt()}%", style: const TextStyle(color: lightBlue, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey[800],
              color: isCourseCompleted ? Colors.green : lightBlue,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),

            const SizedBox(height: 30),

            Text(description, style: TextStyle(color: Colors.grey[400], fontSize: 15, height: 1.4)),
            const SizedBox(height: 20),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),

            // --- MODULE LIST ---
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: modules.length,
              itemBuilder: (context, index) {
                final module = modules[index];
                bool isLocked = module['locked'] ?? false;

                // Determine if this specific module is "Done"
                // It is done if the NEXT one is unlocked, or if course is complete
                bool isDone = isCourseCompleted || (index + 1 < modules.length && modules[index+1]['locked'] == false);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isLocked ? Colors.grey[900] : const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isDone
                            ? Colors.green.withOpacity(0.5)
                            : (isLocked ? Colors.transparent : lightBlue.withOpacity(0.3))
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: isDone ? Colors.green : (isLocked ? Colors.grey[800] : lightBlue.withOpacity(0.2)),
                      child: Icon(
                          isDone ? Icons.check : (isLocked ? Icons.lock : Icons.play_arrow),
                          color: isLocked ? Colors.grey : Colors.white
                      ),
                    ),
                    title: Text(
                      module['title'] ?? "Module ${index + 1}",
                      style: TextStyle(color: isLocked ? Colors.grey : Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        isLocked ? "Terminez le module précédent." : (isDone ? "Terminé" : "En cours"),
                        style: TextStyle(color: isDone ? Colors.green : Colors.grey[600], fontSize: 12),
                      ),
                    ),
                    onTap: isLocked ? () {
                      Get.snackbar("Verrouillé 🔒", "Suivez l'ordre du cours !", backgroundColor: Colors.redAccent, colorText: Colors.white);
                    } : () {
                      _showLessonDialog(context, module, index);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLessonDialog(BuildContext context, Map<String, dynamic> module, int index) {
    String title = module['title'] ?? "";
    String content = module['content'] ?? "";

    // CHECK IF THIS IS A QUIZ
    bool isQuiz = title.toLowerCase().contains("quiz") || title.toLowerCase().contains("test");

    if (isQuiz) {
      _showQuizDialog(context, title, content, index);
    } else {
      // STANDARD LESSON DIALOG
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(module['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 10),
                  Text(
                    module['content'] ?? "Contenu...",
                    style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Fermer", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Get.back();
                _completeLesson(index);
                Get.snackbar("Bravo !", "Leçon terminée", backgroundColor: Colors.green, colorText: Colors.white);
              },
              style: ElevatedButton.styleFrom(backgroundColor: lightBlue),
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text("Terminer la leçon", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
  }

  void _showQuizDialog(BuildContext context, String title, String content, int index) {
    List<QuizQuestion> questions = _parseQuizContent(content);
    
    // If parsing fails or no questions found, fallback to simple view
    if (questions.isEmpty) {
       Get.snackbar("Erreur", "Format du quiz non reconnu", backgroundColor: Colors.redAccent, colorText: Colors.white);
       return;
    }

    // Local state variables for the dialog
    int currentQuestionIndex = 0;
    Map<int, int> userAnswers = {}; // Map<QuestionIndex, OptionIndex>
    bool showResult = false;
    int score = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            QuizQuestion question = questions[currentQuestionIndex];

            // --- RESULT VIEW ---
            if (showResult) {
               return AlertDialog(
                 backgroundColor: const Color(0xFF2C2C2C),
                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                 title: const Center(child: Text("Résultats", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                 content: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Icon(
                       score >= (questions.length / 2) ? Icons.emoji_events : Icons.sentiment_dissatisfied,
                       size: 80,
                       color: score >= (questions.length / 2) ? Colors.amber : Colors.grey,
                     ),
                     const SizedBox(height: 20),
                     Text(
                       "Score: $score / ${questions.length}",
                       style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                     ),
                     const SizedBox(height: 10),
                     Text(
                       score == questions.length ? "Parfait ! 🌟" : (score >= (questions.length / 2) ? "Bien joué ! 👍" : "Essaie encore ! 💪"),
                       style: TextStyle(color: Colors.grey[400]),
                     ),
                   ],
                 ),
                 actions: [
                   ElevatedButton(
                     onPressed: () {
                        Get.back(); // Close dialog
                        if (score >= (questions.length / 2)) {
                           _completeLesson(index); // Mark as complete ONLY if passed (optional rule) or just mark done
                           // _completeLesson already marks it done
                        } else {
                           // Option: Force them to retry? For now, we let them finish.
                           _completeLesson(index); 
                        }
                     },
                     style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                     child: const Text("Terminer le cours", style: TextStyle(color: Colors.white)),
                   )
                 ],
               );
            }

            // --- QUESTION VIEW ---
            return AlertDialog(
              backgroundColor: const Color(0xFF2C2C2C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: Row(
                children: [
                  Text("Question ${currentQuestionIndex + 1}/${questions.length}", style: const TextStyle(color: Colors.orangeAccent, fontSize: 16)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Get.back())
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(question.question, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    ...List.generate(question.options.length, (optIndex) {
                      bool isSelected = userAnswers[currentQuestionIndex] == optIndex;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? lightBlue.withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isSelected ? lightBlue : Colors.grey[800]!)
                        ),
                        child: RadioListTile<int>(
                          activeColor: lightBlue,
                          contentPadding: EdgeInsets.zero,
                          title: Text(question.options[optIndex], style: const TextStyle(color: Colors.white70)),
                          value: optIndex,
                          groupValue: userAnswers[currentQuestionIndex],
                          onChanged: (val) {
                             setState(() {
                               userAnswers[currentQuestionIndex] = val!;
                             });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              actions: [
                // PREVIOUS
                 if (currentQuestionIndex > 0)
                  TextButton(
                    onPressed: () {
                      setState(() => currentQuestionIndex--);
                    },
                    child: const Text("Précédent", style: TextStyle(color: Colors.grey)),
                  ),
                
                // NEXT / FINISH
                ElevatedButton(
                  onPressed: userAnswers[currentQuestionIndex] == null ? null : () {
                    if (currentQuestionIndex < questions.length - 1) {
                      setState(() => currentQuestionIndex++);
                    } else {
                      // CALCULATE SCORE
                      int calculatedScore = 0;
                      for (int i = 0; i < questions.length; i++) {
                        if (userAnswers[i] == questions[i].correctAnswerIndex) {
                          calculatedScore++;
                        }
                      }
                      setState(() {
                        score = calculatedScore;
                        showResult = true;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: userAnswers[currentQuestionIndex] == null ? Colors.grey[800] : lightBlue),
                  child: Text(
                    currentQuestionIndex == questions.length - 1 ? "Voir les résultats" : "Suivant",
                    style: TextStyle(color: userAnswers[currentQuestionIndex] == null ? Colors.grey : Colors.white),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  // --- PARSING LOGIC ---
  List<QuizQuestion> _parseQuizContent(String content) {
    List<QuizQuestion> questions = [];
    
    // Split by "Question" keyword, but be careful not to lose the first one if it starts immediately
    // Regex lookahead could work, or simple split. 
    // Format: "Question 1: Text... \nOptions: A) ... \nCorrect Answer: ..."
    
    // Normalize newlines
    content = content.replaceAll(r'\r\n', '\n');
    List<String> rawBlocks = content.split(RegExp(r'Question \d+:'));
    
    // The first block might be empty if string starts with "Question 1:"
    if (rawBlocks.isNotEmpty && rawBlocks[0].trim().isEmpty) {
      rawBlocks.removeAt(0);
    }
    
    for (String block in rawBlocks) {
      // block contains: " What is HTML? \nOptions: A) ..., B) ... \nCorrect Answer: ..."
      if (block.trim().isEmpty) continue;
      
      try {
        // Extract Question Text (everything before "Options:")
        List<String> parts = block.split("Options:");
        String questionText = parts[0].trim();
        
        if (parts.length < 2) continue; // Malformed
        
        // Extract Options and Correct Answer
        // Part 1 contains "A) ..., B) ... \nCorrect Answer: C) ..."
        List<String> remaining = parts[1].split("Correct Answer:");
        String optionsRaw = remaining[0].trim();
        String correctRaw = remaining.length > 1 ? remaining[1].trim() : ""; // e.g., "C) The Content"
        
        // Parse "A) Option 1, B) Option 2" or "A) Option 1 \n B) Option 2"
        // Let's assume comma or newline separated for A), B), C)...
        // A simple heuristic: split by regex A), B), etc.
        
        // Let's just create a simple splitter for Options
        List<String> options = [];
        // This regex finds A), B), C), D) followed by space
        RegExp optionRegex = RegExp(r'[A-D]\)'); 
        List<String> optionParts = optionsRaw.split(optionRegex);
        // optionParts[0] is usually empty or whitespace before A)
        for (String opt in optionParts) {
           if (opt.trim().isNotEmpty) options.add(opt.trim().replaceAll(RegExp(r',$'), '')); // remove trailing comma
        }
        
        // Determine correct index
        // correctRaw might be "C) The Content" or just "C"
        int correctIndex = -1;
        if (correctRaw.toLowerCase().startsWith("a")) correctIndex = 0;
        else if (correctRaw.toLowerCase().startsWith("b")) correctIndex = 1;
        else if (correctRaw.toLowerCase().startsWith("c")) correctIndex = 2;
        else if (correctRaw.toLowerCase().startsWith("d")) correctIndex = 3;
        
        if (questionText.isNotEmpty && options.isNotEmpty && correctIndex != -1) {
          questions.add(QuizQuestion(questionText, options, correctIndex));
        }
      } catch (e) {
        print("Error parsing quiz block: $e");
      }
    }
    
    return questions;
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion(this.question, this.options, this.correctAnswerIndex);
}