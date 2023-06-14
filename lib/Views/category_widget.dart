import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:needify/main.dart';

class CategoryWidget extends StatefulWidget {
  final categoryname;
  final categoryimage;
  final Function() navigate;
  const CategoryWidget({Key? key, this.categoryname, this.categoryimage, required this.navigate}) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  getData () async{
    var result=await FirebaseFirestore.instance.collection("Users").doc(login).get();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GestureDetector(
        onTap: (){
          widget.navigate();
        },

        child: Container(
          /*decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 2), // Specifies the shadow's offset (x, y)
                blurRadius: 4, // Specifies the blur radius of the shadow
                spreadRadius: 2, // Specifies the spread radius of the shadow
              ),
            ],
          ),*/
          //color: Color(0xFF1592EC),
          color: Color(0xFF25253D),
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.categoryname,
                style: TextStyle(
                    color:Colors.white, fontWeight:FontWeight.w500,fontSize: 20),
              ),
              SizedBox(height: 10,),
              Image.network(widget.categoryimage,width: 150,height: 100,)

            ],
          ),
        ),
      ),
    );
  }

}
