import 'dart:convert';
import 'dart:io';

import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:crm_app/Views/listings/ListingPageCard.dart';
import 'package:crm_app/controllers/nearbyController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/appbars/CommonAppBars.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:crm_app/widgets/loaders/CircularLoader.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'NearbyListingCard.dart';

class NearByListings extends StatefulWidget {

  int rad = 5000;
  NearByListings({this.rad});

  @override
  _NearByListingsState createState() => _NearByListingsState();
}

class _NearByListingsState extends State<NearByListings> {

  Position res;
  Widget _child;
  bool loaded = false;

  void initState(){
    getData();
    super.initState();
  }

  PlatformMapController mapController;


  LatLng _center = LatLng(25.209399881845346, 55.344259032271);
  Set<Marker> markers = Set();

  void _onMapCreated(PlatformMapController controller) {
    mapController = controller;
  }

  getData() async {
    try{
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

      res = await Geolocator.getCurrentPosition();

      int id = sharedPreferences.getInt('id');
      final box = GetStorage();
      List permissions = box.read('permissions');
      int roleId = box.read('role_id');
      String where;
      if(roleId != 3 || permissions.contains('listings_view_other')){
        where = '%5B%7B%22column%22:%22portal_status%22,%22value%22:%22Published%22%7D%5D';
      } else {
        where = '%5B%7B%22column%22:%22portal_status%22,%22value%22:%22Published%22%7D,%7B%22column%22:%22assigned_to_id%22,%22value%22:%22${sharedPreferences.get('user_id')}%22%7D%5D';
      }
      String nearby = '%7B%22latitude%22:${res.latitude},%22longitude%22:${res.longitude},%22radius%22:${widget.rad/1000}%7D';
      String columns = '%5B%22id%22,%22reference%22,%22title%22,%22description%22,%22property_for%22,%22property_type%22,%22listing_status%22,%22category_id%22,%22city_id%22,%22location_id%22,%22property_location%22,%22sub_location_id%22,%22assigned_to_id%22,%22created_by_id%22,%22created_at%22,%22price%22,%22slug%22,%22portal_status%22%5D';
      String include = '%5B%22category:id,name%22,%22location:id,name,latitude,longitude%22,%22sub_location:id,name,latitude,longitude%22,%22tower:id,name,latitude,longitude%22,%22assigned_to:id,first_name,last_name%22%5D';
      String order = '%7B%22created_at%22:%22desc%22%7D';
      String count = '%5B%22leads%22%5D';
      String url = '${ApiRoutes.BASE_URL}/api/listings?where=$where&nearby=$nearby&columns=$columns&include=$include&order=$order&count=$count&page=1&limit=100';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}'
        },
      );
      print(response.body);
      // print(sharedPreferences.get('token'));
      if(response.statusCode == 200){
        Map map = json.decode(response.body);
        List<dynamic> data = map['record']['data'];
        for(int i = 0; i < data.length; i++){

          String imgUrl;
          if(data[i]['images'] != null && data[i]['images'].length != 0){
            imgUrl = data[i]['images'][0]['url'];
          } else {
            print('Entered else');
            imgUrl = null;
          }
          if(data[i]['tower'] == null){
            if(data[i]['sub_location']['latitude'] != null && data[i]['sub_location']['longitude'] != null){
              markers.add(Marker(
                markerId: MarkerId('marker $i'),
                position: LatLng(double.parse(data[i]['sub_location']['latitude']), double.parse(data[i]['sub_location']['longitude'])),
                onTap: () async {
                  List listingsList;
                  String where;
                  if(roleId != 3 || permissions.contains('listings_view_other')){
                    where = '%5B%7B%22column%22:%22portal_status%22,%22value%22:%22Published%22%7D,%7B%22column%22:%22sub_location_id%22,%22operator%22:%22=%22,%22value%22:%22${data[i]['sub_location']['id']}%22%7D%5D';
                  } else {
                    where = '%5B%7B%22column%22:%22portal_status%22,%22value%22:%22Published%22%7D,%7B%22column%22:%22assigned_to_id%22,%22value%22:%22${sharedPreferences.get('user_id')}%22%7D,%7B%22column%22:%22sub_location_id%22,%22operator%22:%22=%22,%22value%22:%22${data[i]['sub_location']['id']}%22%7D%5D';
                  }
                  String columns = '%5B%22id%22,%22reference%22,%22title%22,%22description%22,%22property_for%22,%22property_type%22,%22listing_status%22,%22category_id%22,%22city_id%22,%22location_id%22,%22property_location%22,%22sub_location_id%22,%22assigned_to_id%22,%22created_by_id%22,%22created_at%22,%22price%22,%22slug%22,%22portal_status%22%5D';
                  String include = '%5B%22category:id,name%22,%22location:id,name,latitude,longitude%22,%22sub_location:id,name,latitude,longitude%22,%22tower:id,name,latitude,longitude%22,%22assigned_to:id,first_name,last_name%22%5D';
                  String order = '%7B%22created_at%22:%22desc%22%7D';
                  String url = '${ApiRoutes.BASE_URL}/api/listings?where=$where&columns=$columns&include=$include&order=$order&count=$count&page=1&limit=100';
                  final response = await http.get(
                    Uri.parse(url),
                    headers: {
                      HttpHeaders.authorizationHeader:
                      'Bearer ${sharedPreferences.get('token')}'
                    },
                  );
                  print(response.body);
                  if(response.statusCode == 200){
                    Map newData = json.decode(response.body);
                    listingsList = newData['record']['data'];
                  }
                  await showGeneralDialog(
                    barrierLabel: "Barrier",
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionDuration: Duration(milliseconds: 700),
                    context: context,
                    pageBuilder: (_, __, ___) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Text(
                                    'Listings',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      decoration: TextDecoration.none,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                                for(var map in listingsList)
                                  Column(
                                    children: [
                                      Card(
                                        child: NearbyListingCard(
                                          id: map['id'],
                                          reference: map['reference'],
                                          price: double.parse(map['price'].toString()) != null? double.parse(map['price'].toString()): 0,
                                          listingStatus: map['listing_status'],
                                          agentFullName: map['assigned_to'] != null?map['assigned_to']['full_name']:'',
                                          propertyLocation: map['property_location'],
                                          property_for: map['property_for'],
                                          title: map['title'],
                                          image_path: map['images']!= null?map['images'][0]['url']:null,
                                          updated_at: map['updated_at'],
                                          property_type: map['property_type'],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    transitionBuilder: (_, anim, __, child) {
                      return SlideTransition(
                        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                        child: child,
                      );
                    },
                  );
                }
              ));
            } else if (data[i]['sub_location'] == null || (data[i]['sub_location']['latitude'] == null || data[i]['sub_location']['longitude'] == null)){
              markers.add(Marker(
                markerId: MarkerId('marker $i'),
                position: LatLng(double.parse(data[i]['location']['latitude']), double.parse(data[i]['location']['longitude'])),
                onTap: () async {
                  List<Map> listingsList;
                  String where;
                  if(roleId != 3 || permissions.contains('listings_view_other')){
                    where = '%5B%7B%22column%22:%22portal_status%22,%22value%22:%22Published%22%7D,%7B%22column%22:%22location_id%22,%22operator%22:%22=%22,%22value%22:%22${data[i]['location']['id']}%22%7D%5D';
                  } else {
                    where = '%5B%7B%22column%22:%22portal_status%22,%22value%22:%22Published%22%7D,%7B%22column%22:%22assigned_to_id%22,%22value%22:%22${sharedPreferences.get('user_id')}%22%7D,%7B%22column%22:%22location_id%22,%22operator%22:%22=%22,%22value%22:%22${data[i]['location']['id']}%22%7D%5D';
                  }
                  String columns = '%5B%22id%22,%22reference%22,%22title%22,%22description%22,%22property_for%22,%22property_type%22,%22listing_status%22,%22category_id%22,%22city_id%22,%22location_id%22,%22property_location%22,%22sub_location_id%22,%22assigned_to_id%22,%22created_by_id%22,%22created_at%22,%22price%22,%22slug%22,%22portal_status%22%5D';
                  String include = '%5B%22category:id,name%22,%22location:id,name,latitude,longitude%22,%22sub_location:id,name,latitude,longitude%22,%22tower:id,name,latitude,longitude%22,%22assigned_to:id,first_name,last_name%22%5D';
                  String order = '%7B%22created_at%22:%22desc%22%7D';
                  String url = '${ApiRoutes.BASE_URL}/api/listings?where=$where&columns=$columns&include=$include&order=$order&count=$count&page=1&limit=100';
                  final response = await http.get(
                    Uri.parse(url),
                    headers: {
                      HttpHeaders.authorizationHeader:
                      'Bearer ${sharedPreferences.get('token')}'
                    },
                  );
                  print(response.body);
                  if(response.statusCode == 200){
                    Map newData = json.decode(response.body);
                    listingsList = newData['record']['data'];
                  }
                  showGeneralDialog(
                    barrierLabel: "Barrier",
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionDuration: Duration(milliseconds: 700),
                    context: context,
                    pageBuilder: (_, __, ___) {
                      return Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: Text(
                                    'Listings',
                                    style: AppTextStyles.c18black500(),
                                  ),
                                ),
                                for(map in listingsList)
                                  Column(
                                    children: [
                                      Card(
                                        child: NearbyListingCard(
                                          id: map[i]['id'],
                                          reference: map[i]['reference'],
                                          price: double.parse(map['price'].toString()) != null? double.parse(map['price'].toString()): 0,
                                          listingStatus: map[i]['listing_status'],
                                          agentFullName: map[i]['assigned_to'] != null?map[i]['assigned_to']['full_name']:'',
                                          propertyLocation: map[i]['property_location'],
                                          property_for: map[i]['property_for'],
                                          title: map[i]['title'],
                                          image_path: map['images']!=null?map['images'][0]['url']:null,
                                          updated_at: map[i]['updated_at'],
                                          property_type: map[i]['property_type'],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    transitionBuilder: (_, anim, __, child) {
                      return SlideTransition(
                        position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                        child: child,
                      );
                    },
                  );
                }
              ));
            } else if(data[i]['location'] == null){
              continue;
            }
          } else {
            markers.add(Marker(
              markerId: MarkerId('marker $i'),
              position: LatLng(double.parse(data[i]['tower']['latitude']), double.parse(data[i]['tower']['longitude'])),
              onTap: () async {
                List<Map> listingsList;
                String where;
                if(roleId != 3 || permissions.contains('listings_view_other')){
                  where = '%5B%7B%22column%22:%22portal_status%22,%22value%22:%22Published%22%7D,%7B%22column%22:%22tower_id%22,%22operator%22:%22=%22,%22value%22:%22${data[i]['tower']['id']}%22%7D%5D';
                } else {
                  where = '%5B%7B%22column%22:%22portal_status%22,%22value%22:%22Published%22%7D,%7B%22column%22:%22assigned_to_id%22,%22value%22:%22${sharedPreferences.get('user_id')}%22%7D,%7B%22column%22:%22tower_id%22,%22operator%22:%22=%22,%22value%22:%22${data[i]['tower']['id']}%22%7D%5D';
                }
                String columns = '%5B%22id%22,%22reference%22,%22title%22,%22description%22,%22property_for%22,%22property_type%22,%22listing_status%22,%22category_id%22,%22city_id%22,%22location_id%22,%22property_location%22,%22sub_location_id%22,%22assigned_to_id%22,%22created_by_id%22,%22created_at%22,%22price%22,%22slug%22,%22portal_status%22%5D';
                String include = '%5B%22category:id,name%22,%22location:id,name,latitude,longitude%22,%22sub_location:id,name,latitude,longitude%22,%22tower:id,name,latitude,longitude%22,%22assigned_to:id,first_name,last_name%22%5D';
                String order = '%7B%22created_at%22:%22desc%22%7D';
                String url = '${ApiRoutes.BASE_URL}/api/listings?where=$where&columns=$columns&include=$include&order=$order&count=$count&page=1&limit=100';
                final response = await http.get(
                  Uri.parse(url),
                  headers: {
                    HttpHeaders.authorizationHeader:
                    'Bearer ${sharedPreferences.get('token')}'
                  },
                );
                print(response.body);
                if(response.statusCode == 200){
                  Map newData = json.decode(response.body);
                  listingsList = newData['record']['data'];
                }
                showGeneralDialog(
                  barrierLabel: "Barrier",
                  barrierDismissible: true,
                  barrierColor: Colors.black.withOpacity(0.5),
                  transitionDuration: Duration(milliseconds: 700),
                  context: context,
                  pageBuilder: (_, __, ___) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Text(
                                  'Listings',
                                  style: AppTextStyles.c18black500(),
                                ),
                              ),
                              for(map in listingsList)
                                Column(
                                  children: [
                                    Card(
                                      child: NearbyListingCard(
                                        id: map[i]['id'],
                                        reference: map[i]['reference'],
                                        price: double.parse(map['price'].toString()) != null? double.parse(map['price'].toString()): 0,
                                        listingStatus: map[i]['listing_status'],
                                        agentFullName: map[i]['assigned_to'] != null?map[i]['assigned_to']['full_name']:'',
                                        propertyLocation: map[i]['property_location'],
                                        property_for: map[i]['property_for'],
                                        title: map[i]['title'],
                                        image_path: map['images']!=null?map['images'][0]['url']:null,
                                        updated_at: map[i]['updated_at'],
                                        property_type: map[i]['property_type'],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  transitionBuilder: (_, anim, __, child) {
                    return SlideTransition(
                      position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                      child: child,
                    );
                  },
                );
              }
            ));
          }
        }
        markers.add(Marker(
          markerId: MarkerId('MyLocation'),
          position: LatLng(res.latitude,res.longitude),
          infoWindow: InfoWindow(
              title: 'Current Location'
          ),
          icon: BitmapDescriptor.defaultMarker
        ));
        setState(() {
          loaded = true;
        });
      }
    } catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(loaded){
      _child = mapWidget();
    } else {
      _child = Center(child: NetworkLoading(),);
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 27,),
        ),
        title: Center(
          child: Text(
            'Nearby Listings',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: GlobalColors.globalColor(),
      ),
      body: _child,
    );
  }

  Widget mapWidget(){
    Set<Circle> circles = {
      Circle(
          circleId: CircleId('searchRadius'),
          radius: widget.rad.toDouble(),
          fillColor: Color(0x568DBBF8),
          strokeColor: Color(0x568DBBF8),
          strokeWidth: 1,
          center: LatLng(res.latitude,res.longitude)
      )
    };
    return Stack(
      children: [
        PlatformMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(res.latitude,res.longitude),
              zoom: 12
          ),
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          markers: markers,
          circles: circles,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(widget.rad != 10000)Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(Colors.white)
                ),
                onPressed: (){
                  if(widget.rad <= 9000){
                    widget.rad += 1000;
                  }
                  setState(() {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NearByListings(rad: widget.rad,)));
                    print(widget.rad);
                  });
                },
                child: Icon(
                  Icons.add,
                  size: 25,
                  color: GlobalColors.globalColor(),
                ),
              ),
            ),
            if(widget.rad != 1000)Padding(
              padding: const EdgeInsets.only(left: 10.0,bottom: 50),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  foregroundColor: MaterialStateProperty.all(Colors.white)
                ),
                onPressed: (){
                  if(widget.rad > 1000 ){
                    widget.rad -= 1000;
                  }
                  setState(() {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NearByListings(rad: widget.rad,)));
                    print(widget.rad);
                  });
                },
                child: Icon(
                  Icons.remove,
                  size: 25,
                  color: GlobalColors.globalColor(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


}
