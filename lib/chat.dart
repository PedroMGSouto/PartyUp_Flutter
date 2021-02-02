import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'globals.dart' as globals;

class Chat extends StatefulWidget {
  final String id;
  Chat({Key key, @required this.id}) : super(key: key);

  @override
  _req createState() => _req();
}

class _req extends State<Chat> {
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

  Scaffold buildReq(){
    String hashed = md5.convert(utf8.encode(mail)).toString();
    return Scaffold(
        backgroundColor: Colors.redAccent,
        appBar: AppBar(
          title: Text("Chat"),
          backgroundColor: Colors.black,
        ),
        body: Column(
            children: <Widget>[
              Expanded(
                  child: SingleChildScrollView(
                child: StreamBuilder(
                stream: dbRef.onValue,
                builder: (context, snap) {

                  if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {

                    Map data = snap.data.snapshot.value;
                    List item = [];

                    data.forEach((index, data) => item.add({"key": index, ...data}));

                    item.sort((a, b) => (a["time"]).compareTo(b["time"]));

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: item.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile( leading: Icon(Icons.perm_identity,color: Colors.cyan,size: 50,),
                                  title: Text(item[index]["message"]),
                                  subtitle: Text("Sent by "+item[index]["sentBy"]),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(item[index]["messageDate"]),
                                    Text(item[index]["messageTime"]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  else
                    return CircularProgressIndicator();
                },
            ),
    )
              ),
              Row(
                children: <Widget>[
                  Expanded(child: TextFormField(decoration: new InputDecoration(fillColor: Colors.white,filled: true, border: new OutlineInputBorder(borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),)),controller: myController,)),
                  RawMaterialButton(
                    onPressed: (){
                      var now = DateTime.now();
                      String id = mail + now.toString();
                      String idHash = md5.convert(utf8.encode(id)).toString();
                      FirebaseDatabase.instance.reference().child("chatMessages/" + chatID+"/"+idHash).set({
                        'message':myController.text,
                        'messageDate': DateFormat('dd-MM-yyyy').format(now).toString(),
                        'messageTime': DateFormat('hh:mm').format(now).toString(),
                        'sentBy': globals.username,
                        'time': DateFormat('dd-MM-yyyy hh:mm:ss').format(now).toString()
                      });
                      myController.clear();
                    },
                    elevation: 2.0,
                    fillColor: Colors.white,
                    child: Icon(
                      Icons.send,
                      size: 35.0,
                    ),
                    padding: EdgeInsets.all(15.0),
                    shape: CircleBorder(),
                  ),
                ],
              )
            ]
        ));
  }

  @override
  Widget build(BuildContext context) {
    return buildReq();
  }
}