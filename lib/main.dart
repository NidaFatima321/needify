import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needify/Views/dashboard_needify.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Views/add_post.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: AddPost(),
  ));
}
String login="shaikhnaila488@gmail.com";
DocumentSnapshot? maindata;


