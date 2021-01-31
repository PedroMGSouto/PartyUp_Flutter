import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'chat.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'globals.dart' as globals;


class Requests extends StatefulWidget {
  Requests({Key key}) : super(key: key);

  @override
  _req createState() => _req();
}

class _req extends State<Requests> {
  final dbRef = FirebaseDatabase.instance.reference().child("Requests").orderByChild("time");
  final myRef = FirebaseDatabase.instance.reference().child("Games");
  final dbRef3 = FirebaseDatabase.instance.reference().child("Users/"+md5.convert(utf8.encode(globals.mail)).toString());
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  List<String> games = new List<String>();
  var _game;
  var _size;

  @override
  void initState(){
    myRef.onValue.listen((event) {
      games.clear();
      for(dynamic data in event.snapshot.value){
        games.add(data.toString());
      }
    });
  }

  Scaffold buildReq(){
    return Scaffold(
        backgroundColor: Colors.redAccent,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          right: -40.0,
                          top: -40.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CircleAvatar(
                              child: Icon(Icons.close),
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TypeAheadFormField(
                                  textFieldConfiguration: TextFieldConfiguration(
                                    controller: this._typeAheadController,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.gamepad),
                                        helperText: ' ',
                                        hintText: 'Game Name',
                                        contentPadding: new EdgeInsets.symmetric(
                                            vertical: 25.0, horizontal: 10.0),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(32.0)),
                                      labelText: 'Game'
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    return games.where((item) => item.toLowerCase().contains(this._typeAheadController.text.toLowerCase()));
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      title: Text(suggestion),
                                    );
                                  },
                                  transitionBuilder: (context, suggestionsBox, controller) {
                                    return suggestionsBox;
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    this._typeAheadController.text = suggestion;
                                  },
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please select a game';
                                    }
                                    if(!games.contains(value)){
                                      return 'Invalid game!';
                                    }
                                    _game = value;
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.gamepad),
                                      helperText: ' ',
                                      hintText: 'Number of elements',
                                      contentPadding: new EdgeInsets.symmetric(
                                          vertical: 25.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(32.0)),
                                      labelText: 'Party Size'
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please select a valid party size!';
                                    }
                                    if(int.parse(value)>10){
                                      return 'Max Party Size is 10!';
                                    }
                                    if(int.parse(value)<2){
                                      return 'Min Party Size is 2!';
                                    }
                                    _size = value;
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text(
                                    'Party Up!',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(30.0)),
                                  color: Colors.black,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      var now = DateTime.now();
                                      String id = globals.mail + now.toString();
                                      String idHash = md5.convert(utf8.encode(id)).toString();
                                      FirebaseDatabase.instance.reference().child("Requests/" + idHash).set({
                                        'game': _game,
                                        'id':idHash,
                                        'messageDate': DateFormat('dd-MM-yyyy').format(now).toString(),
                                        'messageTime': DateFormat('hh:mm').format(now).toString(),
                                        'partyCurr':'1',
                                        'partySize':_size,
                                        'sentBy': globals.username,
                                        'time': DateFormat('dd-MM-yyyy hh:mm:ss').format(now).toString()
                                      });
                                      String id2 = "Admin" + now.toString();
                                      String idHash2 = md5.convert(utf8.encode(id2)).toString();
                                      FirebaseDatabase.instance.reference().child("chatMessages/" + idHash+"/"+idHash2).set({
                                        'message':"Link Start! ChatRoom initialized!",
                                        'messageDate': DateFormat('dd-MM-yyyy').format(now).toString(),
                                        'messageTime': DateFormat('hh:mm').format(now).toString(),
                                        'sentBy': "PartyUp",
                                        'time': DateFormat('dd-MM-yyyy hh:mm:ss').format(now).toString()
                                      });
                                      this._typeAheadController.clear();
                                      dbRef3.update({"PStarted":ServerValue.increment(1)});
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          label:Text('New Party'),
          icon: Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: dbRef.onValue,
            builder: (context, snap) {

              if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {

                Map data = snap.data.snapshot.value;
                List item = [];

                data.forEach((index, data) => item.add({"key": index, ...data}));

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
                            ListTile( leading: Icon(Icons.gamepad,color: Colors.cyan,size: 50,),
                              title: Text(item[index]["game"]),
                              subtitle: Text("Party Leader: "+item[index]["sentBy"]),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(onPressed: () async{dbRef3.update({"PJoined":ServerValue.increment(1)});Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(id:item[index]["id"])));}, child: Text("Join Party")),
                                Text(item[index]["time"]),
                                Text(item[index]["partyCurr"] + "/"+ item[index]["partySize"]),
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
          )
        ));
  }

  @override
  Widget build(BuildContext context) {
    return buildReq();
  }
}