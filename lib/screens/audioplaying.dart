import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:spyce/services/firebasedata.dart';

class Audioon extends StatefulWidget {
  final String imageurl,audiourl,audioid,name;
  Audioon(this.imageurl,this.audiourl,this.name,this.audioid);
  @override
  _AudioonState createState() => _AudioonState();
}

class _AudioonState extends State<Audioon> {
  Firebasedata services = new Firebasedata();
  AudioPlayer audioPlayer = new AudioPlayer();
  Duration duration = new Duration();
  Duration current = new Duration();
  bool _isplaying = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(_isplaying){
          playpause();
        }
        return Future<bool>.value(true);
      },
      child: Scaffold(
        body : Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Spacer(),
              Image(
                image: NetworkImage(widget.imageurl),
                alignment: Alignment.center,
                height: 200,
                width: 200,
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  widget.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              slider(),
              Row(
                children: [
                  Spacer(flex: 6,),
                  Ink(
                    decoration: ShapeDecoration(
                      color: Colors.white24,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        Icons.skip_previous
                      ), 
                      iconSize: 30,
                      onPressed: ()async {
                        if(_isplaying){
                          playpause();
                        }
                        QueryDocumentSnapshot prevs = await services.getprevfile(widget.audioid);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context){
                            return Audioon(prevs.data()['imageurl'], prevs.data()['audiourl'], prevs.data()['name'], prevs.id);
                          }
                          )
                        );
                      }
                    ),
                  ),
                  Spacer(),
                  Ink(
                    padding: EdgeInsets.all(4),
                    decoration: ShapeDecoration(
                      color: Colors.white24,
                      shape: CircleBorder(),
                    ),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        _isplaying?
                        Icons.pause:
                        Icons.play_arrow,
                      ), 
                      iconSize: 50,
                      onPressed: (){
                        playpause();
                      }
                    ),
                  ),
                  Spacer(),
                  Ink(
                    decoration: ShapeDecoration(color: Colors.white24,shape: CircleBorder(),),
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(
                        Icons.skip_next
                      ),
                      iconSize: 30,
                      onPressed:  ()async{
                        if(_isplaying){
                          playpause();
                        }
                        QueryDocumentSnapshot prevs = await services.getnextfile(widget.audioid);
                        print(prevs);
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context){
                            return Audioon(prevs.data()['imageurl'], prevs.data()['audiourl'], prevs.data()['name'], prevs.id);
                          }
                          )
                        );
                      },
                    ),
                  ),
                  Spacer(flex: 6,),
                ] 
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void playpause() async {
    if(_isplaying){
      var res = await audioPlayer.pause();
      if(res==1){
        setState(() {
          _isplaying = false;
        });
      }
    }
    else{
      var res = await audioPlayer.play(widget.audiourl,isLocal: true); 
      if(res==1){
        setState(() {
          _isplaying = true;
        });
      }
      audioPlayer.onDurationChanged.listen((Duration dura) {
        setState(() {
          duration = dura;
        });
      });
      audioPlayer.onAudioPositionChanged.listen((Duration dura) { 
        setState(() {
          current = dura;
        });
      });
    }
  }
  Widget slider(){
    return Slider.adaptive(
      min: 0.0,
      value: current.inSeconds.toDouble(),
      max: duration.inSeconds.toDouble(),
      onChanged: (double val){
        setState(() {
          audioPlayer.seek(new Duration(seconds: val.toInt()));
        });
      },
    );
  }

}