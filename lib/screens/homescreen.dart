import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spyce/screens/audioplaying.dart';
import 'package:spyce/services/firebasedata.dart';


class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  Firebasedata  services = new Firebasedata();
  QuerySnapshot allfiles;
  getdata() async{
    allfiles= await services.getaudiofile();
    setState(() {});
  }
  @override
    void initState() {
      getdata();
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    if(allfiles ==null){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
      itemCount: allfiles.docs.length,
      itemBuilder: (context,index){
        if(index == null) {
          return CircularProgressIndicator();
        }
        return audiodisp(
          context,
          imageurl: allfiles.docs[index].data()["imageurl"],
          audiourl: allfiles.docs[index].data()["audiourl"],
          name: allfiles.docs[index].data()["name"],
          id: allfiles.docs[index].id,
        );
      },
    );
  }

  Widget audiodisp(BuildContext context,{String imageurl,String audiourl,String name,String id}){
    return Container(
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return Audioon(imageurl, audiourl,name,id);
          }));
        },
        child: Container(
          padding: EdgeInsets.all(5),
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple,
                Colors.pinkAccent
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.deepPurple,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  image: DecorationImage(
                    fit:BoxFit.fill,
                    image: NetworkImage(imageurl)
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.grey[200],       
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}