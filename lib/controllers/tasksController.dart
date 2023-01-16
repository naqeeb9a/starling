import 'dart:convert';
import 'dart:io';
import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TasksController{

  Future<List> getUsers() async {
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

  Future<List<dynamic>> getTaskDetails(int taskId) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String url = '${ApiRoutes.BASE_URL}/api/tasks/$taskId?include=%5B%22created_by:id,first_name,last_name%22,%22assigned_to:id,first_name,last_name%22,%22object%22,%22list%22,%22list.object%22%5D';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      //print(json.decode(response.body));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
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

  Future<List<dynamic>> getTasksSchedule(int userId) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      DateTime newDate = DateTime.now();
      final box = GetStorage();
      String url;
      List permissions = box.read('permissions');
      url = '${ApiRoutes.BASE_URL}/api/tasks?where=%5B%7B%22column%22:%22assign_to_id%22,%22value%22:${userId ==null?sharedPreferences.get('user_id'):userId}%7D,%7B%22column%22:%22due_at%22,%22operator%22:%22between%22,%22value%22:%5B%22${newDate.toString()}%2000:00:00%22,%22${newDate.add(Duration(days: 7))}%2023:59:59%22%5D%7D%5D&include=%5B%22created_by:id,first_name,last_name%22,%22assigned_to:id,first_name,last_name%22,%22object:id,reference%22%5D&order=%7B%22created_at%22:%22desc%22,%22due_at%22:%22asc%22%7D&page=1&limit=25';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      //print(json.decode(response.body));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
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

  Future<List<dynamic>> getDayTasks(String date, int userId) async {
    try{
      DateTime d = DateTime.parse(date);
      String newDate = DateFormat('yyyy-MM-dd').format(d);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final box = GetStorage();
      String url;
      List permissions = box.read('permissions');
      url = '${ApiRoutes.BASE_URL}/api/tasks?where=%5B%7B%22column%22:%22assign_to_id%22,%22value%22:${userId ==null?sharedPreferences.get('user_id'):userId}%7D,%7B%22column%22:%22due_at%22,%22operator%22:%22between%22,%22value%22:%5B%22$newDate%2000:00:00%22,%22$newDate%2023:59:59%22%5D%7D%5D&include=%5B%22created_by:id,first_name,last_name%22,%22assigned_to:id,first_name,last_name%22,%22object:id,reference%22%5D&order=%7B%22created_at%22:%22desc%22,%22due_at%22:%22asc%22%7D&page=1&limit=25';
      // print(url);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      //print(json.decode(response.body));
      if (response.statusCode == 200) {
        Map<String, dynamic> map = json.decode(response.body);
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

}