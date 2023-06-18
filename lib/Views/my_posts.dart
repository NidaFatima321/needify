import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key}) : super(key: key);

  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Users').doc(login).collection('Posts').snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.connectionState == ConnectionState.active){
                if(snapshot.hasData && snapshot.data != null){
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){

                        Map<String, dynamic> userPosts = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(

                            title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Post# ${index + 1}'),
                              Text(userPosts["Title"].toString()),
                            ],
                          ),
                            //Text(userPosts["Title"].toString()),
                            trailing: Text(userPosts["Status"].toString()),
                            subtitle: Text("Price:${userPosts["Price"]}".toString()),
                            leading:
                                Container(
                                  height: 70,
                                  width: 70,
                                  child: userPosts.containsKey('Image')?Image.network(userPosts["Image"].toString())
                                      :Container(),
                                ),

                          ),
                        );
                      }
                  );
                }
                else{
                  return Text("No data found");
                }
              }
              else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

            },
          ),
        ),
      ),

    );
  }
}


