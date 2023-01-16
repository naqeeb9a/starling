import 'dart:convert';
import 'dart:io';

import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:crm_app/Views/listings/ListingPageCard.dart';
import 'package:crm_app/widgets/EmptyListMessage.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ListingsCommonListingPage extends StatefulWidget {

  final String type;
  final String filter;
  ListingsCommonListingPage({this.type, this.filter});

  @override
  _ListingsCommonListingPageState createState() => _ListingsCommonListingPageState();
}

class _ListingsCommonListingPageState extends State<ListingsCommonListingPage> {

  final keywordController = TextEditingController();

  @override
  void dispose() {
    keywordController.dispose();
  }

  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          /*Container(
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
                      hintText: "Search by keyword",
                      hintStyle: TextStyle(
                        color: Colors.black.withAlpha(120),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){

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
          ),*/
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
      String url;

      String wherePart;
      int id = sharedPreferences.getInt('user_id');
      if(widget.type == 'My Listings'){
        if(widget.filter == null){
          wherePart = 'where=%5B%7B%22column%22:%22assigned_to_id%22,%22value%22:$id%7D%5D&columns=%5B%22id%22,%22reference%22,%22title%22,%22description%22,%22property_for%22,%22property_type%22,%22listing_status%22,%22portal_status%22,%22category_id%22,%22city_id%22,%22location_id%22,%22property_location%22,%22sub_location_id%22,%22assigned_to_id%22,%22created_by_id%22,%22created_at%22,%22updated_at%22,%22price%22,%22slug%22%5D&include=%5B%22category:id,name%22,%22location:id,name%22,%22sub_location:id,name%22,%22assigned_to:id,first_name,last_name%22,%22images%22,%22portals%22%5D&order=%7B%22updated_at%22:%22desc%22%7D&count=%5B%22leads%22,%22images%22,%22listing_updates%22%5D';
        } else {
          wherePart = 'where=%5B%7B%22column%22:%22assigned_to_id%22,%22value%22:$id%7D,${widget.filter}%5D&columns=%5B%22id%22,%22reference%22,%22title%22,%22description%22,%22property_for%22,%22property_type%22,%22listing_status%22,%22portal_status%22,%22category_id%22,%22city_id%22,%22location_id%22,%22property_location%22,%22sub_location_id%22,%22assigned_to_id%22,%22created_by_id%22,%22created_at%22,%22updated_at%22,%22price%22,%22slug%22%5D&include=%5B%22category:id,name%22,%22location:id,name%22,%22sub_location:id,name%22,%22assigned_to:id,first_name,last_name%22,%22images%22,%22portals%22%5D&order=%7B%22updated_at%22:%22desc%22%7D&count=%5B%22leads%22,%22images%22,%22listing_updates%22%5D';
        }
      } else {
        if(widget.filter == null){
          wherePart = 'where=%5B%5D&columns=%5B%22id%22,%22reference%22,%22title%22,%22description%22,%22property_for%22,%22property_type%22,%22listing_status%22,%22portal_status%22,%22category_id%22,%22city_id%22,%22location_id%22,%22property_location%22,%22sub_location_id%22,%22assigned_to_id%22,%22created_by_id%22,%22created_at%22,%22updated_at%22,%22price%22,%22slug%22%5D&include=%5B%22category:id,name%22,%22location:id,name%22,%22sub_location:id,name%22,%22assigned_to:id,first_name,last_name%22,%22images%22,%22portals%22%5D&order=%7B%22updated_at%22:%22desc%22%7D&count=%5B%22leads%22,%22images%22,%22listing_updates%22%5D';
        } else {
          wherePart = 'where=%5B${widget.filter}%5D&columns=%5B%22id%22,%22reference%22,%22title%22,%22description%22,%22property_for%22,%22property_type%22,%22listing_status%22,%22portal_status%22,%22category_id%22,%22city_id%22,%22location_id%22,%22property_location%22,%22sub_location_id%22,%22assigned_to_id%22,%22created_by_id%22,%22created_at%22,%22updated_at%22,%22price%22,%22slug%22%5D&include=%5B%22category:id,name%22,%22location:id,name%22,%22sub_location:id,name%22,%22assigned_to:id,first_name,last_name%22,%22images%22,%22portals%22%5D&order=%7B%22updated_at%22:%22desc%22%7D&count=%5B%22leads%22,%22images%22,%22listing_updates%22%5D';
        }
      }

      url = '${ApiRoutes.API_URL}listings?$wherePart&page=$page&limit=15';
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
    } catch (e){
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
    String imgUrl;
    if(value['images'] != null && value['images'].length != 0){
      imgUrl = value['images'][0]['url'];
    } else {
      print('Entered else');
      imgUrl = null;
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(2, 0, 2, 2),
      child: Column(
        children: [
          ListingCard(
            id: value['id'],
            reference: value['reference'],
            price: value['price'] != null? double.parse(value['price']): 0,
            listingStatus: value['listing_status'],
            agentFullName: value['assigned_to'] != null?value['assigned_to']['full_name']:'',
            propertyLocation: value['property_location'],
            property_for: value['property_for'],
            title: value['title'],
            image_path: imgUrl,
            updated_at: value['updated_at'],
            property_type: value['property_type'],
            portals: value['portals'],
            portalStatus: value['portal_status'],
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
    return EmptyListMessage(message: 'No Listings Available',);
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
    total = jsonData['record']['paginator']['total'];
    // print(total);
    nItems = countries.length;
  }

  CountriesData.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}
