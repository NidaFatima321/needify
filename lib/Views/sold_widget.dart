import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needify/main.dart';

class SoldWidget extends StatefulWidget {
  final CollectionReference collectionReference;
  // final Function() purchase;
  const SoldWidget(
      {Key? key,
        required this.collectionReference,
       })
      : super(key: key);

  @override
  State<SoldWidget> createState() => _SoldWidgetState();
}

class _SoldWidgetState extends State<SoldWidget> {

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
          height: 1000,
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              List<Widget> mywidget = [];
              for(int i=0;i<maindata!["Sold"].length;i++){
                if (snapshot.data!.docs[index].id == maindata!["Sold"][i]) {
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

                        ],
                      )
                    ],
                  ));
                }
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
