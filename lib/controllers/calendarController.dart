import 'dart:convert';
import 'dart:io';
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:crm_app/Views/calendar/EventProvider.dart';
import 'package:crm_app/Views/calendar/EventModel.dart';
import 'package:crm_app/widgets/ColorFunctions/CalendarTypeColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CalendarControl {

  Future<List<Event>> fetchCalendar() async {
    try{
      EventProvider().clearEvent();
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url;
      url = '${ApiRoutes.BASE_URL}/api/profile/calendar';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        var map = json.decode(response.body);
        print(json.decode(response.body));
        var record = map["record"];
        Event event;
        List<Event> eventList = [];
        for(var i in record){
          event = Event(
              title: i['title'],
              description: i['description'],
              from: DateTime.parse(i['start_date']),
              to: i['end_date'] != null? DateTime.parse(i['end_date']): DateTime.parse(i['start_date']),
              object: i['object'],
              type: i['type'],
              backgroundColor: calendarColor(i['type'])
          );
          print(event.from);
          eventList.add(event);
        }
        return eventList;
      } else {
        print(response.body);
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<List<dynamic>> getCalendarTasks(int id) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url;
      url = '${ApiRoutes.BASE_URL}/api/tasks/$id?include=%5B%22created_by:id,first_name,last_name%22,%22assigned_to:id,first_name,last_name%22,%22object%22,%22list%22,%22list.object%22,%22reminders%22%5D';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        var map = json.decode(response.body);
        var record = map["record"];
        return record;
      }
    } catch(e){
      return null;
    }
  }

}