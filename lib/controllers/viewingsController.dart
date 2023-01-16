

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewingsController{

  Future<List<dynamic>> getViewingData(int id) async {

    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String include = '%5B%22agent:id,first_name,last_name,profile_picture%22,%22user:id,first_name,last_name,profile_picture%22,%22listing:id,reference,listing_status%22,%22lead:id,reference,status%22%5D';
      String url = '${ApiRoutes.BASE_URL}/api/leads/views/$id?include=$include';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        Map<String, dynamic> record = map["record"];

        List a = [];
        a.add(record);
        return a;
      } else {
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }

  }
}