import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddContactController {

  Future<List> getCountries() async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String url = '${ApiRoutes.BASE_URL}/api/countries?columns=%5B%22id%22,%22name%22%5D&order=%5B%22name%22%5D';

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
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<List> getLanguages() async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String url = '${ApiRoutes.BASE_URL}/api/languages?columns=%5B%22id%22,%22name%22%5D&order=%5B%22name%22%5D';

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
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<List> getUsers() async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String columns = '%5B%22id%22,%22reference%22,%22first_name%22,%22last_name%22,%22email%22,%22mobile%22,%22phone%22,%22office_extension_number%22,%22type%22%5D';
      String order = '%5B%22first_name%22,%22last_name%22%5D';

      String url = '${ApiRoutes.BASE_URL}/api/users?columns=$columns&order=$order';
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
    } catch(e) {
      print(e);
      return null;
    }
  }

  Future<bool> createContact(String address1, String city, int countryId, String email, String firstName, int languageId, String lastName, String mobile, String note, String phone, String state, String type, String zip, double budget) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String url = '${ApiRoutes.BASE_URL}/api/clients';
      Map data = {
        'address1': address1,
        'budget': budget,
        'city': city,
        'country_id': countryId,
        'email': email,
        'first_name': firstName,
        'language_id': languageId,
        'last_name': lastName,
        'mobile': mobile,
        'note': note,
        'phone': phone,
        'state': state,
        'type': type,
        'zip': zip
      };
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