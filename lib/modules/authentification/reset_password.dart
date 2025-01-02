
import 'package:flutter/material.dart';

import '../../services/send_email_service.dart';
import 'new_password.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  void _resetPassword() async {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final response = await _authService.sendResetEmail(email);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );

      if (response['type'] == 'success') {
        // Naviguer directement vers NewPasswordPage après succès
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewPassword(email: email), // Passer l'email
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/illustration.webp",
                  height: 350,
                ),
              ),
              const Text(
                "Réinitialiser le Mot de Passe",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "Veuillez entrer votre adresse e-mail",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        prefixIcon: const Icon(
                          Icons.mail_outline,
                          color: Colors.cyan,
                        ),
                        hintText: "Adresse e-mail",
                        hintStyle: const TextStyle(color: Colors.cyan),
                        fillColor: Colors.cyan.shade50,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer votre adresse e-mail';
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Adresse e-mail invalide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
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
                          "Rééinitialiser",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
