import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:partyup_flutter/home.dart';
import 'package:string_validator/string_validator.dart';

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
                colors: [Colors.orange, Colors.purpleAccent]),
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
                                if(!isAlpha(value)){
                                  return 'Invalid characters!';
                                }
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
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
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
