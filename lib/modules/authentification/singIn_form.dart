import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/code_otp_service.dart';
import '../../services/otp_service.dart';
import '../../services/registration_service.dart';
import '../bar_navigation/bouton_navigation_bar.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  State<SignForm> createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _nomFocusNode = FocusNode();
  final FocusNode _prenomFocusNode = FocusNode();
  final FocusNode _contactFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  String? genre; // Variable pour stocker la valeur 'Mr' ou 'Mdme'
  String? groupValue; // Variable pour gérer le groupValue des RadioListTile
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late Timer _timer;
  int _start = 60;
  bool _showResendText = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_start == 1) {
          _showResendText = true;
          _timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  Future<void> _onResendCode() async {
    final codeOtpService = CodeOtpService();
    bool success = await codeOtpService.resendOtp();

    if (success) {
      print('Code renvoyé avec succès');
      setState(() {
        _start = 60;
        _showResendText = false;
        startTimer();
      });
    } else {
      print('Échec du renvoi du code');
    }
  }

  void _handleRadioValueChange(String? value) {
    setState(() {
      groupValue = value;

      if (value == 'Homme') {
        genre = 'Mr';
      } else if (value == 'Femme') {
        genre = 'Mdme';
      }
    });
  }

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
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller4.dispose();
    _timer.cancel();
    super.dispose();
  }



  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      //_submitForm();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  String getCode() {
    return _controller1.text + _controller2.text + _controller3.text + _controller4.text;
  }

  void _submitOTP() async {
    final otpService = OTPService();

    // Récupérer le code OTP depuis les TextFields
    final otpCode = getCode();

    // Envoyer l'OTP via le service
    final success = await otpService.sendOTP(otpCode);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BarDeNavigation()),
      );
      // OTP validé avec succès
      // Naviguer vers la page suivante ou effectuer d'autres actions
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur de validation de l\'OTP. Veuillez réessayer.')),
      );
    }
  }



  void _register() async {
    if (_emailController.text.isEmpty ||
        _prenomController.text.isEmpty ||
        _nomController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _contactController.text.isEmpty ||
        genre == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir tous les champs')),
      );
      return;
    }

    final registrationService = RegistrationService();

    final result = await registrationService.registerUser(
      email: _emailController.text,
      firstname: _prenomController.text,
      lastname: _nomController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      contact: _contactController.text,
      civility: genre!,
    );

    if (result != null && result['data'] != null && result['token'] != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('uuid', result['data']['uuid'] ?? '');
      prefs.setString('first_name', result['data']['first_name'] ?? '');
      prefs.setString('last_name', result['data']['last_name'] ?? '');
      prefs.setString('email', result['data']['email'] ?? '');
      prefs.setString('contact', result['data']['contact'] ?? '');
      prefs.setString('pack', result['pack']?['name'] ?? '');
      prefs.setString('access_token', result['token']['access_token'] ?? '');

      _nextPage();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors de l\'inscription. Veuillez réessayer.')),
      );
    }
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
          "Inscription",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Nous nous authentifions pour une vie équilibrée", style: TextStyle(fontSize: 13),),
                Container(
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(child: Text("${_currentPage + 1}/2")),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / 2, // Pourcentage de progression (entre 0.0 et 1.0)
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildPage1(size),
                _buildPage2(size),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: _previousPage,
              child: Container(
                height: size.height * 0.07,
                width: size.height * 0.07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.cyan,
                  )
                ),
                child: const Icon(Icons.arrow_back),
              ),
            ),
            Container(
              width: size.width * 0.8,
              height: size.height * 0.07,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.cyan,
              ),
              child: TextButton(
                onPressed: _currentPage == 1 ? _submitOTP : _register,
                child: Text(
                  _currentPage == 1 ? "S'inscrire" : "Suivant",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1(Size size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: const EdgeInsets.all(0.0),
                    title: const Text('Homme'),
                    tileColor: Colors.cyan.shade100,
                    value: 'Homme',
                    dense: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    groupValue: groupValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: const EdgeInsets.all(0.0),
                    title: const Text('Femme'),
                    tileColor: Colors.cyan.shade100,
                    value: 'Femme',
                    dense: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    groupValue: groupValue,
                    onChanged: _handleRadioValueChange,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          _buildTextField(
            size: size,
            focusNode: _nomFocusNode,
            controller: _nomController,
            hintText: "Nom",
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.text, // Clavier pour texte
          ),
          const SizedBox(height: 10.0),
          _buildTextField(
            size: size,
            focusNode: _prenomFocusNode,
            controller: _prenomController,
            hintText: "Prenoms",
            prefixIcon: Icons.person_outline,
            keyboardType: TextInputType.text, // Clavier pour texte
          ),
          const SizedBox(height: 10.0),
          _buildTextField(
            size: size,
            focusNode: _emailFocusNode,
            controller: _emailController,
            hintText: "E-mail",
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress, // Clavier pour texte
          ),
          const SizedBox(height: 10.0),
          _buildTextField(
            size: size,
            focusNode: _contactFocusNode,
            controller: _contactController,
            hintText: "Contact",
            prefixIcon: Icons.contact_mail_outlined,
            keyboardType: TextInputType.number, // Clavier pour texte
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
        ],
      ),
    );
  }

  Widget _buildPage2(Size size) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Verification',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Entrer votre code OTP",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black38,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 28,
            ),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _textFieldOTP(first: true, last: false, controller: _controller1),
                    _textFieldOTP(first: false, last: false, controller: _controller2),
                    _textFieldOTP(first: false, last: false, controller: _controller3),
                    _textFieldOTP(first: false, last: true, controller: _controller4),
                  ],
                ),
                const SizedBox(
                  height: 22,
                ),
                _showResendText
                    ? RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Vous n'avez pas reçu de code ? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "Renvoyer",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = _onResendCode,
                      ),
                    ],
                  ),
                )
                    : Text(
                  "$_start secondes",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _textFieldOTP({required bool first, required bool last, required TextEditingController controller}) {
    return SizedBox(
      height: 65,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          controller: controller,
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.black12),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: Colors.cyan),
                borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required Size size,
    required FocusNode focusNode,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    required TextInputType keyboardType, // Paramètre requis
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
        keyboardType: keyboardType, // Utilise le type de clavier spécifié
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
