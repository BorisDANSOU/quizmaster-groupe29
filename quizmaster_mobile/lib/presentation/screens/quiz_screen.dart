import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/reponse_option_tile.dart';

/// Ecran de jeu : affiche une question a la fois, gere le timer et
/// le feedback visuel (vert/rouge) apres selection. La validation
/// reelle (via ValiderReponseUseCase) sera branchee par le provider ;
/// ici, onReponseSelectionnee recoit juste l'index choisi.
class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.categorie,
    required this.numeroQuestion,
    required this.totalQuestions,
    required this.enonce,
    required this.options,
    required this.bonneReponseIndex,
    required this.onReponseSelectionnee,
    required this.onQuestionSuivante,
    required this.onFermer,
    this.dureeSecondes = 60,
  });

  final String categorie;
  final int numeroQuestion;
  final int totalQuestions;
  final String enonce;
  final List<String> options;
  final int bonneReponseIndex;
  final ValueChanged<int> onReponseSelectionnee;
  final VoidCallback onQuestionSuivante;
  final VoidCallback onFermer;
  final int dureeSecondes;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? _indexSelectionne;
  late int _secondesRestantes;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _secondesRestantes = widget.dureeSecondes;
    _demarrerTimer();
  }

  @override
  void didUpdateWidget(QuizScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reinitialise le timer et la selection quand on passe a la question suivante
    if (oldWidget.numeroQuestion != widget.numeroQuestion) {
      setState(() {
        _indexSelectionne = null;
        _secondesRestantes = widget.dureeSecondes;
      });
      _demarrerTimer();
    }
  }

  void _demarrerTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondesRestantes <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _secondesRestantes--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _tempsFormate {
    final minutes = (_secondesRestantes ~/ 60).toString().padLeft(2, '0');
    final secondes = (_secondesRestantes % 60).toString().padLeft(2, '0');
    return '$minutes:$secondes';
  }

  void _selectionnerReponse(int index) {
    if (_indexSelectionne != null) return; // deja repondu, on bloque
    setState(() => _indexSelectionne = index);
    widget.onReponseSelectionnee(index);
  }

  EtatReponse _etatPour(int index) {
    if (_indexSelectionne == null) return EtatReponse.neutre;
    if (index == widget.bonneReponseIndex) return EtatReponse.correcte;
    if (index == _indexSelectionne) return EtatReponse.incorrecte;
    return EtatReponse.neutre;
  }

  @override
  Widget build(BuildContext context) {
    final progression = widget.numeroQuestion / widget.totalQuestions;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildEnTete(progression),
              const SizedBox(height: 20),
              _buildBadgeCategorie(),
              const SizedBox(height: 16),
              Text(
                'QUESTION ${widget.numeroQuestion}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.enonce,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.options.length,
                  itemBuilder: (context, index) {
                    return ReponseOptionTile(
                      lettre: String.fromCharCode(65 + index), // A, B, C...
                      texte: widget.options[index],
                      etat: _etatPour(index),
                      onTap: () => _selectionnerReponse(index),
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _indexSelectionne != null
                      ? widget.onQuestionSuivante
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    disabledBackgroundColor: AppColors.darkCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Suivant',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnTete(double progression) {
    return Row(
      children: [
        GestureDetector(
          onTap: widget.onFermer,
          child: const Icon(Icons.close, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progression,
              minHeight: 6,
              backgroundColor: AppColors.darkCard,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBlue,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          '${widget.numeroQuestion}/${widget.totalQuestions}',
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(
                _tempsFormate,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeCategorie() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        widget.categorie,
        style: const TextStyle(
          color: AppColors.success,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
