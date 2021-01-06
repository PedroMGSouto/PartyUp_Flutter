import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';



class Requests extends StatefulWidget {
  Requests({Key key}) : super(key: key);

  @override
  _req createState() => _req();
}

class _req extends State<Requests> {
  final dbRef = FirebaseDatabase.instance.reference().child("Requests");
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
                              title: Text(lists[index]["game"]),
                              subtitle: Text(lists[index]["sentBy"]),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(onPressed: null, child: Text("Join Party")),
                                Text(lists[index]["time"]),
                                Text(lists[index]["partyCurr"] + "/"+ lists[index]["partySize"]),
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