import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/leads/NewLeadNotesPage.dart';
import 'package:crm_app/Views/leads/NewLeadTaskPage.dart';
import 'package:crm_app/Views/leads/NewLeadViewingPage.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:flutter/material.dart';

import 'NewLeadDetailPage.dart';

class NewLeadsDetailLandingPage extends StatelessWidget {
  final int id;
  NewLeadsDetailLandingPage({this.id});

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
                'Lead Details',
                style: AppTextStyles.c20white500(),
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
          ),
          body: DefaultTabController(
            length: 4,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(left:8.0,right:8,top: 8),
                    child: TabBar(
                      indicatorColor: GlobalColors.globalColor(),
                      tabs: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                              'Lead Info',
                              style: AppTextStyles.c16Global500(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'Notes',
                            style: AppTextStyles.c16Global500(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'Viewings',
                            style: AppTextStyles.c16Global500(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            'Tasks',
                            style: AppTextStyles.c16Global500(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      NewLeadDetailPage(id: id,),
                      NewLeadNotesPage(id: id,),
                      NewLeadViewingPage(id: id,),
                      NewLeadTaskPage(id: id,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
