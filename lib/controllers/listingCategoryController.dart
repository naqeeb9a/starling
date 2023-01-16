
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListingCategoryController{


  Future<List> getCategories(String propertyType) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String where;
      String columns;
      String order;
      String url;
      where = '%5B%7B%22column%22:%22type%22,%22value%22:%22$propertyType%22%7D%5D';
      columns = '%5B%22id%22,%22name%22,%22type%22%5D';
      order = '%7B%22name%22:%22asc%22%7D';
      url = '${ApiRoutes.BASE_URL}/api/categories?where=$where&columns=$columns&order=$order';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      print(url);
      if (response.statusCode == 200) {
        Map map = json.decode(response.body);

        var record = map["record"];
        print(record.runtimeType);

        return record;
      } else {
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

}