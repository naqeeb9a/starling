import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/controllers/listingController.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/ListingStatusColors.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';

class NewListingStatusPage extends StatelessWidget {
  final int id;
  NewListingStatusPage({this.id});
  DateTimeConversion dateTimeConv = DateTimeConversion();

  Future<List<dynamic>> getStatusList() async {

    ListingController lc =ListingController();
    //print(status);
    return lc.getStatusList(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: getStatusList(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          print(snapshot.data);
          if(snapshot.hasData){
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for(int i = 0; i < snapshot.data[0].length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${snapshot.data[0][i]['status']}',
                                    style: TextStyle(
                                        color: listingStatusColor(snapshot.data[0][i]['status']),
                                        fontFamily: 'Roboto',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  Text(
                                    '${dateTimeConv.getDDMMMYYY(snapshot.data[0][i]['created_at'])}',
                                    style: AppTextStyles.c14grey400(),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                              child: Text(
                                'By: ${snapshot.data[0][i]['user']['full_name']}',
                                style: AppTextStyles.c12grey400(),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                ],
              ),
            );
          } else {
            return Center(
              child: AnimatedSearch(),
            );
          }
        },
      ),
    );
  }
}
