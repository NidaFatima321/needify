import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../reusable_widgets/UserImage.dart';
import '../reusable_widgets/round_image.dart';
import 'SignIn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final currentUser = FirebaseAuth.instance;
  var currentPage = DrawerSelections.Home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Users")
                        .where("Email", isEqualTo: currentUser.currentUser!.email)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData){
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.docs[index];
                              return Container(
                                color: Colors.pinkAccent,
                                width: double.infinity,
                                height: 200,
                                padding: EdgeInsets.only(top: 20,),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AppRoundImage.url(
                                        data["User image"].toString(),
                                        height: 80,
                                        width: 80
                                    ),
                                      //Image.network(data["User image"].toString()),
                                    Text(
                                      data["Name"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      data["Email"],
                                      style: TextStyle(
                                        color: Colors.grey[200],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );

                            }
                        );
                      }else{
                        return CircularProgressIndicator();
                      }
                    }),
                MyDrawerList()
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: ElevatedButton(
            child: Text("Logout"),
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out!");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              });
            },
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 70,),
      child: Column(
        children: [
          menuItem(1, "Home", Icons.dashboard_outlined,
              currentPage == DrawerSelections.Home? true : false),
          menuItem(1, "My Purchases", Icons.shopping_bag_outlined,
              currentPage == DrawerSelections.SignIn? true : false),
          menuItem(1, "My Posts", Icons.post_add_outlined,
              currentPage == DrawerSelections.SignUp? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage == DrawerSelections.Home;
            } else if (id == 2) {
              currentPage == DrawerSelections.SignIn;
            } else if (id == 3) {
              currentPage == DrawerSelections.SignUp;
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.black,
                  )
              ),
              Expanded(
                flex: 3,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSelections {
  Home,
  SignIn,
  SignUp
}

