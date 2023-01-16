import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddLeadController {

  Future<bool> addLead(int agentId, int campaignId, int clientId, String enquiryDate, String leadSource, String priority, int sourceId, String status, String subStatus, String type) async {
    try{
      Map data = {
        'agent_id': agentId,
        'campaign_id': campaignId!=null?campaignId:null,
        'client_id': clientId,
        'enquiry_date': enquiryDate!=null?enquiryDate:"",
        'finance': "",
        'is_accepted': 1,
        'is_agent_referral': 0,
        'is_hot_lead': 0,
        'is_prospect': 0,
        'is_reassigned': 0,
        'is_shareable': 0,
        'lead_source': leadSource,
        'listing_id': null,
        'location_id': null,
        'note': "",
        'priority': priority,
        'properties': [],
        'reminders': [],
        'source_id': sourceId,
        'status': "Active",
        'sub_location_id': null,
        'sub_status': subStatus,
        'task_assign_to_id': "",
        'task_description': "",
        'task_due_at': null,
        'task_priority': "",
        'task_status': "",
        'task_title': "",
        'type': type
      };
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url = '${ApiRoutes.BASE_URL}/api/leads';
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
        print(response.statusCode);
        return false;
      }

    } catch(e){
      print(e);
      return false;
    }

  }

}