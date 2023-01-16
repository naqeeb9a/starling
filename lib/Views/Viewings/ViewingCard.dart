import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/Views/Viewings/ViewingsDetailsPage.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/ViewingStatusColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../globals/globalColors.dart';

class ViewingCard extends StatelessWidget {

  final int id;
  String agentFullName;
  String userFullName;
  String status;
  String leadRef;
  String listingRef;
  String datetime;

  ViewingCard({this.id,this.agentFullName,this.userFullName,this.status,this.leadRef,this.listingRef,this.datetime});

  DateTimeConversion dateTimeConversion = DateTimeConversion();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewingsDetailsPage(id: id,)));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            /*Text(
                                '${snapshot.data[i]}'
                              ),*/
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'Scheduled By: ',
                        style: AppTextStyles.c12grey400(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.orange
                        ),
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 3),
                            child: Text(
                              '$userFullName',
                              style: AppTextStyles.c12white400(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 14,
                        color: viewingStatusColors(status),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        '$status',
                        style: AppTextStyles.c12grey400(),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Color(0xFFF2F2F2)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0,top: 8,bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_circle_rounded,
                            size: 30,
                            color: Color(0xFFCCCCCC),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '$agentFullName',
                            style: AppTextStyles.c16black500(),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0,top: 8,bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 15,
                            color: Color(0xFFCCCCCC),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '${DateTimeConversion().getDDMMMYYYandTIME(datetime)}',
                            style: AppTextStyles.c12grey400(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Lead: ',
                        style: AppTextStyles.c12grey400(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: GlobalColors.globalColor()
                        ),
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 3),
                            child: Text(
                              '$leadRef',
                              style: AppTextStyles.c12white400(),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Listing: ',
                        style: AppTextStyles.c12grey400(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: GlobalColors.globalColor()
                        ),
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 3),
                            child: Text(
                              '$listingRef',
                              style: AppTextStyles.c12white400(),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
