# QuizMaster — Groupe 29

QuizMaster est un projet de quiz interactif composé de deux applications complémentaires :

- un générateur de quiz en ligne de commande (`quizmaster_cli/`)
- une application mobile Flutter (`quizmaster_mobile/`)

Le dépôt centralise la gestion du contenu pédagogique, les outils de création de quiz et l'expérience utilisateur mobile connectée à Firebase.

## Objectif du projet

Le projet vise à proposer :

- une création rapide de quiz via un CLI simple
- un stockage des quiz au format JSON exploitable par l'application
- une expérience de jeu mobile fluide avec navigation, questions et résultats
- un classement ou un suivi utilisateur via Firebase

## Structure du dépôt

- `README.md` — documentation globale du projet
- `quizmaster_cli/` — application CLI de création et gestion des quiz
- `quizmaster_mobile/` — application Flutter mobile pour jouer aux quiz
- `data/` — fichiers JSON utilisés par le projet et le CLI
- `test/` — tests globaux du workspace

## Démarrage rapide

### CLI

```powershell
cd quizmaster_cli
dart pub get
dart run
```

### Mobile

```powershell
cd quizmaster_mobile
flutter pub get
flutter run
```

## Rôle des sous-projets

### `quizmaster_cli`

Le CLI permet de :

- créer un nouveau quiz
- lister les quiz existants
- modifier un quiz
- supprimer un quiz
- exporter le contenu au format JSON

### `quizmaster_mobile`

L'application mobile permet de :

- consulter les quiz disponibles
- jouer une session de questions
- valider une réponse
- afficher un résultat
- consulter le profil et le classement

## Bonnes pratiques

- conserver le format JSON des quiz stable entre le CLI et l'application
- éviter de modifier le code des modules existants sans nécessité
- documenter toute évolution de structure ou de contrat de données
- valider les changements à l'aide des tests du projet

## Stack technique

- Dart
- Flutter
- Firebase (authentification / données / classements)
- JSON pour le stockage des quiz
