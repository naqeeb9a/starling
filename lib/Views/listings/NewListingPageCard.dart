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
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';

import 'ListingDetailsLandingPage.dart';
import 'NewListingsDetailsLandingPage.dart';

class NewListingCard extends StatelessWidget {


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
  String description;
  String image_path;
  String property_for;
  String updated_at;
  String property_type;
  String portalStatus = 'Unpublished';
  String bua;
  String beds,baths;
  List<dynamic> portals = [];

  NewListingCard({Key key, this.id, this.reference,this.price,this.listingStatus,this.agentFullName,this.propertyLocation,this.title,this.image_path,this.property_for,this.updated_at,this.property_type,this.portals,this.portalStatus, this.description, this.bua,this.beds,this.baths}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    print(image_path);

    List<Widget> portalIcons = [];
    if(portals != null && portals != []){
      for(int i = 0; i < portals.length;i++){
        if(portals[i]['name'] == 'Dubizzle'){
          portalIcons.add(Image.asset('assets/images/DZicon.png',scale: 3,));
        }
        if(portals[i]['name'] == 'PropertyFinder'){
          portalIcons.add(Image.asset('assets/images/PFicon.png',scale: 3,));
        }
        if(portals[i]['name'] == 'Bayut'){
          portalIcons.add(Image.asset('assets/images/BYicon.png',scale: 3,));
        }
        if(portals[i]['name'] == 'Generic'){
          portalIcons.add(Image.asset('assets/images/GEicon.png',scale: 3,));
        }
      }
    }

    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NewListingsDetailsLandingPage(id: id, selectedIndex: 0,)));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xFFB3B3B3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 8),
                      child: Text(
                        '$reference',
                        style: AppTextStyles.c12white400(),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                        style: AppTextStyles.c12grey400(),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8,bottom: 4),
                      child: Stack(
                        children: [
                          Container(
                            foregroundDecoration: RotatedCornerDecoration(
                              color: GlobalColors.globalColor(),
                              geometry: const BadgeGeometry(width: 40, height: 40, cornerRadius: 5),
                              textSpan: TextSpan(
                                text: '$property_for',
                                style: AppTextStyles.c10white400(),
                              )
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: image_path != null?Image.network(
                                image_path,scale: 1,fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.35,
                                height: MediaQuery.of(context).size.height * 0.16,
                              ): Image.asset(
                                'assets/images/placeholder.png',
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width * 0.35,
                                height: MediaQuery.of(context).size.height * 0.16
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 4.0,top: 4),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: property_type == 'Commercial'?Color(0xFF758BFD):Color(0xFF8CC63F)
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8.0,right: 8.0,top: 4,bottom: 4),
                                  child: Text(
                                    '$property_type',
                                    style: AppTextStyles.c08white400(),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8,bottom: 8),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: GlobalColors.globalColor()
                        ),
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Center(
                          child: Text(
                            'AED ${FormatCurrency().CurrencyCheck(price)}',
                            style: AppTextStyles.c14white400(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8,bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFF2F2F2)
                      ),
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1.0,vertical: 4),
                              child: Text(
                                '$title',
                                style: AppTextStyles.c14black500(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1.0,vertical: 4),
                              child: Text(
                                '$description',
                                style: AppTextStyles.c10grey400(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1.0,vertical: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(0xFF2F7ED8)
                                ),

                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.0,top: 4,bottom: 4),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.real_estate_agent,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Flexible(
                                        child: Text(
                                          '$agentFullName',
                                          style: AppTextStyles.c10white400(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1.0,vertical: 4),
                              child: Row(
                                children: [
                                  beds!=null && beds!=''?Row(
                                    children: [
                                      Icon(
                                        Icons.bed,
                                        color: GlobalColors.globalColor(),
                                        size: 15,
                                      ),
                                      Text(
                                        ' $beds',
                                        style: AppTextStyles.c12grey400(),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      )
                                    ],
                                  ):SizedBox(width: 0,),
                                  baths!=null && baths!=''?Row(
                                    children: [
                                      Icon(
                                        Icons.bathroom,
                                        color: GlobalColors.globalColor(),
                                        size: 15,
                                      ),
                                      Text(
                                        ' $baths',
                                        style: AppTextStyles.c12grey400(),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      )
                                    ],
                                  ):SizedBox(width: 0,),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.aspect_ratio,
                                        color: GlobalColors.globalColor(),
                                        size: 15,
                                      ),
                                      Text(
                                        ' $bua sqft',
                                        style: AppTextStyles.c12grey400(),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 1.0,vertical: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: GlobalColors.globalColor(),
                                    size: 20,
                                  ),
                                  Flexible(
                                    child: Text(
                                      ' $propertyLocation',
                                      style: AppTextStyles.c12grey400(),
                                      maxLines: 2,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),


          ],
        ),
      ),
    );
  }
}

