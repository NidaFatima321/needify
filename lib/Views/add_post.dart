import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:needify/Views/Home.dart';
import 'package:needify/Views/dashboard_needify.dart';
import 'dart:core';

import 'package:needify/Views/my_purchases.dart';

import '../main.dart';
import 'Home.dart';
class AddPost extends StatefulWidget {


  AddPost({Key? key}) : super(key: key){
    //Getting the reference of root collection as Users

    _userDocumentReference = FirebaseFirestore.instance.collection('Users').doc(login);

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

  //for inputting the unique post Id
  int collectionLengthPlusOne = 0;
  void listenToCollectionLength() {
    widget._referencePostsReference.snapshots().listen((snapshot) {
      setState(() {
        collectionLengthPlusOne = snapshot.docs.length + 1;
      });
    });
  }


  String valueChoose = "Drawing Tools";
  List<String> listItem = <String>[
    "Laptop", "Notes", "Drawing Tools", "Others"
  ];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _condController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _statusController = TextEditingController();


  String imageUrl = '';

  // late DocumentReference _userDocumentReference;
  //late CollectionReference _referencePostsReference;

  TextEditingController _jazzAccController = TextEditingController();

  @override
  void initState() {
    super.initState();
    listenToCollectionLength();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC52348),
        foregroundColor: Colors.black,
        title: Text("Create new Post"),
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
                  Center(
                    child: Image.asset(
                      'assets/images/post.jpeg', // Replace with your image path
                      width: 100, // Set the desired width
                      height: 100, // Set the desired height
                    ),
                  ),
                  Text(
                    "Create Your Post and Sell with Ease",
                    style: TextStyle(
                      color: Color(0xFF081857), fontSize: 40, fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "This page designed exclusively for sellers like you. Get ready to unleash your "
                        "selling potential and effortlessly showcase your items to a wide audience. With "
                        "our intuitive platform, you can craft compelling posts that captivate potential "
                        "buyers and pave the way for successful transactions.",
                    style: TextStyle(
                        fontSize: 15
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Add Details of Your Item Here",
                    style: TextStyle(
                      color: Color(0xFFC52348), fontSize: 20, fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Add Title",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          width: 3,
                          color: Color(0xFFC52348),
                        )
                      )
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _descController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add Description',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFFC52348),
                        ),
                      ),
                      // contentPadding: EdgeInsets.only(left:8.0,bottom:32.0,top:32.0),
                    ),
                    maxLength: 100,

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
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color(0xFFC52348),
                            )
                        )
                    ),

                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _brandController,
                    decoration: InputDecoration(
                      hintText: " Brand",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color(0xFFC52348),
                            )
                        )
                    ),

                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      hintText: " Price",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color(0xFFC52348),
                            )
                        )
                    ),

                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _statusController,
                    decoration: InputDecoration(
                        hintText: " Status",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Color(0xFFC52348),
                            )
                        )
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
                        width: 300,
                      //eight: 50,
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
                      String status = _statusController.text;
                      String category = valueChoose;
                      String jazzAccNo = _jazzAccController.text;
                      String id = collectionLengthPlusOne.toString();
                      String withdrawn = "-0";
                      String withdrawnTime = "";



                      // Add the new value at the 0th index
                     // array.insert(0, 'New Value');

                      Map<String,String> dataToSend = {
                        'Title'  : title,
                        'Description' : desc,
                        'Condition' : cond,
                        'Brand' : brand,
                        'Price' : price,
                        'Status' : status,
                        'Image' : imageUrl,
                        'Category' : category,
                        'id': id,
                        'Withdrawn' : withdrawn,
                        'WithdrawnTime' : withdrawnTime,
                      };
                      //  Stream<QuerySnapshot<Object?>> stream = widget._referencePostsReference.snapshots();
                      //  Future<int> length = stream.length;
                      //  print(length);
                      //
                      // final int postLength = await widget._referencePostsReference.snapshots().length;
                      // print(postLength);

                      // QuerySnapshot posts = await widget._referencePostsReference.get();
                      // int postLength = posts.docs.length;
                      // widget._referencePostsReference.doc('zoyakashif23@gmail.com_${postLength +1 }').set(dataToSend);
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Dashboard()));

                      QuerySnapshot posts = await widget._referencePostsReference.get();
                      int postLength = posts.docs.length;
                      String userPost = "${login}_${postLength+1}";
                      widget._referencePostsReference.doc(userPost).set(dataToSend);
                      List<dynamic> Categories = maindata!['Categories'];
                      int val=0;
                      for(int i=0;i<Categories.length;i++){
                        if(Categories[i] == category){
                          val=1;
                        }
                      }
                      if(val==0){
                      Categories.add(category);
                      }
                      print(Categories);
                      FirebaseFirestore.instance.collection('Users').doc(login).update({'Categories':Categories});
                      print("Adeed Successfully!");
                      print(userPost);
                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));

                      //Updating jazzAccount field of login user
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
                      // List<dynamic> Categories=maindata!['Categories'];
                      // Categories.add(category);
                      // print(Categories);
                      // FirebaseFirestore.instance.collection('Users').doc(login).update({'Categories':Categories});
                      //
                      //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));


                    },
                    child: Text("Post", style: TextStyle(fontSize: 22),),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.black26;
                          }
                          return Color(0xFF081857);
                        }),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                        )
                    ),
                  )
                ]

            ),
          ),
        ),
      );

  }
}


