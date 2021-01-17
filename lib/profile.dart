import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';



class Profile extends StatefulWidget {
  final String email;
  Profile({Key key, @required this.email}) : super(key: key);

  @override
  _pr createState() => _pr();
}

class _pr extends State<Profile> {
  static String mail;

  @override
  void initState(){
    super.initState();
    mail= md5.convert(utf8.encode(widget.email)).toString();
  }

  final dbRef = FirebaseDatabase.instance.reference().child("Users").child(mail);
  List<Map<dynamic, dynamic>> lists = [];

  Scaffold buildReq(){
    return Scaffold(
        body: FutureBuilder(
            future: dbRef.once(),
            builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
              if (snapshot.hasData) {
                lists.clear();
                Map<dynamic, dynamic> values = snapshot.data.value;
                values.forEach((key, values) {
                  lists.add(values);
                });
                return new ListView.builder(
                    shrinkWrap: true,
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile( leading: Icon(Icons.gamepad,color: Colors.cyan,size: 50,),
                              title: Text("Profile"),
                              subtitle: Text("this profile"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Email: "+lists[index]["Email"]),
                                Text("Name: "+lists[index]["Name"]),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              }
              return CircularProgressIndicator();
            }));
  }

  @override
  Widget build(BuildContext context) {
    dbRef.onValue.listen((event) {
      setState(() {
        return buildReq();
      });
    });
    return buildReq();
  }
}