import 'package:flutter/material.dart';
import 'package:needify/Views/Home.dart';
import 'package:needify/Views/dashboard_needify.dart';

class Checkout extends StatelessWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/148767.png',width: 200,),
            SizedBox(height: 20,),
            Text("Your Order Has Been Successfully Booked",style: TextStyle(color: Colors.grey,fontSize: 20),),
            SizedBox(height: 20,),
            SizedBox(width:370,child: ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(),));
            }, child: Text("OK"),style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),),)

          ],
        ),
      ),
    );
  }
}
