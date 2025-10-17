import 'package:flutter/material.dart';
import 'package:thexeasonapp/demo.dart';
import 'package:thexeasonapp/src/theme/spacer.dart';
import 'package:thexeasonapp/src/widgets/buttons/button.dart';

class FirstOnboardScreen extends StatelessWidget {
  const FirstOnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  //Icon
                  CircleAvatar(radius: 30,),
                  spacer,
            
                  //Title
                  Text("WELCOME TO", style: Theme.of(context).textTheme.displayLarge,),
                  Text("THEXEASON APP", style: Theme.of(context).textTheme.displayLarge,),
                  spacer,
                  //subtitle
                  Text("Discover your social world. Connect, Share and exxplore vibrant community", style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,),
                  spacer,
                  //Image
                  SizedBox(
                    // padding: EdgeInsets.all(10),
                    height: 350,
                    width: double.infinity,
                    child: Image.asset( "assets/images/onboarding_first.webp", fit: BoxFit.contain,),
                    //color: Theme.of(context).primaryColor
                  ),
                  
            spacer,
                  //Button
                  MainButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MainApp()));
                  }, title: "Get Started"),
                  spacer,
                  // MainButton(onPressed: (){}, title: "Login"),
            
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}