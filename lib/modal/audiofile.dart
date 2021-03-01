import 'dart:math';

class Audiofile{
  String imageurl,audiourl,name;
  int likes=0,dislikes=0;
  Map<String,dynamic> tojson(){
    return {
      "imageurl":imageurl,
      "audiourl":audiourl,
      "name":name,
      "likes":likes,
      "dislikes":dislikes,
    };
  }
}