import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';

void main() {
  runApp(MaterialApp(
    title: 'PartyUp',
    home: LRSelection(),
  ));
}

class LRSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PartyUp'),
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
            padding: EdgeInsets.fromLTRB(0,MediaQuery.of(context).size.height*0.2,0,MediaQuery.of(context).size.height*0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                title,
                buttonSelection(context),
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
      'PartyUp',
    style: TextStyle(
      color: Colors.white,
      fontSize: 56,
      fontWeight: FontWeight.bold,
    ),
  ),
);

Widget buttonSelection(BuildContext context) {
  return FractionallySizedBox(
      widthFactor: 0.8,
      child: Column(
        children: <Widget>[
          ButtonTheme(
            minWidth: double.infinity,
            height: 45,
            child: RaisedButton(
              child: Text('Login', style: TextStyle(fontSize: 18),),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          ButtonTheme(
            minWidth: double.infinity,
            height: 45,
            child: RaisedButton(
              child: Text('Register', style: TextStyle(fontSize: 18),),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
            ),
          ),
        ],
      ),
    );
}