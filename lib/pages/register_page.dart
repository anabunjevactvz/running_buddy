import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPgeState();
}

class _RegisterPgeState extends State<RegisterPage> {

  final emailTextController = TextEditingController();
  final passwordTextConroller = TextEditingController();
  final confirmPasswordTextConroller = TextEditingController();

  Future<void> signUp() async {
    if(passwordTextConroller.text != confirmPasswordTextConroller.text){
      Navigator.pop(context);
      displayMessage("Passwords don't match!");
      return;
    }

    try {
      UserCredential userCredential =  await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextConroller.text,
      );
      
      FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email!).set(
          {'username' : emailTextController.text.split('@')[0],
          'about': 'About...'});
      
    } on FirebaseAuthException catch (e){
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Create an account!"),
              const SizedBox(height: 25),
              MyTextField(
                  controller: emailTextController,
                  hintText: 'Email',
                  obsecureText: false),
              const SizedBox(height: 10),
              MyTextField(
                  controller: passwordTextConroller,
                  hintText: 'Password',
                  obsecureText: true),
              const SizedBox(height: 10),
              MyTextField(
                  controller: confirmPasswordTextConroller,
                  hintText: 'Confirm password',
                  obsecureText: true),
              const SizedBox(height: 25),
              MyButton(onTap: widget.onTap, text: 'Sign up'),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Have an account? Login now!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
