import 'package:flutter/material.dart';
import 'dart:async';

import 'package:needify/Views/SignIn.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  late Animation<Offset> splashAnimation;
  late AnimationController splashAnimationController;

  @override
  void initState(){
    super.initState();
    splashAnimationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2)
    );

    splashAnimation = Tween(
      begin:Offset(0,0),
      end:Offset(5,0),
    ).animate(splashAnimationController.view);

    Timer(Duration(seconds: 3), () {
      splashAnimationController.forward();
    });

    Timer(Duration(milliseconds: 3350), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
    });



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(100,15,77,146),
      body: Container(
        child: SlideTransition(
          position: splashAnimation,
          child: Container(
            child: Center(
              child: Image.asset("assets/images/NEEDIFY-Logo.png"),
            ),
          ),
        ),
      ),
    );

  }
}
