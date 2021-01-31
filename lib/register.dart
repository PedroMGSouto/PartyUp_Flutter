import 'dart:collection';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:partyup_flutter/home.dart';
import 'package:string_validator/string_validator.dart';
import 'globals.dart' as globals;

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [globals.color1, globals.color2]),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                width * 0.04, heigth * 0.05, width * 0.05, heigth * 0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                title,
                LogForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget title = Container(
  child: Text(
    'Register',
    style: TextStyle(
      color: Colors.white,
      fontSize: 36,
      fontWeight: FontWeight.bold,
    ),
  ),
);

class LogForm extends StatefulWidget {
  @override
  LogFormState createState() {
    return LogFormState();
  }
}

class LogFormState extends State<LogForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  var _username;
  var _name;
  var _email;
  var _passwd;

  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Form(
        key: _formKey,
        child: Expanded(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Empty field!';
                                }
                                if(value.length>20){
                                  return 'Size limit exceeded!';
                                }
                                _username = value;
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.perm_identity),
                                helperText: ' ',
                                hintText: 'Username',
                                labelText: 'Username',
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 25.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Empty field!';
                                }
                                if(!isAlpha(value.replaceAll(new RegExp(r"\s+"), ""))){
                                  return 'Invalid characters!';
                                }
                                _name=value;
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.face),
                                helperText: ' ',
                                hintText: 'Name',
                                labelText: 'First and Last name',
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 25.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Empty field!';
                                }
                                if(!isEmail(value)){
                                  return 'Invalid email address!';
                                }
                                _email=value;
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                helperText: ' ',
                                hintText: 'Email',
                                labelText: 'Email',
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 25.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                            ),
                            TextFormField(
                              obscureText: true,
                              controller: _pass,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Empty field!';
                                }
                                if(value.length<6){
                                  return 'Password is too small!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                helperText: ' ',
                                hintText: 'Password',
                                labelText: 'Password',
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 25.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                            ),
                            TextFormField(
                              obscureText: true,
                              controller:  _confirmPass,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Empty field!';
                                }
                                if(value!=_pass.text){
                                  return "Passwords don't match!";
                                }
                                _passwd=value;
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                helperText: ' ',
                                hintText: 'Password',
                                labelText: 'Repeat Password',
                                contentPadding: new EdgeInsets.symmetric(
                                    vertical: 25.0, horizontal: 10.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ], //slivers
                  ),
                ),
                ButtonTheme(
                  minWidth: double.infinity,
                  height: 45,
                  child: RaisedButton(
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 18),
                    ),
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.black,
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        try {
                          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                              email: _email,
                              password: _passwd
                          );
                          userCredential.user.updateProfile(displayName: _username);
                          globals.markers =  new HashSet<Marker>();
                          globals.got = new HashSet<String>();
                          globals.mail = userCredential.user.email;
                          globals.user = userCredential;
                          globals.username=_username;
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            var snackBar = SnackBar(content: Text('The password provided is too weak.'));
                            Scaffold.of(context).showSnackBar(snackBar);
                            print('The password provided is too weak.');
                            return;
                          } else if (e.code == 'email-already-in-use') {
                            var snackBar = SnackBar(content: Text('The account already exists for that email.'));
                            Scaffold.of(context).showSnackBar(snackBar);
                            print('The account already exists for that email.');
                            return;
                          }
                        } catch (e) {
                          print(e);
                          return;
                        }
                        String hashed = md5.convert(utf8.encode(globals.mail)).toString();
                        final myRef = FirebaseDatabase.instance.reference().child("Users/"+hashed);
                        final myRef2 = FirebaseDatabase.instance.reference().child("AchievementsGot/"+hashed);
                        myRef.set({
                          'Email':_email,
                          'Name':_name,
                          'PJoined':0,
                          'PStarted':0,
                          'QRScanned':0,
                          'User':_username
                        });
                        myRef2.set({
                          '0':'init'
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()));
                      }
                    },
                  ),
                ),
              ]),
        ));
  }
}
