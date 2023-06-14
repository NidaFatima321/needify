import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needify/main.dart';
import '../reusable_widgets/reusable_widgets.dart';
import '../utils/colors_utils.dart';
import 'Home.dart';
import 'SignUp.dart';
import 'dashboard_needify.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        decoration: BoxDecoration(
          color: Color(0xFF25253D)
        ),

        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //logoWidget("assets/images/login3.png"),
              SizedBox(height: 80),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Welcome back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'User please Sign in to continue',
                      style: TextStyle(
                        color: Color(0xFF9696C0),
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    textField("Enter Email", Icons.email_outlined, false,
                        _emailTextController),
                    SizedBox(
                      height: 30,
                    ),
                    textField("Enter Password", Icons.lock_outline, true,
                        _passwordTextController),
                    SizedBox(
                      height: 30,
                    ),
                    signinSignupButton(context, true, () {
                      FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _emailTextController.text, password: _passwordTextController.text).then((value) {

                        login=_emailTextController.text;
                        print(login);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomeScreen()));
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                      });
                    }),
                    signUpOption()
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account?",
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            ' Sign Up',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}