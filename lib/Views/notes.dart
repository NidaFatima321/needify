import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needify/Views/PostWidget.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _LaptopsState();
}

class _LaptopsState extends State<Notes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NOTES"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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


              List<Widget> mywidgets = [];
              for (int i = 0;
              i < snapshot.data.docs[index]["Categories"].length;
              i++) {
                if (snapshot.data.docs[index]["Categories"][i] == "Notes") {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  // CollectionReference collectionReference =
                  // documentSnapshot.reference.collection("Posts");
                  mywidgets.add(Card(
                      child: Column(children: [
                        // Text(snapshot.data.docs[index]["Name"]),
                        PostWidget(
                          collectionReference:
                          documentSnapshot.reference.collection("Posts"),category: "Notes",
                        docsnap: snapshot.data.docs[index],
                        //   purchase: () {
                        //   for (int i = 0; i < snapshot.data.docs.length; i++) {
                        //     if (snapshot.data.docs[i] == login) {
                        //       snapshot.data.docs[i]["Purchased"]
                        //           .add(collectionReference.id);
                        //     }
                        //   }
                        // }
                        )
                      ])));
                }
              }
              return Container(
                child: Column(
                  children: mywidgets,
                ),
              );

              // return Card(
              //     child: Column(children: [
              //       Text(snapshot.data.docs[index]["Name"]),
              //       Text("${snapshot.data.docs[index]["Categories"].length}"),
              //      Text("${categories}"),
              //      // FutureBuilder(
              //      //   future: collectionReference.get(),
              //      //   builder: (context, dynamic snapshot) {
              //      //
              //      //       return Text(snapshot.data!.docs[0]["Category"]);
              //      //
              //      // },)
              //
              //      PostWidget(collectionReference: documentSnapshot
              //           .reference.collection("Posts"))
              // ])
              //
              // );
            },
          );
        },
      ),
    );
  }
}
