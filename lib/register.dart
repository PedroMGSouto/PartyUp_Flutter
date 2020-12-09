import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            padding: EdgeInsets.fromLTRB(0,MediaQuery.of(context).size.height*0.2,0,MediaQuery.of(context).size.height*0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
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
      fontSize: 56,
      fontWeight: FontWeight.bold,
    ),
  ),
);

Widget userPass(BuildContext context) {
  return FractionallySizedBox(
    widthFactor: 0.8,
    child: Column(
      children: <Widget>[
        
      ],
    ),
  );
}