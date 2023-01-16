import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignController{

  Future<List> getCampaigns() async{
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final box = GetStorage();
      List permissions = box.read('permissions');
      int roleId = box.read('role_id');
      String url;
      if(roleId != 3 && roleId != 5){
        url = '${ApiRoutes.BASE_URL}/api/campaigns?where=%5B%5D&include=%5B%22attach_source:id,name%22,%22sub_source:id,name%22%5D&count=%5B%22leads%22%5D&order=%7B%22title%22:%22asc%22%7D';
      } else {
        url = '${ApiRoutes.BASE_URL}/api/campaigns/app-campaigns?agent_id=${sharedPreferences.get('user_id')}';
      }
      print(url);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        Map map = json.decode(response.body);
        print(response.body);
        List rec = map['record'];
        return rec;
      } else {
        print(response.body);
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<List> getAgentCampaigns(int agentId) async{
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final box = GetStorage();
      List permissions = box.read('permissions');
      int roleId = box.read('role_id');
      String url;
      url = '${ApiRoutes.BASE_URL}/api/campaigns/app-campaigns?agent_id=$agentId';
      print(url);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        Map map = json.decode(response.body);
        print(response.body);
        List rec = map['record'];
        return rec;
      } else {
        print(response.body);
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

}