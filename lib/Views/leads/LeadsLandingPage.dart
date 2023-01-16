import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/leads/LeadsCommonPage.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/appbars/CommonAppBars.dart';
import 'package:flutter/material.dart';

class LeadsLandingPage extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Leads',
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
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Active',
                  style: AppTextStyles.c16white600(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  'Closed',
                  style: AppTextStyles.c16white600(),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LeadsCommonPage(type: 'Active',),
            LeadsCommonPage(type: 'Closed',)
          ],
        ),
      ),
    );
  }
}
