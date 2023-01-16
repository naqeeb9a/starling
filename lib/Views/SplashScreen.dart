import 'package:crm_app/widgets/appbars/CommonAppBars.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void loadLoginScreen() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var status = sharedPreferences.getBool('isLoggedIn') ?? false;

    if (status) {
      await Future.delayed(Duration(seconds: 5), () {
        print(sharedPreferences.getString('token'));
        Navigator.pushReplacementNamed(context, '/dashboard');
      });
    } else {
      await Future.delayed(Duration(seconds: 7), () {
        Navigator.pushReplacementNamed(context, '/login');
      });

    }

  }

  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    loadLoginScreen();
  }

  var year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Splash Screen',

          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/anwbackground.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/images/anw.png',
            width: 350.0,
          ),
        ),
      ),
    );
  }
}


