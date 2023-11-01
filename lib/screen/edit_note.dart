
// ignore_for_file: prefer_const_constructors, avoid_print, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_net/screen/home.dart';
 
class EditNote extends StatefulWidget {
  const EditNote({super.key, required this.editDocid, required this.oldTitle, required this.oldNote });
  final String editDocid;
  final String oldTitle;
  final String oldNote;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

   TextEditingController title = TextEditingController();
   TextEditingController note = TextEditingController();


  CollectionReference users = FirebaseFirestore.instance.collection('users');

Future<void>EditNote(){
  return users.doc(widget.editDocid)
          .update({
            'title': title.text, 
            'note': note.text,  
            
           
          })
          .then((value) => print("User Update"))
          .catchError((error) => print("Failed to update user: $error"));
        
 }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title.text = widget.oldTitle;
    note.text = widget.oldNote;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title:  Text("EDIT NOTE".tr),centerTitle: true,
        actions: [
          ElevatedButton.icon(onPressed: ()async{
            await EditNote();
              Get.to(()=> HomeScreen());
             
          }, icon: Icon(Icons.save), label: Text("Save".tr)),
        ],
      ),
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
            
            ],
           ),
         ))

        ],
      ),
    );
  }
}