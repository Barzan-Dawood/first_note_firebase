
// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_net/screen/home.dart';
 
class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

   TextEditingController title = TextEditingController();
   TextEditingController note = TextEditingController();
 

  CollectionReference users = FirebaseFirestore.instance.collection('users');

Future<void>addNote(){
  return users
          .add({
            'title': title.text, 
            'note': note.text, 
             'created': DateTime.now(), 
            "email" : FirebaseAuth.instance.currentUser!.email,
            "uid" : FirebaseAuth.instance.currentUser!.uid,
          
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
        
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ADD NOTE".tr),centerTitle: true),
      body:  Column(
        children:   [
          
         Expanded(child: Padding(
           padding: EdgeInsets.all(20),
           child: Column(
            children: [
               TextField(
                controller: title,
              decoration: InputDecoration(
                hintText:  "Title".tr,
                hintStyle: TextStyle(color: Colors.grey,
                fontSize: 26,
                fontWeight: FontWeight.bold),
                border: InputBorder.none
              ),
            ),
            TextField(
             controller: note,
              decoration: InputDecoration(
                hintText: "Note".tr,
                hintStyle: TextStyle(color: Colors.grey,
                fontSize: 24,
                ),
                border: InputBorder.none
                
              ),
            ),
            ElevatedButton(onPressed: ()async{
              await addNote();
              Get.to(()=> HomeScreen());
              title.clear();
              note.clear();
            }, child: Text("Add".tr)),
            ],
           ),
         ))

        ],
      ),
    );
  }
}