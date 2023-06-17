import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needify/Views/sold2.dart';
import 'package:needify/Views/sold_widget.dart';
import 'package:needify/main.dart';

class SoldItems extends StatefulWidget {
  const SoldItems({Key? key}) : super(key: key);

  @override
  State<SoldItems> createState() => _SoldItemsState();
}

class _SoldItemsState extends State<SoldItems> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

                List<String> ids = [];
                for (int i = 0; i < maindata!["Solds"]['Items'].length; i++) {
                  ids.add(maindata!["Solds"]['Items'][i]);
                }
                print(ids);
                DocumentSnapshot documentSnapshot = snapshot.data.docs[index];

                List<Widget> mywidgets = [];

                if (maindata!["Solds"]['Items'].length <= 0 && count == 1) {
                  count = count + 1;
                  mywidgets.add(Center(
                    child: Text("DATA NOT FOUND"),
                  ));
                } else {
                  for (int i = 0; i < maindata!["Solds"]['Items'].length; i++) {
                    if (maindata!["Solds"]['Items'][i].substring(0, 5) ==
                        snapshot.data.docs[index].id.substring(0, 5)) {
                      mywidgets.add(SoldWidget(
                          collectionReference:
                              documentSnapshot.reference.collection("Posts")));
                      break;
                    }
                    ;
                  }
                }
                return Container(
                  child: Column(
                    children: mywidgets,
                  ),
                );
              },
            );
          },
        )
    );
  }
}
