import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needify/main.dart';

class PostWidget extends StatefulWidget {
  final CollectionReference collectionReference;
  final String category;
  final DocumentSnapshot docsnap;
  // final Function() purchase;
  const PostWidget(
      {Key? key,
      required this.collectionReference,
      required this.category,
      required this.docsnap})
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
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          // color: Colors.teal,
          height: 160,
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
                    SizedBox(width: 5,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data!.docs[index]["Title"]),
                        Text(snapshot.data!.docs[index]["Brand"]),
                        Text(snapshot.data!.docs[index]["Condition"]),
                        Text(snapshot.data!.docs[index]["Category"]),
                        Text("${snapshot.data!.docs[index]["Price"]}"),
                        SizedBox(
                            width: 170,
                            child: Text("${snapshot.data!.docs[index]["Description"]}")),
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
                            child: Text("PURCHASE"))
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
