import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needify/Views/dates.dart';
import 'package:needify/Views/earnings.dart';
import 'package:needify/Views/sold2.dart';
import 'package:needify/main.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("TODAY'S TRANSACTIONS"),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('Users').snapshots(),
          builder: (context, snapshot) {
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
                todayCount=0;
                totalCount=0;
                profitearned=0;
                List<Widget> mylist = [];
                if (snapshot.data!.docs[index]['Solds']['Items'].length > 0) {
                  totalCount = totalCount + snapshot.data!.docs[index]['Solds']['Items'].length;
                  for (int i = 0;
                      i < snapshot.data!.docs[index]['Solds']['Items'].length;
                      i++) {
                    if (snapshot.data!.docs[index]['Solds']['Timestamps'][i]
                            .toDate()
                            .day ==
                        DateTime.now().day) {
                      DocumentSnapshot documentSnapshot =
                          snapshot.data!.docs[index];
                      mylist.add(SoldWidget2(
                        collectionReference:
                            documentSnapshot.reference.collection('Posts'),
                        id: snapshot.data!.docs[index]['Solds']['Items'][i],
                      ));
                    }
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
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Earnings(),));
        },
        label: Text('VIEW EARNINGS'),
      ),
    );
  }
}
