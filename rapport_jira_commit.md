# Rapport de Suivi Jira & Commits Git

Ce document présente une proposition de structure pour votre gestion de projet Jira, avec les tâches (User Stories/Tasks) associées aux commits réalisés.

## 1. Epic : Gestion des Cours & Contenu Pédagogique (LMS)

**Description :** Création, affichage et gestion des cours, modules et quiz.

### Tâches (Issues) :
*   **[STORY] Création et gestion des cours administrateur**
    *   *Description :* Permettre aux administrateurs de créer, modifier et supprimer des cours manuellement.
    *   *Commits associés :*
        *   `be9211f` - added admin courses /manipulation
        *   `a04c3e4` - fixed courses visibility
*   **[STORY] Intégration de contenu Multimédia (YouTube)**
    *   *Description :* Intégrer un lecteur YouTube dans les modules de cours pour les tutoriels vidéo.
    *   *Commits associés :*
        *   `722e30a` - added youtube interface inside modules in the app to show tutorials
        *   `0883806` - fixed Yt Url bug for students
*   **[STORY] Système de Quiz et Correction**
    *   *Description :* Ajouter des quiz aux cours avec un système de correction automatique.
    *   *Commits associés :*
        *   `740d3f4` - added quiz to admin courses with correction
*   **[TASK] Recherche et Filtrage des Cours**
    *   *Description :* Améliorer la logique de recherche pour afficher les cours pertinents pour l'utilisateur.
    *   *Commits associés :*
        *   `dcc406c` - fixed search logic the show user specific course
*   **[STORY] Inscriptions et Évaluations**
    *   *Description :* Gérer le nombre d'inscrits et permettre aux utilisateurs de noter les cours.
    *   *Commits associés :*
        *   `fd7fd8b` - added user enrollement count/ Rating / Fixed Comments to appear on the global course

## 2. Epic : Intelligence Artificielle (Gemini Integration)

**Description :** Fonctionnalités générées ou assistées par l'IA.

### Tâches (Issues) :
*   **[STORY] Génération de Cours par IA**
    *   *Description :* Utiliser l'API Gemini pour générer automatiquement le contenu des cours à partir d'un sujet.
    *   *Commits associés :*
        *   `e30fa01` - added AI gen courses / dynamic profile

## 3. Epic : Collaboration & Social

**Description :** Fonctionnalités d'interaction entre les utilisateurs et travail de groupe.

### Tâches (Issues) :
*   **[STORY] Espace Collaboratif et Ressources Partagées**
    *   *Description :* Mise en place d'un tableau des tâches, calendrier d'événements et partage de ressources pour les groupes.
    *   *Commits associés :*
        *   `1e608ee` - Ehanced Collaborative PLatform added Shared Rsources Task Board Events&Meetings
*   **[STORY] Messagerie de Groupe**
    *   *Description :* Chat en temps réel pour les groupes de travail.
    *   *Commits associés :*
        *   `fb09960` - added group chats
*   **[STORY] Messagerie Privée**
    *   *Description :* Système de messages directs entre utilisateurs et avec les créateurs de cours.
    *   *Commits associés :*
        *   `e7f4dc0` - added private messages between users
        *   `ad4bfb1` - added private messages to cours creator

## 4. Epic : Gamification & Profil Utilisateur

**Description :** Engagement utilisateur et gestion du profil.

### Tâches (Issues) :
*   **[STORY] Profil Utilisateur Dynamique**
    *   *Description :* Page de profil affichant les informations et statistiques de l'utilisateur.
    *   *Commits associés :*
        *   `e30fa01` - added AI gen courses / dynamic profile
*   **[STORY] Certification et Récompenses (XP)**
    *   *Description :* Génération dynamique de certificats de réussite et attribution de points d'expérience (XP).
    *   *Commits associés :*
        *   `cc82088` - added dynamic certificate generation fixed xp bug for AIgeneratedCertfs

## Résumé pour Jira

| Type | Résumé (Summary) | Priorité | Statut |
| :--- | :--- | :--- | :--- |
| Epic | Gestion des Cours & LMS | High | In Progress |
| Story | Création de cours Admin | High | Done |
| Story | Intégration Player YouTube | Medium | Done |
| Story | Module Quiz & Correction | Medium | Done |
| Epic | Fonctionnalités IA (Gemini) | High | Done |
| Story | Génération automatique de cours | High | Done |
| Epic | Collaboration & Social | High | Done |
| Story | Chat de groupe & Messagerie | Medium | Done |
| Story | Tableau de bord collaboratif | Medium | Done |
| Epic | Gamification | Low | Done |
| Story | Certificats et XP | Low | Done |
