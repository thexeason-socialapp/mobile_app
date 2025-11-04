import 'package:flutter/material.dart';
import 'package:thexeasonapp/src/onboarding/screens/first_screen.dart';
import 'package:thexeasonapp/src/onboarding/screens/second_screen.dart';
import 'package:thexeasonapp/src/onboarding/screens/third_screen.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentindex = 0;
  List<Widget> pages = [
    const FirstOnboardScreen(),
    const SecondOnboardingScreen(),
    const ThirdOnboardingScreen(),
  ];
  @override

  Widget build(BuildContext context) {
    return  Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 10),
        child: PageView(
          onPageChanged: (index){
            setState(() {
              currentindex = index;
            });
          },
          children: pages,
        ),
      ),
    );
  }
}