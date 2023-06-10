import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needify/reusable_widgets/UserImage.dart';
import '../reusable_widgets/reusable_widgets.dart';
import '../utils/colors_utils.dart';
import 'Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _phnoTextController = TextEditingController();
  TextEditingController _deptTextController = TextEditingController();
  TextEditingController _yearTextController = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection("Users");

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColors("CB2B93"),
              hexStringToColors("9546C4"),
              hexStringToColors("5E61F4")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Username", Icons.person_outline, false,
                    _userNameTextController),
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Email Id", Icons.email_outlined, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Phone no.", Icons.phone_android_outlined, false,
                    _phnoTextController),
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Department", Icons.house_siding_outlined, false,
                    _deptTextController),
                const SizedBox(
                  height: 20,
                ),
                textField("Enter Year", Icons.book_outlined, false,
                    _yearTextController),
                const SizedBox(
                  height: 20,
                ),
                UserImage(
                    onFileChanged: (imageUrl) {
                      setState(() {
                        this.imageUrl = imageUrl;
                      });
                    }
                ),
                const SizedBox(
                  height: 20,
                ),
                signinSignupButton(context, false, () async {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text).then((value) {
                    print("New Account Created!");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace){
                    print("Error ${error.toString()}");
                  });

                  await users.doc(_emailTextController.text).set({
                    "Email":_emailTextController.text,
                    "Name":_userNameTextController.text,
                    "Password":_passwordTextController.text,
                    "Phone no":_phnoTextController.text,
                    "Department":_deptTextController.text,
                    "Year":_yearTextController.text,
                    "User image": imageUrl,
                    "Sold":[],
                    "Categories":[],
                    "Purchased":[]
                  }).then((value) {
                    print("Added user!");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace){
                    print("Error ${error.toString()}");
                  });
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
