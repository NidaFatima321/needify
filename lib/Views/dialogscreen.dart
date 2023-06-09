import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'email_dialog.dart';

class DialogScreen extends StatelessWidget {
  final DocumentSnapshot posterData;
  const DialogScreen({Key? key, required this.posterData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight*0.6,
              color: Colors.white,
              child: Column(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(posterData['Image'])),
                    Container(
                      color: Colors.green,
                      child: Column(
                        children: [
                          SizedBox(height: 10,),
                          Text(posterData["Name"],style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontFamily: "Times New Roman",
                            fontWeight: FontWeight.bold
                          ),
                          ),
                          SizedBox(height: 10,),
                          Text(posterData['Department'],style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: "Times New Roman"
                          ),),
                          SizedBox(height: 10,),
                          Text('Year of Study : ${posterData['Year']}',style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: "Times New Roman"
                          ),),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(22, 18, 22, 21),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                    onTap:(){
                                      launch('tel://${posterData["contactNumber"]}');
                                    },
                                    child: Icon(Icons.call, color: Colors.white,)),
                                GestureDetector(
                                    onTap: (){
                                      // showDialog(context: context, builder: (context) => EmailDialog());
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EmailDialog(),));
                                    },
                                    child: Icon(Icons.email, color: Colors.white,))
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ),
        );
      },

    );
  }
}
