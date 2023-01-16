import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/Views/Viewings/ViewingCard.dart';
import 'package:crm_app/controllers/listingController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:flutter/material.dart';

import 'ListingAddViewing.dart';

class NewListingViewingsPage extends StatefulWidget {
  final int id;
  NewListingViewingsPage({this.id});

  @override
  _NewListingViewingsPageState createState() => _NewListingViewingsPageState();
}

class _NewListingViewingsPageState extends State<NewListingViewingsPage> {

  DateTimeConversion dateTimeConv = DateTimeConversion();

  Future<List> getListingViewing() {
    ListingController lc = ListingController();
    return lc.getListingViewings(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: getListingViewing(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            print(snapshot.data);
            if(snapshot.data.isEmpty){
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(45.0),
                  child: Text(
                    'No Viewings available',
                    style: AppTextStyles.c16black500(),
                  ),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    for(int i = 0; i < snapshot.data.length; i++)
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: ViewingCard(
                              id: snapshot.data[i]['id'],
                              leadRef: snapshot.data[i]['lead']!=null?snapshot.data[i]['lead']['reference']: '',
                              listingRef: snapshot.data[i]['listing']!=null?snapshot.data[i]['listing']['reference']: '',
                              agentFullName: snapshot.data[i]['agent']['full_name'],
                              userFullName: snapshot.data[i]['user']['full_name'],
                              status: snapshot.data[i]['status'],
                              datetime: snapshot.data[i]['datetime'],
                            ),
                          ),
                          SizedBox(
                            height: 7,
                          )
                        ],
                      )
                  ],
                ),
              );
            }
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(45.0),
                child: Text(
                  'No Viewings available',
                  style: AppTextStyles.c16black500(),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ListingAddViewing(id: widget.id,)));
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
