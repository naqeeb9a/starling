import 'package:crm_app/Views/Login/LogoutPage.dart';
import 'package:crm_app/Views/NearByListings/NearByListings.dart';
import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/Viewings/ViewingsList.dart';
import 'package:crm_app/Views/contacts/ContactsListing.dart';
import 'package:crm_app/Views/leads/LeadsLandingPage.dart';
import 'package:crm_app/Views/listings/ListingCommonPage.dart';
import 'package:crm_app/Views/tasks/TasksListingPage.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ProfileHeader.dart';
import 'package:crm_app/widgets/appbars/CommonAppBars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'ListingFilterPage.dart';

class ListingLandingPage extends StatelessWidget {

  final box = GetStorage();
  String filter;
  ListingLandingPage({this.filter});


  @override
  Widget build(BuildContext context) {
    List permissions = box.read('permissions');
    int roleId = box.read('role_id');
    int tabCount = 1;
    if(roleId != 3 || permissions.contains('listings_view_other'))
      tabCount += 1;
    return DefaultTabController(
      length: tabCount,
      child: Scaffold(
        backgroundColor: Colors.white24,
        appBar: AppBar(
          backgroundColor: GlobalColors.globalColor(),
          elevation: 10,
          leading: IconButton(
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 27,),
          ),
          title: Center(
            child: Text(
              'Listings',
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
          bottom: TabBar(
            isScrollable: false,
            indicatorColor: Colors.white,
            tabs: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'My Listings',
                  style: AppTextStyles.c16white600(),
                ),
              ),
              if(permissions.contains('listings_view_other'))
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                  'Company Listings',
                  style: AppTextStyles.c16white600(),
              ),
                )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            filter==null?ListingsCommonListingPage(type: 'My Listings',):ListingsCommonListingPage(type: 'My Listings',filter: filter,),
            filter==null?ListingsCommonListingPage(type: 'All Listings',):ListingsCommonListingPage(type: 'All Listings',filter: filter,)
          ],
        ),
      ),
    );
  }
}
