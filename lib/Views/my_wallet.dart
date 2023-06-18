import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:needify/main.dart';
import 'package:intl/intl.dart';


class SoldData {
  final List<String> soldItems;
  final List<DateTime> soldDateTime;

  SoldData(this.soldItems, this.soldDateTime);
}

class MyWallet extends StatefulWidget {
  const MyWallet({Key? key}) : super(key: key);

  @override
  State<MyWallet> createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {




  var totalWalletAmount = 0;
  // var soldItems = [];
  // var soldDateTime = [];

  Future<SoldData> fetchData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(login)
        .get();

    List<String> soldItems = [];
    List<DateTime> soldDateTime = [];
    List<dynamic> items = documentSnapshot?['Solds']['Items'];
    List<dynamic> timestamps = documentSnapshot?['Solds']['Timestamps'];
    for (int i = 0; i < items.length; i++) {
      soldItems.add(items[i]);
      soldDateTime.add(timestamps[i].toDate());
    }
    // Calculate the totalWalletAmount
    int totalAmount = 0;
    for (int i = 0; i < soldItems.length; i++) {
      String documentId = soldItems[i];
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .doc('/Users/$login/Posts/$documentId')
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        totalAmount = totalAmount + int.parse(data["Price"]) + int.parse(data["Withdrawn"]);
      }
    }

    setState(() {
      totalWalletAmount = totalAmount;
    });

    return SoldData(soldItems, soldDateTime);
  }

  //After Withdrawn
  Future<SoldData> Withdraw() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(login)
        .get();

    List<String> soldItems = [];
    List<DateTime> soldDateTime = [];
    List<dynamic> items = documentSnapshot?['Solds']['Items'];
    List<dynamic> Buyingtimestamps = [];
    for (int i = 0; i < items.length; i++) {
      soldItems.add(items[i]);

    }
    // Calculate the totalWalletAmount
    int totalAmount = 0;
    for (int i = 0; i < soldItems.length; i++) {
      String documentId = soldItems[i];
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .doc('/Users/$login/Posts/$documentId')
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        DocumentReference documentRef = FirebaseFirestore.instance.doc('/Users/$login/Posts/$documentId');
        await documentRef.update({
          'Withdrawn': "-${data["Price"]}",
        });

       totalAmount += int.parse(data["Withdrawn"]);
       totalAmount = 0;
       for(int i =0;i< soldItems.length; i++) {
           Buyingtimestamps.add(
               DateFormat('dd-M-yy HH:mm').format(DateTime.now()).toString());
           DocumentReference documentRef2 = FirebaseFirestore.instance.doc(
               '/Users/$login/Posts/$documentId');
           await documentRef2.update({
             'WithdrawnTime': Buyingtimestamps[i],
         });
       }

      }
    }

    setState(() {
      totalWalletAmount = totalAmount;
    });

    return SoldData(soldItems, soldDateTime);
  }


  //Alert Msg
  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [

              Text('Congratulations!'),
              Icon(Icons.check_circle),
            ],
          ),
          content: Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Your Money has been transferred"),
                Text("tp your Jazzcash Account"),
                Text("Soon you'll get the confirmation msg."),
                Icon(Icons.sms_rounded),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                  // setState(() {
                  //   totalWalletAmount = 0;
                  // });
                   Withdraw();



                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }



  late Future<SoldData> fetchDataFuture;
  void updateTotalWalletAmount(int amount) {
    setState(() {
      totalWalletAmount += amount;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDataFuture = fetchData();
    // setState(() {
    //   totalWalletAmount;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Wallet"),
          backgroundColor: Color(0xFFC52348),
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white24,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                        Text("Your Wallet Amount",style: TextStyle(fontSize: 15.0),),
                        SizedBox(height: 20.0,),
                        Text("Rs. $totalWalletAmount",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),),
                          SizedBox(height: 20.0,),
                        ElevatedButton(
                            onPressed: (){
                               showAlertDialog(context);
                            },
                            child: Text("Click here to Withdraw the amount")),
                    ]
                      ),
                    ),

                SizedBox(height: 0.0,),
                Text("Your Transactions",style:TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                SizedBox(height: 20.0,),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    //color:Colors.cyan,
                    height: MediaQuery.of(context).size.height - 200,
                    child: FutureBuilder<SoldData>(
                        future: fetchDataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          final soldData = snapshot.data;
                          if (soldData == null || soldData.soldItems.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(48.0),
                              child: Center(
                                child: Text(
                                  "You have no transactions yet!",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            );
                          }


                          // Build your ListView using soldItems


                        return ListView.builder(
                          itemCount: soldData.soldItems.length == 0 ? 1 : soldData.soldItems.length ,
                          itemBuilder: (context, index) {
                            print("soldItems length: ${soldData.soldItems.length}");
                            if (soldData.soldItems.length == 0) {
                              return Padding(
                                padding: const EdgeInsets.all(48.0),
                                child: Center(
                                  child: Text("You have no transactions yet!",
                                    style: TextStyle(fontSize: 20),),),
                              );
                            }
                            else {
                              String documentId = soldData.soldItems[index];
                              DateTime dateTime = soldData.soldDateTime[index];
                              String formattedDateTime = DateFormat(
                                  'dd-M-yy HH:mm')
                                  .format(dateTime);

                              //String userId = finalpurchDocids[index];

                              return StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .doc('/Users/$login/Posts/$documentId')
                                    .snapshots(),
                                builder:
                                    (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
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

                                  // int price = int.parse(data["Price"]);

                                  // Update the totalWalletAmount
                                  // updateTotalWalletAmount(price);
                                  if(data.containsKey('Withdrawn') && data['Withdrawn'] != "-0"){
                                    return Column(
                                      children: [
                                        ListTile(
                                            title: Row(
                                              children: [
                                                Text("Post#${data['id'].toString()}",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold),),
                                                SizedBox(width: 5.0),
                                                Text(data['WithdrawnTime'], style: TextStyle(color: Colors.blue,),),
                                              ],
                                            ),
                                            trailing: Text(
                                                "Rs ${data["Withdrawn"].toString()}",
                                                style: TextStyle(color: Colors.red,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold)),
                                            subtitle: Text("Withdrawn from your Wallet"),
                                            leading: Icon(Icons.wallet)
                                        ),
                                        ListTile(
                                            title: Row(
                                              children: [
                                                Text("Post#${data['id'].toString()}",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold),),
                                                SizedBox(width: 5.0),
                                                Text(formattedDateTime, style: TextStyle(color: Colors.blue,),),
                                              ],
                                            ),
                                            trailing: Text(
                                                "Rs ${data["Price"].toString()}",
                                                style: TextStyle(color: Colors.green,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold)),
                                            subtitle: Text("Added to your Wallet"),
                                            leading: Icon(Icons.wallet)
                                        ),
                                      ],
                                    );
                                  }
                                if(soldData.soldItems.length > 3) {
                                  return Container(
                                    height: 100,
                                    color: Colors.pink,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                  );
                                }
                                return ListTile(
                                    title: Row(
                                      children: [
                                        Text("Post#${data['id'].toString()}",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),),
                                        SizedBox(width: 5.0),
                                        Text(formattedDateTime, style: TextStyle(color: Colors.blue,),),
                                      ],
                                    ),
                                    trailing: Text(
                                        "Rs ${data["Price"].toString()}",
                                        style: TextStyle(color: Colors.green,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text("Added to your Wallet"),
                                    leading: Icon(Icons.wallet)
                                );
                                },
                              );
                            }
                          },
                        );
                      }
                    ),
                  ),
                ),

         ]
        ),
          ),
        )
    );
  }
}

