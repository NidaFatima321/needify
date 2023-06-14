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

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: SignInScreen(),
  ));
}

String? login;
DocumentSnapshot? maindata;


