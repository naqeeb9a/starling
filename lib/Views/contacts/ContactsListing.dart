import 'dart:convert';
import 'dart:io';
import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:crm_app/Views/Login/LogoutPage.dart';
import 'package:crm_app/Views/NearByListings/NearByListings.dart';
import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/Viewings/ViewingsList.dart';
import 'package:crm_app/Views/contacts/ContactDetails.dart';
import 'package:crm_app/Views/contacts/ContactListingCard.dart';
import 'package:crm_app/Views/leads/LeadsLandingPage.dart';
import 'package:crm_app/Views/leads/LeadsListingCard.dart';
import 'package:crm_app/Views/listings/ListingLandingPage.dart';
import 'package:crm_app/Views/tasks/TasksListingPage.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/EmptyListMessage.dart';
import 'package:crm_app/widgets/ProfileHeader.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddContact.dart';

class ContactsListing extends StatefulWidget {
  @override
  _ContactsListingState createState() => _ContactsListingState();
}

class _ContactsListingState extends State<ContactsListing> {

  final keywordController = TextEditingController();

  @override
  void dispose() {
    keywordController.dispose();
  }

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
            title: Center(
              child: Text(
                'Contacts',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
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
                ),
              )
            ],
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddContact()));
              },
              backgroundColor: GlobalColors.globalColor(),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              tooltip: 'Add new contact',
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        ),
      ],
    );
  }

  Future<CountriesData> sendCountriesDataRequest (int page) async {
    try{

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String url;
      String filter;
      String where;
      String columns;
      String include;
      String order;

      where = '%5B%5D';
      columns = '%5B%22first_name%22,%22last_name%22,%22reference%22,%22mobile%22,%22email%22,%22language_id%22,%22country_id%22,%22state%22,%22city%22,%22zip%22,%22address1%22%5D';
      include = '%5B%22language%22,%22country%22%5D';
      order = '%7B%22first_name%22:%22ASC%22,%22last_name%22:%22ASC%22%7D';
      filter = 'where=$where&columns=$columns&include=$include&order=$order&page=$page&limit=10';
      url = '${ApiRoutes.BASE_URL}/api/users/${sharedPreferences.get('user_id')}/clients?$filter';
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
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContactDetails(
          id: value['id'],
          reference: value['reference'],
          fullName: value['full_name'],
          mobile: value['mobile'],
          phone: value['phone'],
          email: value['email'],
        )));
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(5, 0, 2, 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContactListingCard(
              id: value['id'],
              reference: value['reference'],
              fullName: value['full_name'],
              phone: value['mobile'],
              email: value['email'],
            ),
            Divider(
              height: 0.2,
              thickness: 1,
              color: Colors.grey,
            ),
            SizedBox(
              height: 5,
            )
          ],
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
    return EmptyListMessage(message: 'No Contacts Available',);
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
