import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadsDetails {

  Future<List<dynamic>> getLeadsDetails(int id) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String include = '%5B%22creator:id,first_name,last_name,reference,phone,email%22,%22agent:id,first_name,last_name,reference,phone,email%22,%22client:id,first_name,last_name,reference,mobile,phone,email,language_id,country_id%22,%22client.language:id,name%22,%22client.country:id,name,iso_code2,iso_code3%22,%22contact_history%22,%22contact_history.user:id,first_name,last_name,profile_picture%22,%22notes_list%22,%22notes_list.user:id,first_name,last_name,profile_picture%22,%22status_history%22,%22status_history.user:id,first_name,last_name,profile_picture%22,%22viewings.agent:id,first_name,last_name,profile_picture%22,%22viewings.listing:id,reference,title%22,%22viewings.user:id,reference,first_name,last_name%22,%22properties%22,%22properties.category:id,name%22,%22source:id,name%22,%22sub_source:id,name%22,%22listing%22,%22listing.category:id,name%22,%22listing.location:id,name%22,%22campaign:id,title,campaign_id%22%5D';
      String url = '${ApiRoutes.BASE_URL}/api/leads/$id?include=$include';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){

        Map<String, dynamic> map = json.decode(response.body);
        print(json.decode(response.body));
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

  Future<List<dynamic>> getLeadTasks(int leadId) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url = '${ApiRoutes.BASE_URL}/api/leads/tasks/$leadId';
      print(url);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){

        List<dynamic> map = json.decode(response.body);
        print(json.decode(response.body));

        return map;
      } else {
        print(response.body);
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<bool> addLeadTask(int assignToId, String description, String dueDate, List list, String objectType, String priority, String status, String title) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      Map data = {
        'assign_to_id': assignToId,
        'description': description,
        'due_at': dueDate,
        'list': list,
        'object_id': null,
        'object_type': 'lead',
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
    }catch(e){
      print(e);
      return false;
    }
  }

  Future<List> getLeadViewings(int id) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String where = '%5B%7B%22column%22:%22lead_id%22,%22value%22:$id%7D%5D';
      String include = '%5B%22agent:id,first_name,last_name,profile_picture%22,%22user:id,first_name,last_name,profile_picture%22,%22listing:id,reference,listing_status%22,%22lead:id,reference%22%5D';
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
        print(json.decode(response.body));
        List record = map['record'];
        return record;
      } else {
        print(response.body);
        return null;
      }

    } catch(e) {
      print(e);
      return null;
    }
  }

  Future<List> getSources() async {
    try{

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url = '${ApiRoutes.BASE_URL}/api/listing-sources?where=%5B%7B%22column%22:%22is_base%22,%22operator%22:%22=%22,%22value%22:1%7D%5D&columns=%5B%22id%22,%22name%22,%22is_base%22%5D&include=%5B%22sources:id,name,is_base%22%5D&order=%5B%22name%22%5D';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        Map map = json.decode(response.body);
        print(json.decode(response.body));
        List record = map['record'];
        return record;
      } else {
        print(response.body);
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }
  Future<List> getContacts() async {
    try{

      final box = GetStorage();
      List permissions = box.read('permissions');

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url;

      if(permissions.contains('contacts_view_other')){
        url = '${ApiRoutes.BASE_URL}/api/clients?where=%5B%5D&include=%5B%22users:id,first_name,last_name%22%5D&order=%7B%22created_at%22:%22desc%22%7D';
      } else {
        url = '${ApiRoutes.BASE_URL}/api/clients?where=%5B%5D&include=%5B%22users:id,first_name,last_name%22%5D&agent_id=${sharedPreferences.get('user_id')}&order=%7B%22created_at%22:%22desc%22%7D';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        print(json.decode(response.body));
        Map map = json.decode(response.body);
        List a = map['record'];
        return a;
      } else {
        print(jsonDecode(response.body));
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

}