# QuizMaster Mobile

L'application mobile QuizMaster propose une expérience de quiz interactive, accessible et connectée à Firebase pour les profils, les résultats et le classement.

## Objectif

Le module `quizmaster_mobile` permet de :

- afficher la liste des quiz disponibles
- lancer une session de jeu
- répondre à des questions à choix multiples
- afficher le score final
- consulter le profil utilisateur
- visualiser le classement général

## Stack technique

- Flutter
- Dart
- Firebase Auth
- Cloud Firestore
- Material Design

## Structure du projet

```text
quizmaster_mobile/
├── android/
├── ios/
├── lib/
├── test/
├── web/
├── windows/
├── pubspec.yaml
├── README.md
├── firebase.json
└── analysis_options.yaml
```

## Démarrage

Depuis le dossier du projet :

```powershell
flutter pub get
flutter run
```

## Fonctionnalités principales

- écran de connexion / inscription
- navigation principale entre accueil, quiz, classement et profil
- récupération des données de quiz et de résultats
- gestion de session utilisateur
- intégration des services Firebase

## Rôle du module mobile dans le projet

L'application mobile est le point d'entrée utilisateur. Elle consomme les quiz préparés par le CLI et met en place l'expérience de jeu, la logique de validation et la gestion des données de score.

## Validation

Pour lancer les tests du module :

```powershell
flutter test
```

Les tests se concentrent sur les flux de données, les repositories, les sources de données locales et les composants UI de base.
