import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EditLeadController {
  final int id;
  EditLeadController({this.id});

  Future<bool> updateStatus(String subStatus) async {
    try{
      SharedPreferences sharedPreferences  = await SharedPreferences.getInstance();
      String status;
      if(subStatus == 'Not Interested' || subStatus == 'Unsuccessful' || subStatus == 'Invalid Number' || subStatus == 'Successful' || subStatus == 'Invalid Inquiry'){
        status = 'Closed';
      } else {
        status = 'Active';
      }
      Map data;

      if(subStatus == 'Shuffle'){
        data = {
          'status': status,
          'sub_status': subStatus,
          'agent_id': 2
        };
      } else {
        data = {
          'status': status,
          'sub_status': subStatus
        };
      }

      String url = '${ApiRoutes.BASE_URL}/api/leads/$id/update-status';
      var response = await http.put(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data)
      );
      print(jsonEncode(data));
      if(response.statusCode == 200){
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

  Future<bool> sendNote(String notes) async {
    try{
      SharedPreferences sharedPreferences  = await SharedPreferences.getInstance();
      Map data = {
        'lead_id': id,
        'notes': notes
      };
      String url = '${ApiRoutes.BASE_URL}/api/leads/notes';
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
      print(e);
      return false;
    }
  }

}