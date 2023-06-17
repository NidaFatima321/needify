import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailDialog extends StatelessWidget {
  const EmailDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController subject = TextEditingController();
    TextEditingController recipient = TextEditingController();
    TextEditingController bcc = TextEditingController();
    TextEditingController cc = TextEditingController();
    TextEditingController body = TextEditingController();
    PlatformFile? _file;

    getfile() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.first;
        _file = PlatformFile(path:result.files.single.path, name: result.files.single.name,size: result.files.single.size);
        print(file);
      } else {
        print("No file selected");
      }
    }
    Future<void> send() async {
      final Email email = Email(
        body: body.text,
        subject: subject.text,
        recipients: [recipient.text],
        attachmentPaths: [_file!.path!],
      );
      String platformResponse;

      try {
        await FlutterEmailSender.send(email);
        platformResponse = 'success';
      } catch (error) {
        platformResponse = error.toString();
      }

    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFC52348),
            foregroundColor: Colors.black,
            title: Text("Email"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/email.jpeg', // Replace with your image path
                        width: 100, // Set the desired width
                        height: 100, // Set the desired height
                      ),
                    ),
                    Text(
                        "Compose and Send Email",
                      style: TextStyle(
                        color: Color(0xFF081857), fontSize: 40, fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Welcome to our Email Sending feature! This powerful tool allows you to effortlessly "
                          "compose and send emails directly from our app. Whether you need to communicate "
                          "with clients, colleagues, or friends, our intuitive interface makes it easy to "
                          "craft and deliver your messages with just a few clicks.",
                      style: TextStyle(
                        fontSize: 15
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Subject",
                      style: TextStyle(
                        color: Color(0xFFA4062A), fontSize: 20, fontFamily: 'Times New Roman', fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: subject,
                      style:
                          TextStyle(fontSize: 17, fontFamily: 'SourceSansPro'),
                      decoration: InputDecoration(
                        labelText: "Enter Subject Here",
                        fillColor: Colors.grey[300],
                        filled: true,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Recipient",
                      style: TextStyle(
                          color: Color(0xFFA4062A),fontSize: 20, fontFamily: 'Times New Roman', fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller:recipient,
                      style:
                          TextStyle(fontSize: 17, fontFamily: 'SourceSansPro'),
                      decoration: InputDecoration(
                        labelText: "Enter Recipient Here",
                        fillColor: Colors.grey[300],
                        filled: true,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "BCC",
                      style: TextStyle(
                          color: Color(0xFFA4062A),fontSize: 20, fontFamily: 'Times New Roman', fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: bcc,
                      style:
                          TextStyle(fontSize: 17, fontFamily: 'SourceSansPro'),
                      decoration: InputDecoration(
                        labelText: "Enter BCC Here",
                        fillColor: Colors.grey[300],
                        filled: true,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "CC",
                      style: TextStyle(
                          color: Color(0xFFA4062A), fontSize: 20, fontFamily: 'Times New Roman', fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: cc,
                      style:
                          TextStyle(fontSize: 17, fontFamily: 'SourceSansPro'),
                      decoration: InputDecoration(
                        labelText: "Enter CC Here",
                        fillColor: Colors.grey[300],
                        filled: true,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Body",
                      style: TextStyle(
                          color: Color(0xFFA4062A), fontSize: 20, fontFamily: 'Times New Roman', fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: body,
                      style:
                          TextStyle(fontSize: 17, fontFamily: 'SourceSansPro'),
                      decoration: InputDecoration(
                        labelText: "Enter Body Here",
                        fillColor: Colors.grey[300],
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 50.0),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: constraints.maxWidth,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: getfile,
                          child: Text("Attatch Files"),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.black26;
                              }
                              return Color(0xFFC90505);
                            }),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                        width: constraints.maxWidth,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: send, child: Text("Send Email"),
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
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }
}
