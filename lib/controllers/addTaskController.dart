import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTaskController {

  Future<List> getListingsIdRef() async{
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url;
      url = '${ApiRoutes.BASE_URL}/api/listings?columns=%5B%22id%22,%22reference%22%5D';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        List record = map["record"];
        return record;
      } else {
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<List> getLeadsIdRef() async{
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url;
      url = '${ApiRoutes.BASE_URL}/api/leads?columns=%5B%22id%22,%22reference%22%5D';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if (response.statusCode == 200) {
        Map map = json.decode(response.body);
        List record = map["record"];
        return record;
      } else {
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<bool> sendTask(int assignToId, String description, String dueDate, List list, int objectId, String objectType, String priority, String status, String title) async{
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      Map data = {
        'assign_to_id': assignToId,
        'description': description,
        'due_at': dueDate,
        'list': list,
        'object_id': objectId == null? null:objectId,
        'object_type': objectType,
        'priority': priority,
        'status': status,
        'title': title
      };

      String url = '${ApiRoutes.BASE_URL}/api/tasks';
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
        print(response.body);
        return true;
      } else {
        print(response.body);
        return false;
      }
    } catch(e){
      print(e);
      return false;
    }
  }

}