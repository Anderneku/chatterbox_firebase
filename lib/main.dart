import 'package:chatterbox/pages/chat.dart';
import 'package:chatterbox/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    
  ));

  // final value = await documents;
  // print(value.documents.length);
}


class MyApp extends StatefulWidget {
  MyApp();
  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  // Future<void> logout() async {
  //   await widget.account.deleteSession(sessionId: 'current');
  //   setState(() {
  //     loggedInUser = null;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null ? Login() : Chat()
      
    );
  }
}
