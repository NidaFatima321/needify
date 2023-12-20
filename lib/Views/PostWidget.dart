import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:needify/Views/jazzcash_screen.dart';
import 'package:needify/Views/payment_screen.dart';
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
      required this.docsnap,
      required this.posterData})
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
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30,),bottomRight: Radius.circular(30)),
          ),
          // color: Colors.teal,
          height: 200,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              List<Widget> mywidget = [];

              if (snapshot.data!.docs[index]["Category"] == widget.category &&
                  snapshot.data!.docs[index]["Status"] == "Available") {
                mywidget.add(
                    Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(
                      snapshot.data!.docs[index]["Image"],
                      width: 150,
                      height: 150,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 170,
                            child: Text(
                              snapshot.data!.docs[index]["Title"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: "Times New Roman"),
                            )),
                        Text(
                          '(${snapshot.data!.docs[index]["Condition"]})',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.lightBlue),
                        ),
                        Text("Brand: "+
                          snapshot.data!.docs[index]["Brand"],
                          style: const TextStyle(
                              fontSize: 18, fontFamily: 'Times New Roman'),
                        ),
                        Text(
                          snapshot.data!.docs[index]["Category"],
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text("Price: "+
                          "${snapshot.data!.docs[index]["Price"]}",
                          style:
                              const TextStyle(fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            "${snapshot.data!.docs[index]["Description"]}",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                                      if (states.contains(MaterialState.pressed)) {
                                        return Colors.black26;
                                      }
                                      return Color(0xFF081857);
                                    }),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                                    )
                                ),
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height: 260,
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text("Payment Methods"),
                                              ),
                                              Card(
                                                child: ListTile(
                                                  leading: Image.asset(
                                                    'assets/images/jazz.png',
                                                    width: 50,
                                                  ),
                                                  title: Text("JazzCash"),
                                                  trailing: GestureDetector(
                                                      onTap: () {
                                                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentDecision(postsdata: snapshot.data!.docs[index],),));
                                                         Navigator.push(context, MaterialPageRoute(builder: (context) => JazzCashScreen(postsData: snapshot
                                                             .data!
                                                             .docs[
                                                         index],
                                                             collectionReference:
                                                             widget
                                                                 .collectionReference,
                                                             docssnap: widget
                                                                 .docsnap,productPrice:snapshot.data!.docs[index]["Price"], productName:snapshot.data!.docs[index]["Title"])));

                                                      },
                                                      child: Icon(
                                                          Icons.arrow_forward)),
                                                ),
                                              ),
                                              Card(
                                                child: ListTile(
                                                  leading: Icon(
                                                    Icons.delivery_dining,
                                                    color: Colors.indigo,
                                                    size: 30,
                                                  ),
                                                  title:
                                                      Text("Cash On Delivery"),
                                                  trailing: GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              PaymentDecision(
                                                                  postsdata: snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index],
                                                                  collectionReference:
                                                                      widget
                                                                          .collectionReference,
                                                                  docssnap: widget
                                                                      .docsnap),
                                                        ));
                                                      },
                                                      child: Icon(
                                                          Icons.arrow_forward)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  // widget.collectionReference
                                  //     .doc(snapshot.data!.docs[index].id)
                                  //     .update({"Status": "Sold"});
                                  //
                                  // List<dynamic> news = [];
                                  // for (int i = 0;
                                  //     i < maindata!["Purchased"].length;
                                  //     i++) {
                                  //   news.add(maindata!["Purchased"][i]);
                                  // }
                                  // print(maindata!["Name"]);
                                  // news.add(snapshot.data!.docs[index].id);
                                  // print(news);
                                  // FirebaseFirestore.instance
                                  //     .collection("Users")
                                  //     .doc(login)
                                  //     .update({"Purchased": news});
                                  // print(maindata!.id);
                                  // String logid =
                                  //     widget.collectionReference.parent!.id;
                                  // List<dynamic> soldItems = [];
                                  // for (int i = 0;
                                  //     i < widget.docsnap["Sold"].length;
                                  //     i++) {
                                  //   soldItems.add(widget.docsnap["Sold"][i]);
                                  // }
                                  // soldItems.add(snapshot.data!.docs[index].id);
                                  // FirebaseFirestore.instance
                                  //     .collection("Users")
                                  //     .doc(logid)
                                  //     .update({"Sold": soldItems});
                                },
                                child: Text("PURCHASE")),
                            SizedBox(width:10),
                            Tooltip(
                                message: 'Details',
                                child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => DialogScreen(
                                            posterData: widget.posterData),
                                      );
                                    },
                                    child: Icon(
                                      Icons.details,
                                      color: Colors.grey,
                                    )))
                          ],
                        )
                      ],
                    )
                  ],
                ));
              } else if (snapshot.data!.docs[index]["Category"] ==
                      widget.category &&
                  snapshot.data!.docs[index]["Status"] == "Sold") {
                mywidget.add(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                Image.network(
                snapshot.data!.docs[index]["Image"],
                  width: 150,
                  height: 150,
                ),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 170,
                            child: Text(
                              snapshot.data!.docs[index]["Title"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  fontFamily: "Times New Roman"),
                            )),
                        Text(
                          '(${snapshot.data!.docs[index]["Condition"]})',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.lightBlue),
                        ),
                        Text("Brand: "+
                          snapshot.data!.docs[index]["Brand"],
                          style: const TextStyle(
                              fontSize: 18, fontFamily: 'Times New Roman'),
                        ),
                        Text(
                          snapshot.data!.docs[index]["Category"],
                          style: const TextStyle(fontSize: 18),
                        ),
                        Text("Price: "+
                          "${snapshot.data!.docs[index]["Price"]}",
                          style:
                          const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            "${snapshot.data!.docs[index]["Description"]}",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                        Text("SOLD",style: TextStyle(color: Colors.red,fontSize: 17, fontWeight: FontWeight.bold),)
                ]),
                  ],
                )]));
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
