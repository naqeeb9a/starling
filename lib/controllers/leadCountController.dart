import 'dart:convert';
import 'dart:io';

import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LeadCountController {

  Future<int> getLeadsCount(String type,int campaignId, String q, List<String> filter, int agentId) async{
    try{

      final box = GetStorage();

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String url;
      String test;
      String f = '';
      String where;
      String columns;
      String include;
      String order;
      List permissions = box.read('permissions');

      List<String> statusList = ['Called No Reply','In Progress','Invalid Inquiry','Invalid Number','Not Interested','Not Yet Contacted','Offer Made','Prospect','Successful','Unsuccessful','Viewing', 'Shuffle', 'Follow Up Later'];

      if(filter != null && filter.isNotEmpty){

        for(int i = 0; i < filter.length; i++){
          if(i == filter.length - 1){
            f += filter[i];
          } else {
            f += filter[i] + ',';
          }
        }
        bool hasAgent = false;

        if(f.contains('%22agent_id%22')){
          hasAgent = true;
        }
        print(hasAgent);

        if(hasAgent){
          if(type == 'All'){
            if(campaignId != null){
              where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:$campaignId%7D,$f%5D';
            } else{
              where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,$f%5D';
            }
          } else if(statusList.contains(type)){
            if(campaignId != null){
              where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:$campaignId%7D,$f%5D';
            } else {
              where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,$f%5D';
            }
          }
        } else {
          if(permissions.contains('leads_view_other')){
            if(type == 'All'){
              if(campaignId != null){
                where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:$campaignId%7D,$f%5D';
              } else{
                where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,$f%5D';
              }
            } else if(statusList.contains(type)){
              if(campaignId != null){
                where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:$campaignId%7D,$f%5D';
              } else {
                where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,$f%5D';
              }
            }
          } else {
            if(type == 'All'){
              if(campaignId != null){
                where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:$campaignId%7D,$f%5D';
              } else{
                where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D,$f%5D';
              }
            } else if(statusList.contains(type)){
              if(campaignId != null){
                where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:$campaignId%7D,$f%5D';
              } else {
                where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D,$f%5D';
              }
            }
          }
        }

      } else {

        if(permissions.contains('leads_view_other')){
          if(type == 'All'){
            if(campaignId != null){
              where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:$campaignId%7D%5D';
            } else{
              where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D%5D';
            }
          } else if(statusList.contains(type)){
            if(campaignId != null){
              where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:$campaignId%7D%5D';
            } else {
              where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D%5D';
            }
          }
        } else {
          if(type == 'All'){
            if(campaignId != null){
              where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:$campaignId%7D%5D';
            } else{
              where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D%5D';
            }
          } else if(statusList.contains(type)){
            if(campaignId != null){
              where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:$campaignId%7D%5D';
            } else {
              where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D%5D';
            }
          }
        }
      }

      columns = '%5B%22id%22,%22reference%22,%22type%22,%22status%22,%22sub_status%22,%22lead_source%22,%22type%22,%22priority%22,%22is_hot_lead%22,%22enquiry_date%22,%22created_at%22,%22agent_id%22,%22listing_id%22,%22client_id%22%5D';
      include = '%5B%22agent:id,first_name,last_name,email,phone,mobile%22,%22source:id,name%22,%22sub_source:id,name%22,%22campaign:id,title,campaign_id%22,%22client:id,first_name,last_name,email,phone,mobile%22,%22listing:id,reference,assigned_to_id,owner_id,property_location,location_id,sub_location_id%22,%22listing.location%22,%22listing.sub_location%22,%22listing.owner:id,mobile,email,first_name,last_name%22,%22location%22,%22sub_location%22%5D';
      order = '%7B%22enquiry_date%22:%22desc%22%7D';
      String fil;
      if(q == null){
        fil = 'where=$where&include=$include&order=$order&page=1&limit=15';
      } else {
        fil = 'where=$where&include=$include&order=$order&page=1&limit=15&q=$q';
      }

      url = '${ApiRoutes.BASE_URL}/api/leads?$fil';
      //print(url);
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      if(response.statusCode == 200){
        Map map = json.decode(response.body);
        //print(map['record']['paginator']);
        int total = map['record']['paginator']['total'];
        return total;
      } else {
        print(response.body);
        return 0;
      }
    } catch(e){
      print(e);
      return 0;
    }
  }

}