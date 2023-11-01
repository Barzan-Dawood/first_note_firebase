

// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_net/auth/login.dart';
import 'package:note_net/language/lan_controller.dart';
import 'package:note_net/screen/add_note.dart';
import 'package:note_net/screen/edit_note.dart';
import 'package:note_net/screen/view.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
   @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> { 

 List<QueryDocumentSnapshot> mydata = [];
    bool isloding = true;
   

 getData()async{
   QuerySnapshot querySnapshot = 
    await FirebaseFirestore.instance.collection("users")
    .where("uid" , isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    mydata.addAll(querySnapshot.docs);
    isloding = false;
    setState(() {
      
    });
 }

 @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    LangController langController = Get.find();

    return Scaffold(
       appBar: AppBar(title:   Text("Home Page".tr),centerTitle: true),
       drawer:   Drawer(
        backgroundColor: Colors.purple,
           child:   Column(
            children: [
              const SizedBox(height: 100),
              const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.person),
              ),
        const SizedBox(height: 50),
              ListTile(
                title: ElevatedButton.icon(onPressed: () {
                   if(Get.isDarkMode){
                    Get.changeTheme(ThemeData.light());
                   }
                   else{
                     Get.changeTheme(ThemeData.dark());
                   }
                },
                 icon: const Icon(Icons.dark_mode),
                  label:   Text("Theme".tr)),
              ),
 
               ListTile(
                title: ElevatedButton.icon(onPressed: () {
                   
                     showDialog(context: context, builder: (context){
              return   Expanded(
                child: AlertDialog(
                  backgroundColor: Colors.greenAccent,
                
                  actions: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
              
                      Center(child: TextButton(onPressed: (){
                            langController.changeLang("ar");
                            Get.back();
                      }, child:  Text("Arbic".tr,
                      style: const TextStyle(color: Colors.black,fontSize: 20),))),
            const Divider(color: Colors.red,),
                      Center(child: TextButton(onPressed: (){
                             langController.changeLang("en");
                              Get.back();
                      }, child:  Text("English".tr,
                      style: const TextStyle(color: Colors.black,fontSize: 20),))),
                      
                      ],
                    ),
                   
                  ],
                ),
              );
            });
                },
                 icon: const Icon(Icons.language),
                  label:   Text("Language".tr)),
              ),
               ListTile(
                title: ElevatedButton.icon(onPressed: () {
                 
                },
                 icon: const Icon(Icons.help_outline_rounded),
                  label:   Text("about".tr)),
              ),

               ListTile(
                title: ElevatedButton.icon(onPressed: ()async{
                   await FirebaseAuth.instance.signOut();
                  Get.offAll(()=> const Login());
                },
                 icon: const Icon(Icons.exit_to_app),
                  label:   Text("Exit".tr)),
              ),
            ],
          ),
       ),
       floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
         child: const Icon(Icons.add,color: Colors.white),
        onPressed: (){
          Get.to(()=> const AddNote());
        }),

       body: isloding == true ? const Center(child: CircularProgressIndicator()) :
        GridView.builder(
        itemCount: mydata.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3) , 
        itemBuilder: (BuildContext , i){
          return    InkWell(
            onLongPress: (){
   
            showDialog(context: context, builder: (context){
              return Expanded(
                child: AlertDialog(
                  backgroundColor: Colors.white54,
                  title: const Text(""),
                  actions: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
              // botton update
                      Center(
                        child: ElevatedButton.icon(onPressed: (){
                           Get.back();
                          Get.to(()=> EditNote(
                            editDocid: mydata[i].id, 
                            oldTitle: mydata[i]['title'],
                            oldNote: mydata[i]['note'],
                            )
                            );
                         
                        },
                         icon: const Icon(Icons.edit),
                          label:   Text("Edit".tr)),
                      ),

                 // botton delete     
                      const SizedBox(height: 15),
                     Center(
                       child: ElevatedButton.icon(onPressed: (){
                  Navigator.pop(context);
                showAdaptiveDialog(context: context, builder: (BuildContext){
                  return AlertDialog(
                 backgroundColor: Colors.red,
                    
                title:   Text("Are you sure you want to delete ?".tr,
                style: const TextStyle(fontSize: 18,color: Colors.white),),
                    actions: [
                      Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    TextButton(onPressed: ()async{
                     
                    await FirebaseFirestore.instance.collection("users").doc(mydata[i].id).delete(); 
                    Get.back(); 
                     Get.to(()=> const HomeScreen()); 
                   showMsg("", "Then delete successfully".tr, ContentType.success);

                      
                    }, child:   Text("Ok".tr,
                    style: const TextStyle(fontSize: 20,color: Colors.black),)),

                    TextButton(onPressed: (){
                       Get.back();
                    }, child:   Text("Cancel".tr,
                    style: const TextStyle(fontSize: 20,color: Colors.black),)),
                    ],
                  ),
                        
                    ],
                  );
                });
               
                       },
                         icon: const Icon(Icons.delete),
                          label:   Text("Delete".tr)),
                     ),
                const SizedBox(height: 15),
                     Center(
                        child: ElevatedButton.icon(onPressed: (){
                          Get.back();
                        },
                         icon: const Icon(Icons.cancel),
                          label:   Text("Back".tr)),
                      ),
                
                      ],
                    ),
                   
                  ],
                ),
              );
            });
            },
            child: Padding(
              padding:   const EdgeInsets.all(5),
              
              child:  ListNote(notess: mydata[i]),
            
            ),
          );
        })
    );
  
  }

  
showMsg(String title,String msg ,ContentType contentType){
  
    final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: title,
                    message: msg,messageFontSize: 16,
                    contentType: contentType,
                    
                  ),
                );
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
}

}

class ListNote extends StatelessWidget {
  const ListNote({super.key, this.notess});
 final notess;


  @override
  Widget build(BuildContext context) {
    return ListTile(   
       
        onTap: (){
              Get.to(()=>  ViewScreen(viewnote: notess,));
            },         
            tileColor: Colors.blueGrey,
            title: Text("${notess["title"]}",
            style: const TextStyle(color: Colors.white),),
            subtitle: Text("${notess['note']}",
            style: const TextStyle(color: Colors.white),),
            
          );
  }
}




