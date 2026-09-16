import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../theme/app_colors.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';

/// Ecran d'inscription. Meme logique que LoginScreen
class SignupScreen extends StatefulWidget {
  const SignupScreen({
    super.key,
    required this.onInscription,
    required this.onNaviguerVersConnexion,
    this.isLoading = false,
    this.erreur,
  });

  final Future<void> Function(String nom, String email, String motDePasse)
  onInscription;
  final VoidCallback onNaviguerVersConnexion;
  final bool isLoading;
  final String? erreur;

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nomController = TextEditingController();
  final _emailController = TextEditingController();
  final _motDePasseController = TextEditingController();
  final _confirmationMotDePasseController = TextEditingController();
  bool _motDePasseVisible = false;

  String? _erreurNom;
  String? _erreurEmail;
  String? _erreurMotDePasse;
  String? _erreurConfirmationMotDePasse;

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _motDePasseController.dispose();
    _confirmationMotDePasseController.dispose();
    super.dispose();
  }

  bool _validerFormulaire() {
    setState(() {
      _erreurNom = _nomController.text.trim().isEmpty
          ? 'Le nom est requis'
          : null;
      _erreurEmail = _emailController.text.trim().isEmpty
          ? 'L\'email est requis'
          : (!_emailController.text.contains('@') ? 'Email invalide' : null);
      _erreurMotDePasse = _motDePasseController.text.length < 6
          ? 'Minimum 6 caracteres'
          : null;
      _erreurConfirmationMotDePasse =
          _confirmationMotDePasseController.text != _motDePasseController.text
          ? 'Les mots de passe ne correspondent pas'
          : null;
    });
    return _erreurNom == null &&
        _erreurEmail == null &&
        _erreurMotDePasse == null &&
        _erreurConfirmationMotDePasse == null;
  }

  void _soumettre() {
    if (_validerFormulaire()) {
      widget.onInscription(
        _nomController.text.trim(),
        _emailController.text.trim(),
        _motDePasseController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              _buildLogo(),
              const SizedBox(height: 24),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Créer un compte',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Rejoins QuizMaster et commence à progresser dès aujourd\'hui.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              AppTextField(
                controller: _nomController,
                hintText: 'Nom complet',
                icon: Icons.person_outline,
                errorText: _erreurNom,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _emailController,
                hintText: 'Adresse e-mail',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                errorText: _erreurEmail,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _motDePasseController,
                hintText: 'Mot de passe',
                icon: Icons.lock_outline,
                obscureText: !_motDePasseVisible,
                onToggleObscure: () =>
                    setState(() => _motDePasseVisible = !_motDePasseVisible),
                errorText: _erreurMotDePasse,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _confirmationMotDePasseController,
                hintText: 'Confirmer le mot de passe',
                icon: Icons.lock_reset_outlined,
                obscureText: !_motDePasseVisible,
                onToggleObscure: () =>
                    setState(() => _motDePasseVisible = !_motDePasseVisible),
                errorText: _erreurConfirmationMotDePasse,
              ),
              const SizedBox(height: 24),
              if (widget.erreur != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.erreur!,
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              AppButton(
                label: 'S\'inscrire',
                onPressed: _soumettre,
                isLoading: widget.isLoading,
              ),
              const SizedBox(height: 20),
              _buildLienConnexion(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryBlue, AppColors.primaryBlueDark],
        ),
      ),
      child: const Icon(Icons.school_rounded, color: Colors.white, size: 36),
    );
  }

  Widget _buildLienConnexion() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: AppColors.textSecondaryLight,
          fontSize: 13,
        ),
        children: [
          const TextSpan(text: 'Déjà un compte ? '),
          TextSpan(
            text: 'Se connecter',
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = widget.onNaviguerVersConnexion,
          ),
        ],
      ),
    );
  }
}
