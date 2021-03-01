import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spyce/modal/audiofile.dart';

class Firebasedata{
  getaudiofile() async {
    return await FirebaseFirestore.instance.collection("audiofile").get();
  }
  uploadaudiofile(Audiofile file) async {
    await FirebaseFirestore.instance.collection("audiofile").add(file.tojson());
  }
  Future<QueryDocumentSnapshot> getnextfile(String id) async {
    QuerySnapshot allfiles= await getaudiofile();
    for(int i=0;i<allfiles.docs.length-1;i++){
      if(allfiles.docs[i].id==id){
        return allfiles.docs[i+1];
      }
    }
    return allfiles.docs[0];
  }
  Future<QueryDocumentSnapshot> getprevfile(String id) async{
    QuerySnapshot allfiles = await getaudiofile();
    for(int i=1;i<allfiles.docs.length;i++){
      if(allfiles.docs[i].id==id){
        return allfiles.docs[i-1];
      }
    }
    return allfiles.docs[allfiles.docs.length-1];
  }
}