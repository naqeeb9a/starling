
import 'dart:convert';
import 'dart:io';
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Nearby {

 Future<List<dynamic>> getlistings(double lat,double longitude, int radius) async {
    try{
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

      int id = sharedPreferences.getInt('id');

      String filter = '{"where": [{"column":"portal_status","value":"Published"},{"column":"assigned_to_id","value":$id}],"nearby": {"latitude":$lat,"longitude":$longitude,"radius":$radius},"columns": ["id","reference","title","description","property_for","property_type","listing_status","category_id","city_id","location_id","property_location","sub_location_id","assigned_to_id","created_by_id","created_at","price","slug","portal_status"],"include": ["category:id,name","location:id,name,latitude,longitude","sub_location:id,name,latitude,longitude","assigned_to:id,first_name,last_name"],"order": {"created_at":"desc"},"count": ["leads"]}';
      String url = '${ApiRoutes.API_URL}listings?$filter&page=1&limit=100';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );

      print(response.body);
      if(response.statusCode == 200){
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> record = map["record"];
        List a = [];
        a.add(record);
        return a;
      } else {
        return null;
      }

    } catch (e){
      print (e);
      return null;
    }
  }
}

class MarkerData{
  final List<dynamic> data;
  final List<dynamic> paginator;

  MarkerData({this.data, this.paginator});

  factory MarkerData.fromJson(Map<String,dynamic> json){
    return MarkerData(
      data: json['record']['data'],
      paginator: json['record']['paginator']
    );
  }
}