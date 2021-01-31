import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'globals.dart' as globals;

class Achievements extends StatelessWidget{
  final dbRef = FirebaseDatabase.instance.reference().child("AchievementsGot/"+md5.convert(utf8.encode(globals.mail)).toString());
  final dbRef3 = FirebaseDatabase.instance.reference().child("Users/"+md5.convert(utf8.encode(globals.mail)).toString());
  final dbRef2 = FirebaseDatabase.instance.reference().child("Achievements");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.redAccent,
        body: ListView(
            children: [
              StreamBuilder(
                stream: dbRef.onValue,
                builder: (context, snap) {

                  if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                    for(String id in snap.data.snapshot.value){
                      globals.got.add(id);
                    }

                    return StreamBuilder(
                        stream: dbRef2.onValue,
                        builder: (context, snap) {
                          if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                            Map data = snap.data.snapshot.value;
                            List item = [];

                            data.forEach((index, data) {
                              if (globals.got.contains(index)) {
                                item.add({"key": index, ...data});
                              }
                            });


                            return ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: item.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: new InkWell(
                                  onTap: () {
                                    showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                    return AlertDialog(
                                      content:
                                      Container(
                                        height: 200.0, // Change as per your requirement
                                        width: 200.0,
                                        child: Center(
                                          child: QrImage(
                                            data:  item[index]["name"]+","+item[index]["id"],
                                            version: QrVersions.auto,
                                            size: 200.0,
                                          ),
                                        ),
                                      ),
                                    );});
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(leading: FaIcon(FontAwesomeIcons.trophy,size: 50,color: Colors.cyan,),
                                          title: Text(item[index]["name"]),
                                          subtitle: Text(
                                              item[index]["description"]),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(child: Text("Created by "+item[index]["sentBy"]+" at "+ item[index]["time"]))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ),
                                );
                              },
                            );
                          }
                          else{
                            return CircularProgressIndicator();
                          }
                    });

                  }
                  else
                    return CircularProgressIndicator();
                },
              ),]
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if(await Permission.camera.request().isGranted){
              String cameraScanResult = await scanner.scan();
              var split = cameraScanResult.split(',');
              if(!globals.got.contains(split[1])){
                globals.got.add(split[1]);
                dbRef.set(globals.got.toList());
                dbRef3.update({"QRScanned":ServerValue.increment(1)});
                showAchievementView(context, split[0]);
              }
            }
          },
          label:Text('Achievement Scanner'),
          icon: FaIcon(FontAwesomeIcons.trophy),
        )
    );
  }
}

void showAchievementView(BuildContext context, String achiev){
  AchievementView(
      context,
      title: "Achievement unlocked!",
      subTitle: achiev,
      icon: Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0),child: FaIcon(FontAwesomeIcons.trophy, color: Colors.white,)),
      borderRadius: 5.0,
      color: Colors.cyan,
      textStyleTitle: TextStyle(),
      textStyleSubTitle: TextStyle(),
      alignment: Alignment.topCenter,
      duration: Duration(seconds: 3),
      isCircle: true,
      listener: (status){
        print(status);
      }
  )..show();
}


