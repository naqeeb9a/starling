import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/listings/NewListingDetailPage.dart';
import 'package:crm_app/Views/listings/NewListingStatusPage.dart';
import 'package:crm_app/Views/listings/NewListingViewingPage.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:flutter/material.dart';

import 'NewListingNotesPage.dart';

class NewListingsDetailsLandingPage extends StatelessWidget {

  final int id;
  final int selectedIndex;
  NewListingsDetailsLandingPage({this.id,this.selectedIndex});

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
                      'LISTING DETAILS',
                      style: TextStyle(
                        fontFamily: 'Montserrat-Regular',
                        fontSize: 20,
                        color: Colors.white,
                      ),
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
                    ),
                  ],
                ),
                body: DefaultTabController(
                  length: 4,
                  initialIndex: selectedIndex,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(left:8.0,right:8,top: 8),
                          child: TabBar(
                            isScrollable: true,
                            indicatorColor: GlobalColors.globalColor(),
                            tabs: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  'Listing',
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
                                  'History',
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
                            NewListingDetailPage(id: id,),
                            NewListingNotesPage(id: id),
                            NewListingViewingsPage(id: id,),
                            NewListingStatusPage(id: id,)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}

/*
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
                'LISTING DETAILS',
                style: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontSize: 20,
                  color: Colors.white,
                ),
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
              ),
            ],
          ),
          body: DefaultTabController(
            length: 4,
            initialIndex: widget.selectedIndex,
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
                            'Listing',
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
                            'History',
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
                // Expanded(
                //   child: TabBarView(
                //     children: [
                //
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
 */
