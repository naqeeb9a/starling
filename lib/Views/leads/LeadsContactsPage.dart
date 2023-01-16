import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/controllers/leadsController.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';


class LeadsContactsPage extends StatelessWidget {
  final int id;
  LeadsContactsPage({this.id});

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
            if(snapshot.data[0]['contact_history'].length == 0){
              return Center(
                child: Text(
                  'No Contacts found',
                  style: AppTextStyles.c14grey400(),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    for(int i = 0; i < snapshot.data[0]['contact_history'].length; i++)
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
                                    foregroundImage: (snapshot.data[0]['contact_history'][i]['user']['profile_picture_url'] != null && snapshot.data[0]['contact_history'][i]['user']['profile_picture_url'] != '')?NetworkImage('${snapshot.data[0]['contact_history'][i]['user']['profile_picture_url']}'):NetworkImage('https://ui-avatars.com/api/?background=EEEEEE&color=3F729B&name=${snapshot.data[0]['contact_history'][i]['user']['full_name']}&size=128&font-size=0.33'),
                                    radius: 25,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${snapshot.data[0]['contact_history'][i]['user']['full_name']}',
                                      style: AppTextStyles.c18black500(),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                    ),
                                    Text(
                                      '${dateTimeConv.getDDMMMYYY(snapshot.data[0]['contact_history'][i]['updated_at'])}',
                                      style: AppTextStyles.c14grey400(),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${snapshot.data[0]['contact_history'][i]['phone']}',
                                  style: AppTextStyles.c14grey400(),
                                ),
                                Text(
                                  '${snapshot.data[0]['contact_history'][i]['email']}',
                                  style: AppTextStyles.c14grey400(),
                                ),
                                Text(
                                  '${snapshot.data[0]['contact_history'][i]['type']}',
                                  style: AppTextStyles.c14grey400(),
                                ),
                                Text(
                                  snapshot.data[0]['contact_history'][i]['notes']!=null?'${snapshot.data[0]['contact_history'][i]['notes']}': '',
                                  style: AppTextStyles.c14grey400(),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                  ],
                ),
              );
            }
            return null;
          } else {
            return Center(child: AnimatedSearch(),);
          }
        },
      ),
    );
  }
}
