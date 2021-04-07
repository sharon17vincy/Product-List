import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_project/Screens/Home.dart';
import 'package:new_project/appTheme.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();
    new Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  void showSnackbar(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message.toString()),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          _scaffoldKey.currentState.removeCurrentSnackBar();
        },
      ),
    ));
  }

  initScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              child: Text(
                "Welcome!" + "\n",
                style: TextStyle(
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: appTheme.primaryColorDark),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 30.0)),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
