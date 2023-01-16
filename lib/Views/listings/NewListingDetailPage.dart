import 'dart:convert';

import 'package:crm_app/CodeSnippets/CurrencyCheck.dart';
import 'package:crm_app/CodeSnippets/LaunchUrlSnippet.dart';
import 'package:crm_app/Views/leads/ListingLeadsPage.dart';
import 'package:crm_app/Views/listings/ImageSlider.dart';
import 'package:crm_app/controllers/listingController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/ListingStatusColors.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_slider/image_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ListingUpdatePage.dart';

class NewListingDetailPage extends StatefulWidget {
  final int id;
  NewListingDetailPage({this.id});

  @override
  _NewListingDetailPageState createState() => _NewListingDetailPageState();
}

class _NewListingDetailPageState extends State<NewListingDetailPage> with SingleTickerProviderStateMixin{

  final box = GetStorage();
  List<Map<String,dynamic>> status;
  int userId;
  int roleId;



  Future<List<dynamic>> getListingDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.get('user_id');
    ListingController lc = ListingController();
    //status = await lc.getStatusList(id);
    return lc.getListingDetails(widget.id);
  }

  LaunchUrlSnippet launchApp = LaunchUrlSnippet();

  @override
  void initState(){

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    roleId = box.read('role_id');
    List<dynamic> permissions = box.read('permissions');
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getListingDetails(),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            if(snapshot.hasData){
              print(snapshot.data[0]['property_type']);
              int deposit;
              snapshot.data[0]['deposit'] != null?deposit = snapshot.data[0]['deposit']:deposit = 0;
              double price = double.parse(snapshot.data[0]['price'].toString());
              double pricePerSqft;
              snapshot.data[0]['price_per_sq_feet']!= null?pricePerSqft = double.parse(snapshot.data[0]['price_per_sq_feet'].toString()):pricePerSqft = 0;
              double commission;
              snapshot.data[0]['commission']!= null? commission = double.parse(snapshot.data[0]['commission'].toString()): commission = 0;
              List<String> imageUrls = [];
              if(snapshot.data[0]['images'].length != 0){
                for(int i = 0; i < snapshot.data[0]['images'].length; i++){
                  imageUrls.add(snapshot.data[0]['images'][i]['url']);
                }
              }

              List<Widget> portalIcons = [];
              if(snapshot.data[0]['portals'] != null && snapshot.data[0]['portals'] != []){
                for(int i = 0; i < snapshot.data[0]['portals'].length;i++){
                  if(snapshot.data[0]['portals'][i]['name'] == 'Dubizzle'){
                    portalIcons.add(Image.asset('assets/images/DZicon.png',scale: 3,));
                  }
                  if(snapshot.data[0]['portals'][i]['name'] == 'PropertyFinder'){
                    portalIcons.add(Image.asset('assets/images/PFicon.png',scale: 3,));
                  }
                  if(snapshot.data[0]['portals'][i]['name'] == 'Bayut'){
                    portalIcons.add(Image.asset('assets/images/BYicon.png',scale: 3,));
                  }
                  if(snapshot.data[0]['portals'][i]['name'] == 'Generic'){
                    portalIcons.add(Image.asset('assets/images/GEicon.png',scale: 3,));
                  }
                }
              }
              int imgLength = 0;


              return Column(
                children: [



                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //ORIGINAL IMAGE SLIDER

                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: snapshot.data[0]['images'].length != 0?ImageSliderContainer(length: snapshot.data[0]['images'].length, imgUrls: imageUrls,):ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/placeholder.png',
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  fit: BoxFit.cover,
                                )),
                          ),

                          //PLACEHOLDER
                          /*Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: imgLength != 0?ImageSliderContainer(length: snapshot.data[0]['images'].length, imgUrls: imageUrls,):ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/placeholder.png',
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  fit: BoxFit.cover,
                                )),
                          ),*/

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Color(0xFFB3B3B3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 8),
                                    child: Text(
                                      '${snapshot.data[0]['reference']}',
                                      style: AppTextStyles.c14white400(),
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
                                Row(
                                  children: [
                                    Icon(Icons.circle,color: listingStatusColor(snapshot.data[0]['listing_status']),size: 10,),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      snapshot.data[0]['listing_status'] != null?'${snapshot.data[0]['listing_status']}': '',
                                      style: AppTextStyles.c12grey400(),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: snapshot.data[0]['property_type'] == 'Commercial'?Color(0xFF758BFD):Color(0xFF8CC63F)
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8.0,right: 8.0,top: 4,bottom: 4),
                                        child: Text(
                                          '${snapshot.data[0]['property_type']}',
                                          style: AppTextStyles.c12white400(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: GlobalColors.globalColor()
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 8.0,right: 8.0,top: 4,bottom: 4),
                                        child: Text(
                                          '${snapshot.data[0]['property_for']}',
                                          style: AppTextStyles.c12white400(),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                if(snapshot.data[0]['leads_count'] > 0)
                                  InkWell(
                                    onTap: (){
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListingLeadsPage(id: snapshot.data[0]['id'],)));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: GlobalColors.globalColor()
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                        child: Text(
                                          'Leads count: ${snapshot.data[0]['leads_count']}',
                                          style: AppTextStyles.c12white400(),
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0,bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color(0xFF2F7ED8)
                              ),

                              child: Padding(
                                padding: EdgeInsets.only(left: 8.0,right: 8.0,top: 4,bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.real_estate_agent,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      '${snapshot.data[0]['assigned_to']['full_name']}',
                                      style: AppTextStyles.c14white400(),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if(permissions.contains('listings_update_other') || permissions.contains('listings_update') && snapshot.data[0]['listing_status'] != 'Closed')
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: GlobalColors.globalColor()
                                )
                            ),
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListingUpdatePage(id: widget.id,catId: snapshot.data[0]['category_id'],type: snapshot.data[0]['property_type'],)));
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.update,
                                  color: GlobalColors.globalColor(),
                                ),
                                Text(
                                  'Update',
                                  style: TextStyle(
                                      color: GlobalColors.globalColor(),
                                      fontSize: 12,
                                      fontFamily: 'Cairo'
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                            child: Text(
                              'Title & Description:',
                              style: AppTextStyles.c16black600(),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                                child: Text(
                                  '${snapshot.data[0]['title']}',
                                  style: AppTextStyles.c14black500(),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0,),
                            child: Text(
                              '${snapshot.data[0]['description']}',
                              style: AppTextStyles.c14grey400(),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          )

                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0,right:15,top: 15,bottom: 7),
                            child: Text(
                              'Property Specifics:',
                              style: AppTextStyles.c16black600(),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.apartment,
                                    size: 17,
                                    color: GlobalColors.globalColor(),
                                  ),
                                  Text(
                                    ' ${snapshot.data[0]['category']['name']}',
                                    style: AppTextStyles.c14grey400(),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.bed,
                                    size: 17,
                                    color: GlobalColors.globalColor(),
                                  ),
                                  Text(
                                    ' ${snapshot.data[0]['beds']} Bedrooms',
                                    style: AppTextStyles.c14grey400(),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.bathtub_outlined,
                                    size: 17,
                                    color: GlobalColors.globalColor(),
                                  ),
                                  Text(
                                    ' ${snapshot.data[0]['baths']} Bathrooms',
                                    style: AppTextStyles.c14grey400(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if(permissions.contains('listings_update_other') || permissions.contains('listings_update') && snapshot.data[0]['listing_status'] != 'Closed')
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    snapshot.data[0]['built_up_area']!=null?Row(
                                      children: [
                                        Icon(
                                          Icons.aspect_ratio,
                                          size: 17,
                                          color: GlobalColors.globalColor(),
                                        ),
                                        Text(
                                          ' ${snapshot.data[0]['built_up_area']}',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      ],
                                    ):SizedBox(width: 0,),
                                    snapshot.data[0]['built_up_area']==null?SizedBox(
                                      width: 15,
                                    ):SizedBox(
                                      width: 0,
                                    ),
                                    snapshot.data[0]['unit_no']!=null?Row(
                                      children: [
                                        Icon(
                                          Icons.tag,
                                          size: 17,
                                          color: GlobalColors.globalColor(),
                                        ),
                                        Text(
                                          ' Unit #${snapshot.data[0]['unit_no']}',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      ],
                                    ):SizedBox(width: 0,),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          if(permissions.contains('listings_update_other') || permissions.contains('listings_update') && snapshot.data[0]['listing_status'] != 'Closed')
                            Column(
                              children: [
                                snapshot.data[0]['permit_no']!=null && snapshot.data[0]['permit_no']!= ''?Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.task,
                                        size: 17,
                                        color: GlobalColors.globalColor(),
                                      ),
                                      Text(
                                        ' Permit No. ${snapshot.data[0]['permit_no']}',
                                        style: AppTextStyles.c14grey400(),
                                      ),
                                    ],
                                  ),
                                ):SizedBox(width: 0,),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          if(snapshot.data[0]['property_location']!= null && snapshot.data[0]['property_location']!='')
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 17,
                                        color: GlobalColors.globalColor(),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Flexible(
                                        child: Text(
                                          '${snapshot.data[0]['property_location']}',
                                          style: AppTextStyles.c14grey400(),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),







                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                    child: Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              'Property Pricing:',
                              style: AppTextStyles.c16black600(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Price',
                                      style: AppTextStyles.c14grey400(),
                                    ),
                                    Text(
                                      'AED ${FormatCurrency().CurrencyCheck(price)}',
                                      style: AppTextStyles.c14grey400(),
                                    )
                                  ],
                                ),
                                Divider(
                                  thickness: 0.7,
                                  color: Colors.grey.shade400,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Price Per Square Feet',
                                      style: AppTextStyles.c14grey400(),
                                    ),
                                    Text(
                                      'AED ${FormatCurrency().CurrencyCheck(pricePerSqft)}',
                                      style: AppTextStyles.c14grey400(),
                                    )
                                  ],
                                ),
                                Divider(
                                  thickness: 0.7,
                                  color: Colors.grey.shade400,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Deposit %',
                                      style: AppTextStyles.c14grey400(),
                                    ),
                                    Text(
                                      snapshot.data[0]['deposit_percent'] != null?'${snapshot.data[0]['deposit_percent']}': '0',
                                      style: AppTextStyles.c14grey400(),
                                    )
                                  ],
                                ),
                                Divider(
                                  thickness: 0.7,
                                  color: Colors.grey.shade400,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Deposit amount',
                                      style: AppTextStyles.c14grey400(),
                                    ),
                                    Text(
                                      'AED ${FormatCurrency().CurrencyCheck(deposit.toDouble())}',
                                      style: AppTextStyles.c14grey400(),
                                    )
                                  ],
                                ),
                                Divider(
                                  thickness: 0.7,
                                  color: Colors.grey.shade400,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Commission %',
                                      style: AppTextStyles.c14grey400(),
                                    ),
                                    Text(
                                      snapshot.data[0]['commission_percent'] != null?'${snapshot.data[0]['commission_percent']}': '0',
                                      style: AppTextStyles.c14grey400(),
                                    )
                                  ],
                                ),
                                Divider(
                                  thickness: 0.7,
                                  color: Colors.grey.shade400,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Commission amount',
                                      style: AppTextStyles.c14grey400(),
                                    ),
                                    Text(
                                      'AED ${FormatCurrency().CurrencyCheck(commission.toDouble())}',
                                      style: AppTextStyles.c14grey400(),
                                    )
                                  ],
                                ),
                                Divider(
                                  thickness: 0.7,
                                  color: Colors.grey.shade400,
                                ),
                                SizedBox(
                                  height: 15,
                                )
                              ],
                            ),
                          ),







                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if(snapshot.data[0]['owner'] != null && (permissions.contains('listings_publish') || permissions.contains('listings_detail')) && (snapshot.data[0]['assigned_to_id'] == userId || roleId != 3))
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                      child: Card(
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'Owner Details:',
                                style: AppTextStyles.c16black600(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFF2F2F2)
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width * 0.6,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    '${snapshot.data[0]['owner']['full_name']}',
                                                    style: AppTextStyles.c16grey500(),
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              snapshot.data[0]['owner']['mobile']!= null && snapshot.data[0]['owner']['mobile']!= ''? Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){
                                                      launchApp.launchWhatsapp('${snapshot.data[0]['owner']['mobile']}');
                                                    },
                                                    child: Image.asset('assets/images/whatsapp.png',scale: 2),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){
                                                      _callNumber(snapshot.data[0]['owner']['mobile']);
                                                    },
                                                    child: Image.asset('assets/images/call.png',scale: 2,),
                                                  ),
                                                ],
                                              ):SizedBox(
                                                width: 0,
                                                height: 0,
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              snapshot.data[0]['owner']['email']!=null&&snapshot.data[0]['owner']['email']!=''? GestureDetector(
                                                onTap: (){
                                                  launchApp.launchmail('${snapshot.data[0]['owner']['email']}');
                                                },
                                                child: Image.asset('assets/images/email.png',scale: 2,),
                                              ):SizedBox(
                                                width: 0,
                                                height: 0,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  )
                                ],
                              ),
                            ),







                          ],
                        ),
                      ),
                    ),


                  SizedBox(
                    height: 30,
                  )
                ],
              );
            } else {
              return Center(
                child: AnimatedSearch(),
              );
            }
          },
        ),
      ),
    );
  }

  _callNumber(String phone) async {
    var data;
    final String response = await rootBundle.loadString('assets/codes/countries.json');
    data = json.decode(response);
    print(data);
    for(var i in data){

      String code = i['dialCode'];
      // print(phone.substring(0,code.length-1));
      if(code.substring(1) == phone.substring(0,code.length-1)){
        phone = '+$phone';
        print(phone);
      } else if(phone[0] == '0'){
        break;
      } else {
        continue;
      }
    }
    /*String prefixType1 = phone[0]+phone[1]+phone[2];
    if(prefixType1 == '971'){
      phone = '+$phone';
    }*/
    bool res = await FlutterPhoneDirectCaller.callNumber(phone);

    void newDialog(){

    }
  }
}
