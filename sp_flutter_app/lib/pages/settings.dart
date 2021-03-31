import 'package:flutter/material.dart';
import 'package:ReserveIt/service/database.dart';
import 'package:ReserveIt/shared/loader.dart';
import 'package:ReserveIt/models/user.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ReserveIt/pages/editProfile.dart';
import 'package:ReserveIt/pages/changePassword.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as Path;

class SettingsPage extends StatefulWidget {

  final String firstName,lastName,email,type;
  final int phoneNo;

  SettingsPage({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNo,
    this.type,
  });
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool updatePicture = true;
  var userData ;
  var id;
  void getUser(String uid) async {
    userData = await DatabaseService(uid: uid).getUserInfo();
    setState(() {
      updatePicture = true;
    });
  }

  final DatabaseService _database = DatabaseService();

  File _image;
  final picker = ImagePicker();
  String _uploadedFileURL;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
      updatePicture = false;
      print('File selected');
    });
  }

  Future uploadFile() async {
    print('File Uploading');
    if(widget.type == "User"){
      StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profilePictures/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete.then((result) async{
    // do something
     print('File Uploaded');
     storageReference.getDownloadURL().then((fileURL) async {
       await _database.updateProfilePicture(id, fileURL).then((result){
        setState(() {
        _uploadedFileURL = fileURL;
        print(_uploadedFileURL);
        print("shahahah");
        updatePicture = true;
        Navigator.pop(context);
      });
      });
    });
}); 
    }
    else{
      StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('adminProfilePictures/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete.then((result) async{
    // do something
     print('File Uploaded');
     storageReference.getDownloadURL().then((fileURL) async {
       await _database.updateAdminProfilePicture(id, fileURL).then((result){
        setState(() {
        _uploadedFileURL = fileURL;
        print(_uploadedFileURL);
        print("shahahah");
        updatePicture = true;
        Navigator.pop(context);
      });
      });
    });
}); 
    }
  }


  @override
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width*0.8;
    final user = Provider.of<User>(context);
    id = user.uid;
    if(!updatePicture){
      print(" getting userinfo ");
      uploadFile();
      return Loader();
    }
    else{
      print("Settings page Called");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            ),
        ),
        ),
      body: SingleChildScrollView(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ 
            Container(
                height: MediaQuery.of(context).size.height * 0.48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 0.0,
                        color: Colors.black26,
                        offset: Offset(1.0, 10.0),
                        blurRadius: 20.0),
                  ],
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: 
                // FlutterLogo(size: 100),
                Image.asset('assets/img/settings.png',
                fit:BoxFit.cover ,),
                 ),
             SizedBox(height: 15,),
            Text(
                  "Account Settings",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
             SizedBox(height: 15,),
            Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                  elevation: 3.0,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfilePage(
                                        firstName:widget.firstName,
                                        lastName:widget.lastName,
                                        email:widget.email,
                                        phoneNo:widget.phoneNo,
                                        type:widget.type,)));
                          },
                          child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.edit,
                                    color: Color(0xff374ABE),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Text(
                                    "Edit Profile",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                        ),
                        Divider(
                          height: 10.0,
                          color: Colors.grey,
                        ),
                        FlatButton(
                          onPressed: getImage,
                          child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.add_a_photo,
                                    color: Color(0xff374ABE),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Text(
                                    "Change Profile Picture",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                        ),
                        Divider(
                          height: 10.0,
                          color: Colors.grey,
                        ),
                        FlatButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordPage()));
                          },
                          child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.update,
                                    color: Color(0xff374ABE),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Text(
                                    "Change Password",
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ],
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],),
            ),
          ],
          ) ,
          ),
      ),
    );
    }
  }
}