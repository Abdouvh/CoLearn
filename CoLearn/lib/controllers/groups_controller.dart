import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsController extends GetxController {
  // 1. Dynamic List - NOW INCLUDES 'inviteLink'
  var myGroups = <Map<String, dynamic>>[
    {
      "name": "Flutter Developers",
      "members": 12,
      "nextSession": "Demain, 10:00",
      "color": Colors.blueAccent,
      "icon": Icons.code,
      "inviteLink": "colearn.app/join/flutter" // Specific link
    },
    {
      "name": "Spring Boot Masters",
      "members": 5,
      "nextSession": "Lun, 14:00",
      "color": Colors.green,
      "icon": Icons.storage,
      "inviteLink": "colearn.app/join/spring" // Specific link
    },
  ].obs;

  // 2. Create Group
  void createGroup(String name, String time) {
    myGroups.add({
      "name": name,
      "members": 1,
      "nextSession": time,
      "color": Colors.orange,
      "icon": Icons.school,
      // Generate a fake link based on the name
      "inviteLink": "colearn.app/join/${name.replaceAll(' ', '').toLowerCase()}"
    });

    Get.back();
    Get.snackbar("Succès", "Le groupe '$name' a été créé !",
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  // 3. SMART JOIN GROUP (Checks the link text!)
  void joinGroup(String text) {
    Get.back(); // Close dialog

    // Simulate Loading
    Get.snackbar(
      "Recherche...",
      "Analyse du lien d'invitation...",
      showProgressIndicator: true,
      backgroundColor: Colors.black54,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    // Simulate Network Delay
    Future.delayed(const Duration(seconds: 2), () {
      String lowerText = text.toLowerCase();
      Map<String, dynamic> newGroup;

      // SMART LOGIC: Check what the user pasted
      if (lowerText.contains("flutter")) {
        newGroup = {
          "name": "Advanced Flutter",
          "members": 45,
          "nextSession": "Sam 10:00",
          "color": Colors.blue,
          "icon": Icons.flutter_dash,
          "inviteLink": "colearn.app/join/flutter-adv"
        };
      } else if (lowerText.contains("spring") || lowerText.contains("java")) {
        newGroup = {
          "name": "Java Experts",
          "members": 20,
          "nextSession": "Dim 18:00",
          "color": Colors.redAccent,
          "icon": Icons.coffee,
          "inviteLink": "colearn.app/join/java"
        };
      } else if (lowerText.contains("design") || lowerText.contains("ui")) {
        newGroup = {
          "name": "UI/UX Designers",
          "members": 15,
          "nextSession": "Ven 14:00",
          "color": Colors.purple,
          "icon": Icons.palette,
          "inviteLink": "colearn.app/join/design"
        };
      } else {
        // Fallback for random text
        newGroup = {
          "name": "Groupe Invité",
          "members": 3,
          "nextSession": "TBD",
          "color": Colors.grey,
          "icon": Icons.group,
          "inviteLink": "colearn.app/join/guest"
        };
      }

      myGroups.add(newGroup);
      Get.snackbar("Succès", "Vous avez rejoint: ${newGroup['name']}",
          backgroundColor: Colors.green, colorText: Colors.white);
    });
  }
}