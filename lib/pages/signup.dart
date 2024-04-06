import 'package:chatterbox/pages/chat.dart';
import 'package:chatterbox/pages/login.dart';
import 'package:chatterbox/setup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  models.User? loggedInUser;
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();
  final TextEditingController signupNameController = TextEditingController();

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
                  child: Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.bold),),
                ),
                flex: 1,
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 30.0, left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Username", style: TextStyle(color: Colors.white, fontSize: 15.0)),
                          TextField(
                            // controller
                            style: TextStyle(color: Colors.white),
                            controller: signupNameController,
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
                          Text("Email", style: TextStyle(color: Colors.white, fontSize: 15.0)),
                          TextField(
                            // controller
                            style: TextStyle(color: Colors.white),
                            controller: signupEmailController,
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
                            controller: signupPasswordController,
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
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                    Future<void> createUserDocument(UserCredential userCredential) async{
                                      if (userCredential != null && userCredential.user != null) {
                                      await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(userCredential.user!.email)
                                        .set(
                                          {
                                            "email" : userCredential.user!.email,
                                            "username" : signupNameController.text
                                          }
                                      );
                                    }
                                  }
                                  UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: signupEmailController.text, 
                                    password: signupPasswordController.text
                                    );
                                  createUserDocument(userCredential);
                                  Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new Chat()));
                                } on FirebaseAuthException{
                                const snackBar = SnackBar(
                                content: Text('Error logging in!', style: TextStyle(color: Colors.white),),
                                backgroundColor: Colors.redAccent,
                              );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              }, 
                              child: Text("SIGN UP"), style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))))),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center, 
                              mainAxisAlignment: MainAxisAlignment.center, 
                              children: [
                                Text("Already have an account?", style: TextStyle(color: Colors.white, fontSize: 15.0)), 
                                TextButton(
                                  onPressed: (){
                                    Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new Login()));
                                    }, 
                                  child: Text("Sign In")),
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