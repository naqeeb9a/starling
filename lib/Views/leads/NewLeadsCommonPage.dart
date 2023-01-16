import 'dart:convert';
import 'dart:io';
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:crm_app/Views/leads/LeadsListingCard.dart';
import 'package:crm_app/widgets/EmptyListMessage.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'NewLeadsListingCard.dart';

class NewLeadsCommonPage extends StatefulWidget {
  final String type;
  String query;
  int campaignId;
  List filter;
  NewLeadsCommonPage({this.type, this.query,this.campaignId, this.filter});

  @override
  _NewLeadsCommonPageState createState() => _NewLeadsCommonPageState();
}

class _NewLeadsCommonPageState extends State<NewLeadsCommonPage> {

  final box = GetStorage();
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child:  Paginator.listView(
        key: paginatorGlobalKey,
        pageLoadFuture: sendCountriesDataRequest,
        pageItemsGetter: listItemsGetter,
        listItemBuilder: listItemBuilder,
        loadingWidgetBuilder: loadingWidgetMaker,
        errorWidgetBuilder: errorWidgetMaker,
        emptyListWidgetBuilder: emptyListWidgetMaker,
        totalItemsGetter: totalPagesGetter,
        pageErrorChecker: pageErrorChecker,
        scrollPhysics: BouncingScrollPhysics(),
      ),
    );
  }

  Future<CountriesData> sendCountriesDataRequest (int page) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String url;
      String test;
      String filter = '';
      String where;
      String columns;
      String include;
      String order;
      List permissions = box.read('permissions');

      List<String> statusList = ['Called No Reply','In Progress','Invalid Inquiry','Invalid Number','Not Interested','Not Yet Contacted','Offer Made','Prospect','Successful','Unsuccessful','Viewing'];

      print(widget.type);
      print(widget.filter);
      if(widget.filter != null && widget.filter.isNotEmpty){

        for(int i = 0; i < widget.filter.length; i++){
          if(i == widget.filter.length - 1){
            filter += widget.filter[i];
          } else {
            filter += widget.filter[i] + ',';
          }
        }
        bool hasAgent = false;

        if(filter.contains('%22agent_id%22')){
          hasAgent = true;
        }

        if(hasAgent){
          if(widget.type == 'All'){
            if(widget.campaignId != null){
              where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:${widget.campaignId}%7D,$filter%5D';
            } else{
              where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,$filter%5D';
            }
          } else if(statusList.contains(widget.type)){
            if(widget.campaignId != null){
              where = '`%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(widget.type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:${widget.campaignId}%7D,$filter%5D';
            } else {
              where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(widget.type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,$filter%5D';
            }
          }
        } else {
          if(permissions.contains('leads_view_other')){
            if(widget.type == 'All'){
              if(widget.campaignId != null){
                where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:${widget.campaignId}%7D,$filter%5D';
              } else{
                where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,$filter%5D';
              }
            } else if(statusList.contains(widget.type)){
              if(widget.campaignId != null){
                where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(widget.type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:${widget.campaignId}%7D,$filter%5D';
              } else {
                where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(widget.type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,$filter%5D';
              }
            }
          } else {
            if(widget.type == 'All'){
              if(widget.campaignId != null){
                where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:${widget.campaignId}%7D,$filter%5D';
              } else{
                where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D,$filter%5D';
              }
            } else if(statusList.contains(widget.type)){
              if(widget.campaignId != null){
                where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(widget.type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:${widget.campaignId}%7D,$filter%5D';
              } else {
                where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(widget.type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D,$filter%5D';
              }
            }
          }
        }

      } else {

        if(permissions.contains('leads_view_other')){
          if(widget.type == 'All'){
            if(widget.campaignId != null){
              where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:${widget.campaignId}%7D%5D';
            } else{
              where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D%5D';
            }
          } else if(statusList.contains(widget.type)){
            if(widget.campaignId != null){
              where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(widget.type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:${widget.campaignId}%7D%5D';
            } else {
              where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(widget.type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D%5D';
            }
          }
        } else {
          if(widget.type == 'All'){
            if(widget.campaignId != null){
              where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:${widget.campaignId}%7D%5D';
            } else{
              where = '%5B%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D%5D';
            }
          } else if(statusList.contains(widget.type)){
            if(widget.campaignId != null){
              where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(widget.type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D,%7B%22column%22:%22campaign_id%22,%22operator%22:%22=%22,%22value%22:${widget.campaignId}%7D%5D';
            } else {
              where = '%5B%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(widget.type)}%22%7D,%7B%22column%22:%22status%22,%22operator%22:%22in%22,%22value%22:%5B%22Active%22,%22Closed%22%5D%7D,%7B%22column%22:%22is_prospect%22,%22operator%22:%22=%22,%22value%22:0%7D,%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:${sharedPreferences.get('user_id')}%7D%5D';
            }
          }
        }
      }

      columns = '%5B%22id%22,%22reference%22,%22type%22,%22status%22,%22sub_status%22,%22lead_source%22,%22type%22,%22priority%22,%22is_hot_lead%22,%22enquiry_date%22,%22created_at%22,%22agent_id%22,%22listing_id%22,%22client_id%22%5D';
      include = '%5B%22agent:id,first_name,last_name,email,phone,mobile%22,%22source:id,name%22,%22sub_source:id,name%22,%22campaign:id,title,campaign_id%22,%22client:id,first_name,last_name,email,phone,mobile%22,%22listing:id,reference,assigned_to_id,owner_id,property_location,location_id,sub_location_id%22,%22listing.location%22,%22listing.sub_location%22,%22listing.owner:id,mobile,email,first_name,last_name%22,%22location%22,%22sub_location%22%5D';
      order = '%7B%22enquiry_date%22:%22desc%22%7D';
      String fil;
      if(widget.query == null){
        fil = 'where=$where&include=$include&order=$order&page=$page&limit=15';
      } else {
        fil = 'where=$where&include=$include&order=$order&page=$page&limit=15&q=${widget.query}';
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
        if(response.body != null){
          return CountriesData.fromResponse(response);
        }
      } else {
        return null;
      }
    } catch(e){
      if (e is IOException) {
        return CountriesData.withError(
            'Please check your internet connection.');
      } else {
        print(e.toString());
        return CountriesData.withError('Something went wrong.');
      }
    }
  }

  List<dynamic> listItemsGetter(CountriesData countriesData) {
    return countriesData.countries;
  }

  Widget listItemBuilder (value, int index){
    return Column(
      children: [
        NewLeadListingCard(
          id: value['id'],
          reference: value['reference'],
          status: value['status'],
          sub_status: value['sub_status'],
          enquiry_date: value['enquiry_date'],
          client_firstName: value['client']['first_name'],
          client_lastName: value['client']['last_name'],
          type: value['type'],
          phone: value['client']['mobile'],
          email: value['client']['email'],
          assignedToId: value['agent_id'],
          campaign: value['campaign']!=null?value['campaign']['title']:'',
          source: value['source']!=null?value['source']['name']:'Unknown',
          priority: value['priority'],
          agent: value['agent']!= null && value['agent'] != ''?value['agent']['full_name']:'',
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }


  Widget loadingWidgetMaker() {
    return Container(
      alignment: Alignment.center,
      height: 160.0,
      child: Center(child: AnimatedSearch()),
    );
  }

  Widget errorWidgetMaker(CountriesData countriesData, retryListener) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(countriesData.errorMessage),
        ),
        // ignore: deprecated_member_use
        ElevatedButton(
          onPressed: retryListener,
          child: Text('Retry'),
        )
      ],
    );
  }

  Widget emptyListWidgetMaker(CountriesData countriesData) {
    return EmptyListMessage(message: 'No Leads Available',);
  }

  int totalPagesGetter(CountriesData countriesData) {
    return countriesData.total;
  }

  bool pageErrorChecker(CountriesData countriesData) {
    return countriesData.statusCode != 200;
  }

}

class CountriesData {
  List<dynamic> countries;
  int statusCode;
  String errorMessage;
  int total;
  int nItems;

  CountriesData.fromResponse(http.Response response) {
    this.statusCode = response.statusCode;
    //print(response.statusCode);
    Map<String, dynamic> jsonData = json.decode(response.body);
    //print( jsonData);
    countries = jsonData['record']['data'];
    //print(jsonData['record']);
    total = jsonData['record']['paginator']['total'];
    // print(total);
    nItems = countries.length;
  }

  CountriesData.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}
