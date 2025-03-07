import 'package:flutter/material.dart';
import 'package:game_arcade/screens/home_page.dart';
import 'package:game_arcade/screens/sing_up.dart';
import 'package:game_arcade/widget/button.dart';
import 'package:game_arcade/widget/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  // for controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SafeArea(
          child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: height / 2.7,
              child: Image.asset('images/game_logo.jpg'),
            ),
            TextFieldInput(
                icon: Icons.email,
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.text),
            TextFieldInput(
              icon: Icons.lock,
              textEditingController: passwordController,
              hintText: 'Enter your passord',
              textInputType: TextInputType.text,
              isPass: true,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ),
              MyButtons(onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              }, text: "Log In"),
              SizedBox(height: height / 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,),
                      ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                         MaterialPageRoute(
                          builder: (context)=> const SignUpScreen()
                          ),
                        );
                       },
                  child: Text(
                    "SingUp",
                    style: TextStyle(
                      fontWeight:FontWeight.bold,fontSize: 16
                      ),
                      ),
                  ),
                  ],
                  ),
          ],
        ),
      )),
    );
  }
}
