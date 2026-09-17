# QuizMaster CLI

Le CLI QuizMaster est un outil de création et de gestion de quiz destiné à produire des fichiers JSON réutilisables par l'application mobile.

## Objectif

Le module `quizmaster_cli` permet de :

- créer un nouveau quiz
- lister les quiz déjà disponibles
- modifier les métadonnées et questions d'un quiz existant
- supprimer un quiz
- exporter le contenu dans le dossier `data/`

## Structure du projet

```text
quizmaster_cli/
├── bin/
├── data/
├── lib/
├── test/
├── pubspec.yaml
├── README.md
└── analysis_options.yaml
```

## Démarrage

Depuis le dossier du module :

```powershell
dart pub get
dart run
```

## Rôle du CLI dans le projet

Le CLI agit comme source de contenu du projet : il prépare les quiz au format exploitable par l'application mobile. Les fichiers générés sont ensuite consommés par l'application pour proposer des questions et mesurer les résultats.

## Format des quiz

Les quiz sont stockés au format JSON dans le dossier `data/`.

```json
{
  "quizId": "q001",
  "titre": "Bien-être au quotidien",
  "categorie": "Sante_Bien_Etre",
  "difficulte": "facile",
  "questions": [
    {
      "id": "q001-01",
      "enonce": "Quelle activité aide à réduire le stress ?",
      "type": "qcm",
      "options": ["Méditer", "Ignorer le problème", "Travailler sans pause"],
      "bonneReponseIndex": 0,
      "points": 10
    }
  ]
}
```

## Validation

Pour lancer les tests du module :

```powershell
dart test
```

La couverture des tests porte sur la validation des modèles, la sérialisation JSON et les flux de création / lecture / modification de quiz.
