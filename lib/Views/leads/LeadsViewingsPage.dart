import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/controllers/leadsController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/ViewingStatusColors.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';

import 'LeadsAddViewingPage.dart';

class LeadsViewingsPage extends StatelessWidget {

  final int id;
  LeadsViewingsPage({this.id});

  Future<List<dynamic>> getLeads(){
    LeadsDetails lc = LeadsDetails();
    return lc.getLeadsDetails(id);
  }

  DateTimeConversion dateTimeConv = DateTimeConversion();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getLeads(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data[0]['viewings'].length == 0){
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'No Viewings found',
                        style: AppTextStyles.c14grey400(),
                      ),
                    ),
                    OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor()),
                          foregroundColor: MaterialStateProperty.all(GlobalColors.globalColor())
                      ),
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LeadsAddViewingPage(id: id,)));
                      },
                      child: Text(
                        '+ Schedule Viewing',
                        style: AppTextStyles.c16white600(),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    for(int i = 0; i < snapshot.data[0]['viewings'].length;i++)
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    foregroundColor: Colors.blue,
                                    foregroundImage: (snapshot.data[0]['viewings'][i]['user']['profile_picture_url'] != null && snapshot.data[0]['viewings'][i]['user']['profile_picture_url'] != '')?NetworkImage('${snapshot.data[0]['viewings'][i]['user']['profile_picture_url']}'):NetworkImage('https://ui-avatars.com/api/?background=EEEEEE&color=3F729B&name=${snapshot.data[0]['viewings'][i]['user']['full_name']}&size=128&font-size=0.33'),
                                    radius: 25,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${snapshot.data[0]['viewings'][i]['user']['full_name']}',
                                        style: AppTextStyles.c18black500(),
                                      ),
                                      /*SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                      ),*/
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Text(
                                          '${dateTimeConv.getDDMMMYYY(snapshot.data[0]['viewings'][i]['datetime'])}',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    '${snapshot.data[0]['viewings'][i]['status']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Cairo',
                                      color: viewingStatusColors(snapshot.data[0]['viewings'][i]['status']),
                                      fontWeight: FontWeight.w600
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      Text(
                                        'Listing: ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Cairo',
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        '${snapshot.data[0]['viewings'][i]['listing']['reference']}',
                                        style: AppTextStyles.c12grey400(),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Added by: ',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Cairo',
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        '${snapshot.data[0]['viewings'][i]['agent']['full_name']}',
                                        style: AppTextStyles.c12grey400(),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor()),
                          foregroundColor: MaterialStateProperty.all(GlobalColors.globalColor())
                      ),
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LeadsAddViewingPage(id: id,)));
                      },
                      child: Text(
                        '+ Schedule Viewing',
                        style: AppTextStyles.c16white600(),
                      ),
                    )
                  ],
                ),
              );
            }
          } else {
            return Center(child: AnimatedSearch(),);
          }
        },
      ),
    );
  }
}
