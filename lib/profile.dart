import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'globals.dart' as globals;



class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _pr createState() => _pr();
}

class _pr extends State<Profile> {
  final String mail = globals.mail;

  Scaffold buildReq(){
    String hashed = md5.convert(utf8.encode(mail)).toString();

    final dbRef = FirebaseDatabase.instance.reference().child("Users/"+hashed);
    return Scaffold(
        body: StreamBuilder(
          stream: dbRef.onValue,
          builder: (context, snap) {
            if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {

              Map data = snap.data.snapshot.value;

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.redAccent, Colors.pinkAccent]
                            )
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 350.0,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  child: Icon(Icons.person,size: 50,
                                  ),
                                  radius: 50.0,
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  data["Name"],
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Card(
                                  margin: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                                  clipBehavior: Clip.antiAlias,
                                  color: Colors.white,
                                  elevation: 5.0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 22.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(

                                            children: <Widget>[
                                              Text(
                                                "PJoined",
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                data["PJoined"].toString(),
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.pinkAccent,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(

                                            children: <Widget>[
                                              Text(
                                                "PStarted",
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                data["PStarted"].toString(),
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.pinkAccent,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(

                                            children: <Widget>[
                                              Text(
                                                "QR Scan",
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                data["QRScanned"].toString(),
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.pinkAccent,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Info:",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 28.0
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,0,0,20),
                              child: Text('User: '+data["User"],
                                style: TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                  letterSpacing: 2.0,
                                ),
                              ),
                            ),
                            Text('E-mail: '+data["Email"],
                              style: TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              );
            }
            else
              return CircularProgressIndicator();
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return buildReq();
  }
}