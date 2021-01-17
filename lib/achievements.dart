import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/material.dart';
import 'package:achievement_view/achievement_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class Achievements extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.redAccent,
        body: Column(
            children: [
              Text(
              'Achievements',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),]
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if(await Permission.camera.request().isGranted){
              String cameraScanResult = await scanner.scan();
              showAchievementView(context, cameraScanResult);
            }
          },
          label:Text('Achievement Scanner'),
          icon: Icon(Icons.qr_code_scanner),
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
