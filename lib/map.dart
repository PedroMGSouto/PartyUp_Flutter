import 'dart:convert';

import 'package:achievement_view/achievement_view.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'globals.dart' as globals;

class Map extends StatelessWidget{
  final _formKey = GlobalKey<FormState>();
  var _name;
  var _desc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.gamepad),
                                      helperText: ' ',
                                      hintText: 'Name',
                                      contentPadding: new EdgeInsets.symmetric(
                                          vertical: 25.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(32.0)),
                                      labelText: 'Achievement Name'
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Name cannot be empty!';
                                    }
                                    _name = value;
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
                                      hintText: 'Description',
                                      contentPadding: new EdgeInsets.symmetric(
                                          vertical: 25.0, horizontal: 10.0),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(32.0)),
                                      labelText: 'Achievement Description'
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Description cannot be empty!';
                                    }
                                    _desc = value;
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text(
                                    'Add Achievement!',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  textColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(30.0)),
                                  color: Colors.black,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      var now = DateTime.now();
                                      String id = _name + now.toString();
                                      String idHash = md5.convert(utf8.encode(id)).toString();
                                      FirebaseDatabase.instance.reference().child("Achievements/" + idHash).set({
                                        'name': _name,
                                        'description':_desc,
                                        'id':idHash,
                                        'sentBy': globals.username,
                                        'time': DateFormat('dd-MM-yyyy hh:mm:ss').format(now).toString(),
                                        'local': globals.current.latitude.toString()+","+globals.current.longitude.toString()
                                      });
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
          label:Text('New Achievement'),
          icon: Icon(Icons.add),),
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = Location();

  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) { //Here is acks the location changes.
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 15),
        ),
      );
      globals.current = LatLng(l.latitude, l.longitude);
      String hashed = md5.convert(utf8.encode(globals.mail)).toString();
      final dbRef2 = FirebaseDatabase.instance.reference().child("AchievementsGot/"+hashed);
      dbRef2.once().then((DataSnapshot snapshot){
        for(String id in snapshot.value){
          globals.got.add(id);
        }

        for(Marker m in globals.markers){
          if(Geolocator.distanceBetween(l.latitude, l.longitude, m.position.latitude, m.position.longitude)<25 && !globals.got.contains(m.markerId.value.toString())){
            globals.got.add(m.markerId.value.toString());
            dbRef2.set(globals.got.toList());
            showAchievementView(context, m.infoWindow.title);
          }
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final dbRef = FirebaseDatabase.instance.reference().child("Achievements");
    String hashed = md5.convert(utf8.encode(globals.mail)).toString();
    final dbRef2 = FirebaseDatabase.instance.reference().child("Users/"+hashed);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            StreamBuilder(
                stream: dbRef.onValue,
                builder: (context, snap) {
                  if (snap.hasData && !snap.hasError && snap.data.snapshot.value != null) {
                    var data = snap.data.snapshot.value;
                    for(String key in data.keys){
                      Marker m = new Marker(
                        markerId: MarkerId(key),
                        position: LatLng(double.parse(data[key]["local"].split(",")[0]),double.parse(data[key]["local"].split(",")[1])),
                        infoWindow: InfoWindow(title:data[key]["name"],snippet:data[key]["description"]),
                      );
                      globals.markers.add(m);
                    }
                  }
                  return GoogleMap(
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(target: _initialcameraposition),
                    mapType: MapType.normal,
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    markers: globals.markers,
                  );
                }),
          ],
        ),
      ),
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