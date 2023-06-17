import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needify/Views/queries.dart';
import 'package:needify/Views/stats.dart';
import 'package:needify/main.dart';

import 'SignIn.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  getData() async{
    var result=await FirebaseFirestore.instance.collection('Users').doc(login).get();
    return result;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ADMIN "),),
      drawer: Drawer(
        child: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("Admin")
              .where("Email", isEqualTo: login)
              .snapshots(),
         builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(
                 child:
                 CircularProgressIndicator()); //return means the bottom code wont run
           }
           if (snapshot.data == null || snapshot.hasError) {
             return const Center(child: Text("DATA NOT AVAILABLE"));
           }

           return ListView(
            children: [
              DrawerHeader(child: Image.network(snapshot.data!.docs[0]['Image'])),
              ListTile(
                leading: Icon(Icons.supervised_user_circle),
                title: Text(snapshot.data!.docs[0]['Name']),
              ),ListTile(
                leading: Icon(Icons.phone),
                title: Text(snapshot.data!.docs[0]['phoneNumber']),
              ),ListTile(
                leading: Icon(Icons.email),
                title: Text(snapshot.data!.docs[0]['Email']),
              ),ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: (){
                  FirebaseAuth.instance.signOut().then((value) {
                    print("Signed Out!");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignInScreen()));
                  });
                },
              ),
            ],
          );}
        ),
      ),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
        children: [
            Card(
              child: ListTile(
                leading: Image.asset('assets/images/plusButton.png'),
                title: Text("Today's Statistics"),
                trailing: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Statistics(),
                      ));
                    },
                    child: Icon(Icons.arrow_forward)),
              ),
            ), Card(
              child: ListTile(
                leading: Image.asset('assets/images/plusButton.png'),
                title: Text("Complete Transactions"),
                trailing: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Statistics(),
                      ));
                    },
                    child: Icon(Icons.arrow_forward)),
              ),
            ),Card(
              child: ListTile(
                leading: Image.asset('assets/images/plusButton.png'),
                title: Text("Queries"),
                trailing: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QueriesWidget(),
                      ));
                    },
                    child: Icon(Icons.arrow_forward)),
              ),
            ),
        ],
      ),
          )),
    );
  }
}
