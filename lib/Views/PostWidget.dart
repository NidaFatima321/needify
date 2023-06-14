import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needify/main.dart';

import 'dialogscreen.dart';

class PostWidget extends StatefulWidget {
  final CollectionReference collectionReference;
  final String category;
  final DocumentSnapshot docsnap;
  final DocumentSnapshot posterData;
  // final Function() purchase;
  const PostWidget(
      {Key? key,
      required this.collectionReference,
      required this.category,
      required this.docsnap, required this.posterData})
      : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Object?>>(
      stream: widget.collectionReference.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child:
                  CircularProgressIndicator()); //return means the bottom code wont run
        }
        if (snapshot.data == null || snapshot.hasError) {
          return const Center(child: Text("DATA NOT AVAILABLE"));
        }

        return Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
              /*gradient: LinearGradient(
                colors: [
                  Color(0xFFD70F44),
                  Color(0xFFFF5900)],
                begin: Alignment.topCenter,end: Alignment.bottomCenter,
              ),*/
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          // color: Colors.teal,
          height: 300,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              List<Widget> mywidget = [];

              if (snapshot.data!.docs[index]["Category"] == widget.category &&
                  snapshot.data!.docs[index]["Status"] == "Available") {
                mywidget.add(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                   
                    Container(
                      width: 150,
                      height: 140,
                      child: Image.network(
                        snapshot.data!.docs[index]["Images"][0],
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: EdgeInsets.only(bottom: 5),child: Text(snapshot.data!.docs[index]["Title"],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 22,fontFamily: "Pacifico"),)),
                          Padding(padding: EdgeInsets.only(bottom: 8),child: Text('(${snapshot.data!.docs[index]["Condition"]})',style: const TextStyle(fontSize: 18,color: Colors.lightBlue),)),
                          Padding(padding: EdgeInsets.only(bottom: 8),child: Text("Brand: "+snapshot.data!.docs[index]["Brand"],style: const TextStyle(fontSize: 18,fontFamily: 'Times New Roman', fontWeight: FontWeight.bold),)),
                          Padding(padding: EdgeInsets.only(bottom: 8),child: Text("Category: "+snapshot.data!.docs[index]["Category"],style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                          Padding(padding: EdgeInsets.only(bottom: 8),child: Text("Price: "+"${snapshot.data!.docs[index]["Price"]}",style: const TextStyle(fontSize: 18,color: Colors.red),)),
                          SizedBox(
                              width: 170,
                              child: Padding(padding: EdgeInsets.only(bottom: 8),child: Text("${snapshot.data!.docs[index]["Description"]}",style: TextStyle(color: Colors.grey,fontSize: 18),)),),
                          Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    widget.collectionReference
                                        .doc(snapshot.data!.docs[index].id)
                                        .update({"Status": "Sold"});

                                    List<dynamic> news = [];
                                    for (int i = 0;
                                        i < maindata!["Purchased"].length;
                                        i++) {
                                      news.add(maindata!["Purchased"][i]);
                                    }
                                    print(maindata!["Name"]);
                                    news.add(snapshot.data!.docs[index].id);
                                    print(news);
                                    FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(login)
                                        .update({"Purchased": news});
                                    print(maindata!.id);
                                    String logid =
                                        widget.collectionReference.parent!.id;
                                    List<dynamic> soldItems = [];
                                    for (int i = 0;
                                        i < widget.docsnap["Sold"].length;
                                        i++) {
                                      soldItems.add(widget.docsnap["Sold"][i]);
                                    }
                                    soldItems.add(snapshot.data!.docs[index].id);
                                    FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc(logid)
                                        .update({"Sold": soldItems});
                                  },
                                  child: Text("PURCHASE"),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                                      if (states.contains(MaterialState.pressed)) {
                                        return Colors.black26;
                                      }
                                      return Color(0xFF081857);
                                    }),
                                ),
                              ),
                              SizedBox(width: 30,),
                              Tooltip(
                                  message: 'Details',
                                  child: GestureDetector(
                                      onTap: (){
                                        showDialog(context: context, builder: (context) => DialogScreen(posterData:widget.posterData),);
                                      },
                                      child: Icon(Icons.details,color: Colors.grey,)))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ));
              }
              else if(snapshot.data!.docs[index]["Category"] == widget.category &&
                  snapshot.data!.docs[index]["Status"] == "Sold"){
                mywidget.add(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(
                      snapshot.data!.docs[index]["Images"][0],
                      width: 200,
                      height: 140,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(bottom: 5),child: Text(snapshot.data!.docs[index]["Title"],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 22,fontFamily: "Pacifico"),)),
                        Padding(padding: EdgeInsets.only(bottom: 8),child: Text('(${snapshot.data!.docs[index]["Condition"]})',style: const TextStyle(fontSize: 18,color: Colors.lightBlue),)),
                        Padding(padding: EdgeInsets.only(bottom: 8),child: Text("Brand: "+snapshot.data!.docs[index]["Brand"],style: const TextStyle(fontSize: 18,fontFamily: 'Times New Roman', fontWeight: FontWeight.bold),)),
                        Padding(padding: EdgeInsets.only(bottom: 8),child: Text("Category: "+snapshot.data!.docs[index]["Category"],style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
                        Padding(padding: EdgeInsets.only(bottom: 8),child: Text("Price: "+"${snapshot.data!.docs[index]["Price"]}",style: const TextStyle(fontSize: 18,color: Colors.red),)),
                        SizedBox(
                          width: 170,
                          child: Padding(padding: EdgeInsets.only(bottom: 8),child: Text("${snapshot.data!.docs[index]["Description"]}",style: TextStyle(color: Colors.grey,fontSize: 18),
                          )
                          ),
                        ),
                        Text("Sold",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 22,fontFamily: "Pacifico", decoration: TextDecoration.underline, decorationThickness: 2.0,),)
                      ],
                    )
                  ],
                ));
              }
              return (Container(
                child: Column(
                  children: mywidget,
                ),
              ));
            },
          ),
        );
      },
    );
  }
}
