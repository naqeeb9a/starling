import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/Views/Viewings/ViewingCard.dart';
import 'package:crm_app/controllers/leadsController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/ViewingStatusColors.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:crm_app/widgets/loaders/CircularLoader.dart';
import 'package:flutter/material.dart';

import 'LeadsAddViewingPage.dart';

class NewLeadViewingPage extends StatefulWidget {
  final int id;
  NewLeadViewingPage({this.id});

  @override
  _NewLeadViewingPageState createState() => _NewLeadViewingPageState();
}

class _NewLeadViewingPageState extends State<NewLeadViewingPage> {

  Future<List<dynamic>> getLeads(){
    LeadsDetails lc = LeadsDetails();
    return lc.getLeadViewings(widget.id);
  }

  DateTimeConversion dateTimeConv = DateTimeConversion();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getLeads(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              if(snapshot.data.isNotEmpty){
                return Column(
                  children: [
                    for(int i = 0; i < snapshot.data.length; i++)
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: ViewingCard(
                              id: snapshot.data[i]['id'],
                              agentFullName: snapshot.data[i]['agent']['full_name'],
                              userFullName: snapshot.data[i]['user']['full_name'],
                              datetime: snapshot.data[i]['datetime'],
                              leadRef: snapshot.data[i]['lead']['reference'],
                              listingRef: snapshot.data[i]['listing']['reference'],
                              status: snapshot.data[i]['status'],
                            ),
                          ),
                        ],
                      )
                  ],
                );
              } else {
                return Center(
                  child: Text(
                    'No viewings found',
                    style: AppTextStyles.c14grey400(),
                  ),
                );
              }

            } else {
              return Center(
                child: AnimatedSearch(),
              );
            }
          }
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LeadsAddViewingPage(id: widget.id,)));
            },

            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: GlobalColors.globalColor()
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 27,
                        ),
                        Text(
                          ' Add Viewing',
                          style: AppTextStyles.c16white600(),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
