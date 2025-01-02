import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../services/reset_password_service.dart';

class NewPassword extends StatefulWidget {
  final String email;
  const NewPassword({super.key, required this.email});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureText = true;
  bool _obscureConfirmText = true;

  final ResetPasswordService _resetPasswordService = ResetPasswordService(); // Instanciation du service

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmText = !_obscureConfirmText;
    });
  }

  void _resetPassword() async {
    final email = widget.email;
    final token = _codeController.text.trim();
    final newPassword = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    // Afficher les valeurs pour le débogage
    print('Token: $token');
    print('Email: $email');
    print('New Password: $newPassword');
    print('Confirm Password: $confirmPassword');

    // Appel au service de réinitialisation de mot de passe
    final response = await _resetPasswordService.resetPassword(
      token: token,
      email: email,
      newPassword: newPassword,
      confirm: confirmPassword,
    );

    // Afficher la réponse pour le débogage
    print('API Response: ${response.toString()}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['message'])),
    );

    if (response['type'] == 'success') {
      // Naviguer vers la page souhaitée après succès
      print("OK");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade50,
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade50,
        title: const Text(
          "Modifier votre mot de passe",
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Column(
          children: [
            TextFormField(
              controller: _codeController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Entrer le code reçu par e-mail",
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SvgPicture.asset("assets/icons/password-check-svgrepo-com.svg"),
                ),
                fillColor: Colors.white70,
                filled: true,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Entrer le mot de passe",
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SvgPicture.asset("assets/icons/password-check-svgrepo-com.svg"),
                ),
                fillColor: Colors.white70,
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.cyan,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmText,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "Resaisissez le mot de passe",
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SvgPicture.asset("assets/icons/password-check-svgrepo-com.svg"),
                ),
                fillColor: Colors.white70,
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.cyan,
                  ),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.cyan,
              ),
              child: TextButton(
                onPressed: _resetPassword,
                child: const Text(
                  "Valider",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
