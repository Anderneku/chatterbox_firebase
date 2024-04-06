import 'package:chatterbox/pages/login.dart';
import 'package:chatterbox/pages/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:date_format/date_format.dart';

class Chat extends StatefulWidget {

  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  
  final TextEditingController message_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 31, 48),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("messages").orderBy("timestamp").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(),);
                  } else if (snapshot.hasError){
                    return Center(child: Text("Error don show"),);
                  } else{
                    List<Message> messages = snapshot.data!.docs.map((doc) {
                      return Message(body: doc["body"], timestamp: (doc["timestamp"] as Timestamp).toDate(), email: doc["email"], username: doc["username"]);
                    }).toList();
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Align(
                          alignment: messages[index].email == FirebaseAuth.instance.currentUser?.email ? Alignment.centerRight : Alignment.centerLeft,
                          child: Card(
                            elevation: 8,
                            color: messages[index].email == FirebaseAuth.instance.currentUser?.email ? Colors.green : Colors.purple,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(messages[index].username, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                  Text(messages[index].body, style: const TextStyle(color: Colors.white),),
                                  Text(formatDate(messages[index].timestamp, [HH, ':', mm]), style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                  controller: message_controller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(251, 255, 255, 255),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                        contentPadding: EdgeInsets.all(12),
                        hintText: "Type your message here...",
                    )
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  child: IconButton(onPressed: () async {
                    try {
                      DocumentSnapshot userDoc = await FirebaseFirestore
                      .instance
                      .collection("users").doc(FirebaseAuth.instance.currentUser?.email).get();
                      
                      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
                      String username = userData["username"];

                      await FirebaseFirestore.instance.collection("messages").add({
                        "body" : message_controller.text,
                        "email" : FirebaseAuth.instance.currentUser?.email,
                        "username" : username,
                        "timestamp" : DateTime.now()
                      });
                    } catch (e) {
                      print(e);
                    }
                  }, 
                  icon: Icon(Icons.send, size: 25, color: const Color.fromARGB(255, 255, 255, 255),)),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Color.fromARGB(255, 107, 166, 107)),
                )
                
              ],
            )
            
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 50, 140, 229),
        title: Center(child: Text("Chatterbox", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40))),
        actions: [
          IconButton(onPressed: (){
          FirebaseAuth.instance.signOut();
          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => new Login()));
           }, 
        icon: Icon(Icons.logout_rounded, color: Colors.white, size: 30,))
        ],
      ),
    );
  }
}