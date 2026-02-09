import 'dart:async';

import 'package:cosecha_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';

import '../onboarding_item.dart';

class OnboardingPage extends StatefulWidget {
  final OnboardingItem slide;

  const OnboardingPage({super.key, required this.slide});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  Timer? _hapticTimer;

  @override
  void initState() {
    super.initState();
    _startHapticFeedback();
  }

  void _startHapticFeedback() {
    const int hapticFrequency = 3;
    const Duration charAnimationSpeed = Duration(
      milliseconds: AppConstants.slideTextAnimationDuration,
    );
    Duration hapticTickDuration = Duration(
      milliseconds: charAnimationSpeed.inMilliseconds * hapticFrequency,
    );

    if (widget.slide.description.isNotEmpty) {
      _hapticTimer = Timer.periodic(hapticTickDuration, (timer) {
        HapticFeedback.lightImpact();
      });

      final int animationDuration =
          widget.slide.description.length * charAnimationSpeed.inMilliseconds;
      Future.delayed(Duration(milliseconds: animationDuration), () {
        _hapticTimer?.cancel();
      });
    }
  }

  @override
  void dispose() {
    _hapticTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.slide.icon, size: 120, color: theme.primaryColor),
          const SizedBox(height: 48),
          Text(
            widget.slide.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          DefaultTextStyle(
            style: theme.textTheme.bodyLarge!.copyWith(height: 1.5),
            textAlign: TextAlign.center,
            child: AnimatedTextKit(
              key: ValueKey(widget.slide.title),
              totalRepeatCount: 1,
              animatedTexts: [
                TypewriterAnimatedText(
                  widget.slide.description,
                  speed: const Duration(
                    milliseconds: AppConstants.slideTextAnimationDuration,
                  ),
                  cursor: '|',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
