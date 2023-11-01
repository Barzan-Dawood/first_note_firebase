 
// ignore_for_file: unnecessary_const, unused_local_variable

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_net/auth/login.dart';
 

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController myName = TextEditingController();
  TextEditingController myEmail = TextEditingController();
  TextEditingController myPass = TextEditingController();
  bool showpass = true;
  bool isloding = false;

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: isloding == true ? const Center(child: CircularProgressIndicator()) : Padding(
        padding: const EdgeInsets.all(40),
        child: Expanded(
          child: ListView(
             
            children: [
                  const SizedBox(height: 25),
                   Center(child: Text("SignUp".tr,style: const TextStyle(color: Colors.purple,fontSize: 50,fontWeight: FontWeight.bold),)),
              const SizedBox(height: 45),
               TextFormField(
                 controller: myName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                  label: Text ("UserName".tr),
                  prefixIcon: const Icon(Icons.person,color: Colors.green,)
                   
                ),
               ),
             const SizedBox(height: 20),

               TextFormField(
                 controller: myEmail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                  label: Text ( "Email".tr),
                  prefixIcon: const Icon(Icons.email,color: Colors.green,)
                   
                ),
               ),
             const SizedBox(height: 20),
                 TextFormField(
                  obscureText: showpass,
                    controller: myPass,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                  label: Text ( "PassWord".tr),
                  prefixIcon: const Icon(Icons.password,color: Colors.green),
                  suffixIcon: IconButton(onPressed: (){
                       setState(() {
                          showpass = !showpass;
                       });
                  }, icon: Icon(showpass ? Icons.visibility_off : Icons.visibility ,color: Colors.blue,),),
                   
                ),
               ),
                 const SizedBox(height: 10),
                 Row(
                children: [
                   Text("if you have account".tr),
                  InkWell(
                    onTap: (){
                      Get.to(() =>const Login());
                    },
                    child: Text("Click Here".tr,
                  style: const TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold),)),
                ],
               ),
               
             
         Padding(
              
               padding:   const EdgeInsets.all(50),
               child: ElevatedButton(
               style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
               onPressed: ()async {
                  try {
                   isloding = true;
                   setState(() {
                     
                   });
                  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: myEmail.text,
                    password: myPass.text,
                  );
                isloding = false;
                setState(() {
                  
                }); 
                  Get.off(()=> const Login());
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                    showMsg('', 'The password provided is too weak.'.tr, ContentType.failure);
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                   showMsg('', 'The account already exists for that email.'.tr, ContentType.failure);

                  }
                } catch (e) {
                  print(e);
                }
             
               },
                child: Text("SignUp".tr,style: const TextStyle(fontSize: 20,color: Colors.white),)),
             )
        
          
            ],
          ),
        ),
      ),
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