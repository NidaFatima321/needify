import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:needify/Views/Home.dart';
import 'package:needify/Views/category_widget.dart';
import 'package:needify/Views/drawing_tools.dart';
import 'package:needify/Views/Laptop.dart';
import 'package:needify/Views/my_purchases.dart';
import 'package:needify/Views/notes.dart';
import 'package:needify/Views/other_categories.dart';
import 'package:needify/Views/sold_items.dart';
import 'package:needify/main.dart';

import 'add_post.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFF202491),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
            children: [
              Container(
                height:150,
                padding: EdgeInsets.symmetric(horizontal: 0,vertical: 30),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                width:  MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20)),

                ),
                child: Text("Dashboard",style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),textAlign: TextAlign.center,),
              ),
              // CarouselSlider(
              //     items: [
              //       Container(
              //         child: Image.asset('assets/images/laptop.jpg'),
              //       ),  Container(
              //         child: Image.asset('assets/images/tools.jpg'),
              //       ), Container(
              //         child: Image.asset('assets/images/mobile.jpg'),
              //       ), Container(
              //         child: Image.asset('assets/images/notes.jpg'),
              //       ),
              //     ],
              //     options: CarouselOptions(
              //       height: 150,
              //       aspectRatio: 16 / 9,
              //       viewportFraction: 0.5,
              //       initialPage: 0,
              //       enableInfiniteScroll: true,
              //       reverse: false,
              //       autoPlay: true,
              //       autoPlayInterval: Duration(seconds: 3),
              //       autoPlayAnimationDuration: Duration(milliseconds: 800),
              //       autoPlayCurve: Curves.fastOutSlowIn,
              //       enlargeCenterPage: true,
              //       enlargeFactor: 0.4,
              //       scrollDirection: Axis.horizontal,
              //     )
              // ),
              Padding(
                padding: EdgeInsets.fromLTRB(0,100,0,0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(3, 0), // changes position of shadow

                              )]
                          ),
                          child: CategoryWidget(
                            categoryimage:
                            "https://img.icons8.com/?size=1x&id=MFk6IqgCtnGg&format=png",
                            categoryname: "Laptop",
                            navigate: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Laptop(),
                                  ));
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(3, 0), // changes position of shadow

                              )]
                          ),
                          child: CategoryWidget(
                            categoryimage:
                            "https://img.icons8.com/?size=1x&id=dr9VaG7p8e1a&format=png",
                            categoryname: "Notes",
                            navigate: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Notes(),
                                  ));
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(3, 0), // changes position of shadow

                              )]
                          ),
                          child: CategoryWidget(
                              categoryimage:
                              "https://img.icons8.com/?size=1x&id=xdC06v7JSTKS&format=png",
                              categoryname: "Drawing Tools",
                              navigate: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DrawingTools(),
                                    ));
                              }),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(3, 0), // changes position of shadow

                              )]
                          ),
                          child: CategoryWidget(
                              categoryimage:
                              "https://img.icons8.com/?size=1x&id=lR3F6LWNiZ8C&format=png",
                              categoryname: "Others",
                              navigate: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OtherCategories(),
                                    ));
                              }),
                        ),
                      ],
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream:
                        FirebaseFirestore.instance.collection("Users").snapshots(),
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
                              if (snapshot.data.docs[index].id == login) {
                                maindata = snapshot.data.docs[index];
                              }
                              return Container(
                                child: Text(
                                  "Items Found",
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

      bottomNavigationBar: BottomAppBar(
        // height: 70.0,
        child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost()));
            },
            child: Image.asset("assets/images/plusButton.png",width: 100,height: 100,)
        ),
      ),
    );
  }

}
