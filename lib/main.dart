import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'globals.dart' as globals;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'PartyUp',
    home: Scaffold(
      appBar: AppBar(
        title: const Text('PartyUp'),
        backgroundColor: Colors.black,
      ),
      body: Center(child: App()),
    ),
  ));
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return LRSelection();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Loading");
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("Something Went Wrong!");
  }
}

class LRSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [globals.color1, globals.color2]),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            0,
            MediaQuery.of(context).size.height * 0.2,
            0,
            MediaQuery.of(context).size.height * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            title,
            buttonSelection(context),
          ],
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
            child: Text(
              'Login',
              style: TextStyle(fontSize: 18),
            ),
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
            child: Text(
              'Register',
              style: TextStyle(fontSize: 18),
            ),
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
