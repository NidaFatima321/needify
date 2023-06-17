import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needify/Views/checkoutScreen.dart';
import 'package:needify/main.dart';

class PaymentDecision extends StatelessWidget {
  final DocumentSnapshot postsdata;
  final CollectionReference collectionReference;
  final DocumentSnapshot docssnap;
  const PaymentDecision({Key? key, required this.postsdata, required this.collectionReference, required this.docssnap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "CONFIRM ORDER",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        fontFamily: 'Pacifico'),
                  ),
                  Card(
                    child: Row(
                      children: [
                        Image.network(postsdata['Image'], width: 160),
                        SizedBox(width:5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              postsdata['Title'],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                            Text(
                              postsdata['Brand'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              postsdata['Price'],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(child: SizedBox()),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Rs.${postsdata['Price']}',
                          style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                collectionReference
                                    .doc(postsdata.id)
                                    .update({"Status": "Sold"});

                                List<dynamic> news = [];
                                for (int i = 0;
                                    i < maindata!["Purchased"].length;
                                    i++) {
                                  news.add(maindata!["Purchased"][i]);
                                }
                                print(maindata!["Name"]);
                                news.add(postsdata.id);
                                print(news);
                                FirebaseFirestore.instance
                                    .collection("Users")
                                    .doc(login)
                                    .update({"Purchased": news});
                                print(maindata!.id);
                                String logid =
                                    collectionReference.parent!.id;
                                // List<dynamic> soldItems = [];
                                // for (int i = 0;
                                //     i < docssnap["Sold"].length;
                                //     i++) {
                                //   soldItems.add(docssnap["Sold"][i]);
                                // }
                                // soldItems.add(postsdata.id);
                                // FirebaseFirestore.instance
                                //     .collection("Users")
                                //     .doc(logid)
                                //     .update({"Sold": soldItems});
                                Map<String,dynamic> maps={};
                                List<dynamic> items=[];
                                for(int i=0;i<docssnap['Solds']['Items'].length;i++){
                                  items.add(docssnap['Solds']['Items'][i]);
                                }
                                items.add(postsdata.id);
                                List<dynamic> Timestamps=[];
                                for(int i=0;i<docssnap['Solds']['Timestamps'].length;i++){
                                  Timestamps.add(docssnap['Solds']['Timestamps'][i]);
                                }
                                Timestamps.add(DateTime.now());
                                maps={"Items":items,"Timestamps":Timestamps};
                                FirebaseFirestore.instance
                                    .collection("Users")
                                    .doc(logid)
                                    .update({"Solds": maps});
                                print(items);
                                print(Timestamps);

                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Checkout(),));
                              }, child: Text("Checkout")))
                    ],
                  )
                ],
              ),
            ),
          );
        },

      ),
    );
  }
}
