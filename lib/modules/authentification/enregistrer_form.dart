import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EnregisterForm extends StatefulWidget {
  const EnregisterForm({super.key});

  @override
  State<EnregisterForm> createState() => _EnregisterFormState();
}

class _EnregisterFormState extends State<EnregisterForm> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _nomFocusNode = FocusNode();
  final FocusNode _prenomFocusNode = FocusNode();
  final FocusNode _contactFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();

  final bool _showAnimation = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;


 /* void _handleLogin() async {
    setState(() {
      _showAnimation = true;
    });

    bool success = await _registrationService.registerUser(
      email: _emailController.text,
      firstname: _prenomController.text,
      lastname: _nomController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      contact: _contactController.text,
    );

    setState(() {
      _showAnimation = false;
    });

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BarDeNavigation()),
      );
    } else {
      // Afficher une erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Échec de l\'inscription')),
      );
    }
  } */

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _nomFocusNode.dispose();
    _prenomFocusNode.dispose();
    _contactFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _passwordFocusNode.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Image.asset("assets/carre.webp", width: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "S'enregistrer à Equilife360",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text("Nous nous authentifions pour une vie équilibrée"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    _buildTextField(
                      size: size,
                      focusNode: _nomFocusNode,
                      controller: _nomController,
                      hintText: "Nom",
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 10.0),
                    _buildTextField(
                      size: size,
                      focusNode: _prenomFocusNode,
                      controller: _prenomController,
                      hintText: "Prenoms",
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 10.0),
                    _buildTextField(
                      size: size,
                      focusNode: _emailFocusNode,
                      controller: _emailController,
                      hintText: "E-mail",
                      prefixIcon: Icons.mail_outline,
                    ),
                    const SizedBox(height: 10.0),
                    _buildTextField(
                      size: size,
                      focusNode: _contactFocusNode,
                      controller: _contactController,
                      hintText: "Contact",
                      prefixIcon: Icons.contact_mail_outlined,
                    ),
                    const SizedBox(height: 10.0),
                    _buildPasswordField(
                      size: size,
                      focusNode: _passwordFocusNode,
                      controller: _passwordController,
                      hintText: "Mot de passe",
                      obscureText: _obscurePassword,
                      toggleObscureText: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    const SizedBox(height: 10.0),
                    _buildPasswordField(
                      size: size,
                      focusNode: _confirmPasswordFocusNode,
                      controller: _confirmPasswordController,
                      hintText: "Confirmer le mot de passe",
                      obscureText: _obscureConfirmPassword,
                      toggleObscureText: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: size.height * 0.08,
                      width: size.width * 0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.cyan,
                      ),
                      child: TextButton(
                        onPressed: (){},
                        child: const Text(
                          "S'inscrire",
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_showAnimation)
            Center(
              child: Lottie.asset(
                "assets/animations/Animation - 1721031172360.json",
                fit: BoxFit.cover,
                width: 150,
                height: 150,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required Size size,
    required FocusNode focusNode,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
  }) {
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: focusNode.hasFocus ? Colors.cyan : Colors.transparent,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: InputBorder.none,
          prefixIcon: Icon(prefixIcon, color: Colors.cyan),
          hintText: hintText,
          hintStyle: TextStyle(color: focusNode.hasFocus ? Colors.cyan : Colors.grey),
        ),
        onTap: () {
          setState(() {
            FocusScope.of(context).requestFocus(focusNode);
          });
        },
      ),
    );
  }

  Widget _buildPasswordField({
    required Size size,
    required FocusNode focusNode,
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback toggleObscureText,
  }) {
    return Container(
      height: size.height * 0.08,
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: focusNode.hasFocus ? Colors.cyan : Colors.transparent,
        ),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.lock_outline, color: Colors.cyan),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.cyan),
            onPressed: toggleObscureText,
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: focusNode.hasFocus ? Colors.cyan : Colors.grey),
        ),
        onTap: () {
          setState(() {
            FocusScope.of(context).requestFocus(focusNode);
          });
        },
      ),
    );
  }
}
