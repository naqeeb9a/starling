import 'dart:io';
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:crm_app/Views/Login/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController{
  String username;
  String password;
  String osId;

  LoginController({this.username,this.password,this.osId});
  Future<bool> attemptLogin() async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences
          .getInstance();
      Map data = {'username': username, 'password': password};
      var jsonResponse;
      String url = '${ApiRoutes.BASE_URL}${ApiRoutes.AUTH_URL}';
      var response = await http.post(Uri.parse(url), body: data);
      print(response.body);

      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        /*print(jsonResponse);*/
        if (jsonResponse != null) {
          sharedPreferences.setString("token", jsonResponse['access_token']);
          sharedPreferences.setBool("isLoggedIn", true);

          Map data2 = {'device_id': osId, 'type': 'mobile'};
          print(data2);
          String OSurl='${ApiRoutes.API_URL}profile/register-device';
          print(Uri.parse(OSurl));

          Map<String, String> OSheaders = {
            HttpHeaders.authorizationHeader:
            'Bearer ${sharedPreferences.get('token')}'
          };

          var OSresponse = await http.post(Uri.parse(OSurl), headers: OSheaders, body: data2);
          print(OSresponse.body);
          if (OSresponse.statusCode == 200) {
            print(OSresponse.body);
          }

          url = '${ApiRoutes.BASE_URL}${ApiRoutes.PROFILE}';
          final response = await http.get(Uri.parse(url),
            headers: {HttpHeaders.authorizationHeader: 'Bearer ${sharedPreferences.get('token')}'},
          );
          if(response.statusCode == 200) {
            Map<String, dynamic> map = json.decode(response.body);
            Map<String, dynamic> record = map["record"];
            //print(record['full_name']);
            //SETTING COMPANY ID
            //sharedPreferences.setInt("company_id", int.parse(data['id']));
            sharedPreferences.setInt('user_id', record['id']);
            final box = GetStorage();
            box.erase();

            box.write('user_id', record['id']);
            box.write('permissions', record['permissions']);
            box.write('username', record['username']);
            box.write('role_id', record['role_id']);
            box.write('user_type_id', record['user_type_id']);
            box.write('email', record['email']);
            box.write('first_name', record['first_name']);
            box.write('last_name', record['last_name']);
            box.write('status', record['status']);
            box.write('reference',record['reference']);
            box.write('full_name',record['full_name']);
            box.write('initials',record['initials']);
            List a = [];
            a.add(record);
          }


          return true;
        } else {
          return false;
        }
      } else {
        jsonResponse = json.decode(response.body);
        print("The error message is: ${jsonResponse['error']}");
        if (jsonResponse['error'] == 'invalid_credentials') {
          Fluttertoast.showToast(
              msg: "Invalid Credentials!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        else {
          print(jsonResponse['error']);
          Fluttertoast.showToast(
              msg: "${jsonResponse['error']}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
        return false;
      }
    }catch(e) {
      print(e);
      return false;
    }
  }
  void fetchProfile(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String url = '${ApiRoutes.BASE_URL}${ApiRoutes.PROFILE}';
    final response = await http.get(Uri.parse(url),
      headers: {HttpHeaders.authorizationHeader: 'Bearer ${sharedPreferences.get('token')}'},
    );
    if(response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      Map<String, dynamic> record = map["record"];
      print(record['full_name']);
      //SETTING COMPANY ID
      //sharedPreferences.setInt("company_id", int.parse(data['id']));
      sharedPreferences.setInt('user_id', record['id']);
      final box = GetStorage();
      box.erase();

      // box.write('user_id', record['id']);
      box.write('permissions', record['permissions']);
      box.write('username', record['username']);
      box.write('role_id', record['role_id']);
      box.write('user_type_id', record['user_type_id']);
      box.write('email', record['email']);
      box.write('first_name', record['first_name']);
      box.write('last_name', record['last_name']);
      box.write('status', record['status']);
      box.write('reference',record['reference']);
      box.write('full_name',record['full_name']);
      box.write('initials',record['initials']);
      List a = [];
      a.add(record);
    } else {
      print('Profile not loading ${response.statusCode}');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
    }
  }

  Future<bool> attemptLogout() async {
    try {

      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

      //GET USER PROFILE
      String url='${ApiRoutes.BASE_URL}${ApiRoutes.LOGOUT_URL}';
      final response = await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${sharedPreferences.get('token')}'},
      );
      sharedPreferences.setBool('isLoggedIn', false);
      sharedPreferences.remove('token');
      if(response.statusCode == 200) {
        final box = GetStorage();
        box.erase();
        sharedPreferences.clear();
        return true;
      }
      else{
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}