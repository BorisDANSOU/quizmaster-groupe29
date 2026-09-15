import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../theme/app_colors.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_button.dart';
import '../widgets/google_logo.dart';

/// Ecran de connexion.
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onConnexion,
    required this.onConnexionGoogle,
    required this.onNaviguerVersInscription,
    required this.onMotDePasseOublie,
    this.isLoading = false,
    this.erreur,
  });

  final Future<void> Function(String email, String motDePasse) onConnexion;
  final Future<void> Function() onConnexionGoogle;
  final VoidCallback onNaviguerVersInscription;
  final VoidCallback onMotDePasseOublie;
  final bool isLoading;
  final String? erreur;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _motDePasseController = TextEditingController();
  bool _motDePasseVisible = false;
  String? _erreurEmail;
  String? _erreurMotDePasse;

  @override
  void dispose() {
    _emailController.dispose();
    _motDePasseController.dispose();
    super.dispose();
  }

  bool _validerFormulaire() {
    setState(() {
      _erreurEmail = _emailController.text.trim().isEmpty
          ? 'L\'email est requis'
          : (!_emailController.text.contains('@') ? 'Email invalide' : null);
      _erreurMotDePasse = _motDePasseController.text.isEmpty
          ? 'Le mot de passe est requis'
          : null;
    });
    return _erreurEmail == null && _erreurMotDePasse == null;
  }

  void _soumettre() {
    if (_validerFormulaire()) {
      widget.onConnexion(
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
              const SizedBox(height: 16),
              const Text(
                'QuizMaster',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                'APPRENDS • TESTE • PROGRESSE',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1,
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bienvenue !',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Connecte-toi pour accéder à ton espace et relever de nouveaux défis.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 24),
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
              const SizedBox(height: 8),
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
                const SizedBox(height: 8),
              ],
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: widget.onMotDePasseOublie,
                  child: const Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              AppButton(
                label: 'Se connecter',
                onPressed: _soumettre,
                isLoading: widget.isLoading,
              ),
              const SizedBox(height: 24),
              _buildSeparateur(),
              const SizedBox(height: 24),
              AppButton(
                label: 'Continuer avec Google',
                isOutlined: true,
                onPressed: widget.onConnexionGoogle,
                icon: const GoogleLogo(),
              ),
              const SizedBox(height: 24),
              _buildLienInscription(),
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

  Widget _buildSeparateur() {
    return Row(
      children: const [Expanded(child: Divider(color: Color(0xFFE5E7EB)))],
    );
  }

  Widget _buildLienInscription() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: AppColors.textSecondaryLight,
          fontSize: 13,
        ),
        children: [
          const TextSpan(text: 'Pas encore de compte ? '),
          TextSpan(
            text: 'S\'inscrire',
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = widget.onNaviguerVersInscription,
          ),
        ],
      ),
    );
  }
}
