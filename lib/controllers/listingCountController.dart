import 'dart:convert';
import 'dart:io';

import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ListingCountController{

  Future<int> getCount(String type, String query, List filter, int portalId) async{
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url;

      String wherePart;
      String columns;
      String include;
      String fil = '';
      int id = sharedPreferences.getInt('user_id');
      if(type == 'My Listings'){
        if(filter != null){
          for(int i = 0; i < filter.length; i++){
            if(i == filter.length - 1){
              fil += filter[i];
            } else {
              fil += filter[i] + ',';
            }
          }
          wherePart = 'where=%5B%7B%22column%22:%22assigned_to_id%22,%22value%22:$id%7D,$fil%5D';

        } else {
          wherePart = 'where=%5B%7B%22column%22:%22assigned_to_id%22,%22value%22:$id%7D%5D';
        }

      } else {
        if(filter != null){
          for(int i = 0; i < filter.length; i++){
            if(i == filter.length - 1){
              fil += filter[i];
            } else {
              fil += filter[i] + ',';
            }
          }
          wherePart = 'where=%5B$fil%5D';
        } else {
          wherePart = 'where=%5B%5D';
        }
      }

      columns = '%5B%22id%22,%22assigned_to_id%22,%22listing_status%22,%22reference%22,%22external_reference%22,%22transaction_no%22,%22permit_no%22,%22permit_expiry%22,%22property_type%22,%22property_for%22,%22unit_no%22,%22property_location%22,%22beds%22,%22build_up_area%22,%22price%22,%22furnished%22,%22published_at%22,%22created_at%22,%22updated_at%22,%22title%22,%22category_id%22,%22created_by_id%22,%22slug%22,%22portal_status%22,%22location_id%22,%22sub_location_id%22,%22tower_id%22,%22submitted_by%22,%22description%22,%22is_featured%22,%22is_premium%22,%22is_exclusive%22%5D';
      include = '%5B%22category:id,name%22,%22assigned_to:id,first_name,last_name%22,%22created_by:id,first_name,last_name%22,%22location%22,%22sub_location%22,%22tower%22,%22portals:name%22,%22images%22%5D';
      String order = '%7B%22updated_at%22:%22desc%22%7D';
      String count = '%5B%22leads%22,%22images%22,%22listing_updates%22%5D';
      String q = query;
      int pid = portalId;
      if(q == null){
        if(pid == null){
          url = '${ApiRoutes.API_URL}listings?$wherePart&columns=$columns&include=$include&order=$order&count=$count&portal_id=&portal_breakdown_id=&page=1&limit=8';
        } else {
          url = '${ApiRoutes.API_URL}listings?$wherePart&columns=$columns&include=$include&order=$order&count=$count&portal_id=$pid&portal_breakdown_id=&page=1&limit=8';
        }
      } else {
        if(pid == null){
          url = '${ApiRoutes.API_URL}listings?$wherePart&columns=$columns&include=$include&order=$order&count=$count&portal_id=&portal_breakdown_id=&page=1&limit=8&q=$q';
        } else {
          url = '${ApiRoutes.API_URL}listings?$wherePart&columns=$columns&include=$include&order=$order&count=$count&portal_id=$pid&portal_breakdown_id=&page=1&limit=8&q=$q';
        }
      }



      //print(url);
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        Map map = json.decode(response.body);
        int total = map['record']['paginator']['total'];
        return total;
      } else {
        print(response.body);
        return 0;
      }
    } catch(e){
      print(e);
      return 0;
    }
  }

}