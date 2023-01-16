import 'package:crm_app/CodeSnippets/CurrencyCheck.dart';
import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/CodeSnippets/LaunchUrlSnippet.dart';
import 'package:crm_app/Views/leads/ListingLeadsPage.dart';
import 'package:crm_app/Views/listings/ListingUpdatePage.dart';
import 'package:crm_app/controllers/listingController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/ListingStatusColors.dart';
import 'package:crm_app/widgets/appbars/CommonAppBars.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListingDetailsTabPage extends StatelessWidget {

  final int id;

  ListingDetailsTabPage({this.id});

  final box = GetStorage();
  List<Map<String,dynamic>> status;
  int userId;
  int roleId;


  Future<List<dynamic>> getListingDetails() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.get('user_id');
    ListingController lc = ListingController();
    //status = await lc.getStatusList(id);
    return lc.getListingDetails(id);
  }

  DateTimeConversion dateTimeConv = DateTimeConversion();
  LaunchUrlSnippet launchApp = LaunchUrlSnippet();

  @override
  Widget build(BuildContext context) {
    roleId = box.read('role_id');
    List<dynamic> permissions = box.read('permissions');
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: getListingDetails(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print(snapshot);
          if(snapshot.hasData){
            print(snapshot.data[0]['property_type']);
            int deposit;
            snapshot.data[0]['deposit'] != null?deposit = snapshot.data[0]['deposit']:deposit = 0;
            double price = double.parse(snapshot.data[0]['price']);
            double pricePerSqft;
            snapshot.data[0]['price_per_sq_feet']!= null?pricePerSqft = double.parse(snapshot.data[0]['price_per_sq_feet'].toString()):pricePerSqft = 0;
            double commission;
            snapshot.data[0]['commission']!= null? commission = snapshot.data[0]['commission'].toDouble(): commission = 0;
            List<dynamic> imageUrls = [];
            if(snapshot.data[0]['images'].length != 0){
              for(int i = 0; i < snapshot.data[0]['images'].length; i++){
                imageUrls.add(snapshot.data[0]['images'][i]['url']);
              }
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              Icon(Icons.circle,color: listingStatusColor(snapshot.data[0]['listing_status']),size: 14,),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                '${snapshot.data[0]['listing_status']}',
                                style: TextStyle(
                                    color: listingStatusColor(snapshot.data[0]['listing_status']),
                                    fontSize: 16,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5,right: 5),
                          child: Text(
                            'Created Date: ${dateTimeConv.getDDMMMYYY(snapshot.data[0]['created_at'])}',
                            style: AppTextStyles.c14black500(),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${snapshot.data[0]['title']}',
                            style: AppTextStyles.c20black400(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            '${snapshot.data[0]['property_location']}',
                            style: AppTextStyles.c14grey400(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RawChip(
                          side: BorderSide(
                            color: snapshot.data[0]['property_for'] == 'Rental'?Color(0xFF8702BA):Color(0xFF4062A4),
                          ),
                          label: Text(
                              '${snapshot.data[0]['property_for']}'
                          ),
                          labelStyle:TextStyle(
                              color: snapshot.data[0]['property_for'] == 'Rental'?Color(0xFF8702BA):Color(0xFF4062A4),
                              fontSize: 12,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w500
                          ),
                          backgroundColor: Colors.white54,
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Assigned to: ${snapshot.data[0]['assigned_to']['full_name']}',
                            style: AppTextStyles.c14black500(),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Published on: ${dateTimeConv.getDDMMMYYY(snapshot.data[0]['published_at'])}',
                            style: AppTextStyles.c14black500(),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Updated on: ${dateTimeConv.getDDMMMYYY(snapshot.data[0]['updated_at'])}',
                            style: AppTextStyles.c14black500(),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            'Expires on: ${dateTimeConv.getDDMMMYYY(snapshot.data[0]['expiry_date'])}',
                            style: AppTextStyles.c14black500(),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 0.2,
                      thickness: 0.7,
                      color: Colors.grey,
                    ),
                    if(snapshot.data[0]['leads_count'] > 0)
                      Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListingLeadsPage(id: snapshot.data[0]['id'],)));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                color: GlobalColors.globalColor(),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                                      child: Text(
                                        'LEADS',
                                        style: AppTextStyles.c16white600(),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${snapshot.data[0]['leads_count']}',
                                          style: AppTextStyles.c18white600(),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(right: 4.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Property Details',
                          style: AppTextStyles.c20black400(),
                        ),
                        if(permissions.contains('listings_update_other') || permissions.contains('listings_update') && snapshot.data[0]['listing_status'] != 'Closed')
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: GlobalColors.globalColor()
                                )
                            ),
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListingUpdatePage(id: id,type: snapshot.data[0]['property_type'],)));
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
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.015,
                    ),
                    imageUrls.length != 0?CarouselSlider(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.25,
                        enableInfiniteScroll: true,
                      ),
                      items: imageUrls.map(
                              (item) => Container(
                            child: Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Center(
                                  child:
                                  Image.network(item, fit: BoxFit.cover, width: 1000)),
                            )
                          )
                      ).toList(),
                    ) : Center(child: Text('No Images', style: AppTextStyles.c14grey400(),)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Property Specifics:',
                      style: AppTextStyles.c14grey400(),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        children: [
                          RawChip(
                            backgroundColor: Colors.grey,
                            label: Text('${snapshot.data[0]['category']['name']}'),
                            labelStyle: AppTextStyles.c14black500(),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          if(snapshot.data[0]['beds'] != null)
                            RawChip(
                              backgroundColor: Colors.grey,
                              label: Text('${snapshot.data[0]['beds']} beds'),
                              labelStyle: AppTextStyles.c14black500(),
                            ),
                          SizedBox(
                            width: 5,
                          ),
                          if(snapshot.data[0]['baths'] != null)
                            RawChip(
                              backgroundColor: Colors.grey,
                              label: Text('${snapshot.data[0]['baths']} baths'),
                              labelStyle: AppTextStyles.c14black500(),
                            ),
                          SizedBox(
                            width: 5,
                          ),
                          if(snapshot.data[0]['unit_no'] != null && snapshot.data[0]['unit_no'] != '' && (permissions.contains('listings_publish') || permissions.contains('listings_detail')) && (snapshot.data[0]['assigned_to_id'] == userId || roleId != 3))
                            Row(
                              children: [
                                RawChip(
                                  backgroundColor: Colors.grey,
                                  label: Text('Unit #${snapshot.data[0]['unit_no']}'),
                                  labelStyle: AppTextStyles.c14black500(),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          if(snapshot.data[0]['build_up_area'] != null && snapshot.data[0]['build_up_area'] != '')
                            Row(
                              children: [
                                RawChip(
                                  backgroundColor: Colors.grey,
                                  label: Text('BUA: ${snapshot.data[0]['build_up_area']}'),
                                  labelStyle: AppTextStyles.c14black500(),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          if(snapshot.data[0]['permit_no'] != null && snapshot.data[0]['permit_no'] != '')
                            RawChip(
                              backgroundColor: Colors.grey,
                              label: Text('Permit: ${snapshot.data[0]['permit_no']}'),
                              labelStyle: AppTextStyles.c14black500(),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Property Pricing',
                      style: AppTextStyles.c20black400(),
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text(
                                'Price',
                                style: AppTextStyles.c14black500(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4.0),
                              child: Text(
                                'AED ${FormatCurrency().CurrencyCheck(price)}',
                                style: AppTextStyles.c14black500(),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text(
                                'Price Per Square Feet',
                                style: AppTextStyles.c14black500(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4.0),
                              child: Text(
                                'AED ${FormatCurrency().CurrencyCheck(pricePerSqft)}',
                                style: AppTextStyles.c14black500(),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text(
                                'Deposit %',
                                style: AppTextStyles.c14black500(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4.0),
                              child: Text(
                                snapshot.data[0]['deposit_percent'] != null?'${snapshot.data[0]['deposit_percent']}': '0',
                                style: AppTextStyles.c14black500(),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text(
                                'Total Deposit amount',
                                style: AppTextStyles.c14black500(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4.0),
                              child: Text(
                                'AED ${FormatCurrency().CurrencyCheck(deposit.toDouble())}',
                                style: AppTextStyles.c14black500(),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text(
                                'Commission %',
                                style: AppTextStyles.c14black500(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4.0),
                              child: Text(
                                snapshot.data[0]['commission_percent'] != null?'${snapshot.data[0]['commission_percent']}': '0',
                                style: AppTextStyles.c14black500(),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4.0),
                              child: Text(
                                'Total Commission amount',
                                style: AppTextStyles.c14black500(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 4.0),
                              child: Text(
                                'AED ${FormatCurrency().CurrencyCheck(commission.toDouble())}',
                                style: AppTextStyles.c14black500(),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 0.2,
                      thickness: 0.7,
                      color: Colors.grey,
                    ),
                    if(snapshot.data[0]['owner'] != null && (permissions.contains('listings_publish') || permissions.contains('listings_detail')) && (snapshot.data[0]['assigned_to_id'] == userId || roleId != 3))
                      Column(
                        children: [
                          Text(
                            'Owner Details',
                            style: AppTextStyles.c20black400(),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${snapshot.data[0]['owner']['full_name']}',
                                    style: AppTextStyles.c16black500(),
                                  ),
                                  Text(
                                    '${snapshot.data[0]['owner']['type']}',
                                    style: AppTextStyles.c14grey400(),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  (snapshot.data[0]['owner']['email']!= null && snapshot.data[0]['owner']['email'] != '')?OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        minimumSize: Size(15,20),
                                        side: BorderSide(
                                            color: GlobalColors.globalColor()
                                        )
                                    ),
                                    onPressed: (){
                                      launchApp.launchmail('${snapshot.data[0]['owner']['email']}');
                                    },
                                    child: Icon(
                                      Icons.email_outlined,
                                      color: GlobalColors.globalColor(),
                                    ),
                                  ):SizedBox(width: 0,height: 0,),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  (snapshot.data[0]['owner']['mobile']!= null && snapshot.data[0]['owner']['mobile']!= '')?OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        minimumSize: Size(10, 20),
                                        side: BorderSide(
                                            color: GlobalColors.globalColor()
                                        )
                                    ),
                                    onPressed: (){
                                      launchApp.launchCall('tel:${snapshot.data[0]['owner']['mobile']}');
                                    },
                                    child: Icon(
                                      Icons.phone,
                                      color: GlobalColors.globalColor(),
                                    ),
                                  ):SizedBox(width: 0,height: 0,),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Divider(
                            height: 0.2,
                            thickness: 0.7,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: AnimatedSearch());
          }
        },
      ),
    );
  }
}
