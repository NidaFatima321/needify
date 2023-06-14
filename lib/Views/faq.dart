import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_faq/flutter_faq.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:needify/main.dart';

class FAQFINAL extends StatefulWidget {
  const FAQFINAL({Key? key}) : super(key: key);

  @override
  State<FAQFINAL> createState() => _FAQFINALState();
}

class _FAQFINALState extends State<FAQFINAL> {
  TextEditingController input=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FAQScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SizedBox(
                height: 560,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Question",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Times New Roman'),),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: input,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
                        ),
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance.collection('FAQ').doc(login).set({'question':input.text,'answer':""});
                      },
                      child: Text("POST"),
                    )
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('FAQ').snapshots(),
      builder: (context, snapshot) {
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return FAQ(
              question: snapshot.data!.docs[index]['question'],
              answer: snapshot.data!.docs[index]['answer']==""?"QUERY NOT ANSWERED YET":snapshot.data!.docs[index]['answer'],
              separator: Container(
                height: 5,
                width: double.infinity,
                color: Colors.blueGrey,
              ),
              ansStyle: const TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontFamily: 'Times New Roman'),
              queStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Times New Roman'),
              expandedIcon: const Icon(Icons.minimize),
              collapsedIcon: const Icon(Icons.add),
            );
          },
        );
      },
    );
  }
}
