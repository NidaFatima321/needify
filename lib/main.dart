import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:needify/Views/Home.dart';
import 'package:needify/Views/SignIn.dart';
import 'package:needify/Views/SignUp.dart';
import 'package:needify/Views/dashboard_needify.dart';
import 'package:needify/Views/email_dialog.dart';
import 'package:needify/Views/my_purchases.dart';
import 'Views/add_post.dart';
import 'Views/splash_screen.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    home: SplashScreen(),
  ));
}

String? login;
DocumentSnapshot? maindata;
String? postId;


