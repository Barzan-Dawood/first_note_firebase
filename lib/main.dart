// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_net/auth/login.dart';
import 'package:note_net/firebase_options.dart';
import 'package:note_net/language/lan_controller.dart';
import 'package:note_net/language/lang.dart';
import 'package:note_net/screen/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

 bool? islogin;
 SharedPreferences? sPreferences;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  sPreferences = await SharedPreferences.getInstance();
  var user = FirebaseAuth.instance.currentUser;
  if(user == null){
    islogin = false;
  }
  else{
    islogin = true;
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

 @override
  void initState() {
    
FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

    super.initState();
  }

   @override
  Widget build(BuildContext context) {
         LangController langController = Get.put(LangController());
    return   GetMaterialApp(
      locale: langController.inLang,
      translations: MyLang(),
      debugShowCheckedModeBanner: false,
      home: islogin == false ? const Login() : const HomeScreen(),
    );
  }
}
 