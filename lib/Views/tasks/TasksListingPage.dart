import 'dart:convert';
import 'dart:io';

import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/listings/ListingPageCard.dart';
import 'package:crm_app/Views/tasks/AddTask.dart';
import 'package:crm_app/Views/tasks/TaskDetailsPage.dart';
import 'package:crm_app/Views/tasks/TasksCard.dart';
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

class TasksListingPage extends StatefulWidget {

  @override
  _TasksListingPageState createState() => _TasksListingPageState();
}

class _TasksListingPageState extends State<TasksListingPage> {

  final keywordController = TextEditingController();

  @override
  void dispose() {
    keywordController.dispose();
    super.dispose();
  }

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
                'Tasks',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: GlobalColors.globalColor(),
            leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white,size: 27,),
            ),
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
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddTask()));
              },
              backgroundColor: GlobalColors.globalColor(),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              tooltip: 'Add new task',
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
      final box = GetStorage();
      int roleId = box.read('role_id');
      List permissions = box.read('permissions');
      int id = sharedPreferences.getInt('user_id');
      String where;
      String column;
      String include;
      String order;
      String filter;

      if(permissions.contains('todo_view_other')){
        where = '%5B%5D';
      } else {
        where = '%5B%7B%22column%22:%22assign_to_id%22,%22value%22:$id%7D%5D';
      }
      column = '%5B%22title%22,%22status%22,%22priority%22,%22due_at%22,%22created_by_id%22,%22assign_to_id%22%5D';
      include = '%5B%22created_by:id,first_name,last_name%22,%22assigned_to:id,first_name,last_name%22,%22object:id,reference%22%5D';
      order = '%7B%22created_at%22:%22desc%22,%22due_at%22:%22asc%22%7D';
      filter = 'where=$where&columns=$column&include=$include&order=$order&page=$page&limit=10';
      url = '${ApiRoutes.BASE_URL}/api/tasks?$filter';
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

  Widget listItemBuilder (value, int index) {

    return TasksCard(
      id: value['id'],
      status: value['status'],
      priority: value['priority'],
      createdDate: value['created_at'],
      dueDate: value['due_at'],
      title: value['title'],
      fullName: value['assigned_to']!=null?'${value['assigned_to']['full_name']}':'',
    );

    return InkWell(
      onTap: (){
        print(value);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => TasksDetailsPage(
          id: value['id'],
          status: value['status'],
          priority: value['priority'],
          createdDate: value['created_at'],
          dueDate: value['due_at'],
          title: value['title'],
          description: value['description'],
        )));
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text(
                    value['assigned_to']!=null?'${value['assigned_to']['full_name']}':'',
                    style: AppTextStyles.c14grey400(),
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: taskStatus(value['status']),
                    ),
                    SizedBox(width: 3,),
                    Text(
                      '${value['status']}',
                      style: TextStyle(
                        color: taskStatus(value['status']),
                        fontSize: 14,
                        fontFamily: 'Cairo'
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(right:8.0),
                  child: Row(
                    children: [
                      Text(
                        'Priority: ',
                        style: AppTextStyles.c12grey400(),
                      ),

                      Text(
                        '${value['priority']}',
                        style: TextStyle(
                            color: priorityColor(value['priority']),
                            fontSize: 14,
                            fontFamily: 'Cairo'
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      '${value['title']}',
                      style: AppTextStyles.c18black500(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right:8.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 18,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Due on: ${dateTimeConversion.getDDMMMYYY(value['due_at'])}',
                    style: AppTextStyles.c14grey400(),
                  ),
                ),
              ],
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
    return EmptyListMessage(message: 'No Tasks Available',);
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
