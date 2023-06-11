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
  TextEditingController _nameTextController = TextEditingController();
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
          color: Color(0xFF25253D),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 80,
                ),
                Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),
                Text(
                  'User please fill the input below',
                  style: TextStyle(
                    color: Color(0xFF9696C0),
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Enter Your Full Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                textField("", Icons.person_outline, false,
                    _nameTextController),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Enter Email ID',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                textField("", Icons.email_outlined, false,
                    _emailTextController),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Enter Pasword',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                textField("", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Enter Phone no.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                textField("", Icons.phone_android_outlined, false,
                    _phnoTextController),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Enter Department',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                textField("", Icons.house_siding_outlined, false,
                    _deptTextController),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Enter Year',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                textField("", Icons.book_outlined, false,
                    _yearTextController),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: UserImage(
                      onFileChanged: (imageUrl) {
                        setState(() {
                          this.imageUrl = imageUrl;
                        });
                      }
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: signinSignupButton(context, false, () async {
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
                      "Name":_nameTextController.text,
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
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
