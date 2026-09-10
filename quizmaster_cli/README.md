# QuizMaster CLI

Outil en ligne de commande pour créer, lister, modifier et supprimer des quiz au format JSON, utilisés ensuite par l'application mobile QuizMaster.

## Lancer le CLI

Depuis le dossier `quizmaster_cli/` :

```powershell
dart run
```

## Fonctionnalités du menu

1. **Créer un nouveau quiz** — saisie guidée des métadonnées (ID, titre, catégorie, difficulté) puis d'une ou plusieurs questions QCM. L'ID doit être unique et non vide ; la difficulté doit être `facile`, `moyen` ou `difficile`.
2. **Lister les quiz existants** — affiche les fichiers présents dans `data/`
3. **Modifier un quiz existant** — change les métadonnées et/ou ajoute des questions à un quiz déjà créé (laisser vide pour conserver la valeur actuelle)
4. **Supprimer un quiz** — supprime un fichier de quiz après confirmation (`o`/`n`)
5. **Quitter**

## Format des fichiers générés

Les quiz sont enregistrés dans `data/<quizId>.json`. Exemple :

```json
{
  "quizId": "q001",
  "titre": "Bien-etre au quotidien",
  "categorie": "Sante_Bien_Etre",
  "difficulte": "facile",
  "questions": [
    {
      "id": "q001-01",
      "enonce": "...",
      "type": "qcm",
      "options": ["...", "..."],
      "bonneReponseIndex": 0,
      "points": 10
    }
  ]
}
```

Ce format est le contrat entre le CLI et l'application mobile : toute modification de structure doit être communiquée à l'équipe mobile.

## Lancer les tests

```powershell
dart test
```

Comprend :
- Tests unitaires des modèles `Quiz`/`Question` (sérialisation JSON)
- Tests unitaires du `JsonService` (lecture/écriture de fichiers)
- Tests d'intégration du pipeline complet (création → écriture → lecture, et modification)