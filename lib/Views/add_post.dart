import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:needify/Views/dashboard_needify.dart';
import 'dart:core';

import 'package:needify/Views/my_purchases.dart';
class AddPost extends StatefulWidget {


  AddPost({Key? key}) : super(key: key){
    //Getting the reference of root collection as Users

    _userDocumentReference = FirebaseFirestore.instance.collection('Users').doc('zoyakashif234@gmail.com');

    //Get the collection reference for Posts collection of this document
    _referencePostsReference = _userDocumentReference.collection('Posts');

  }

  // Map data;


  late DocumentReference _userDocumentReference;
  late CollectionReference _referencePostsReference;


  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  File? pickedImage ;
  bool showTextFields = false;

  void imagePickerOption(){
    Get.bottomSheet(
        SingleChildScrollView(
          child: ClipRRect(
            borderRadius:  BorderRadius.only(
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
            child: Container(
              color: Colors.white,
              height: 250,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Pick Image From",style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                        height  : 10
                    ),
                    ElevatedButton.icon(
                        onPressed: (){
                          pickImage(ImageSource.camera);
                        },
                        icon:Icon(Icons.camera),
                        label: Text("Camera")),
                    SizedBox(
                        height  : 10
                    ),
                    ElevatedButton.icon(
                        onPressed: (){
                          pickImage(ImageSource.gallery);
                        },
                        icon:Icon(Icons.image),
                        label: Text("Gallery")),
                    SizedBox(
                        height  : 10
                    ),
                    ElevatedButton.icon(
                        onPressed: (){
                          Get.back();
                        },
                        icon:Icon(Icons.close),
                        label: Text("Cancel")),
                  ],

                ),
              ),
            ),
          ),
        )
    );
  }

  pickImage (ImageSource imageType) async{
    try{
      final photo = await ImagePicker().pickImage(source: imageType);
      if(photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
      Get.back();
      String uniqueImgFileName = DateTime.now().millisecondsSinceEpoch.toString();

      //Get a reference to firebase storage root
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');

      //Create a reference for the image to be stored
      Reference referenceImageToUpload = referenceDirImages.child(uniqueImgFileName);



      //Store the Image in Firebase Storage
      await  referenceImageToUpload.putFile(pickedImage!);
      //Get the download url
      imageUrl = await referenceImageToUpload.getDownloadURL();
    }catch(error){
      debugPrint(error.toString());
    }
  }


  String valueChoose = "Tools";
  List<String> listItem = <String>[
    "Laptop", "Notes", "Tools", "Others"
  ];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _condController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _priceController = TextEditingController();


  String imageUrl = '';

  // late DocumentReference _userDocumentReference;
  //late CollectionReference _referencePostsReference;

  TextEditingController _jazzAccController = TextEditingController();





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Create a Post"),
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.close)
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: ListView(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Add Title",
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _descController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add Description',

                      // contentPadding: EdgeInsets.only(left:8.0,bottom:32.0,top:32.0),
                    ),
                    maxLength: 50,

                  ),
                  SizedBox(height: 20),
                  Text("Category"),
                  DropdownButton<String>(
                    value: valueChoose,
                    onChanged: (String? newValue){
                      setState(() {
                        valueChoose = newValue!;
                      });
                    },
                    items: listItem.map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value)
                          );
                        }

                    ).toList(),

                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _condController,
                    decoration: InputDecoration(
                      hintText: " Condition",

                    ),

                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _brandController,
                    decoration: InputDecoration(
                      hintText: " Brand",

                    ),

                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      hintText: " Price",

                    ),

                  ),

                  SizedBox(height: 20),
                  GestureDetector(

                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        color: Colors.teal,
                        child: Stack(
                          children: [
                            pickedImage != null ? Image.file(pickedImage!,width:MediaQuery.of(context).size.width,fit: BoxFit.cover,): Image.asset("assets/images/upload.jpg",
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              color: Colors.black.withOpacity(0.5),
                              colorBlendMode: BlendMode.darken,),
                            Center(
                                child: Text("Upload Image", style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold))
                            ),
                          ],
                        ),
                      ),
                    onTap:
                    imagePickerOption,

                    //   ImagePicker imagePicker = ImagePicker();
                    //   XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
                    //   //imagePicker.pickImage(source: ImageSource.gallery);
                    //   //print('${file?.path}');
                    //   String uniqueImgFileName = DateTime.now().millisecondsSinceEpoch.toString();
                    //
                    //   //Get a reference to firebase storage root
                    //   Reference referenceRoot = FirebaseStorage.instance.ref();
                    //   Reference referenceDirImages = referenceRoot.child('images');
                    //
                    //   //Create a reference for the image to be stored
                    //   Reference referenceImageToUpload = referenceDirImages.child(uniqueImgFileName);
                    //
                    //
                    //
                    //     //Store the Image in Firebase Storage
                    //    await  referenceImageToUpload.putFile(File(file!.path));
                    //    //Get the download url
                    //    imageUrl = await referenceImageToUpload.getDownloadURL();
                    //
                    //
                    //
                    //


                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      Icon(Icons.info),
                      Container(
                        width: 350,
                       // height: 40,
                        child: Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Do You Already input your Jazzcash Account Number for receiving payment, If No, Click on No Button!",
                              //overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 150,
                    child: TextButton(
                        onPressed: (){
                          setState(() {
                            showTextFields = !showTextFields;
                          });

                        },
                        child: Text("No"),

                    ),
                  ),

                  Visibility(
                    visible: showTextFields,
                    child: Column(
                      children: [
                        TextField(
                          controller:_jazzAccController,
                          decoration: InputDecoration(
                            hintText: "Enter Your Jazzash Account Number",
                            labelText: 'Jazzcash Account Number',
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        )
                        // TextField(
                        //   decoration: InputDecoration(
                        //     labelText: 'Password',
                        //   ),
                        // ),
                        // TextField(
                        //   decoration: InputDecoration(
                        //     labelText: 'Integrity Salt',
                        //   ),
                        // ),
                      ],
                    ),
                  ),


                  ElevatedButton(
                    onPressed: () async {
                      String title = _titleController.text;
                      String desc = _descController.text;
                      String cond = _condController.text;
                      String brand = _brandController.text;
                      String price = _priceController.text;
                      String category = valueChoose;
                      String jazzAccNo = _jazzAccController.text;



                      // Add the new value at the 0th index
                     // array.insert(0, 'New Value');

                      Map<String,String> dataToSend = {
                        'Title'  : title,
                        'Description' : desc,
                        'Condition' : cond,
                        'Brand' : brand,
                        'Price' : price,
                        'Image' : imageUrl,
                        'Category' : category,
                      };
                      //  Stream<QuerySnapshot<Object?>> stream = widget._referencePostsReference.snapshots();
                      //  Future<int> length = stream.length;
                      //  print(length);
                      //
                      // final int postLength = await widget._referencePostsReference.snapshots().length;
                      // print(postLength);

                      QuerySnapshot posts = await widget._referencePostsReference.get();
                      int postLength = posts.docs.length;
                      String userPost = "${login}_${postLength+1}";
                      widget._referencePostsReference.doc(userPost).set(dataToSend);
                      print("Adeed Successfully!");
                      print(userPost);



                      DocumentSnapshot snapshot = await FirebaseFirestore.instance
                          .collection('Users')
                          .doc(login)
                          .get();

                      if (snapshot.exists) {
                        var fieldValue = snapshot.get('JazzcashAccountNumber');
                        if(fieldValue == ''){
                          widget._userDocumentReference.update({"JazzcashAccountNumber": _jazzAccController.text});

                        }
                      } else {
                        print('Document does not exist');
                      }
                     //
                     //      var fieldValue = field['JazzcashAccountNumber']
                     //      if(fieldValue== "" ){
                     //        widget._userDocumentReference.update({"JazzcashAccountNumber": _jazzAccController.text});
                     //      }
                     //    else {
                     //      // Document does not exist
                     //    }
                     // if(widget._userDocumentReference.snapshots())
                     //  widget._userDocumentReference.set({ "JazzcashAccountNumber": _jazzAccController.text});
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Dashboard()));


                    },
                    child: Text("Post"),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan)),
                  )
                ]

            ),
          ),
        ),
      );

  }
}
