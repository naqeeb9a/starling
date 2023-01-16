import 'package:crm_app/Views/dashboard/Dashboard.dart';
import 'package:crm_app/controllers/loginController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/CircularLoader.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../SplashScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool isLoading = true;
  bool _obscureText = true;


  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void getValues() async {
    setState(() {
      isLoading = false;
    });

    String username = usernameController.text;
    String password = passwordController.text;
    final status = await OneSignal.shared.getDeviceState();
    final String osUserID = status?.userId;
    /* print(email);
    print(password);*/
    LoginController instance = LoginController(username: username, password: password, osId: osUserID);

    bool value=false;

    if(username.length>1&&password.length>1)
      value = await instance.attemptLogin();

    if (value) {
      //Navigator.popUntil(context, ModalRoute.withName('screen_route'));
      // print('reached back');
      print('Login Successful');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => DashboardPage()),
              (Route<dynamic> route) => false);
    } else {
      print('Failed');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (Route<dynamic> route) => false);
    }

  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return isLoading
        ?Scaffold(
      backgroundColor: Color(0xFFEEEEFF),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/screen.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          /*Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset('assets/images/building.png',scale: 4,),
          ),*/
          Form(
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.11),
              child: Container(
                alignment: Alignment.topCenter,

                child: SingleChildScrollView(
                  // new line
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/anw.png',
                          width: MediaQuery.of(context).size.width * 0.7,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Icon(
                      Icons.account_circle_rounded,
                      color: GlobalColors.globalColor(),
                      size: MediaQuery.of(context).size.width * 0.3,
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 15.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Material(
                          elevation: 5.0,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          shadowColor: Colors.grey,
                          child: TextField(
                            controller: usernameController,
                            decoration: new InputDecoration(
                              border: new UnderlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              focusColor: Colors.white,
                              hintStyle: new TextStyle(color: Colors.white,fontSize: 14),
                              hintText: "Username",
                              fillColor: GlobalColors.globalColor(),
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            style: AppTextStyles.c14white400(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 10.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: Material(
                          elevation: 5.0,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          shadowColor: Colors.grey,
                          child: TextField(
                            controller: passwordController,
                            decoration: new InputDecoration(
                              border: new UnderlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),
                              ),
                              filled: true,
                              hintStyle: new TextStyle(color: Colors.white),
                              hintText: "Password",
                              fillColor:  GlobalColors.globalColor(),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                color: Colors.white,
                                onPressed: _toggle,
                                icon: Icon(_obscureText
                                    ? Icons.remove_red_eye
                                    : Icons.visibility_off),
                              ),
                            ),
                            obscureText: _obscureText,
                            style: AppTextStyles.c14white400(),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(0.0, 10.0, 35.0, 0.0),
                          child: Text(
                            ' ',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: ElevatedButton(
                            onPressed: (){
                              print('clicked');
                              getValues();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor())
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Login',
                                    style: AppTextStyles.c18white600(),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Icon(
                                    Icons.login,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[400],
                            fontSize: 15.0,
                          ),
                        ),
                        Text(
                          ' ',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),

                  ]),
                ),
              ),
            ),
          ),
        ],
      )
    ):Center(child: NetworkLoading(),);
  }


  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  void initState() {
    // TODO: implement initState
    super.initState();
  }
}
