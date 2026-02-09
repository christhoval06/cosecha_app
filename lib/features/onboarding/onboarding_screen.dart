import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cosecha_app/l10n/app_localizations.dart';
import 'package:cosecha_app/core/constants/app_routes.dart';
import 'package:cosecha_app/core/constants/app_prefs.dart';

import 'package:cosecha_app/features/onboarding/onboarding_item.dart';
import 'package:cosecha_app/features/onboarding/widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controlador para el PageView
  final _pageController = PageController();
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppPrefs.onboardingComplete, true);

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.profileSetup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final List<OnboardingItem> slides = [
      OnboardingItem(
        icon: Icons.point_of_sale,
        title: l10n.onboardingSlide1Title,
        description: l10n.onboardingSlide1Description,
      ),
      OnboardingItem(
        icon: Icons.inventory_2_outlined,
        title: l10n.onboardingSlide2Title,
        description: l10n.onboardingSlide2Description,
      ),
      OnboardingItem(
        icon: Icons.bar_chart_rounded,
        title: l10n.onboardingSlide3Title,
        description: l10n.onboardingSlide3Description,
      ),
    ];

    final isLastPage = _currentPage == slides.length - 1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface.withOpacity(0),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _completeOnboarding,
            child: Text(l10n.onboardingSkip),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // El PageView que ocupa la mayor parte de la pantalla
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  final item = slides[index];
                  return OnboardingPage(slide: item);
                },
              ),
            ),

            // Indicadores de Puntos y Botón
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DotsIndicator(
                    dotsCount: slides.length,
                    position: _currentPage,
                    decorator: DotsDecorator(
                      color: theme.colorScheme.outlineVariant,
                      activeColor: theme.colorScheme.primary,
                      size: const Size.square(9.0),
                      activeSize: const Size(
                        24.0,
                        9.0,
                      ), // Hace que el punto activo sea más ancho
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),

                  FilledButton(
                    onPressed: () {
                      if (isLastPage) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Icon(isLastPage ? Icons.check : Icons.arrow_forward),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
