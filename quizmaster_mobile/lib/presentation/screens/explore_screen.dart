import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:quizmaster_mobile/presentation/widget/listtile_widget.dart';

class ExploreScreen extends HookWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCat = useState("Toutes");
    final selectedDiff = useState("Toutes");
    List<String> filterParDifficulter = [
      "Toutes",
      "Facile",
      "Moyen",
      "Difficile",
    ];
    List<String> catalogues = [
      "Toutes",
      "Education",
      "Sante",
      "Technolologies",
    ];

    void filterByCatalogue(String catalogue) {
      selectedCat.value = catalogue;
      log("Catalogue selected: $catalogue");
      // AJOUTER DES LOGIQUES POUR FILTRER LES QUIZ EN FONCTION DU CATALOGUE
    }

    void filterByDifficulter(String difficulte) {
      selectedDiff.value = difficulte;
      log("Difficulte selected: $difficulte");
      // AJOUTER DES LOGIQUES POUR FILTRER LES QUIZ EN FONCTION DE LA DIFFICULTE
    }

    useEffect(() {
      filterByCatalogue("Toutes");
      filterByDifficulter("Toutes");
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text("Catalogue des quiz", style: TextStyle(fontSize: 20)),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search, size: 30)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              //  ------------------------------- 1 filter --------
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: .horizontal,
                  shrinkWrap: true,
                  itemCount: catalogues.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(width: 12),

                  itemBuilder: (context, index) {
                    final catalogue = catalogues[index];
                    return InkWell(
                      onTap: () => filterByCatalogue(catalogue),
                      child: Chip(
                        label: Text(
                          catalogue,
                          style: TextStyle(
                            color: selectedCat.value == catalogue
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        backgroundColor: selectedCat.value == catalogue
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHigh,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "FiltreS de difficulte",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              //  ------------------------------- 2 filter --------
              SizedBox(
                height: 50,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: .horizontal,
                  itemCount: filterParDifficulter.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final difficulte = filterParDifficulter[index];
                    return InkWell(
                      onTap: () => filterByDifficulter(difficulte),
                      child: Chip(
                        label: Text(
                          difficulte,
                          style: TextStyle(
                            color: selectedDiff.value == difficulte
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        backgroundColor: selectedDiff.value == difficulte
                            ? Colors.black
                            : theme.colorScheme.surfaceContainerHigh,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                ),
              ),
              //  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
              // LISTE DES QUIZ FILTRER PAR CATALOGUE ET DIFFICULTE
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return ListtileWidget(
                    subtitle: "Education",
                    progress: "8 quiz * 3 niveaux",
                    icon: Icons.school,
                    color: Colors.blue,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
