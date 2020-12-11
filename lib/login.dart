import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final heigth = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Login"),
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
    'Login',
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
        child: Column(
            children: <Widget>[
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
                    labelText: 'Enter your email',
                    contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, heigth*0.4),
                child: TextFormField(
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
                    labelText: 'Enter your password',
                    contentPadding: new EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
              ),
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
                    if (_formKey.currentState.validate()) {
                      Scaffold
                          .of(context)
                          .showSnackBar(SnackBar(content: Text('Processing Data')));
                    }
                  },
                ),
              ),
            ]
        )
    );
  }
}