import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:spyce/modal/audiofile.dart';
import 'dart:io';
import 'package:spyce/services/firebasedata.dart';

class Uploadsong extends StatefulWidget {
  @override
  _UploadsongState createState() => _UploadsongState();
}

class _UploadsongState extends State<Uploadsong> {
  Firebasedata services = new Firebasedata();
  bool imageuploaded=false,audiouploaded=false,_loading=false;
  TextEditingController audioname = new TextEditingController();
  String imagepath,audiopath,imageurl,audiourl;
  FilePickerResult image,audio;
  File imagefile,audiofile;
  final formkey = GlobalKey<FormState>();
  void pickimage() async {
    image = await FilePicker.platform.pickFiles(type: FileType.image);
    imagefile=File(image.files.single.path);
    if(image!=null){
      imageuploaded=true;
    }
    setState(() {});
  }
  void pickaudio() async {
    audio = await  FilePicker.platform.pickFiles(type: FileType.audio);
    audiofile=File(audio.files.single.path);
    if(audio!=null){
      audiouploaded=true;
    }
    setState(() {});
  }
  uploadfile()async{
    String currenttime =DateTime.now().toString();
    UploadTask imageUpload = FirebaseStorage.instance.ref().child("images").child(currenttime+image.files.single.extension).putFile(imagefile);
    imageurl = await(await imageUpload).ref.getDownloadURL();
    UploadTask audioUpload = FirebaseStorage.instance.ref().child("audios").child(currenttime+audio.files.single.extension).putFile(audiofile);
    audiourl = await(await audioUpload).ref.getDownloadURL();
  }
  void upload() async {
    if(formkey.currentState.validate()){
      setState(() {
        _loading=true;
      });
      await uploadfile();
      Audiofile audiofile = new Audiofile();
      audiofile.name = audioname.text;
      audiofile.imageurl = imageurl;
      audiofile.audiourl = audiourl;
      services.uploadaudiofile(audiofile);
    }
    setState(() {
      _loading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return _loading?
    Center(
      child: CircularProgressIndicator(),
    ):
    Container(
      padding: EdgeInsets.all(30),
      child: Center(
        child: Form(
          key: formkey,
          child: ElevatedButtonTheme(
            data: ElevatedButtonThemeData(
              style: ButtonStyle( backgroundColor: MaterialStateProperty.all(Colors.purpleAccent.shade200)),
            ),
            child: Column(
              children: [
                Container(
                  width: 300,
                  padding: EdgeInsets.all(7),
                  child: TextFormField(
                    validator: (val){
                      if(val.isNotEmpty){
                        return null;
                      }
                      else if(!audiouploaded){
                        return "no audio uploaded";
                      }
                      else if(!imageuploaded){
                        return "no image uploaded";
                      }
                      else{
                        return "name can't be nothing";
                      }
                    },
                    controller: audioname,
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Song Name',
                      hintStyle: TextStyle(color: Colors.white60),
                      enabledBorder:  UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.purpleAccent.shade200),
                      ),
                    ),
                    cursorColor: Colors.white30,
                  ),
                ),
                //(imageuploaded)?Image(image: FileImage(imagefile)):Container(),
                ElevatedButton(
                  child: Container(
                    width: 250,
                    child: Text(
                      (imageuploaded)?image.files.single.name:"Select a file",
                      softWrap: true,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.3,
                    ),
                  ),
                  onPressed: (){
                    pickimage();
                  }
                ),
                ElevatedButton(
                  child: Container(
                    width: 250,
                    child: Text(
                      (audiouploaded)?audio.files.single.name:"Select a file",
                      softWrap: true,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.3,
                    ),
                  ),
                  onPressed:(){
                    pickaudio();
                  } 
                ),
                ElevatedButton(
                  child: Container(
                    width: 250,
                    child: Text(
                      "Upload",
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.3,
                    ),
                  ),
                  onPressed: (){
                    upload();
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}