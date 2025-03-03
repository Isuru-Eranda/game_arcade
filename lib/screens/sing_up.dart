import 'package:flutter/material.dart';
import 'package:game_arcade/screens/login.dart';
import 'package:game_arcade/widget/button.dart';
import 'package:game_arcade/widget/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignUpScreen> {
  // for controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController(); 
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
                icon: Icons.person,
                textEditingController: emailController,
                hintText: 'Enter your name',
                textInputType: TextInputType.text),
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
            
              MyButtons(
                onTap: (){

                }, text: "Sign Up"),
              SizedBox(height: height / 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,),
                      ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                         MaterialPageRoute(
                          builder: (context)=> const LoginScreen(),
                          ),
                        );
                       },
                  child: Text(
                    "Login",
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