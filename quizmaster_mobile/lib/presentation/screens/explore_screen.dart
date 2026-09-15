import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/filter_chip_custom.dart';
import '../widgets/categorie_list_tile.dart';
import '../widgets/bottom_nav_bar.dart';

/// Ecran Catalogue/Explorer : recherche, filtres par categorie et
/// difficulte, liste des categories disponibles.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({
    super.key,
    required this.categories,
    required this.onTapCategorie,
    required this.onRetour,
    required this.onChangerOnglet,
    required this.onRecherche,
  });

  final List<CategorieExploreData> categories;
  final ValueChanged<CategorieExploreData> onTapCategorie;
  final VoidCallback onRetour;
  final ValueChanged<int> onChangerOnglet;
  final ValueChanged<String> onRecherche;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _categorieSelectionnee = 'Toutes';
  String _difficulteSelectionnee = 'Tous';

  static const _categoriesFiltre = [
    'Toutes',
    'Education',
    'Santé',
    'Mode de vie',
  ];
  static const _difficultesFiltre = ['Tous', 'Facile', 'Moyen', 'Difficile'];

  List<CategorieExploreData> get _categoriesAffichees {
    if (_categorieSelectionnee == 'Toutes') return widget.categories;
    return widget.categories
        .where(
          (c) => c.nom.toLowerCase().contains(
            _categorieSelectionnee.toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildEnTete(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildFiltresCategories(),
                    const SizedBox(height: 20),
                    const Text(
                      'Filtres de difficulté',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildFiltresDifficulte(),
                    const SizedBox(height: 20),
                    ..._categoriesAffichees.map(
                      (categorie) => CategorieListTile(
                        nom: categorie.nom,
                        resume: categorie.resume,
                        icone: categorie.icone,
                        couleur: categorie.couleur,
                        onTap: () => widget.onTapCategorie(categorie),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            AppBottomNavBar(indexActuel: 1, onTap: widget.onChangerOnglet),
          ],
        ),
      ),
    );
  }

  Widget _buildEnTete() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onRetour,
            child: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Catalogue des quiz',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _afficherRecherche(context),
            child: const Icon(Icons.search, size: 22),
          ),
        ],
      ),
    );
  }

  void _afficherRecherche(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Rechercher un quiz...',
            ),
            onSubmitted: (valeur) {
              widget.onRecherche(valeur);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  Widget _buildFiltresCategories() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categoriesFiltre.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = _categoriesFiltre[index];
          return FilterChipCustom(
            label: label,
            selected: _categorieSelectionnee == label,
            onTap: () => setState(() => _categorieSelectionnee = label),
          );
        },
      ),
    );
  }

  Widget _buildFiltresDifficulte() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _difficultesFiltre.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final label = _difficultesFiltre[index];
          return FilterChipCustom(
            label: label,
            selected: _difficulteSelectionnee == label,
            onTap: () => setState(() => _difficulteSelectionnee = label),
          );
        },
      ),
    );
  }
}

class CategorieExploreData {
  const CategorieExploreData({
    required this.nom,
    required this.resume,
    required this.icone,
    required this.couleur,
  });

  final String nom;
  final String resume;
  final IconData icone;
  final Color couleur;
}
