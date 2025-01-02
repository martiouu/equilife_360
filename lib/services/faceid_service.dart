import 'package:local_auth/local_auth.dart';

class FaceIDService {
  final LocalAuthentication _auth = LocalAuthentication();

  // Nouvelle méthode pour vérifier si l'appareil prend en charge l'authentification biométrique
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      print('Erreur lors de la vérification de la prise en charge de l\'appareil : $e');
      return false;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    try {
      // Vérifier si l'appareil prend en charge l'authentification biométrique
      bool canAuthenticate = await _auth.isDeviceSupported();
      if (!canAuthenticate) {
        print("L'appareil ne prend pas en charge l'authentification biométrique.");
        return false;
      }

      // Authentifier l'utilisateur avec biométrie (Face ID ou empreinte digitale)
      bool isAuthenticated = await _auth.authenticate(
        localizedReason: 'Connectez-vous avec Face ID ou empreinte digitale',
        options: const AuthenticationOptions(
          biometricOnly: true, // Assurez-vous que seules les méthodes biométriques sont utilisées
        ),
      );
      return isAuthenticated;
    } catch (e) {
      print('Erreur d\'authentification biométrique: $e');
      return false;
    }
  }
}
