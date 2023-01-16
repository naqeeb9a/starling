import 'dart:convert';
import 'dart:io';

import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:crm_app/Views/Viewings/ViewingsDetailsPage.dart';
import 'package:crm_app/Views/leads/LeadsDetailsDashboardPage.dart';
import 'package:crm_app/Views/leads/NewLeadsDetailLandingPage.dart';
import 'package:crm_app/Views/listings/ListingDetailsLandingPage.dart';
import 'package:crm_app/Views/listings/NewListingsDetailsLandingPage.dart';
import 'package:crm_app/Views/tasks/TaskDetailsPage.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/EmptyListMessage.dart';
import 'package:crm_app/widgets/NotificationIcons.dart';
import 'package:crm_app/widgets/appbars/CommonAppBars.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsListPage extends StatefulWidget {

  @override
  _NotificationsListPageState createState() => _NotificationsListPageState();
}

class _NotificationsListPageState extends State<NotificationsListPage> {
  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/anwbackground.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: GlobalColors.globalColor(),
            elevation: 10,
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 27,),
            ),
            title: Center(
              child: Text(
                'Notifications',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  color: Colors.white,

                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.notifications, color: GlobalColors.globalColor(),size: 27,),
              )
            ],
          ),
          body: Column(
            children: [
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
        ),
      ],
    );
  }


  Future<CountriesData> sendCountriesDataRequest (int page) async {
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String where = '%5B%7B%22column%22:%22user_id%22,%22value%22:${sharedPreferences.getInt('user_id')}%7D%5D';
      String include = '%5B%5D';
      String order = '%7B%22created_at%22:%22desc%22%7D';
      String url = '${ApiRoutes.BASE_URL}/api/notifications?where=$where&include=$include&order=$order&page=$page&limit=15';

      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      print(response.body);
      if(response.statusCode == 200){
        print(response.body);
        return CountriesData.fromResponse(response);
      } else {
        print(response.body);
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
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  switch(value['object_type']){
                    case 'lead_view':
                      {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewingsDetailsPage(id: value['object_id'],)));
                      }
                      break;
                    case 'listing':
                      {
                        String msg = value['message'];
                        String refs = msg.split('Ref: ')[1];
                        String ref = refs.split(' . ')[0];
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewListingsDetailsLandingPage(id: value['object_id'],selectedIndex: 0,)));
                      }
                      break;
                    case 'lead':
                      {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewLeadsDetailLandingPage(id: value['object_id'],)));
                      }
                      break;
                    case 'task':
                      {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TasksDetailsPage(id: value['object_id'],)));
                      }
                      break;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      getNotificationIcons(value['object_type']),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.04,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${value['subject']}',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              '${value['message']}',
                              style: AppTextStyles.c14grey400(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
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
