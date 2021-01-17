import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'globals.dart' as globals;
import 'package:intl/intl.dart';

class chat extends StatefulWidget {
  final String id;
  chat({Key key, @required this.id}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<chat> {
  static String chatID;
  static var dbRef;
  final myController = TextEditingController();

  @override
  void initState(){
    super.initState();
    chatID= widget.id;
    dbRef = FirebaseDatabase.instance.reference().child("chatMessages/" + chatID).orderByChild('time');
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  final String mail = globals.mail;
  List<Map<dynamic, dynamic>> lists = [];

  Scaffold buildReq() {
    String hashed = md5.convert(utf8.encode(mail)).toString();
    return Scaffold(
        body: Column(
            children: <Widget>[ FutureBuilder(
                future: dbRef.once(),
                builder: (context, AsyncSnapshot<DataSnapshot> snapshot){
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
                                  title: Text(lists[index]["message"]),
                                  subtitle: Text(lists[index]["sentBy"]),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(lists[index]["time"]),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  }
                  return CircularProgressIndicator();
                }
          ),
        Spacer(),
              Row(
                children: <Widget>[
                  Expanded(child: TextFormField(controller: myController,)),
                  RaisedButton(onPressed: (){
                    var now = DateTime.now();
                    String id = mail + now.toString();
                    String idHash = md5.convert(utf8.encode(id)).toString();
                    FirebaseDatabase.instance.reference().child("chatMessages/" + chatID+"/"+idHash).set({
                      'message':myController.text,
                      'messageDate': DateFormat('dd-MM-yyyy').format(now).toString(),
                      'messageTime': DateFormat('hh:mm').format(now).toString(),
                      'sentBy': globals.user.user.email,
                      'time': DateFormat('dd-MM-yyyy hh:mm:ss').format(now).toString()
                    });
                  }),
                ],
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    dbRef.onValue.listen((event) {
      setState(() {
        //return buildReq();
      });
    });
    return buildReq();
  }
}


