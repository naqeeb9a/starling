import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/leads/LeadsDetailsCommonPage.dart';
import 'package:crm_app/Views/leads/LeadsViewingsPage.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:flutter/material.dart';

import 'LeadsContactsPage.dart';
import 'LeadsNotesPage.dart';

class LeadsDetailsDashboard extends StatelessWidget {

  String title;
  final int id;
  LeadsDetailsDashboard({this.id,this.title});

  @override
  Widget build(BuildContext context) {
    bool isTitle = false;
    if(title != null && title != ''){
      isTitle = true;
    }
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: GlobalColors.globalColor(),
          elevation: 10,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 27,),
          ),
          title: isTitle?Text(
            'Leads Details | $title',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              color: Colors.white,
            ),
          ):Text(
            'Leads Details',
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
                    'Lead',
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
                    'Contacts',
                    style: AppTextStyles.c16white600()
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Text(
                    'Viewings',
                    style: AppTextStyles.c16white600()
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LeadsDetailsPage(id: id,isTitle: isTitle,),
            LeadsNotesPage(id: id,),
            LeadsContactsPage(id: id,),
            LeadsViewingsPage(id: id,)
          ],
        ),
      ),
    );
  }
}
