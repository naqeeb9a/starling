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

import 'NewListingPageCard.dart';

class NewListingsCommonListingPage extends StatefulWidget {

  final String type;
  String query;
  List filter;
  int portalId;
  NewListingsCommonListingPage({this.type, this.query, this.filter,this.portalId});

  @override
  _NewListingsCommonListingPageState createState() => _NewListingsCommonListingPageState();
}

class _NewListingsCommonListingPageState extends State<NewListingsCommonListingPage> {

  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
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
    );
  }

  Future<CountriesData> sendCountriesDataRequest (int page) async {
    try{

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url;

      String wherePart;
      String columns;
      String include;
      String filter = '';
      int id = sharedPreferences.getInt('user_id');
      if(widget.type == 'My Listings'){
        if(widget.filter != null){
          for(int i = 0; i < widget.filter.length; i++){
            if(i == widget.filter.length - 1){
              filter += widget.filter[i];
            } else {
              filter += widget.filter[i] + ',';
            }
          }
          wherePart = 'where=%5B%7B%22column%22:%22assigned_to_id%22,%22value%22:$id%7D,$filter%5D';

        } else {
          wherePart = 'where=%5B%7B%22column%22:%22assigned_to_id%22,%22value%22:$id%7D%5D';
        }

      } else {
        if(widget.filter != null){
          for(int i = 0; i < widget.filter.length; i++){
            if(i == widget.filter.length - 1){
              filter += widget.filter[i];
            } else {
              filter += widget.filter[i] + ',';
            }
          }
          wherePart = 'where=%5B$filter%5D';
        } else {
          wherePart = 'where=%5B%5D';
        }
      }
      columns = '%5B%22id%22,%22assigned_to_id%22,%22listing_status%22,%22reference%22,%22external_reference%22,%22transaction_no%22,%22permit_no%22,%22permit_expiry%22,%22property_type%22,%22property_for%22,%22unit_no%22,%22property_location%22,%22beds%22,%22build_up_area%22,%22price%22,%22furnished%22,%22published_at%22,%22created_at%22,%22updated_at%22,%22title%22,%22category_id%22,%22created_by_id%22,%22slug%22,%22portal_status%22,%22location_id%22,%22sub_location_id%22,%22tower_id%22,%22submitted_by%22,%22description%22,%22is_featured%22,%22is_premium%22,%22is_exclusive%22%5D';
      include = '%5B%22category:id,name%22,%22assigned_to:id,first_name,last_name%22,%22created_by:id,first_name,last_name%22,%22location%22,%22sub_location%22,%22tower%22,%22portals:name%22,%22images%22%5D';
      String order = '%7B%22updated_at%22:%22desc%22%7D';
      String count = '%5B%22leads%22,%22images%22,%22listing_updates%22%5D';
      String q = widget.query;
      int pid = widget.portalId;
      if(q == null){
        if(pid == null){
          url = '${ApiRoutes.API_URL}listings?$wherePart&columns=$columns&include=$include&order=$order&count=$count&portal_id=&portal_breakdown_id=&page=$page&limit=8';
        } else {
          url = '${ApiRoutes.API_URL}listings?$wherePart&columns=$columns&include=$include&order=$order&count=$count&portal_id=$pid&portal_breakdown_id=&page=$page&limit=8';
        }
      } else {
        if(pid == null){
          url = '${ApiRoutes.API_URL}listings?$wherePart&columns=$columns&include=$include&order=$order&count=$count&portal_id=&portal_breakdown_id=&page=$page&limit=8&q=$q';
        } else {
          url = '${ApiRoutes.API_URL}listings?$wherePart&columns=$columns&include=$include&order=$order&count=$count&portal_id=$pid&portal_breakdown_id=&page=$page&limit=8&q=$q';
        }
      }



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
        print(response.body);
        return null;
      }
    } catch (e){
      if (e is IOException) {
        return CountriesData.withError(
            'Please check your internet connection.');
      } else {
        print(e.toString());
        return CountriesData.withError('Something went wrong. ${e.toString()}');
      }
    }
  }

  List<dynamic> listItemsGetter(CountriesData countriesData) {
    return countriesData.countries;
  }

  Widget listItemBuilder (value, int index){

    String imgUrl;
    if(value['images'] != null && value['images'].length != 0){
      //print(value['images'][0]['url']);
      imgUrl = value['images'][0]['url'];
    } else {
      // print('Entered else');
      imgUrl = null;
    }
    return NewListingCard(
      id: value['id'],
      reference: value['reference'],
      price: value['price'] != null? double.parse(value['price'].toString()): 0,
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
      description: value['description'],
      bua: value['build_up_area'].toString(),
      beds: value['beds']!=null && value['beds'] != 0?value['beds'].toString():'',
      baths: value['baths']!=null && value['baths'] != 0?value['baths'].toString():'',
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

    Map<String, dynamic> jsonData = json.decode(response.body);

    countries = jsonData['record']['data'];
    total = jsonData['record']['paginator']['total'];

    nItems = countries.length;
  }

  CountriesData.withError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}
