import 'dart:ui';

import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:crm_app/controllers/listingCategoryController.dart';
import 'package:crm_app/controllers/listingController.dart';
import 'package:crm_app/controllers/listingUpdateController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/ListingStatusColors.dart';
import 'package:crm_app/widgets/loaders/CircularLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

class ListingUpdatePage extends StatefulWidget {


  final int id;
  int catId;
  final String type;
  ListingUpdatePage({this.id,this.catId,this.type});

  @override
  _ListingUpdatePageState createState() => _ListingUpdatePageState();
}

class _ListingUpdatePageState extends State<ListingUpdatePage> {





  Future<List<Map>> getListingDetails() async{
    ListingController lc = ListingController();
    ListingCategoryController lcc = ListingCategoryController();
    categories = await lcc.getCategories(widget.type);
    return lc.getListingDetails(widget.id);
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false;

  List numberOfBeds = [
    {'num': 0, 'text':'Studio'},
    {'num': 1, 'text':'1 Bed'},
    {'num': 2, 'text':'2 Beds'},
    {'num': 3, 'text':'3 Beds'},
    {'num': 4, 'text':'4 Beds'},
    {'num': 5, 'text':'5 Beds'},
    {'num': 6, 'text':'6 Beds'},
    {'num': 7, 'text':'7 Beds'},
    {'num': 8, 'text':'8 Beds'},
    {'num': 9, 'text':'9 Beds'},
    {'num': 10, 'text':'10 Beds'},
    {'num': 11, 'text':'11 Beds'},
    {'num': 12, 'text':'12 Beds'}
  ];
  List numberOfBaths = [
    {'num': 0, 'text':'N/A'},
    {'num': 1, 'text':'1 Bath'},
    {'num': 2, 'text':'2 Baths'},
    {'num': 3, 'text':'3 Baths'},
    {'num': 4, 'text':'4 Baths'},
    {'num': 5, 'text':'5 Baths'},
    {'num': 6, 'text':'6 Baths'},
    {'num': 7, 'text':'7 Baths'},
    {'num': 8, 'text':'8 Baths'},
    {'num': 9, 'text':'9 Baths'},
    {'num': 10, 'text':'10 Baths'},
    {'num': 11, 'text':'11 Baths'},
    {'num': 12, 'text':'12 Baths'}
  ];
  List<String> furnishing = ['Unfurnished','Semi Furnished', 'Fully Furnished'];
  List<String> propertyOwnershipType = ['Freehold', 'Non Freehold', 'Leasehold'];
  List<String> occupancyType = ['Owner Occupied', 'Investment', 'Vacant', 'Tenanted'];

  List<String> projectStatusList = ['Completed', 'Off Plan'];

  List<String> tenureList = ['Freehold', 'Leasehold'];
  List<String> constructionStatusList = ['Not Started', 'Under Construction'];
  List<String> frequencyList = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  List numberOfCheques = [
    {'num': 1, 'text':'1 Cheque'},
    {'num': 2, 'text':'2 Cheques'},
    {'num': 3, 'text':'3 Cheques'},
    {'num': 4, 'text':'4 Cheques'},
    {'num': 5, 'text':'5 Cheques'},
    {'num': 6, 'text':'6 Cheques'},
    {'num': 7, 'text':'7 Cheques'},
    {'num': 8, 'text':'8 Cheques'},
    {'num': 9, 'text':'9 Cheques'},
    {'num': 10, 'text':'10 Cheques'},
    {'num': 11, 'text':'11 Cheques'},
    {'num': 12, 'text':'12 Cheques'}
  ];
  int beds = 0;
  String nBeds;
  String nBaths;
  int baths = 0;
  int nCheques;
  int categoryId;
  String furnishType;
  String propertyOwner;
  String occupancy;
  String projectStatus;
  String tenure;
  String constructionStatus;
  String frequency;
  String cheques;
  String status = '';
  String portalStatus;
  List categories = [];
  String submitStatus;
  String submitUnpublished;
  List<String> categoryList = [];
  List<String> statusList = [];


  TextEditingController buildingNo = new TextEditingController();
  TextEditingController unitNo = new TextEditingController();
  TextEditingController permitNo = new TextEditingController();
  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController unitType = new TextEditingController();
  TextEditingController streetNo = new TextEditingController();
  TextEditingController floorNo = new TextEditingController();
  TextEditingController plotArea = new TextEditingController();
  TextEditingController view = new TextEditingController();
  TextEditingController parking = new TextEditingController();
  TextEditingController propertyDeveloper = new TextEditingController();
  TextEditingController transactionNumber = new TextEditingController();

  TextEditingController pricePerSqFt = new TextEditingController();
  TextEditingController totalCommission = new TextEditingController();
  TextEditingController totalDeposit = new TextEditingController();


  double buildUp;
  double price;
  double deposit;




  @override
  void initState(){
    categoryId = widget.catId;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    List permissions = box.read('permissions');
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/anwbackground.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        GestureDetector(
          onTap: _removeFocus,
          onPanDown: (focus) {
            _isPanDown = true;
            _removeFocus();
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            key: _scaffoldKey,
            appBar: AppBar(
              title: Center(
                child: Text(
                  'Update Listing Details',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              backgroundColor: GlobalColors.globalColor(),
            ),
            body: FutureBuilder(
              future: getListingDetails(),
              builder: (BuildContext context,AsyncSnapshot snapshot) {
                print(snapshot);
                if(snapshot.hasData){
                  bool isMandatory = false;
                  getSubmitText(snapshot.data[0]['listing_status']);
                  if(snapshot.data[0]['building_no'] != null && snapshot.data[0]['building_no'] != ''){
                    buildingNo.text = '${snapshot.data[0]['building_no']}';
                  }
                  if(snapshot.data[0]['unit_no'] != null && snapshot.data[0]['unit_no'] != '') {
                    unitNo.text = '${snapshot.data[0]['unit_no']}';
                  }
                  if(snapshot.data[0]['transaction_no'] != null && snapshot.data[0]['transaction_no'] != ''){
                    transactionNumber.text = '${snapshot.data[0]['transaction_no']}';
                  }
                  if(snapshot.data[0]['permit_no']!=null && snapshot.data[0]['permit_no']!= ''){
                    permitNo.text = '${snapshot.data[0]['permit_no']}';
                  }
                  if(snapshot.data[0]['unit_type'] != null && snapshot.data[0]['unit_type'] != ''){
                    unitType.text = '${snapshot.data[0]['unit_type']}';
                  }
                  if(snapshot.data[0]['street_no'] != null && snapshot.data[0]['street_no'] != ''){
                    streetNo.text = '${snapshot.data[0]['street_no']}';
                  }
                  if(snapshot.data[0]['floor'] != null && snapshot.data[0]['floor'] != ''){
                    floorNo.text = '${snapshot.data[0]['floor']}';
                  }
                  if(snapshot.data[0]['plot_area'] != null){
                    plotArea.text = '${snapshot.data[0]['plot_area']}';
                  } else {
                    plotArea.text = null;
                  }
                  if(snapshot.data[0]['view'] != null && snapshot.data[0]['view'] != ''){
                    view.text = '${snapshot.data[0]['view']}';
                  }
                  if(snapshot.data[0]['parking'] != null && snapshot.data[0]['parking'] != ''){
                    parking.text = '${snapshot.data[0]['parking']}';
                  } else {
                    parking.text = null;
                  }
                  if(snapshot.data[0]['property_developer'] != null && snapshot.data[0]['property_developer'] != ''){
                    propertyDeveloper.text = '${snapshot.data[0]['property_developer']}';
                  }
                  TextEditingController builtUpArea = new TextEditingController(text: '${snapshot.data[0]['build_up_area']}');
                  TextEditingController rentalPrice = new TextEditingController(text: '${snapshot.data[0]['price']}');
                  title.text = snapshot.data[0]['title'];
                  description.text = snapshot.data[0]['description'];
                  pricePerSqFt.text = '${double.parse(snapshot.data[0]['price'].toString())/snapshot.data[0]['build_up_area']}';

                  if(snapshot.data[0]['commission'] != null){
                    totalCommission.text = snapshot.data[0]['commission'].toString();
                  }

                  if(snapshot.data[0]['deposit'] != null){
                    totalDeposit.text = snapshot.data[0]['deposit'].toString();
                  }
                  if(snapshot.data[0]['listing_status'] != null && snapshot.data[0]['listing_status'] != '') {
                    status = snapshot.data[0]['listing_status'];
                  }
                  TextEditingController commission = new TextEditingController(text: '${snapshot.data[0]['commission_percent']}');
                  TextEditingController deposit;
                  if(snapshot.data[0]['deposit_percent'] != null){
                    deposit = new TextEditingController(text: '${snapshot.data[0]['deposit_percent']}');
                  } else {
                    deposit = new TextEditingController();
                  }
                  buildUp = double.parse(snapshot.data[0]['build_up_area'].toString());
                  status = snapshot.data[0]['listing_status'].toString();
                  String stat = snapshot.data[0]['listing_status'].toString().toLowerCase();

                  if(permissions.contains('listings_publish')){
                    statusList = updateStatuses('all');
                  } else {
                    statusList = updateStatuses('pending');
                  }
                  categoryId = snapshot.data[0]['category_id'];
                  beds = snapshot.data[0]['beds'];
                  baths = snapshot.data[0]['baths'];
                  nCheques = snapshot.data[0]['cheques'];
                  furnishType = snapshot.data[0]['furnished'];
                  propertyOwner = snapshot.data[0]['property_ownership'];
                  occupancy = snapshot.data[0]['occupancy'];
                  projectStatus = snapshot.data[0]['project_status'];
                  tenure = snapshot.data[0]['tenure'];
                  constructionStatus = snapshot.data[0]['construction_status'];
                  nCheques = snapshot.data[0]['cheques'];
                  if(snapshot.data[0]['listing_status'] == 'Approved'){
                    isMandatory = true;
                  }


                  return Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0,bottom: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'PROPERTY DETAILS',
                                style: AppTextStyles.c16black600(),
                              ),
                            ),
                            //TITLE
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: title,
                                decoration: InputDecoration(
                                    labelText: 'Title *',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Cairo",
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w400,
                                      fontFeatures: <FontFeature>[
                                        FontFeature.superscripts(),
                                      ],
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the title';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //DESCRIPTION
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: description,
                                maxLines: 3,
                                decoration: InputDecoration(
                                    labelText: 'Description *',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Cairo",
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w400,
                                      fontFeatures: <FontFeature>[
                                        FontFeature.superscripts(),
                                      ],
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the description';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //CATEGORY
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width *0.03),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Category *',
                                    style: AppTextStyles.c14grey400(),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.67,
                                    child: DropdownButtonFormField(
                                      items: categories.map((value){
                                        return DropdownMenuItem(
                                          value: value['id'],
                                          child: Text(
                                            value['name'],
                                            style: AppTextStyles.c14grey400(),
                                          ),
                                        );
                                      }).toList(),
                                      value: categoryId,
                                      selectedItemBuilder: (BuildContext context){
                                        return categories.map((value){
                                          return Text(
                                            value['name'],
                                            style: AppTextStyles.c14grey400(),
                                          );
                                        }).toList();
                                      },
                                      hint: Text(
                                        'Select Category',
                                        style: AppTextStyles.c14grey400(),
                                      ),
                                      onChanged: (value){
                                        categoryId = value['id'];
                                        print(categoryId);
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //BEDS
                            if(widget.type == 'Residential')
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width *0.03),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Beds',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.67,
                                          child: DropdownButtonFormField(
                                            items: numberOfBeds.map((value){
                                              return DropdownMenuItem(
                                                value: value['num'],
                                                child: Text(
                                                  value['text'],
                                                  style: AppTextStyles.c14grey400(),
                                                ),
                                              );
                                            }).toList(),
                                            value: beds,
                                            selectedItemBuilder: (BuildContext context){
                                              return numberOfBeds.map((value){
                                                return Text(
                                                  value['text'],
                                                  style: AppTextStyles.c14grey400(),
                                                );
                                              }).toList();
                                            },
                                            onChanged: (value){
                                              beds = value;
                                              print(beds);
                                            },
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

                            //BATHS
                            if(widget.type == 'Residential')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width *0.03),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Baths',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.67,
                                          child: DropdownButtonFormField(
                                            items: numberOfBaths.map((value){
                                              return DropdownMenuItem(
                                                value: value['num'],
                                                child: Text(
                                                  value['text'],
                                                  style: AppTextStyles.c14grey400(),
                                                ),
                                              );
                                            }).toList(),
                                            value: baths,
                                            selectedItemBuilder: (BuildContext context){
                                              return numberOfBaths.map((value){
                                                return Text(
                                                  value['text'],
                                                  style: AppTextStyles.c14grey400(),
                                                );
                                              }).toList();
                                            },
                                            onChanged: (value){
                                              baths = value;
                                              print(baths);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),

                            //BUILDING NUMBER
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: buildingNo,
                                decoration: InputDecoration(
                                    labelText: 'Building Number',
                                    labelStyle: AppTextStyles.c14grey400(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //UNIT NUMBER
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: unitNo,
                                decoration: InputDecoration(
                                    labelText: 'Unit Number *',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Cairo",
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w400,
                                      fontFeatures: <FontFeature>[
                                        FontFeature.superscripts(),
                                      ],
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the Unit Number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //PERMIT NUMBER
                            if(permissions.contains('listings_publish'))
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8,),
                                    child: TextFormField(
                                      controller: permitNo,
                                      decoration: InputDecoration(
                                          labelText: isMandatory?'Permit Number *':'Permit Number',
                                          labelStyle: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "Cairo",
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w400,
                                            fontFeatures: <FontFeature>[
                                              FontFeature.superscripts(),
                                            ],
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: GlobalColors.globalColor()),
                                          ),
                                          focusColor: GlobalColors.globalColor()
                                      ),

                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            if(!permissions.contains('listings_publish'))
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8,),
                                    child: TextFormField(
                                      controller: permitNo,
                                      decoration: InputDecoration(
                                          labelText: 'Permit Number',
                                          labelStyle: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "Cairo",
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w400,
                                            fontFeatures: <FontFeature>[
                                              FontFeature.superscripts(),
                                            ],
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: GlobalColors.globalColor()),
                                          ),
                                          focusColor: GlobalColors.globalColor()
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),

                            //TRANSACTION NUMBER
                            if(permissions.contains('listings_publish'))
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8,),
                                    child: TextFormField(
                                      controller: transactionNumber,
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('([0-9]+(\.[0-9]+)?)')),],
                                      decoration: InputDecoration(
                                          labelText: isMandatory?'Transaction Number *':'Transaction Number',
                                          labelStyle: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "Cairo",
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w400,
                                            fontFeatures: <FontFeature>[
                                              FontFeature.superscripts(),
                                            ],
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: GlobalColors.globalColor()),
                                          ),
                                          focusColor: GlobalColors.globalColor()
                                      ),

                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            if(!permissions.contains('listings_publish'))
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8,),
                                    child: TextFormField(
                                      controller: transactionNumber,
                                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('([0-9]+(\.[0-9]+)?)')),],
                                      decoration: InputDecoration(
                                          labelText: 'Transaction Number',
                                          labelStyle: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "Cairo",
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w400,
                                            fontFeatures: <FontFeature>[
                                              FontFeature.superscripts(),
                                            ],
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: GlobalColors.globalColor()),
                                          ),
                                          focusColor: GlobalColors.globalColor()
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),

                            //UNIT TYPE
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: unitType,
                                decoration: InputDecoration(
                                    labelText: 'Unit Type',
                                    labelStyle: AppTextStyles.c14grey400(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //STREET NUMBER
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: streetNo,

                                decoration: InputDecoration(
                                    labelText: 'Street Number',
                                    labelStyle: AppTextStyles.c14grey400(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //FLOOR
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: floorNo,
                                decoration: InputDecoration(
                                    labelText: 'Floor',
                                    labelStyle: AppTextStyles.c14grey400(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //BUILT-UP AREA
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: builtUpArea,
                                decoration: InputDecoration(
                                    labelText: 'Built-Up Area (sq.ft) *',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Cairo",
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w400,
                                      fontFeatures: <FontFeature>[
                                        FontFeature.superscripts(),
                                      ],
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                                onChanged: (val){
                                  buildUp = double.parse(val);
                                },
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('([0-9]+(\.[0-9]+)?)')),],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the built-up area';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //PLOT AREA
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: plotArea,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('([0-9]+(\.[0-9]+)?)')),],
                                decoration: InputDecoration(
                                    labelText: 'Plot Area',
                                    labelStyle: AppTextStyles.c14grey400(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //VIEW
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: view,

                                decoration: InputDecoration(
                                    labelText: 'View',
                                    labelStyle: AppTextStyles.c14grey400(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //FURNISHED
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Furnishing',
                                        style: AppTextStyles.c14grey400(),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.67,
                                        child: DropdownButtonFormField(
                                          items: furnishing.map((value){
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              ),
                                            );
                                          }).toList(),
                                          value: furnishType,
                                          selectedItemBuilder: (BuildContext context){
                                            return furnishing.map((value){
                                              return Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              );
                                            }).toList();
                                          },
                                          onChanged: (value){
                                            furnishType = value;
                                          },
                                          hint: Text(
                                            'Select Furninshing',
                                            style: AppTextStyles.c14grey400(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),

                            //PARKING
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: parking,
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('([0-9]+(\.[0-9]+)?)')),],
                                decoration: InputDecoration(
                                    labelText: 'Parking',
                                    labelStyle: AppTextStyles.c14grey400(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //PROPERTY DEVELOPER
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: propertyDeveloper,

                                decoration: InputDecoration(
                                    labelText: 'Property Developer',
                                    labelStyle: AppTextStyles.c14grey400(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),

                            //PROPERTY OWNERSHIP
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Property Ownership',
                                        style: AppTextStyles.c12grey400(),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.67,
                                        child: DropdownButtonFormField(
                                          items: propertyOwnershipType.map((value){
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              ),
                                            );
                                          }).toList(),
                                          value: propertyOwner,
                                          selectedItemBuilder: (BuildContext context){
                                            return propertyOwnershipType.map((value){
                                              return Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              );
                                            }).toList();
                                          },
                                          onChanged: (value){
                                            propertyOwner = value;
                                          },
                                          hint: Text(
                                            'Select ownership type',
                                            style: AppTextStyles.c14grey400(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),

                            //OCCUPANCY
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Occupancy',
                                        style: AppTextStyles.c14grey400(),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.67,
                                        child: DropdownButtonFormField(
                                          items: occupancyType.map((value){
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              ),
                                            );
                                          }).toList(),
                                          value: occupancy,
                                          selectedItemBuilder: (BuildContext context){
                                            return occupancyType.map((value){
                                              return Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              );
                                            }).toList();
                                          },
                                          onChanged: (value){
                                            occupancy = value;
                                          },
                                          hint: Text(
                                            'Select occupancy',
                                            style: AppTextStyles.c14grey400(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),

                            //PROJECT STATUS
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Project Status',
                                        style: AppTextStyles.c14grey400(),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.67,
                                        child: DropdownButtonFormField(
                                          items: projectStatusList.map((value){
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              ),
                                            );
                                          }).toList(),
                                          value: projectStatus,
                                          selectedItemBuilder: (BuildContext context){
                                            return projectStatusList.map((value){
                                              return Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              );
                                            }).toList();
                                          },
                                          onChanged: (value){
                                            projectStatus = value;
                                          },
                                          hint: Text(
                                            'Select project status',
                                            style: AppTextStyles.c14grey400(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),

                            //TENURE
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Tenure',
                                        style: AppTextStyles.c14grey400(),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.67,
                                        child: DropdownButtonFormField(
                                          items: tenureList.map((value){
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              ),
                                            );
                                          }).toList(),
                                          value: tenure,
                                          selectedItemBuilder: (BuildContext context){
                                            return tenureList.map((value){
                                              return Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              );
                                            }).toList();
                                          },
                                          onChanged: (value){
                                            tenure = value;
                                          },
                                          hint: Text(
                                            'Select tenure',
                                            style: AppTextStyles.c14grey400(),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),

                            //CONSTRUCTION STATUS
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Construction Status',
                                        style: AppTextStyles.c12grey400(),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.67,
                                        child: DropdownButtonFormField(
                                          items: constructionStatusList.map((value){
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              ),
                                            );
                                          }).toList(),
                                          value: constructionStatus,
                                          selectedItemBuilder: (BuildContext context){
                                            return constructionStatusList.map((value){
                                              return Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              );
                                            }).toList();
                                          },
                                          hint: Text(
                                            'Select construction status',
                                            style: AppTextStyles.c14grey400(),
                                          ),
                                          onChanged: (value){
                                            constructionStatus = value;
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),

                            Divider(),
                            //Property Pricing
                            Center(
                              child: Text(
                                'PROPERTY PRICING',
                                style: AppTextStyles.c16black600(),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //Rental Price
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: rentalPrice,
                                decoration: InputDecoration(
                                    labelText: 'Rental Price *',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Cairo",
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w400,
                                      fontFeatures: <FontFeature>[
                                        FontFeature.superscripts(),
                                      ],
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [FilteringTextInputFormatter.allow(RegExp('([0-9]+(\.[0-9]+)?)')),],
                                onChanged: (val){
                                  double rentPrice = double.parse(val);
                                  print(rentPrice);
                                  double pricePerSqft = rentPrice/buildUp;
                                  print(pricePerSqft);
                                  pricePerSqFt.text = '${pricePerSqft.toStringAsFixed(2)}';
                                  /*if(snapshot.data[0]['commission_percentage'] != null){
                                    double commissionPercentage = double.parse(commission.text);
                                    double commission = (commissionPercentage/100) * rentPrice ;
                                  }*/
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the built-up area';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //Price / Sq.ft
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: TextField(
                                readOnly: true,
                                controller: pricePerSqFt,
                                decoration: InputDecoration(
                                    labelText: 'Price / SqFt (AED)',
                                    labelStyle: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: "Cairo",
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w400,
                                      fontFeatures: <FontFeature>[
                                        FontFeature.superscripts(),
                                      ],
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //FREQUENCY
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Frequency',
                                        style: AppTextStyles.c14grey400(),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.67,
                                        child: DropdownButtonFormField(
                                          items: frequencyList.map((value){
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              ),
                                            );
                                          }).toList(),
                                          value: frequency,
                                          selectedItemBuilder: (BuildContext context){
                                            return frequencyList.map((value){
                                              return Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              );
                                            }).toList();
                                          },
                                          onChanged: (value){
                                            frequency = value;
                                          },
                                          hint: Text(
                                            'Select Frequency',
                                            style: AppTextStyles.c14grey400(),
                                          ),
                                        ),
                                      )
                                    ],
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                              ],
                            ),

                            //CHEQUES
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Cheques',
                                        style: AppTextStyles.c14grey400(),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.67,
                                        child: DropdownButtonFormField(
                                          items: numberOfCheques.map((value){
                                            return DropdownMenuItem(
                                              value: value['num'],
                                              child: Text(
                                                value['text'],
                                                style: AppTextStyles.c14grey400(),
                                              ),
                                            );
                                          }).toList(),
                                          value: nCheques,
                                          selectedItemBuilder: (BuildContext context){
                                            return numberOfCheques.map((value){
                                              return Text(
                                                value['text'],
                                                style: AppTextStyles.c14grey400(),
                                              );
                                            }).toList();
                                          },
                                          hint: Text(
                                            'Select number of cheques',
                                            style: AppTextStyles.c14grey400(),
                                          ),
                                          onChanged: (value){
                                            nCheques = value;
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),

                            //COMMISSION
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: commission,
                                decoration: InputDecoration(
                                    labelText: 'Commission %',
                                    labelStyle: AppTextStyles.c14grey400(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                                onChanged: (val){
                                  double rentPrice = double.parse(rentalPrice.text);
                                  double commissionPercentage = double.parse(val);
                                  double commission = (commissionPercentage/100) * rentPrice ;
                                  totalCommission.text = '${commission.toStringAsFixed(2)}';
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //TOTAL COMMISSION
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                readOnly: true,
                                controller: totalCommission,
                                decoration: InputDecoration(
                                    labelText: 'Total Commission (AED)',
                                    labelStyle: AppTextStyles.c14grey400(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //DEPOSIT
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                controller: deposit,
                                decoration: InputDecoration(
                                    labelText: 'Deposit %',
                                    labelStyle: AppTextStyles.c14grey400(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                                onChanged: (val){
                                  double rentPrice = double.parse(rentalPrice.text);
                                  double depositPercentage = double.parse(val);
                                  double deposit = (depositPercentage/100) * rentPrice ;
                                  totalDeposit.text = '${deposit.toStringAsFixed(2)}';
                                },
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //TOTAL DEPOSIT
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8,),
                              child: TextFormField(
                                readOnly: true,
                                controller: totalDeposit,
                                decoration: InputDecoration(
                                    labelText: 'Total Deposit (AED)',
                                    labelStyle: AppTextStyles.c14grey400(),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: GlobalColors.globalColor()),
                                    ),
                                    focusColor: GlobalColors.globalColor()
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //Status
                            Divider(),
                            Center(
                              child: Text(
                                'STATUS',
                                style: AppTextStyles.c16black600(),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),

                            //LISTING STATUS
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Listing Status *',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: "Cairo",
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w400,
                                          fontFeatures: <FontFeature>[
                                            FontFeature.superscripts(),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.67,
                                        child: DropdownButtonFormField(
                                          items: statusList.map((value){
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              ),
                                            );
                                          }).toList(),
                                          value: status,
                                          selectedItemBuilder: (BuildContext context){
                                            return statusList.map((value){
                                              return Text(
                                                value,
                                                style: AppTextStyles.c14grey400(),
                                              );
                                            }).toList();
                                          },
                                          hint: Text(
                                            'Select Listing Status',
                                            style: AppTextStyles.c14grey400(),
                                          ),
                                          onChanged: (value){
                                            status = value;
                                            getSubmitText(status);
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                ),

                                //SUBMIT
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () async {

                                      if (_formKey.currentState.validate()) {
                                        ListingUpdateController luc = ListingUpdateController(id: widget.id);
                                        bool updateComplete;
                                        print(categoryId);
                                        if(status == 'Approved'){
                                          updateComplete = await luc.updateListing(title.text, description.text, snapshot.data[0]['assigned_to_id'], beds, baths, builtUpArea.text, buildingNo.text, categoryId,nCheques, snapshot.data[0]['city_id'], totalCommission.text, commission.text, null, null, constructionStatus, totalDeposit.text, deposit.text, floorNo.text, frequency, furnishType, snapshot.data[0]['is_exclusive'], snapshot.data[0]['is_featured'], snapshot.data[0]['is_invite'],snapshot.data[0]['is_managed'], snapshot.data[0]['is_poa'], snapshot.data[0]['is_premium'], snapshot.data[0]['is_tenanted'], snapshot.data[0]['language_id'], status, snapshot.data[0]['location_id'], occupancy, snapshot.data[0]['owner_id'], parking.text, snapshot.data[0]['payment_plan'], permitNo.text, plotArea.text, 'Published', rentalPrice.text, pricePerSqFt.text, projectStatus, propertyDeveloper.text, propertyOwner, snapshot.data[0]['property_type'], snapshot.data[0]['scheduled_date'], snapshot.data[0]['source_id'], streetNo.text, snapshot.data[0]['sub_location_id'],snapshot.data[0]['tenant_id'], tenure, widget.type, transactionNumber.text, unitNo.text, view.text);
                                        } else if(status == "Pending" && snapshot.data[0]['portal_status'] == 'Published'){
                                          updateComplete = await luc.updateListing(title.text, description.text, snapshot.data[0]['assigned_to_id'], beds, baths, builtUpArea.text, buildingNo.text, categoryId,nCheques, snapshot.data[0]['city_id'], totalCommission.text, commission.text, null, null, constructionStatus, totalDeposit.text, deposit.text, floorNo.text, frequency, furnishType, snapshot.data[0]['is_exclusive'], snapshot.data[0]['is_featured'], snapshot.data[0]['is_invite'],snapshot.data[0]['is_managed'], snapshot.data[0]['is_poa'], snapshot.data[0]['is_premium'], snapshot.data[0]['is_tenanted'], snapshot.data[0]['language_id'], status, snapshot.data[0]['location_id'], occupancy, snapshot.data[0]['owner_id'], parking.text, snapshot.data[0]['payment_plan'], permitNo.text, plotArea.text, 'Published', rentalPrice.text, pricePerSqFt.text, projectStatus, propertyDeveloper.text, propertyOwner, snapshot.data[0]['property_type'], snapshot.data[0]['scheduled_date'], snapshot.data[0]['source_id'], streetNo.text, snapshot.data[0]['sub_location_id'],snapshot.data[0]['tenant_id'], tenure, widget.type, transactionNumber.text, unitNo.text, view.text);
                                        } else {
                                          updateComplete = await luc.updateListing(title.text, description.text, snapshot.data[0]['assigned_to_id'], beds, baths, builtUpArea.text, buildingNo.text, categoryId,nCheques, snapshot.data[0]['city_id'], totalCommission.text, commission.text, null, null, constructionStatus, totalDeposit.text, deposit.text, floorNo.text, frequency, furnishType, snapshot.data[0]['is_exclusive'], snapshot.data[0]['is_featured'], snapshot.data[0]['is_invite'],snapshot.data[0]['is_managed'], snapshot.data[0]['is_poa'], snapshot.data[0]['is_premium'], snapshot.data[0]['is_tenanted'], snapshot.data[0]['language_id'], status, snapshot.data[0]['location_id'], occupancy, snapshot.data[0]['owner_id'], parking.text, snapshot.data[0]['payment_plan'], permitNo.text, plotArea.text, 'Unpublished', rentalPrice.text, pricePerSqFt.text, projectStatus, propertyDeveloper.text, propertyOwner, snapshot.data[0]['property_type'], snapshot.data[0]['scheduled_date'], snapshot.data[0]['source_id'], streetNo.text, snapshot.data[0]['sub_location_id'],snapshot.data[0]['tenant_id'], tenure, widget.type, transactionNumber.text, unitNo.text, view.text);
                                        }
                                        if((title.text == null || description.text == null || categoryId == null || unitNo.text == null) && ((snapshot.data[0]['listing_status'] == 'Approved' || status == 'Approved') && isMandatory && (permitNo.text == null || transactionNumber.text == null))){
                                          Fluttertoast.showToast(
                                              msg: 'Please enter the required fields',
                                              gravity: ToastGravity.BOTTOM,
                                              toastLength: Toast.LENGTH_LONG,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.black
                                          );
                                        }
                                        if(updateComplete){
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                              msg: 'Successfully updated',
                                              gravity: ToastGravity.BOTTOM,
                                              toastLength: Toast.LENGTH_LONG,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.black
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'An Error occurred',
                                              gravity: ToastGravity.BOTTOM,
                                              toastLength: Toast.LENGTH_LONG,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.black
                                          );
                                        }
                                      }
                                    },
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor()),
                                        foregroundColor: MaterialStateProperty.all(GlobalColors.globalColor())
                                    ),
                                    child: Text(
                                      'Save Changes',
                                      style: AppTextStyles.c16white600(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),

                                //UNPUBLISH
                                if(permissions.contains('listings_unpublish') && snapshot.data[0]['portal_status'] == 'Published')
                                  Column(
                                    children: [
                                      Center(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            bool isUpdated;
                                            int categoryId;
                                            if (_formKey.currentState.validate()) {
                                              ListingUpdateController luc = ListingUpdateController(id: widget.id);
                                              print(categoryId);
                                              bool updateComplete = await luc.updateListing(title.text, description.text, snapshot.data[0]['assigned_to_id'], beds, baths, builtUpArea.text, buildingNo.text, categoryId, nCheques, snapshot.data[0]['city_id'], totalCommission.text, commission.text, null, null, constructionStatus, totalDeposit.text, deposit.text, floorNo.text, frequency, furnishType, snapshot.data[0]['is_exclusive'], snapshot.data[0]['is_featured'], snapshot.data[0]['is_invite'],snapshot.data[0]['is_managed'], snapshot.data[0]['is_poa'], snapshot.data[0]['is_premium'], snapshot.data[0]['is_tenanted'], snapshot.data[0]['language_id'], status, snapshot.data[0]['location_id'], occupancy, snapshot.data[0]['owner_id'], parking.text, snapshot.data[0]['payment_plan'], permitNo.text, plotArea.text, 'Unpublished', rentalPrice.text, pricePerSqFt.text, projectStatus, propertyDeveloper.text, propertyOwner, snapshot.data[0]['property_type'], snapshot.data[0]['scheduled_date'], snapshot.data[0]['source_id'], streetNo.text, snapshot.data[0]['sub_location_id'],snapshot.data[0]['tenant_id'], tenure, widget.type, transactionNumber.text, unitNo.text, view.text);
                                              if(updateComplete){
                                                Navigator.pop(context);
                                                Fluttertoast.showToast(
                                                    msg: 'Successfully updated',
                                                    gravity: ToastGravity.BOTTOM,
                                                    toastLength: Toast.LENGTH_LONG,
                                                    backgroundColor: Colors.green,
                                                    textColor: Colors.black
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: 'An Error occurred',
                                                    gravity: ToastGravity.BOTTOM,
                                                    toastLength: Toast.LENGTH_LONG,
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.black
                                                );
                                              }
                                            }
                                          },
                                          style: ButtonStyle(
                                              backgroundColor: MaterialStateProperty.all(Colors.red.shade900),
                                              foregroundColor: MaterialStateProperty.all(Colors.red.shade900)
                                          ),
                                          child: Text(
                                            'Unpublish Listing',
                                            style: AppTextStyles.c16white600(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(child: NetworkLoading(),);
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  void getSubmitText(String status){
    switch(status){
      case 'Draft':
        {
          submitStatus = 'Save Draft';
        }
        break;
      case 'Pending':
        {
          submitStatus = 'Send for Approval';
          submitUnpublished = 'Unpublish';
        }
        break;
      case 'Approved':
        {
          submitStatus = 'Approve & Publish';
          submitUnpublished = 'Approve & Unpublish';
        }
        break;
      case 'Rejected':
        {
          submitStatus = 'Reject';
          submitUnpublished = 'Reject & Unpublish';
        }
        break;
      case 'Closed':
        {
          submitStatus = 'Close';
        }
        break;
      case 'Scheduled':
        {
          submitStatus = 'Schedule';
        }
        break;
      default:
        {
          submitStatus = 'Save';
        }
        break;
    }
  }

  void _removeFocus() {
    if (_isDropDownOpened) {
      setState(() {
        _isBackPressedOrTouchedOutSide = true;
      });
    }
  }

  void _onDrawerBtnPressed() {
    if (_isDropDownOpened) {
      setState(() {
        _isBackPressedOrTouchedOutSide = true;
      });
    } else {
      _scaffoldKey.currentState.openEndDrawer();
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }
}