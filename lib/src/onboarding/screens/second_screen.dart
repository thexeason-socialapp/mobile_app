import 'package:flutter/material.dart';

import '../../../demo.dart';
import '../../theme/spacer.dart';
import '../../widgets/buttons/button.dart';

class SecondOnboardingScreen extends StatefulWidget {
  const SecondOnboardingScreen({super.key});

  @override
  State<SecondOnboardingScreen> createState() => _SecondOnboardingScreenState();
}

class _SecondOnboardingScreenState extends State<SecondOnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  //Title
                         Text("Share Your", style: Theme.of(context).textTheme.displayLarge,),
                         Text("Thoughts", style: Theme.of(context).textTheme.displayLarge,),
                        spacer,
                        //subtitle
                         Text("Express yourself freely", style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center,),
                        spacer,
                        //Image
                        Container(
                          padding: EdgeInsets.all(10),
                          height: 500,
                          width: double.infinity,
                          child: Image.asset( "assets/images/onboarding_first.webp", fit: BoxFit.contain,),
                        ),
                        
                  spacer,
                        //Button
                        MainButton(onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MainApp()));
                        }, title: "Next"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}