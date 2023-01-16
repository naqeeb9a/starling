import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/leads/LeadsFilterPage.dart';
import 'package:crm_app/Views/leads/NewLeadsCommonPage.dart';
import 'package:crm_app/controllers/campaignController.dart';
import 'package:crm_app/controllers/leadCountController.dart';
import 'package:crm_app/controllers/tasksController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:crm_app/widgets/loaders/CircularLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paginator/flutter_paginator.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'AddNewLeadPage.dart';

class NewLeadsListingPage extends StatefulWidget {

  int campaignId;
  String q;
  List<String> filter;
  int agentId;
  NewLeadsListingPage({this.campaignId,this.q, this.filter, this.agentId});

  @override
  _NewLeadsListingPageState createState() => _NewLeadsListingPageState();
}

class _NewLeadsListingPageState extends State<NewLeadsListingPage> {

  final keywordController = TextEditingController();

  @override
  void dispose() {
    keywordController.dispose();
    super.dispose();
  }

  GlobalKey<PaginatorState> paginatorGlobalKey = GlobalKey();

  Future<List> getCampaigns() async {
    CampaignController cc = CampaignController();
    return cc.getCampaigns();
  }

  Future<List> getAgentCampaigns() async {
    CampaignController cc = CampaignController();
    return cc.getAgentCampaigns(widget.agentId);
  }

  Future<int> getLeadsCount(String type) async {
    LeadCountController lcc = LeadCountController();
    return lcc.getLeadsCount(type, widget.campaignId, widget.q, widget.filter, widget.agentId);
  }

  @override
  Widget build(BuildContext context) {
    if(widget.q != null){
      keywordController.text = widget.q;
    }
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
                'LEADS',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LeadsFilterPage(q: widget.q,)));
                  },
                  child: Icon(Icons.filter_list, color: Colors.white,size: 27,),
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
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: Colors.black.withAlpha(120),
                    ),
                    border: InputBorder.none,
                    suffixIcon: InkWell(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewLeadsListingPage(q: keywordController.text,)));
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
                ),
              ),
              DefaultTabController(
                length: 12,
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                      child: Row(
                        children: [
                          /*GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                context: context,
                                builder: (context){
                                  return Container(
                                    color: Colors.white,
                                    height: MediaQuery.of(context).size.height * 0.6,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Campaigns',
                                            style: AppTextStyles.c20grey500(),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        FutureBuilder(
                                          future: widget.agentId!=null?getAgentCampaigns():getCampaigns(),
                                          builder: (BuildContext context, AsyncSnapshot snapshot){
                                            if(snapshot.hasData){
                                              print(snapshot.data[0]);
                                              return Expanded(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      for(int i = 0; i < snapshot.data.length;i++)
                                                        InkWell(
                                                          onTap: (){
                                                            Navigator.pop(context);
                                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewLeadsListingPage(campaignId: snapshot.data[i]['id'],)));
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets.only(left: 5),
                                                                    child: Text(
                                                                      '${snapshot.data[i]['title']}',
                                                                      style: AppTextStyles.c16grey500(),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsets.only(right: 5),
                                                                    child: Text(
                                                                      '${snapshot.data[i]['leads_count']}',
                                                                      style: AppTextStyles.c16grey500(),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              Divider(
                                                                thickness: 0.6,
                                                                color: Colors.grey,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      SizedBox(
                                                        height: 30,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            } else {
                                              return Center(
                                                child: NetworkLoading(),
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: GlobalColors.globalColor()
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.campaign,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),*/
                          Expanded(
                            child: TabBar(
                              isScrollable: true,
                              indicatorColor: GlobalColors.globalColor(),
                              tabs: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'All ',
                                        style: AppTextStyles.c16Global500(),
                                      ),
                                      FutureBuilder(
                                        future: getLeadsCount('All'),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            return Text(
                                              '${snapshot.data}',
                                              style: AppTextStyles.c14Global500(),
                                            );
                                          } else {
                                            return AnimatedSearch();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Not Yet Contacted ',
                                        style: AppTextStyles.c16Global500(),
                                      ),
                                      FutureBuilder(
                                        future: getLeadsCount('Not Yet Contacted'),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            return Text(
                                              '${snapshot.data}',
                                              style: AppTextStyles.c14Global500(),
                                            );
                                          } else {
                                            return AnimatedSearch();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'In Progress ',
                                        style: AppTextStyles.c16Global500(),
                                      ),
                                      FutureBuilder(
                                        future: getLeadsCount('In Progress'),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            return Text(
                                              '${snapshot.data}',
                                              style: AppTextStyles.c14Global500(),
                                            );
                                          } else {
                                            return AnimatedSearch();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Offer Made ',
                                        style: AppTextStyles.c16Global500(),
                                      ),
                                      FutureBuilder(
                                        future: getLeadsCount('Offer Made'),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            return Text(
                                              '${snapshot.data}',
                                              style: AppTextStyles.c14Global500(),
                                            );
                                          } else {
                                            return AnimatedSearch();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Prospect ',
                                        style: AppTextStyles.c16Global500(),
                                      ),
                                      FutureBuilder(
                                        future: getLeadsCount('Prospect'),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            return Text(
                                              '${snapshot.data}',
                                              style: AppTextStyles.c14Global500(),
                                            );
                                          } else {
                                            return AnimatedSearch();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Viewing ',
                                        style: AppTextStyles.c16Global500(),
                                      ),
                                      FutureBuilder(
                                        future: getLeadsCount('Viewing'),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            return Text(
                                              '${snapshot.data}',
                                              style: AppTextStyles.c14Global500(),
                                            );
                                          } else {
                                            return AnimatedSearch();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Called No Reply ',
                                        style: AppTextStyles.c16Global500(),
                                      ),
                                      FutureBuilder(
                                        future: getLeadsCount('Called No Reply'),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            return Text(
                                              '${snapshot.data}',
                                              style: AppTextStyles.c14Global500(),
                                            );
                                          } else {
                                            return AnimatedSearch();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Successful ',
                                        style: AppTextStyles.c16Global500(),
                                      ),
                                      FutureBuilder(
                                        future: getLeadsCount('Successful'),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            return Text(
                                              '${snapshot.data}',
                                              style: AppTextStyles.c14Global500(),
                                            );
                                          } else {
                                            return AnimatedSearch();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Unsuccessful ',
                                        style: AppTextStyles.c16Global500(),
                                      ),
                                      FutureBuilder(
                                        future: getLeadsCount('Unsuccessful'),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            return Text(
                                              '${snapshot.data}',
                                              style: AppTextStyles.c14Global500(),
                                            );
                                          } else {
                                            return AnimatedSearch();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Invalid Inquiry ',
                                        style: AppTextStyles.c16Global500(),
                                      ),
                                      FutureBuilder(
                                        future: getLeadsCount('Invalid Inquiry'),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            return Text(
                                              '${snapshot.data}',
                                              style: AppTextStyles.c14Global500(),
                                            );
                                          } else {
                                            return AnimatedSearch();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Invalid Number ',
                                        style: AppTextStyles.c16Global500(),
                                      ),
                                      FutureBuilder(
                                        future: getLeadsCount('Invalid Number'),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            return Text(
                                              '${snapshot.data}',
                                              style: AppTextStyles.c14Global500(),
                                            );
                                          } else {
                                            return AnimatedSearch();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Not Interested ',
                                        style: AppTextStyles.c16Global500(),
                                      ),
                                      FutureBuilder(
                                        future: getLeadsCount('Not Interested'),
                                        builder: (BuildContext context, AsyncSnapshot snapshot){
                                          if(snapshot.hasData){
                                            return Text(
                                              '${snapshot.data}',
                                              style: AppTextStyles.c14Global500(),
                                            );
                                          } else {
                                            return AnimatedSearch();
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),



                              ],
                            ),
                          ),
                          if(widget.campaignId != null)
                            GestureDetector(
                              onTap: (){
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NewLeadsListingPage()));
                              },
                              child: Icon(
                                Icons.clear,
                                size: 24,
                                color: Colors.grey,
                              ),
                            )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.78,
                        child: widget.q == null?TabBarView(
                          children: [
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'All', campaignId: widget.campaignId,filter: widget.filter,):NewLeadsCommonPage(type: 'All',filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Not Yet Contacted', campaignId: widget.campaignId,filter: widget.filter,):NewLeadsCommonPage(type: 'Not Yet Contacted',filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'In Progress', campaignId: widget.campaignId,filter: widget.filter,):NewLeadsCommonPage(type: 'In Progress',filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Offer Made', campaignId: widget.campaignId,filter: widget.filter,):NewLeadsCommonPage(type: 'Offer Made',filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Prospect', campaignId: widget.campaignId,filter: widget.filter,):NewLeadsCommonPage(type: 'Prospect',filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Viewing', campaignId: widget.campaignId,filter: widget.filter,):NewLeadsCommonPage(type: 'Viewing',filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Called No Reply', campaignId: widget.campaignId,filter: widget.filter,):NewLeadsCommonPage(type: 'Called No Reply',filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Successful', campaignId: widget.campaignId,filter: widget.filter,):NewLeadsCommonPage(type: 'Successful',filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Unsuccessful', campaignId: widget.campaignId,filter: widget.filter,):NewLeadsCommonPage(type: 'Unsuccessful',filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Invalid Inquiry', campaignId: widget.campaignId,filter: widget.filter,):NewLeadsCommonPage(type: 'Invalid Inquiry',filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Invalid Number', campaignId: widget.campaignId,filter: widget.filter,):NewLeadsCommonPage(type: 'Invalid Number',filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Not Interested', campaignId: widget.campaignId,filter: widget.filter,):NewLeadsCommonPage(type: 'Not Interested',filter: widget.filter,),

                          ],
                        ):TabBarView(
                          children: [
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'All', campaignId: widget.campaignId,query: widget.q,filter: widget.filter,):NewLeadsCommonPage(type: 'All',query: widget.q,filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Not Yet Contacted', campaignId: widget.campaignId,query: widget.q,filter: widget.filter,):NewLeadsCommonPage(type: 'Not Yet Contacted',query: widget.q,filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'In Progress', campaignId: widget.campaignId,query: widget.q,filter: widget.filter,):NewLeadsCommonPage(type: 'In Progress',query: widget.q,filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Offer Made', campaignId: widget.campaignId,query: widget.q,filter: widget.filter,):NewLeadsCommonPage(type: 'Offer Made',query: widget.q,filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Prospect', campaignId: widget.campaignId,query: widget.q,filter: widget.filter,):NewLeadsCommonPage(type: 'Prospect',query: widget.q,filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Viewing', campaignId: widget.campaignId,query: widget.q,filter: widget.filter,):NewLeadsCommonPage(type: 'Viewing',query: widget.q,filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Called No Reply', campaignId: widget.campaignId,query: widget.q,filter: widget.filter,):NewLeadsCommonPage(type: 'Called No Reply',query: widget.q,filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Successful', campaignId: widget.campaignId,query: widget.q,filter: widget.filter,):NewLeadsCommonPage(type: 'Successful',query: widget.q,filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Unsuccessful', campaignId: widget.campaignId,query: widget.q,filter: widget.filter,):NewLeadsCommonPage(type: 'Unsuccessful',query: widget.q,filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Invalid Inquiry', campaignId: widget.campaignId,query: widget.q,filter: widget.filter,):NewLeadsCommonPage(type: 'Invalid Inquiry',query: widget.q,filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Invalid Number', campaignId: widget.campaignId,query: widget.q,filter: widget.filter,):NewLeadsCommonPage(type: 'Invalid Number',query: widget.q,filter: widget.filter,),
                            widget.campaignId!=null?NewLeadsCommonPage(type: 'Not Interested', campaignId: widget.campaignId,query: widget.q,filter: widget.filter,):NewLeadsCommonPage(type: 'Not Interested',query: widget.q,filter: widget.filter,),

                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewLead(widget.campaignId, widget.q, widget.filter)));
            },
            child: Center(
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
            backgroundColor: GlobalColors.globalColor(),
          ),
        ),
      ],
    );
  }
}
