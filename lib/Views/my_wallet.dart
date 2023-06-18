import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needify/main.dart';
import 'package:intl/intl.dart';

class MyWallet extends StatefulWidget {
  const MyWallet({Key? key}) : super(key: key);

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {

  var totalWalletAmount = 0.00;
  var soldItems = [];
  var soldDateTime = [];


  Future<void> fetchData() async {
    DocumentSnapshot? documentSnapshot;
    await FirebaseFirestore.instance.collection("Users").doc(login).get().then((
        value) => documentSnapshot = value); //you get the document



    for (int i = 0; i < documentSnapshot?['Solds']['Items'].length; i++) {
      soldItems.add(documentSnapshot?['Solds']['Items'][i]);
      soldDateTime.add(documentSnapshot?['Solds']['Timestamps'][i].toDate());

    }
    setState(() {
      soldItems = soldItems.toSet().toList();
      soldDateTime = soldDateTime.toSet().toList();
    });

    print(soldItems);
    print(soldDateTime);
    print(soldItems.length);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 160, 16, 16),
          child: Column(
            children: [
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: Colors.cyan,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                  Text("Your Wallet Amount",
                    style: TextStyle(fontSize: 18),),
                  SizedBox(height: 20.0,),
                  Text("Rs. 0.00",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                    SizedBox(height: 30.0,),
                  ElevatedButton(onPressed: (){}, child: Text("Click here to Withdraw the amount"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.black26;
                        }
                        return Color(0xFF0D80F3);
                      }),
                    ),
                  ),
              ]
                ),
              ),
              SizedBox(height: 20.0,),
              Expanded(
                child: ListView.builder(
                  itemCount: soldItems.length == 0 ? 1 : soldItems.length,
                  itemBuilder: (context, index) {
                    print("soldItems length: ${soldItems.length}");
                    if (soldItems.length == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(48.0),
                        child: Center(child: Text("You have no transactions yet!",
                          style: TextStyle(fontSize: 20),),),
                      );
                    }
                    else {
                      String documentId = soldItems[index];
                      DateTime dateTime = soldDateTime[index]; // Replace with your DateTime object
                      String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm')
                          .format(dateTime);

                      //String userId = finalpurchDocids[index];

                      return StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .doc('/Users/$login/Posts/$documentId')
                            .snapshots(),
                        builder:
                            (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return Text('No data available');
                          }

                          // Retrieve the subcollection document data
                          Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                          //totalWalletAmount += data["Price"].toInt();
                          return ListTile(
                              title: Row(
                                children: [
                                  Text("Post#${data['id'].toString()}",
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 10.0),
                                  Text(formattedDateTime),
                                ],
                              ),
                              trailing: Text("Rs ${data["Price"].toString()}",
                                  style: TextStyle(color: Colors.green,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text("Added to your Wallet"),
                              // leading: Container(
                              // height: 50,
                              // width: 50,
                              // child: data.containsKey('Images') ? Image.network(
                              // data["Image"].toString())
                              //     : Container(),
                              // // Other widget customization as needed
                              // ),
                              leading: Icon(Icons.wallet)
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),

        )
    );
  }
}

