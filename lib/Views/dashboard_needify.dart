import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needify/Views/category_widget.dart';
import 'package:needify/Views/laptops.dart';
import 'package:needify/Views/notes.dart';
import 'package:needify/Views/sold_items.dart';
import 'package:needify/main.dart';

import '../reusable_widgets/round_image.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final currentUser = FirebaseAuth.instance;
  var currentPage = DrawerSelections.Home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.menu),
            SizedBox(
                width: 300,
                child: Text("Faisal Apartments Johar Karachi"))
          ],
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryWidget(categoryimage: "https://www.pngmart.com/files/1/Laptop-PNG-Picture-420x267.png",categoryname: "Laptop",navigate: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Laptop(),));},),
                    CategoryWidget(categoryimage: "https://png.pngtree.com/png-clipart/20221229/original/pngtree-cream-sticky-notes-paper-illustration-with-clip-white-transparent-background-png-image_8822924.png",categoryname: "Notes",navigate: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Notes(),));},),
                  ],
                ),
              SizedBox(height: 20,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoryWidget(categoryimage: "https://static.vecteezy.com/system/resources/previews/009/344/824/original/3d-illustration-engineering-helmet-and-tools-png.png",categoryname: "Drawing Tools",navigate: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Laptop(),));}),
                    CategoryWidget(categoryimage: "https://static.vecteezy.com/system/resources/previews/008/475/692/original/modern-laptop-isolated-on-white-background-3d-illustration-free-png.png",categoryname: "Others",navigate: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Laptop(),));}),
                  ],
                ),
              ElevatedButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SoldItems(),));
              }, child: Text("SOLD ITEMS")),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection("Users").snapshots(),
                  builder: (context, dynamic snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child:
                          CircularProgressIndicator()); //return means the bottom code wont run
                    }
                    if (snapshot.data == null || snapshot.hasError) {
                      return const Center(child: Text("DATA NOT AVAILABLE"));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        if(snapshot.data.docs[index].id==login){
                          maindata=snapshot.data.docs[index];
                        }
                        return Container(
                          child: Text("Items Found",style: TextStyle(color: Colors.white),),
                        );

                    },);

                },),
              )
            ],
          ),

      ),

    );
  }
  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 70,),
      child: Column(
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSelections.Home? true : false),
          menuItem(1, "My Purchases", Icons.shopping_bag_outlined,
              currentPage == DrawerSelections.my_purchases? true : false),
          menuItem(1, "Sold Items", Icons.sell_outlined,
              currentPage == DrawerSelections.sold_items? true : false),
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
              currentPage == DrawerSelections.my_purchases;
            } else if (id == 3) {
              currentPage == DrawerSelections.sold_items;
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
  my_purchases,
  sold_items
}
