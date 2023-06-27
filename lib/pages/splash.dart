import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_cidadao/pages/home.dart';
import 'package:location/location.dart';

class Splash extends StatefulWidget {
  final polygonList, polygonMarkers;
  const Splash(this.polygonList, this.polygonMarkers, {Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Future.delayed(const Duration(seconds: 4)).then((_) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MyApp(widget.polygonList, widget.polygonMarkers)));
    });
  }

  @override
  Widget build(BuildContext context) {
    /*FirebaseMessaging.getInstance().token.addOnCompleteListener {
      task ->
      if (!task.isSuccessful) {
        Log.w(TAG, "Fetching FCM registration token failed", task.exception)
        return
      }
    }*/

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/icon.png',
          ),
        ],
      ),
    );
  }
}
