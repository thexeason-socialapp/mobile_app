import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thexeasonapp/presentation/features/auth/widgets/auth_button.dart';
import 'package:thexeasonapp/presentation/features/auth/widgets/auth_text_field.dart';
import 'package:thexeasonapp/src/theme/spacer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

   TextEditingController _usernameController = TextEditingController();
   TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Column(
          children: [
            //Username field
            AuthTextField(controller: _usernameController, title:"Username or Email", type: TextInputType.text),
            spacer,
            //Password field
            AuthTextField(controller: _usernameController, title:"Forgot Password?", type: TextInputType.text),            
            spacer,
            //forgot password button
            Text("Forgot Password?", textAlign: TextAlign.right,),
            spacer,
            //login button
            AuthButton(action: (){}, title: "Login"),
            //or
            //Google sign in
            //Fb sign in

            //Sign up

          ],
        ),
      ),
    );
  }
}