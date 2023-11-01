

// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
 

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key, this.viewnote});
  final viewnote;
  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title:   Text("View Note".tr),centerTitle: true,),
    
         body: Expanded(
           child: Padding(
             padding: const EdgeInsets.all(15),
             child: ListView(
                  children: [
                        Center(
                          child: Text("${widget.viewnote['title']}",
                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                        ), 
                       Text("${widget.viewnote['note']}",
                        style: const TextStyle(fontSize: 16),),
 
                    
                  ],
             ),
           ),
         ),
    );
  }
}