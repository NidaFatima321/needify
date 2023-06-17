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
      appBar: AppBar(
        backgroundColor: Color(0xFFC52348),
        foregroundColor: Colors.black,
        title: Text("Confirm Order"),
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.close)
        ),
      ),
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
                        Image.network(postsdata['Images'][0], width: 160),
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
                  // SizedBox(
                  //   width: constraints.maxWidth,
                  //   child: ElevatedButton.icon(
                  //     onPressed: () {
                  //     },
                  //     icon: Icon(Icons.cancel_outlined,color: Colors.green[100],),
                  //     label: Text("Clear",style: TextStyle(color: Colors.green[100],fontWeight: FontWeight.bold),),
                  //     style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.green),
                  //
                  //   ),
                  // ),
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
                                List<dynamic> soldItems = [];
                                for (int i = 0;
                                    i < docssnap["Sold"].length;
                                    i++) {
                                  soldItems.add(docssnap["Sold"][i]);
                                }
                                soldItems.add(postsdata.id);
                                FirebaseFirestore.instance
                                    .collection("Users")
                                    .doc(logid)
                                    .update({"Sold": soldItems});
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Checkout(),));
                              }, child: Text("Checkout"),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                                    if (states.contains(MaterialState.pressed)) {
                                      return Colors.black26;
                                    }
                                    return Color(0xFF081857);
                                  }
                                  ),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              )
          ),
                          ))
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
