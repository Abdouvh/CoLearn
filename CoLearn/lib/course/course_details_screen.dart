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

    // Initialize progress (simple logic: count unlocked modules)
    _calculateProgress();
  }

  void _calculateProgress() {
    if (modules.isEmpty) return;

    // Count how many are unlocked
    int unlockedCount = modules.where((m) => m['locked'] == false).length;

    // Progress Logic: If Module 1 is unlocked, progress is 0. If Module 2 unlocked, 1 is done.
    // If last module is unlocked AND user sees this screen, we assume progress is continuing.
    // This is a simplification for the demo.

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

      // 2. CALL API TO SAVE "UNLOCKED" STATUS TO BACKEND (CRITICAL FIX)
      await ApiService.unlockModule(nextModuleId);

      // 3. Update UI Locally
      setState(() {
        modules[index + 1]['locked'] = false;
        progressValue = (index + 1) / modules.length;
      });
    } else {
      // Last module finished
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
              // --- TRIGGER SAVE LOGIC ---
              _completeLesson(index);

              Get.snackbar("Bravo !", "Progression sauvegardée", backgroundColor: Colors.green, colorText: Colors.white);
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