

import 'package:crm_app/controllers/loginController.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LogoutPage extends StatefulWidget {
  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading == false
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Are you sure you want to log out ?',
                style: AppTextStyles.c16black500(),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        this.isLoading = true;
                      });
                      LoginController instance = LoginController();
                      bool value = await instance.attemptLogout();
                      if (value) {
                        Fluttertoast.showToast(
                            msg: "Successfully logged out !",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        setState(() {
                          this.isLoading = false;
                        });
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (Route<dynamic> route) => false);
                      } else {
                        setState(() {
                          this.isLoading = false;
                        });
                        Fluttertoast.showToast(
                            msg:
                            "Sorry Some error occurred!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (Route<dynamic> route) => false);
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          "Logout",
                          style: AppTextStyles.c14white400(),
                        ),
                      ],
                    )),
                SizedBox(width: 30,),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          "Cancel",
                          style: AppTextStyles.c14white400(),
                        ),
                      ],
                    ))
              ],
            ),
          )
        ],
      ),
    )
        : Center(child: AnimatedSearch());
  }
}