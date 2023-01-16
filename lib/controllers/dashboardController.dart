import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController{

  Future<ListingCountResponse> fetchListingCount() async {
    try{

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final box = GetStorage();
      String url;
      List permissions = box.read('permissions');
      if(permissions.contains('listings_view_other')){
        url = '${ApiRoutes.BASE_URL}/api/statistic/listing/count-by-status?where=%5B%5D';
      } else {
        url = '${ApiRoutes.BASE_URL}/api/statistic/listing/count-by-status?where=%5B%7B%22column%22:%22assigned_to_id%22,%22value%22:${sharedPreferences.get('user_id')}%7D%5D';
      }
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        return ListingCountResponse.fromJson(jsonDecode(response.body));
      } else {
        print(response.statusCode);
        return null;
      }

    } catch(e) {
      print(e);
      return null;
    }
  }

  Future<LeadsCountResponse> fetchLeadsCount() async {
    try{
      final box = GetStorage();
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url;
      int roleId = box.read('role_id');
      if(roleId == 3){
        url = '${ApiRoutes.BASE_URL}/api/statistic/leads/count-by-status?where=%5B%7B%22column%22:%22agent_id%22,%22value%22:${sharedPreferences.get('user_id')}%7D%5D';
      } else {
        url = '${ApiRoutes.BASE_URL}/api/statistic/leads/count-by-status?where=%5B%5D';
      }


      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      //print(response.body);
      if(response.statusCode == 200){
        return LeadsCountResponse.fromJson(jsonDecode(response.body));
      } else {
        print(response.statusCode);
        return null;
      }
    } catch(e) {
      print(e);
      return null;
    }
  }

  Future<TodayViewingsCount> fetchViewingsCount() async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url;
      url = '${ApiRoutes.API_URL}leads/views?page=1&limit=1';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        return TodayViewingsCount.fromJson(jsonDecode(response.body));
      } else{
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<PublishedListingsCount> fetchPublishedListings() async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url;

      url = '${ApiRoutes.BASE_URL}/api/statistic/performance/current-month/published-listings';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        return PublishedListingsCount.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }


  Future<PortalsCount> getPortalsCount() async{
    try{
      final box = GetStorage();
      int roleId = box.read('role_id');
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url;
      if(roleId == 1 || roleId == 2){
        url = '${ApiRoutes.BASE_URL}/api/reports/users/by-listing-quota';
      } else {
        url = '${ApiRoutes.BASE_URL}/api/reports/users/by-listing-quota?user_id=${sharedPreferences.get('user_id')}';
      }

      //print(url);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      //print(response.body);
      if(response.statusCode == 200){
        return PortalsCount.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch(e){
      return null;
    }
  }

  Future<Tasks> getTasks() async{
    try{
      final box = GetStorage();
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      int id = sharedPreferences.getInt('user_id');
      List permissions = box.read('permissions');
      String where;
      String column;
      String include;
      String order;
      String filter;
      String url;
      if(permissions.contains('todo_view_other')){
        where = '%5B%5D';
      } else {
        where = '%5B%7B%22column%22:%22assign_to_id%22,%22value%22:$id%7D%5D';
      }
      column = '%5B%22title%22,%22status%22,%22priority%22,%22due_at%22,%22created_by_id%22,%22assign_to_id%22%5D';
      include = '%5B%22created_by:id,first_name,last_name%22,%22assigned_to:id,first_name,last_name%22,%22object:id,reference%22%5D';
      order = '%7B%22created_at%22:%22desc%22,%22due_at%22:%22asc%22%7D';
      filter = 'where=$where&columns=$column&include=$include&order=$order';
      url = '${ApiRoutes.BASE_URL}/api/tasks?$filter';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        //print(response.body);
        return Tasks.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch(e){
      print(e);
      return null;
    }
  }

  Future<List> getChartData() async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final box = GetStorage();
      int roleId = box.read('role_id');
      String url;

      if(roleId != 3){
        url = '${ApiRoutes.BASE_URL}/api/reports/leads/by-status?where=%5B%5D&order=%7B%22count%22:%22desc%22%7D';
      } else {
        url = '${ApiRoutes.BASE_URL}/api/reports/leads/by-status?where=%5B%7B%22column%22:%22agent_id%22,%22value%22:${sharedPreferences.get('user_id')}%7D%5D&order=%7B%22count%22:%22desc%22%7D';
      }
      //print(url);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        Map<String, dynamic> map = json.decode(response.body);
        List list = map['record'];
        return list;
      } else {
        return null;
      }

    } catch(e){
      print(e);
      return null;
    }
  }

}

class ListingCountResponse{
  final int approved;
  final int archived;
  final int closed;
  final int draft;
  final int expired;
  final int pending;
  final int published;
  final int rejected;
  final int scheduled;
  final int unpublished;
  final int prospect;

  ListingCountResponse({this.approved, this.archived, this.closed, this.draft, this.expired, this.pending, this.published, this.rejected, this.scheduled, this.unpublished, this.prospect});

  factory ListingCountResponse.fromJson(Map<String, dynamic> json){
    return ListingCountResponse(
      approved: json['record']['Approved'],
      archived: json['record']['Archived'],
      closed: json['record']['Closed'],
      draft: json['record']['Draft'],
      expired: json['record']['Expired'],
      pending: json['record']['Pending'],
      published: json['record']['Published'],
      rejected: json['record']['Rejected'],
      scheduled: json['record']['Scheduled'],
      unpublished: json['record']['Unpublished'],
      prospect: json['record']['Prospect']
    );
  }
}

class LeadsCountResponse{
  final int active;
  final int closed;
  final int lost;
  final int newLead;
  final int open;
  final int prospect;
  final int won;

  LeadsCountResponse({this.active, this.closed, this.lost, this.newLead, this.open, this.prospect, this.won});

  factory LeadsCountResponse.fromJson(Map<String, dynamic> json) {
    return LeadsCountResponse(
      active: json['record']['Active'],
      closed: json['record']['Closed'],
      lost: json['record']['Lost'],
      newLead: json['record']['New'],
      open: json['record']['Open'],
      prospect: json['record']['Prospect'],
      won: json['record']['Won']
    );
  }
}

class TodayViewingsCount{
  final List<dynamic> data;
  final Map<String,dynamic> paginator;

  TodayViewingsCount({this.data, this.paginator});

  factory TodayViewingsCount.fromJson(Map<String, dynamic> json){
    return TodayViewingsCount(
      data: json['record']['data'],
      paginator: json['record']['paginator']
    );
  }
}

class PublishedListingsCount{
  final int rental;
  final int sale;
  PublishedListingsCount({this.rental,this.sale});
  factory PublishedListingsCount.fromJson(Map<String, dynamic> json){
    return PublishedListingsCount(
      rental: json['record']['Rental'],
      sale: json['record']['Sale']
    );
  }
}

class PortalsCount{
  final List<dynamic> portals;
  final List<dynamic> users;
  PortalsCount({this.portals,this.users});
  factory PortalsCount.fromJson(Map<String, dynamic> json){
    return PortalsCount(
      portals: json['record']['portals'],
      users: json['record']['users']
    );
  }
}

class Tasks{
  final List<dynamic> data;
  Tasks({this.data});
  factory Tasks.fromJson(Map<String, dynamic> json){
    return Tasks(
      data: json['record'],
    );
  }
}

//,%7B%22column%22:%22status%22,%22operator%22:%22=%22,%22value%22:%22In%20Progress%22%7D
