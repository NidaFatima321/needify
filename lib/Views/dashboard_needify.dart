import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      backgroundColor: Color(0xFF252530),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 120, 20, 20),
        child: Column(
          children: [
            // CarouselSlider(
            //     items: [
            //       Container(
            //         child: Image.network(
            //             'https://png.pngtree.com/png-vector/20191026/ourmid/pngtree-laptop-icon-png-image_1871608.jpg'),
            //       ),  Container(
            //         child: Image.network(
            //             'https://cdni.iconscout.com/illustration/premium/thumb/technical-drawing-6624320-5619278.png'),
            //       ),
            //     ],
            //     options: CarouselOptions(
            //       height: 170,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryWidget(
                  categoryimage:
                      "https://www.pngmart.com/files/1/Laptop-PNG-Picture-420x267.png",
                  categoryname: "Laptop",
                  navigate: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Laptop(),
                        ));
                  },
                ),
                CategoryWidget(
                  categoryimage:
                      "https://png.pngtree.com/png-clipart/20221229/original/pngtree-cream-sticky-notes-paper-illustration-with-clip-white-transparent-background-png-image_8822924.png",
                  categoryname: "Notes",
                  navigate: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Notes(),
                        ));
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryWidget(
                    categoryimage:
                        "https://static.vecteezy.com/system/resources/previews/009/344/824/original/3d-illustration-engineering-helmet-and-tools-png.png",
                    categoryname: "Drawing Tools",
                    navigate: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DrawingTools(),
                          ));
                    }),
                CategoryWidget(
                    categoryimage:
                        "https://static.vecteezy.com/system/resources/previews/008/475/692/original/modern-laptop-isolated-on-white-background-3d-illustration-free-png.png",
                    categoryname: "Others",
                    navigate: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherCategories(),
                          ));
                    }),
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
                          style: TextStyle(color: Color(0xFF252530)),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        // height: 70.0,
        color: Color(0xFF252530),
        child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost()));
            },
            child: Image.asset("assets/images/PlusButton.png",width: 100,height: 100,)
        ),
      ),
    );
  }
}
