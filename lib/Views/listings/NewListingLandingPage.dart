import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/controllers/listingCountController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:get_storage/get_storage.dart';

import 'ListingFilterPage.dart';
import 'NewListingCommonPage.dart';

class NewListingLandingPage extends StatefulWidget {
  String q;
  List filter;
  int portalId;
  NewListingLandingPage({this.q,this.filter, this.portalId});

  @override
  _NewListingLandingPageState createState() => _NewListingLandingPageState();
}

class _NewListingLandingPageState extends State<NewListingLandingPage> {

  final keywordController = TextEditingController();

  @override
  void dispose() {
    keywordController.dispose();
    super.dispose();
  }

  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

  Future<int> getListingsNum(String type) async{
    ListingCountController lcc =ListingCountController();
    int x = await lcc.getCount(type, widget.q, widget.filter, widget.portalId);
    return x;
  }
  Future<int> getListingsNum1(String type) async{
    ListingCountController lcc =ListingCountController();
    int x = await lcc.getCount(type, widget.q, widget.filter, widget.portalId);
    return x;
  }

  @override
  Widget build(BuildContext context) {
    if(widget.q != null){
      keywordController.text = widget.q;
    }
    final box = GetStorage();
    List permissions = box.read('permissions');
    int roleId = box.read('role_id');
    int tabCount = 1;
    if(roleId != 3 || permissions.contains('listings_view_other'))
      tabCount += 1;

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
                'LISTINGS',
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ListingFilterPage(q: widget.q,)));
                  },
                  child: Icon(Icons.filter_list,size: 27, color: Colors.white,),
                ),
              ),
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
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(vertical: 0.2, horizontal: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: TextField(
                  controller: keywordController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: Colors.black.withAlpha(120),
                    ),
                    border: InputBorder.none,
                    suffixIcon: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => NewListingLandingPage(q: keywordController.text,)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.black.withAlpha(120),
                        ),
                      ),
                    ),
                  ),
                  onSubmitted: (value){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewListingLandingPage(q: keywordController.text,)));
                  },
                ),
              ),
              DefaultTabController(
                length: tabCount,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        indicatorColor: GlobalColors.globalColor(),

                        tabs: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              children: [
                                Text(
                                  'My Listings',
                                  style: AppTextStyles.c16Global500(),
                                ),
                                FutureBuilder(
                                  future: getListingsNum('My Listings'),
                                  builder: (BuildContext context, AsyncSnapshot snapshot){
                                    if(snapshot.hasData){
                                      return Text(
                                        ' ${snapshot.data}',
                                        style: AppTextStyles.c14Global500(),
                                      );
                                    } else {
                                      return AnimatedSearch();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          if(permissions.contains('listings_view_other'))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Company Listings',
                                    style: AppTextStyles.c16Global500(),
                                  ),
                                  FutureBuilder(
                                    future: getListingsNum1('All Listings'),
                                    builder: (BuildContext context, AsyncSnapshot snapshot){
                                      if(snapshot.hasData){
                                        return Text(
                                          ' ${snapshot.data}',
                                          style: AppTextStyles.c14Global500(),
                                        );
                                      } else {
                                        return AnimatedSearch();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.01),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.78,
                        child: TabBarView(
                          children: [
                            NewListingsCommonListingPage(type: 'My Listings', query: widget.q, filter: widget.filter, portalId: widget.portalId,),
                            if(permissions.contains('listings_view_other'))
                              NewListingsCommonListingPage(type: 'All Listings', query: widget.q, filter: widget.filter, portalId: widget.portalId,),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }



}
