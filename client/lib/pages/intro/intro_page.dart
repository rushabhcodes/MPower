import 'package:client/pages/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return OnBoardingSlider(
      finishButtonText: 'Get Started',
      onFinish: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      skipTextButton: Text(
        'Skip',
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      controllerColor: Theme.of(context).colorScheme.onPrimary,
      totalPage: 3,
      headerBackgroundColor: Theme.of(context).colorScheme.surface,
      pageBackgroundColor: Theme.of(context).colorScheme.surface,
      background: [
        _buildLogoContainer(context, 'assets/one.png'),
        _buildLogoContainer(context, 'assets/two.png'),
        _buildLogoContainer(context, 'assets/three.png'),
      ],
      speed: 1.8,
      pageBodies: [
        _buildPageContent(
          context,
          "Hey there, I'm MM!",
          "Your friendly guide to a happier mind!",
        ),
        _buildPageContent(
          context,
          "Let's Track Your Mood!",
          "Complete fun quizzes, earn streaks, and collect rewards!",
        ),
        _buildPageContent(
          context,
          "Discover Personalized Support!",
          "From AI insights to virtual therapy sessions, I've got you covered!",
        ),
      ],
    );
  }

  Widget _buildLogoContainer(BuildContext context, String assetPath) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Center(
          child: Container(
            width: 200,
            height: 200,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
              borderRadius: const BorderRadius.all(Radius.circular(60)),
            ),
            child: ClipRect(
              child: Image.asset(
                assetPath,
                color: Theme.of(context).colorScheme.onPrimary,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(
      BuildContext context, String title, String subtitle) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        ],
      ),
    );
  }
}
