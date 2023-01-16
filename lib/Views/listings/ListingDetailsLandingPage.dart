import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/listings/ListingCommonPage.dart';
import 'package:crm_app/Views/listings/ListingNotes.dart';
import 'package:crm_app/Views/listings/ListingStatusDetails.dart';
import 'package:crm_app/Views/listings/ListingViewingPage.dart';
import 'package:crm_app/Views/listings/ListingsDetailsPage.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:flutter/material.dart';

class ListingDetailsLandingPage extends StatelessWidget {

  final String title;
  final int id;
  final int selectedIndex;

  ListingDetailsLandingPage({this.title, this.id,this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: selectedIndex,
      child: Scaffold(
        backgroundColor: Color(0xFFE7E7E7),
        appBar: AppBar(
          backgroundColor: GlobalColors.globalColor(),
          elevation: 10,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 27,),
          ),
          title: Text(
            'Listing Details | $title',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              color: Colors.white,
            ),
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
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: [
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                    'Listing',
                    style: AppTextStyles.c16white600()
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                    'Notes',
                    style: AppTextStyles.c16white600()
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                    'Viewings',
                    style: AppTextStyles.c16white600()
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                    'Status',
                    style: AppTextStyles.c16white600()
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListingDetailsTabPage(id: id,),
            ListingNotes(id: id,),
            ListingViewingPage(id: id,title: title,),
           ListingStatus(id: id,)
          ],
        ),
      ),
    );
  }
}
