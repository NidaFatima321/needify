import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needify/main.dart';


class LoadData extends StatefulWidget {
  const LoadData({Key? key}) : super(key: key);

  @override
  State<LoadData> createState() => _LoadDataState();
}

class _LoadDataState extends State<LoadData> {
  var purc = [];
  var purDocids = [];
  var finalpurchDocids = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    DocumentSnapshot? documentSnapshot;
    await FirebaseFirestore.instance.collection("Users").doc(login).get().then((
        value) => documentSnapshot = value); //you get the document

    for (int i = 0; i < documentSnapshot?['Purchased'].length; i++) {
      purc.add(documentSnapshot?['Purchased'][i]);
    }

    purc = purc.toSet().toList();
    print(purc);

    for (int i = 0; i < purc.length; i++) {
      purDocids.add(purc[i].split('_'));
    }

    for (int i = 0; i < purDocids.length; i++) {
      finalpurchDocids.add(purDocids[i][0]);
    }
    setState(() {

    });
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: purc.length == 0 ? 1 :purc.length,
        itemBuilder: (context, index) {
          if(purc.length == 0){
            return Padding(
              padding: const EdgeInsets.all(48.0),
              child: Center(child: Text("You have no purchases yet!",style: TextStyle(fontSize: 20),),),
            );
          }
          else {
            String documentId = purc[index];
            String userId = finalpurchDocids[index];

            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .doc('/Users/$userId/Posts/$documentId')
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

                return ListTile(
                  title: Text(data["Title"].toString(), style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  trailing: Text(data["Brand"].toString()),
                  subtitle: Text("Price:${data["Price"]}".toString()),
                  leading: Container(
                    height: 50,
                    width: 50,
                    child: data.containsKey('Images') ? Image.network(
                        data["Images"][0].toString())
                        : Container(),
                    // Other widget customization as needed
                  ),
                );
              },
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text("Click"),
      ),
    );
  }
}

