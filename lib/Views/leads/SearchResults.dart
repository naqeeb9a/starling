import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/leads/LeadsLandingPage.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';

import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:crm_app/Views/listings/ListingPageCard.dart';
import 'package:crm_app/widgets/EmptyListMessage.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'LeadsListingCard.dart';

class SearchResults extends StatefulWidget {
  final String query;
  SearchResults({this.query});

  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {

  final keywordController = TextEditingController();

  @override
  void dispose() {
    keywordController.dispose();
    super.dispose();
  }

  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    keywordController.text = widget.query;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.globalColor(),
        elevation: 10,
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=> LeadsLandingPage()));
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 27,),
        ),
        title: Center(
          child: Text(
            'Search Results',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              color: Colors.white,

            ),
          ),
        ),
        actions: [
          /*Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListingFilterPage()));
                },
                child: Icon(Icons.filter_list_alt,size: 27, color: Colors.white,),
              ),
            ),*/
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsListPage()));
              },
              child: Icon(Icons.notifications, color: Colors.white,size: 27,),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black38.withAlpha(10),
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: keywordController,
                    decoration: InputDecoration(
                      hintText: "Search in Listings",
                      hintStyle: TextStyle(
                        color: Colors.black.withAlpha(120),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchResults(query: keywordController.text,)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.search,
                      color: Colors.black.withAlpha(120),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Paginator.listView(
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
            ),
          )
        ],
      ),
    );
  }
  Future<CountriesData> sendCountriesDataRequest (int page) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final box = GetStorage();

      String url;
      String filter;
      String where;
      String columns;
      String include;
      String order;
      List permissions = box.read('permissions');
      if(permissions.contains('leads_view_other')){
        where = '%5B%5D';
      } else {
        where = '%5B%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:%5B%22${sharedPreferences.get('user_id')}%22%5D%7D%5D';
      }
      columns = '%5B%22id%22,%22reference%22,%22type%22,%22status%22,%22sub_status%22,%22lead_source%22,%22type%22,%22priority%22,%22is_hot_lead%22,%22enquiry_date%22,%22created_at%22,%22agent_id%22,%22listing_id%22,%22client_id%22%5D';
      include = '%5B%22agent:id,first_name,last_name,reference,phone,email%22,%22client:id,first_name,last_name,reference,mobile,phone,email,country_id%22,%22client.country:id,name,iso_code2%22%5D';
      order = '%7B%22enquiry_date%22:%22desc%22%7D';

      filter = 'where=$where&columns=$columns&include=$include&order=$order&page=$page&limit=15&q=${widget.query}';
      url = '${ApiRoutes.BASE_URL}/api/leads?$filter';
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
    return Padding(
      padding: EdgeInsets.fromLTRB(2, 0, 2, 2),
      child: Column(
        children: [
          LeadsListingCard(
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
          ),
          Divider(
            height: 0.2,
            thickness: 1,
            color: Colors.grey,
          )
        ],
      ),
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
    print(jsonData['record']);
    total = jsonData['record']['paginator']['total'];
    // print(total);
    nItems = countries.length;
  }

  CountriesData.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}
