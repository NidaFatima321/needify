import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needify/main.dart';

class SoldWidget2 extends StatefulWidget {
  final CollectionReference collectionReference;
  final String id;
  const SoldWidget2({Key? key, required this.collectionReference, required this.id}) : super(key: key);

  @override
  State<SoldWidget2> createState() => _SoldWidget2State();
}

class _SoldWidget2State extends State<SoldWidget2> {
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
          height: 100,
          child:
          ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              List<Widget> mywidget = [];
              if(snapshot.data!.docs[index].id==widget.id){
                todayCount+=1;
                profitearned=profitearned+int.parse(snapshot.data!.docs[index]['Price'])*0.1;
              mywidget.add(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(snapshot.data!.docs[index]['Image'],width:170,height: 80,),
                      Column(
                        children: [
                          Text(snapshot.data!.docs[index]['Title'],style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(snapshot.data!.docs[index]['Category']),
                          Text(snapshot.data!.docs[index]['Price'],style: TextStyle(color: Colors.red),),

                        ],
                      )
                    ],
                  ),
                )
              );
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
