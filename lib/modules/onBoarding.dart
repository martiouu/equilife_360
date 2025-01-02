import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'authentification/login_form.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late PageController _pageController;
  int _pageIndex = 0;

  final List<Introduction> list = [
    Introduction(
      title: 'Bienvenue dans EquiLife360',
      subTitle: 'Equilife 1',
      imageUrl: 'assets/6183523_3071347.webp',
    ),
    Introduction(
      title: 'Page 2',
      subTitle: 'Equilife 2',
      imageUrl: 'assets/43309778_9019641.webp',
    ),
    Introduction(
      title: 'Page 3',
      subTitle: 'Equilife 3',
      imageUrl: 'assets/44954733_9045633.webp',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginForm(), // Remplacez par votre écran d'accueil
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: list.length,
                  onPageChanged: (int index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          list[index].imageUrl,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          list[index].title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          list[index].subTitle,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dots indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: list.length,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.cyan,
                      dotHeight: 7,
                      dotWidth: 7,
                    ),
                  ),
                  // Bouton de swipe
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      foregroundColor: Colors.white,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                    ),
                    onPressed: () {
                      if (_pageIndex < list.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      } else {
                        _navigateToHome();
                      }
                    },
                    child: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
