import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';

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
        _file = File(result.files.single.path!) as PlatformFile?;
        print(file);
      } else {
        print("No file selected");
      }
    }

    // sendEmail() async{
    //   final Email email = Email(
    //     body: body.text,
    //     subject:subject.text,
    //     recipients: [recipient.text],
    //     cc: [cc.text],
    //     bcc:[bcc.text],
    //     attachmentPaths:[_file!.path!],
    //     isHTML: false,
    //   );
    //   await FlutterEmailSender.send(email);
    // }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Email"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Subject",
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'Times New Roman'),
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
                      height: 15,
                    ),
                    Text(
                      "Recipient",
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'Times New Roman'),
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
                      height: 20,
                    ),
                    Text(
                      "BCC",
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'Times New Roman'),
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
                      height: 20,
                    ),
                    Text(
                      "CC",
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'Times New Roman'),
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
                      height: 20,
                    ),
                    Text(
                      "Body",
                      style: TextStyle(
                          fontSize: 20, fontFamily: 'Times New Roman'),
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
                      height: 20,
                    ),
                    SizedBox(
                      width: constraints.maxWidth,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: getfile,
                          child: Text("Attatch Files"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                          )),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                        width: constraints.maxWidth,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: (){}, child: Text("Send Email")))
                  ]),
            ),
          ),
        );
      },
    );
  }
}
