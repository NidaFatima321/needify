import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needify/Views/sold2.dart';
import 'package:needify/main.dart';

import 'earnings.dart';

class CompleteStatsWidget extends StatefulWidget {
  const CompleteStatsWidget({Key? key}) : super(key: key);

  @override
  State<CompleteStatsWidget> createState() => _CompleteStatsWidgetState();
}

class _CompleteStatsWidgetState extends State<CompleteStatsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COMPLETE TRANSACTIONS"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, snapshot) {
          current='complete';
          ctotalCount = 0;
          ctodayCount = 0;
          cprofitearned = 0;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); //return means the bottom code wont run
          }
          if (snapshot.data == null || snapshot.hasError) {
            return const Center(child: Text("DATA NOT AVAILABLE"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {

              List<Widget> mylist = [];
              if (snapshot.data!.docs[index]['Solds']['Items'].length > 0) {
                ctotalCount = ctotalCount +
                    snapshot.data!.docs[index]['Solds']['Items'].length;
                for (int i = 0;
                    i < snapshot.data!.docs[index]['Solds']['Items'].length;
                    i++) {
                  if (snapshot.data!.docs[index]['Solds']['Timestamps'][i]
                          .toDate()
                          .day ==
                      DateTime.now().day) {
                    print(snapshot.data!.docs[index]['Solds']['Timestamps'][i]
                        .toDate()
                        .day);
                    ctodayCount = ctodayCount + 1;
                  }
                  DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  mylist.add(SoldWidget2(
                    collectionReference:
                        documentSnapshot.reference.collection('Posts'),
                    id: snapshot.data!.docs[index]['Solds']['Items'][i],
                  ));
                }
              }
              return Container(
                child: Column(children: mylist),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Earnings(),
          ));
        },
        label: Text('VIEW EARNINGS'),
      ),
    );
  }
}
