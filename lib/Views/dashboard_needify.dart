import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needify/Views/category_widget.dart';
import 'package:needify/Views/laptops.dart';
import 'package:needify/Views/notes.dart';
import 'package:needify/Views/sold_items.dart';
import 'package:needify/main.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
}
