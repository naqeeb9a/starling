import 'dart:convert';
import 'dart:io';

import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/Viewings/ViewingCard.dart';
import 'package:crm_app/Views/listings/ListingPageCard.dart';
import 'package:crm_app/Views/tasks/TaskDetailsPage.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/PriorityColors.dart';
import 'package:crm_app/widgets/EmptyListMessage.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewingsList extends StatefulWidget {

  @override
  _ViewingsListState createState() => _ViewingsListState();
}

class _ViewingsListState extends State<ViewingsList> {

  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();
  DateTimeConversion dateTimeConversion = DateTimeConversion();

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
            title: Center(
              child: Text(
                'Viewings',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: (){
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white,size: 27,),
            ),
            backgroundColor: GlobalColors.globalColor(),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsListPage()));
                  },
                  child: Icon(Icons.notifications, color: Colors.white,size: 27,),
                ),
              )
            ],
          ),
          body: Padding(
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
          // floatingActionButton: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: FloatingActionButton(
          //     child: Icon(Icons.add,color: Colors.white,),
          //     backgroundColor: GlobalColors.globalColor(),
          //     onPressed: (){
          //
          //     },
          //     tooltip: 'Add an event for this date',
          //   ),
          // ),
        ),
      ],
    );
  }


  Future<CountriesData> sendCountriesDataRequest (int page) async{
   try{
     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     String url;
     int id = sharedPreferences.getInt('user_id');
     final box = GetStorage();
     int roleId = box.read('role_id');
     List permissions = box.read('permissions');
     String where;
     String column;
     String include;
     String order;
     String filter;

     if(permissions.contains('listings_view_other')){
       where = '%5B%5D';
     } else {
       where = '%5B%7B%22column%22:%22listing_id%22,%22value%22:$id%7D%5D';
     }
     column = '%5B%22agent_id%22,%22created_at%22,%22datetime%22,%22id%22,%22lead_id%22,%22listing_id%22,%22notes%22,%22status%22,%22updated_at%22,%22user_id%22%5D';
     include = '%5B%22agent:id,first_name,last_name,profile_picture%22,%22user:id,first_name,last_name,profile_picture%22,%22listing:id,reference,listing_status%22,%22lead:id,reference,status%22%5D';
     order = '%7B%22datetime%22:%22desc%22%7D';
     filter = 'where=$where&columns=$column&include=$include&order=$order&page=$page&limit=10';
     url = '${ApiRoutes.BASE_URL}/api/leads/views?$filter';
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
      padding: EdgeInsets.fromLTRB(5, 0, 2, 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ViewingCard(
            id: value['id'],
            leadRef: value['lead']['reference'],
            listingRef: value['listing']['reference'],
            agentFullName: value['agent']['full_name'],
            userFullName: value['user']['full_name'],
            status: value['status'],
            datetime: value['datetime'],
          ),
          SizedBox(
            height: 5,
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
    return EmptyListMessage(message: 'No Viewings Available',);
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
