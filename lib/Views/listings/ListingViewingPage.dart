import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/Views/Viewings/ViewingCard.dart';
import 'package:crm_app/Views/listings/ListingAddViewing.dart';
import 'package:crm_app/controllers/listingController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListingViewingPage extends StatelessWidget {

  final int id;
  final String title;
  ListingViewingPage({this.id,this.title});
  DateTimeConversion dateTimeConv = DateTimeConversion();

  Future<List> getListingViewing() {
    ListingController lc = ListingController();
    return lc.getListingViewings(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getListingViewing(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            print(snapshot.data);
            if(snapshot.data.isEmpty){
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(45.0),
                  child: Column(
                    children: [
                      Text(
                        'No Viewings available',
                        style: AppTextStyles.c16black500(),
                      ),
                      OutlinedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor()),
                        ),
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListingAddViewing(id: id,)));
                        },
                        child: Text(
                          '+ Schedule Viewing',
                          style: AppTextStyles.c16white600(),
                        ),
                      )
                    ],
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
                          Divider(
                            height: 0.2,
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    OutlinedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor()),
                          foregroundColor: MaterialStateProperty.all(GlobalColors.globalColor())
                      ),
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListingAddViewing(id: id,)));
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
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(45.0),
                child: Column(
                  children: [
                    Text(
                      'No Viewings available',
                      style: AppTextStyles.c16black500(),
                    ),
                    OutlinedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor()),
                      ),
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListingAddViewing(id: id,)));
                      },
                      child: Text(
                        '+ Schedule Viewing',
                        style: AppTextStyles.c16white600(),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
