import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
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
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          // color: Colors.teal,
          height: 200,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              List<Widget> mywidget = [];

              if (snapshot.data!.docs[index]["Category"] == widget.category &&
                  snapshot.data!.docs[index]["Status"] == "Available") {
                mywidget.add(Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                   
                    Image.network(
                      snapshot.data!.docs[index]["Images"][0],
                      width: 200,
                      height: 140,
                    ),
                    const SizedBox(width: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data!.docs[index]["Title"],style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20,fontFamily: "Pacifico"),),
                        Text('(${snapshot.data!.docs[index]["Condition"]})',style: const TextStyle(fontSize: 18,color: Colors.lightBlue),),
                        Text(snapshot.data!.docs[index]["Brand"],style: const TextStyle(fontSize: 18,fontFamily: 'Times New Roman'),),
                        Text(snapshot.data!.docs[index]["Category"],style: const TextStyle(fontSize: 18),),
                        Text("${snapshot.data!.docs[index]["Price"]}",style: const TextStyle(fontSize: 18,color: Colors.red),),
                        SizedBox(
                            width: 170,
                            child: Text("${snapshot.data!.docs[index]["Description"]}",style: TextStyle(color: Colors.grey,fontSize: 18),),),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SizedBox(
                                        height: 260,
                                        child: Center(
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text("Payment Methods"),
                                              ),

                                              Card(
                                                child: ListTile(
                                                  leading: Image.asset('assets/images/jazz.png',width: 50,),
                                                  title: Text("JazzCash"),
                                                  trailing: GestureDetector(
                                                      onTap: (){
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentDecision(),));
                                                      },
                                                      child: Icon(Icons.arrow_forward)),
                                                ),
                                              ),
                                              Card(
                                                child: ListTile(
                                                  leading: Icon(Icons.delivery_dining,color: Colors.indigo,size: 30,),
                                                  title: Text("Cash On Delivery"),
                                                  trailing: GestureDetector(
                                                      onTap: (){
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentDecision(),));
                                                      },
                                                      child: Icon(Icons.arrow_forward)),
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
                        Text(snapshot.data!.docs[index]["Title"]),
                        Text(snapshot.data!.docs[index]["Brand"]),
                        Text(snapshot.data!.docs[index]["Condition"]),
                        Text(snapshot.data!.docs[index]["Category"]),
                        Text("${snapshot.data!.docs[index]["Price"]}"),
                        Text("${snapshot.data!.docs[index]["Description"]}"),
                        Text("Sold",style: TextStyle(color: Colors.red),)
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
