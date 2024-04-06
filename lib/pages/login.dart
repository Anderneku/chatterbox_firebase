import 'package:chatterbox/pages/chat.dart';
import 'package:chatterbox/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:appwrite/models.dart' as models;
class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  models.User? loggedInUser;
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController loginNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Color.fromARGB(255, 29, 31, 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold),),
                ),
                flex: 1,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 30.0, left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email", style: TextStyle(color: Colors.white, fontSize: 15.0)),
                          TextField(
                            // controller
                            style: TextStyle(color: Colors.white),
                            controller: loginEmailController,
                            decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(width: 2.0))),
                          ),
                      ],
                    ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 30.0, left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Password", style: TextStyle(color: Colors.white, fontSize: 15.0)),
                          TextField(
                            // controller
                            controller: loginPasswordController,
                            style: TextStyle(color: Colors.white),
                            obscureText: true,
                            decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(width: 2.0))),
                          ),
                      ],
                    ),
                    ),

                    Padding(
                          padding: EdgeInsets.only(bottom: 30.0, left: 20.0, right: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            ElevatedButton(onPressed: () async {
                              try {
                                Center(child: CircularProgressIndicator(),);
                                await FirebaseAuth.instance.signInWithEmailAndPassword(email: loginEmailController.text, password: loginPasswordController.text);
                                Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new Chat()));
                              } on FirebaseAuthException{
                                const snackBar = SnackBar(
                                content: Text('Error logging in!', style: TextStyle(color: Colors.white),),
                                backgroundColor: Colors.redAccent,
                              );

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            }, 
                            child: Text("LOGIN"), style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))))),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center, 
                              mainAxisAlignment: MainAxisAlignment.center, 
                              children: [
                                Text("Don't have an account?", style: TextStyle(color: Colors.white, fontSize: 15.0)), 
                                TextButton(
                                  onPressed: (){
                                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new Signup()));
                                  }, 
                                  child: Text("Sign Up")),
                                ]),
                            ]
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 50, 140, 229),
        title: Center(child: Text("Chatterbox", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40))),
      ),
    );
  }
}