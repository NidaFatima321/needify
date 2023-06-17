import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_faq/flutter_faq.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:needify/main.dart';

class QueriesWidget extends StatefulWidget {
  const QueriesWidget({Key? key}) : super(key: key);

  @override
  State<QueriesWidget> createState() => _QueriesWidgetState();
}

class _QueriesWidgetState extends State<QueriesWidget> {
  TextEditingController input = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Answer Your Client's Queries"),
      ),
      body: FAQScreen(),

    );
  }
}

class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  TextEditingController input=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('FAQ').snapshots(),
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
            return Column(
              children: [
                FAQ(
                  question: snapshot.data!.docs[index]['question'],
                  answer: snapshot.data!.docs[index]['answer'],
                  separator: Container(
                    height: 5,
                    width: double.infinity,
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
                ),
                snapshot.data!.docs[index]['answer'] == ""
                    ? ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 560,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Answer",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Times New Roman'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        controller: input,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5))),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('FAQ')
                                            .doc(snapshot.data!.docs[index].id)
                                            .update({
                                          'answer': input.text
                                        });
                                        setState(() {

                                        });
                                      },
                                      child: Text("POST"),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Text("ANSWER"))
                    : Text(
                        "answered",
                        style: TextStyle(color: Colors.white),
                      )
              ],
            );
          },
        );
      },
    );
  }
}
