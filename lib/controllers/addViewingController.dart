import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddViewingController {

  Future<List> getUserData() async {

    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String where;
      String columns;
      String include;
      String order;
      String url;

      where = '%5B%7B%22column%22:%22status%22,%22value%22:1%7D%5D';
      columns = '%5B%22id%22,%22first_name%22,%22last_name%22,%22role_id%22,%22profile_picture%22%5D';
      include = '%5B%22role:id,title%22%5D';
      order = '%7B%22first_name%22:%22asc%22,%22last_name%22:%22asc%22%7D';
      url = '${ApiRoutes.BASE_URL}/api/users?where=$where&columns=$columns&include=$include&order=$order';

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

  Future<List> getLeads(int id) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String where = '%5B%7B%22column%22:%22agent_id%22,%22value%22:${sharedPreferences.get('user_id')}%7D,%7B%22column%22:%22listing_id%22,%22value%22:$id%7D%5D';
      String columns = '%5B%22id%22,%22reference%22,%22client_id%22,%22agent_id%22%5D';
      String include = '%5B%22client:id,first_name,last_name,type,mobile,email,phone%22%5D';
      String order = '%7B%22created_at%22:%22desc%22%7D';
      String url = '${ApiRoutes.BASE_URL}/api/leads?where=$where&columns=$columns&include=$include&order=$order&page=1&limit=500';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        Map map = json.decode(response.body);
        List record = map['record']['data'];
        return record;
      } else {
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<List> getLeadsAddViewingModule(int id) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String where = '%5B%7B%22column%22:%22agent_id%22,%22value%22:$id%7D%5D';
      String columns = '%5B%22id%22,%22reference%22,%22client_id%22,%22agent_id%22%5D';
      String include = '%5B%22client:id,first_name,last_name,type,mobile,email,phone%22%5D';
      String order = '%7B%22created_at%22:%22desc%22%7D';
      String url = '${ApiRoutes.BASE_URL}/api/leads?where=$where&columns=$columns&include=$include&order=$order&page=1&limit=500';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        Map map = json.decode(response.body);
        List record = map['record']['data'];
        return record;
      } else {
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<List> getListings() async {
    try{

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String where = '%5B%7B%22column%22:%22listing_status%22,%22operator%22:%22!=%22,%22value%22:%22Closed%22%7D,%7B%22column%22:%22assigned_to_id%22,%22value%22:${sharedPreferences.get('user_id')}%7D%5D';
      String columns = '%5B%22id%22,%22title%22,%22assigned_to_id%22,%22reference%22,%22listing_status%22%5D';
      String order = '%7B%22title%22:%22asc%22%7D';
      String url = '${ApiRoutes.BASE_URL}/api/listings?where=$where&columns=$columns&order=$order&page=1&limit=500';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        Map map = json.decode(response.body);
        List record = map['record']['data'];
        return record;
      } else {
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<List> getAddViewingModuleListings(int id) async {
    try{

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String where = '%5B%7B%22column%22:%22listing_status%22,%22operator%22:%22!=%22,%22value%22:%22Closed%22%7D,%7B%22column%22:%22assigned_to_id%22,%22value%22:$id%7D%5D';
      String columns = '%5B%22id%22,%22title%22,%22assigned_to_id%22,%22reference%22,%22listing_status%22%5D';
      String order = '%7B%22title%22:%22asc%22%7D';
      String url = '${ApiRoutes.BASE_URL}/api/listings?where=$where&columns=$columns&order=$order&page=1&limit=500';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        Map map = json.decode(response.body);
        List record = map['record']['data'];
        return record;
      } else {
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<bool> sendData(int agentId,String dateTime,int leadId,int listingId, String notes, String status) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      Map data = {
        'agent_id': agentId,
        'datetime': dateTime,
        'lead_id': leadId,
        'listing_id': listingId != null && listingId != 0? listingId:null,
        'notes': notes,
        'status': status
      };

      String url = '${ApiRoutes.BASE_URL}/api/leads/views';
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
        return false;
      }
    } catch(e){
      print(e);
      print(status.runtimeType);
      print(notes.runtimeType);
      print(dateTime.runtimeType);
      return false;
    }
  }

  Future<bool> sendLeadViewData() async {
    try{
      return true;
    } catch(e){
      return false;
    }
  }
}