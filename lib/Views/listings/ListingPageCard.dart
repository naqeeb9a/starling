import 'package:crm_app/CodeSnippets/CurrencyCheck.dart';
import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/Views/listings/ListingsDetailsPage.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/ListingStatusColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'ListingDetailsLandingPage.dart';

class ListingCard extends StatelessWidget {


  DateTimeConversion dateTimeConv = DateTimeConversion();
  final int id;
  String reference;
  double price;
  String listingStatus;
  String agentFullName;
  // String location;
  // String subLocation;
  String propertyLocation;
  String title;
  String image_path;
  String property_for;
  String updated_at;
  String property_type;
  String portalStatus = 'Unpublished';
  List<dynamic> portals = [];

  ListingCard({Key key, this.id, this.reference,this.price,this.listingStatus,this.agentFullName,this.propertyLocation,this.title,this.image_path,this.property_for,this.updated_at,this.property_type,this.portals,this.portalStatus}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    List<Widget> portalIcons = [];
    if(portals != null && portals != []){
      for(int i = 0; i < portals.length;i++){
        if(portals[i]['name'] == 'Dubizzle'){
          portalIcons.add(Image.asset('assets/images/icons/dubizzle-icon.ico',scale: 3,));
        }
        if(portals[i]['name'] == 'PropertyFinder'){
          portalIcons.add(Image.asset('assets/images/icons/pf-icon.png',scale: 2,));
        }
        if(portals[i]['name'] == 'Bayut'){
          portalIcons.add(Image.asset('assets/images/icons/bayut-icon.png',scale: 2,));
        }
      }
    }

    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ListingDetailsLandingPage(id: id, title: reference,selectedIndex: 0,)));
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              child: Row(
                children: [
                  //Details Widget
                  Expanded(
                    flex: 10,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          shape: BoxShape.rectangle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12, 0, 0, 6),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    '$reference',
                                    style: AppTextStyles.c16black600(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.circle,color: listingStatusColor(listingStatus),size: 10,),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        listingStatus != null?listingStatus: '',
                                        style: TextStyle(
                                          color: listingStatusColor(listingStatus),
                                          fontSize: 12,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                if(portalStatus != 'Unpublished')
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      for(int i = 0; i < portalIcons.length; i++)
                                        Row(
                                          children: [
                                            portalIcons[i],
                                            SizedBox(
                                              width: 4,
                                            )
                                          ],
                                        )
                                    ],
                                  )
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.35,
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            image_path != null?Image.network(image_path,scale: 1,): Image.asset('assets/images/placeholder.png'),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: RawChip(
                                                side: BorderSide(
                                                  color: property_for == 'Rental'?Color(0xFF8702BA):Color(0xFF4062A4),
                                                ),
                                                label: Text(
                                                    property_for != null? property_for: ''
                                                ),
                                                labelStyle:TextStyle(
                                                  color: property_for == 'Rental'?Color(0xFF8702BA):Color(0xFF4062A4),
                                                  fontSize: 12,
                                                  fontFamily: 'Cairo',
                                                  fontWeight: FontWeight.w500
                                                ),
                                                backgroundColor: Colors.white54,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.35,
                                          height: MediaQuery.of(context).size.height * 0.04,
                                          color: GlobalColors.globalColor(),
                                          child: Center(
                                            child: Text(
                                              'AED ${FormatCurrency().CurrencyCheck(price)}',
                                              style: AppTextStyles.c12white400(),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        child: Text(
                                          title != null? title: '',
                                          style: AppTextStyles.c16black600(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        child: Text(
                                          '$property_type property for $property_for',
                                          style: AppTextStyles.c12grey400(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        child: Text(
                                          'Location: $propertyLocation',
                                          style: AppTextStyles.c12grey400(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                'Agent: $agentFullName',
                                                style: AppTextStyles.c12grey400(),
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                'Date: ${dateTimeConv.getDDMMMYYY(updated_at)}',
                                                style: AppTextStyles.c12grey400(),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*Stack(
children: [
Align(
alignment: Alignment.centerLeft,
child: Padding(
padding: const EdgeInsets.only(right: 8.0),
child: Column(
children: [
Padding(
padding: const EdgeInsets.only(left: 5.0),
child: Text(
reference,
style: AppTextStyles.c16black500(),
),
),
Container(
width: MediaQuery.of(context).size.width * 0.25,
child: image_path != null?Image.network(image_path): Image.asset('assets/images/logo.png'),
),
Container(
width: MediaQuery.of(context).size.width * 0.25,
height: MediaQuery.of(context).size.height * 0.04,
color: Color(0xFF104A9C),
child: Center(
child: Text(
'AED ${FormatCurrency().CurrencyCheck(price)}',
style: AppTextStyles.c12white400(),
),
),
)
],
),
),
),
Align(
alignment: Alignment.topRight,
child: Padding(
padding: const EdgeInsets.only(right: 8.0),
child: RawChip(
label: Text(
property_for
),
labelStyle: AppTextStyles.c12white400(),
backgroundColor: property_for == 'Rental'?Color(0xFF8702BA):Color(0xFF4062A4),
),
),
),
],
)*/
