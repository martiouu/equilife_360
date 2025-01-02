import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../services/roue_vie_service.dart';

class LifeWheel extends StatefulWidget {
  const LifeWheel({super.key});

  @override
  _LifeWheelState createState() => _LifeWheelState();
}

class _LifeWheelState extends State<LifeWheel> {
  List<String> sections = [];
  List<int> scores = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchResponses();
  }

  Future<void> _fetchResponses() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = RoueVieService();
      final response = await service.fetchLatestResponses();

      // Parser les données
      final data = response['data'] as List<dynamic>;

      // Initialiser les listes
      final List<String> extractedSections = [];
      final List<int> extractedScores = [];

      for (var item in data) {
        final title = item['title'] as String;
        final answerStr = item['answer'] as String;

        // Convertir la chaîne en nombre
        final answer = double.tryParse(answerStr)?.toInt() ?? 0;

        // Ajouter le titre à la liste des sections s'il n'est pas déjà présent
        if (!extractedSections.contains(title)) {
          extractedSections.add(title);
        }

        // Ajouter la réponse à la liste des scores
        extractedScores.add(answer);
      }

      // Mettre à jour l'état avec les nouvelles données
      setState(() {
        sections = extractedSections;
        print("sections: $sections");
        scores = extractedScores;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Une erreur est survenue : $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'lifeWheelHero',
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [
            // Contenu principal
            if (!_isLoading && _errorMessage.isEmpty)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 100, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, 'Quizz');
                          },
                          child: Text(
                            "Aller au questionnaire",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.cyan.shade900,
                              decoration: TextDecoration.none, // Assurez-vous qu'il n'y ait pas de soulignement
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close, color: Colors.cyan.shade900),
                        ),
                      ],
                    ),
                  ),
                  CustomPaint(
                    size: const Size(350, 350),
                    painter: LifeWheelPainter(sections, scores),
                  ),
                ],
              ),

            // Loader
            if (_isLoading)
              const Center(
                child: SpinKitDoubleBounce(
                  color: Colors.cyan,
                  size: 30.0,
                ),
              ),
            // Message d'erreur
            if (_errorMessage.isNotEmpty)
              Center(
                child: Text(_errorMessage),
              ),
          ],
        ),
      ),
    );
  }
}

class LifeWheelPainter extends CustomPainter {
  final List<String> sections;
  final List<int> scores;
  final int maxTitleLength = 12; // Longueur maximale avant troncation
  final double rotationOffset; // Offset de rotation

  LifeWheelPainter(this.sections, this.scores)
      : rotationOffset = -50 * (pi / 85); // Conversion de 50 pixels en radians pour une rotation vers la gauche

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 1, size.height / 2);
    final angle = (2 * pi) / sections.length;

    final paint = Paint()..style = PaintingStyle.fill;

    // Dessiner le cercle de référence à la valeur maximale (10)
    paint.color = Colors.grey.withOpacity(0.1); // Couleur pour le cercle de référence
    canvas.drawCircle(center, radius, paint);

    // Dessiner les sections selon les scores
    for (int i = 0; i < sections.length; i++) {
      final startAngle = i * angle + rotationOffset * 8; // Appliquer le décalage ici
      final sweepAngle = angle;

      // Calculer le rayon selon le score
      final sectionRadius = radius * (scores[i] / 10.0); // Assurez-vous que la division donne un double

      // Dessiner le secteur
      paint.color = Colors.primaries[i % Colors.primaries.length].withOpacity(0.8);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: sectionRadius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
    }

    // Dessiner les lignes pour chaque section
    for (int i = 0; i < sections.length; i++) {
      final x = center.dx + radius * cos(i * angle + rotationOffset * 8); // Appliquer le décalage ici
      final y = center.dy + radius * sin(i * angle + rotationOffset * 8); // Appliquer le décalage ici
      canvas.drawLine(center, Offset(x, y), Paint()..color = Colors.black);
    }

    // Ajouter le texte pour chaque section
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < sections.length; i++) {
      // Position originale
      final x = center.dx + (radius * 0.90) * cos(i * angle + rotationOffset);
      final y = center.dy + (radius * 0.90) * sin(i * angle + rotationOffset);

      // Troncation du titre si nécessaire
      final title = sections[i];
      final truncatedTitle = title.length > maxTitleLength
          ? '${title.substring(0, maxTitleLength)}...'
          : title;

      textPainter.text = TextSpan(
        text: truncatedTitle,
        style: const TextStyle(color: Colors.brown, fontSize: 12),
      );
      textPainter.layout();

      // Calculer le léger mouvement (10 pixels) vers la droite
      final offsetX = x + 10 * cos(i * angle + rotationOffset); // Décalage horizontal
      final offsetY = y + 10 * sin(i * angle + rotationOffset); // Décalage vertical

      // Appliquer la transformation de rotation
      canvas.save(); // Sauvegarder l'état du canevas
      canvas.translate(offsetX, offsetY); // Déplacer le canevas à la position du texte
      canvas.rotate(rotationOffset + (i * angle) + (pi / 2)); // Rotation pour orienter le texte

      // Centrer le texte par rapport à son point d'origine
      canvas.translate(-textPainter.width / 2, -textPainter.height / 2);

      // Dessiner le texte
      textPainter.paint(canvas, Offset.zero);
      canvas.restore(); // Restauration de l'état du canevas
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}




