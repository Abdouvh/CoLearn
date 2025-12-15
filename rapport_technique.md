# Rapport Technique du Projet CoLearn

Ce document recense l'ensemble des technologies, frameworks et dépendances utilisés dans le cadre du développement de l'application CoLearn.

## 1. Backend (Serveur & API)

Le backend est construit sur une architecture Java avec le framework Spring Boot.

*   **Langage :** Java 21
*   **Framework Principal :** Spring Boot 3.5.5
*   **Outil de Build :** Maven
*   **Base de Données :** MySQL (Connecteur `mysql-connector-j`)
*   **ORM / Persistance :** Spring Data JPA / Hibernate
*   **Sécurité & Authentification :**
    *   Spring Security
    *   OAuth2 Client (Intégration Google Sign-In)
*   **Communication & API :**
    *   Spring Web (REST API)
    *   Gson (Traitement JSON)
    *   Spring Boot Starter Mail (Envoi d'emails via SMTP Gmail)
*   **Services Tiers / IA :**
    *   **Google Gemini API** (via `generativelanguage.googleapis.com`) : Utilisé pour les fonctionnalités d'IA générative.
*   **Utilitaires :**
    *   Lombok (Réduction du code boilerplate)
    *   Spring Boot DevTools (Outils de développement)

## 2. Frontend (Application Mobile/Web)

Le frontend est développé avec le framework Flutter pour une application multiplateforme.

*   **Framework :** Flutter
*   **Langage :** Dart
*   **Version SDK :** `>=2.17.3 <3.0.0`
*   **Architecture / Gestion d'État :**
    *   **GetX (`get`)** : Gestion d'état réactive, injection de dépendances et routage.
*   **Interface Utilisateur (UI) :**
    *   `velocity_x` : Framework CSS-like pour une mise en page rapide.
    *   `cupertino_icons` : Icônes style iOS.
    *   `webview_flutter` : Affichage de contenu web intégré.
*   **Fonctionnalités Clés :**
    *   **Authentification :** `google_sign_in` (Connexion via Google).
    *   **Multimédia :** `youtube_player_flutter` (Lecture de vidéos YouTube).
    *   **Documents :** `pdf` (Création de PDF), `printing` (Impression).
    *   **Réseau :** `http` (Requêtes API REST).
    *   **Système :** `url_launcher` (Ouverture de liens externes).

## 3. Outils & Environnement

*   **IDE Recommandés :** IntelliJ IDEA (Backend), VS Code / Android Studio (Frontend).
*   **Contrôle de Version :** Git.
*   **Tests :**
    *   Backend : JUnit, Spring Boot Starter Test.
    *   Frontend : `flutter_test`.

## 4. Architecture Globale

*   **Client-Serveur :** L'application mobile (Flutter) communique avec le backend (Spring Boot) via une API REST.
*   **Base de Données Relationalle :** Les données sont stockées dans MySQL.
*   **Intégration Cloud :** Utilisation intensive des services Google (Auth, Gemini, Gmail).

---
*Généré pour le rapport de projet le 15 Décembre 2025.*
