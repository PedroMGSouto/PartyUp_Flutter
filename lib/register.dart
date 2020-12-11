import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            padding: EdgeInsets.fromLTRB(width*0.04,heigth*0.05,width*0.05,heigth*0.04),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                title,
                LogForm(
                ),
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

class LogForm extends StatefulWidget{
  @override
  LogFormState createState() {
    return LogFormState();
  }
}

class LogFormState extends State<LogForm>{
  final _formKey = GlobalKey<FormState>();

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return 'Empty field!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.perm_identity),
                          helperText: ' ',
                          hintText: 'Username',
                          labelText: 'Username',
                          contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                      TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return 'Empty field!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.face),
                          helperText: ' ',
                          hintText: 'Name',
                          labelText: 'First and Last name',
                          contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                      TextFormField(
                        validator: (value){
                          if(value.isEmpty){
                            return 'Empty field!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          helperText: ' ',
                          hintText: 'Email',
                          labelText: 'Email',
                          contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (value){
                          if(value.isEmpty){
                            return 'Empty field!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          helperText: ' ',
                          hintText: 'Password',
                          labelText: 'Password',
                          contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (value){
                          if(value.isEmpty){
                            return 'Empty field!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          helperText: ' ',
                          hintText: 'Password',
                          labelText: 'Repeat Password',
                          contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                        ),
                      ),
                    ],
                  ),
                ),
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
                      if (_formKey.currentState.validate()) {
                        Scaffold
                            .of(context)
                            .showSnackBar(SnackBar(content: Text('Processing Data')));
                      }
                    },
                  ),
                ),
              ]
          ),
        )
    );
  }
}