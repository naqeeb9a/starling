

import 'dart:convert';
import 'dart:io';

import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ListingController {
  BuildContext context;

  ListingController({this.context});


  Future<List<Map>> getListingDetails(int id) async {
    try{

      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

      String filter = 'include=%5B%22created_by:id,first_name,last_name,profile_picture,profile_video,contact_overlay,role_id%22,%22created_by.role%22,%22assigned_to:id,first_name,last_name,profile_picture,profile_video,contact_overlay,role_id%22,%22assigned_to.role%22,%22owner%22,%22owner.language:id,name,native_name,iso_code%22,%22owner.country%22,%22tenant%22,%22notes_list%22,%22notes_list.user:id,first_name,last_name,profile_picture%22,%22tenant.language:id,name,native_name,iso_code%22,%22tenant.country%22,%22category:id,name%22,%22country%22,%22city:id,name,code%22,%22location:id,name%22,%22language:id,name,native_name,iso_code%22,%22status:id,name%22,%22source:id,name%22,%22images%22,%22floor_plans%22,%22portals:id,name,url%22,%22features:id,name%22,%22amenities:id,name%22,%22neighbourhoods.neighbourhood%22,%22sub_location%22,%22documents%22,%22premium_history%22%5D';
      String url = '${ApiRoutes.API_URL}listings/$id?$filter';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
        print(json.decode(response.body));
        Map record = map["record"];

        List<Map> a = [];
        a.add(record);
        return a;
      } else {
        return null;
      }
    } catch(e) {
      print(e);
      return null;
    }
  }

  Future<List> getListingViewings(int listingId) async {
    try{

      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

      String where = '%5B%7B%22column%22:%22listing_id%22,%22value%22:%22$listingId%22%7D%5D';
      String include = '%5B%22agent:id,first_name,last_name,profile_picture%22,%22user:id,first_name,last_name,profile_picture%22,%22lead:id,reference,status%22,%22listing:id,reference%22%5D';
      String order = '%7B%22created_at%22:%22desc%22%7D';
      String url = '${ApiRoutes.BASE_URL}/api/leads/views?where=$where&include=$include&order=$order';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        Map map = json.decode(response.body);
        List record = map["record"];
        return record;
      } else {
        return null;
      }
    } catch (e){
      print(e);
      return null;
    }
  }

  Future<List<dynamic>> getStatusList(int listingId) async {
    try{

      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

      //String filter = '{"where": [{"column":"listing_id","value":$listing_id}],"include": ["user:id,first_name,last_name,profile_picture"],"order": {"created_at":"desc"}}';
      String url = '${ApiRoutes.API_URL}listings/status-history?where=%5B%7B%22column%22:%22listing_id%22,%22value%22:%22$listingId%22%7D%5D&include=%5B%22user:id,first_name,last_name,profile_picture%22%5D&order=%7B%22created_at%22:%22desc%22%7D';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      // print(response.body);
      if(response.statusCode == 200){
        Map<String, dynamic> map = json.decode(response.body);
        List<dynamic> record = map["record"];
        List a = [];
        a.add(record);
        return a;
      } else {
        return null;
      }
    } catch(e) {
      print(e);
      return null;
    }
  }

  Future<bool> newNote (int id,String note) async {
    try{

      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

      Map data = {
        'listing_id': id,
        'notes': note
      };
      String url = '${ApiRoutes.BASE_URL}/api/listings/notes';
      var response = await http.post(
          Uri.parse(url),
          headers: {
            HttpHeaders.authorizationHeader:
            'Bearer ${sharedPreferences.get('token')}',
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data)
      );
      if(response.statusCode == 201){
        return true;
      } else {
        print(response.body);
        return false;
      }

    } catch(e){
      return false;
    }
  }
}