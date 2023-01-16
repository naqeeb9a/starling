import 'dart:async';
import 'dart:convert';

import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:crm_app/CodeSnippets/CurrencyCheck.dart';
import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/CodeSnippets/LaunchUrlSnippet.dart';
import 'package:crm_app/Views/listings/ListingDetailsLandingPage.dart';
import 'package:crm_app/controllers/editLeadController.dart';
import 'package:crm_app/controllers/leadsController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/LeadsSubStatusColors.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'LeadsDetailsDashboardPage.dart';

class LeadsDetailsPage extends StatefulWidget {

  final int id;
  final bool isTitle;
  LeadsDetailsPage({this.id,this.isTitle});

  @override
  _LeadsDetailsPageState createState() => _LeadsDetailsPageState();
}

class _LeadsDetailsPageState extends State<LeadsDetailsPage> {
  Future<List<dynamic>> getLeads(){
    LeadsDetails lc = LeadsDetails();
    return lc.getLeadsDetails(widget.id);
  }

  DateTimeConversion dateTimeConversion = DateTimeConversion();

  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var data;

  LaunchUrlSnippet launchApp = LaunchUrlSnippet();

  TextEditingController notesController = TextEditingController();

  List<String> statusList = ['Called No reply','In Progress','Invalid Inquiry','Invalid Number','Not Interested','Not Yet Contacted','Offer Made','Prospect','Successful','Unsuccessful','Viewing'];
  String status;
  String setStatus = 'In Progress';
  int val = -1;


  @override
  Widget build(BuildContext context) {

    List<DropdownMenuItem<String>> statList = statusList.map((String value){
      return DropdownMenuItem<String>(
        child: Center(child: Text(value)),
        value: value,
      );
    }).toList();
    return GestureDetector(
      onTap: _removeFocus,
      onPanDown: (focus) {
        _isPanDown = true;
        _removeFocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: FutureBuilder(
          future: getLeads(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              // setStatus = snapshot.data[0]['sub_status'];
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //SUB STATUS
                            Row(
                              children: [
                                Icon(Icons.circle,size: 10, color: leadsSubStatusColor(snapshot.data[0]['sub_status']),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    '${snapshot.data[0]['sub_status']}',
                                    style: TextStyle(
                                      color: leadsSubStatusColor(snapshot.data[0]['sub_status']),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Cairo'
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if(!widget.isTitle)
                              Row(
                                children: [
                                  Text(
                                    'Ref: ${snapshot.data[0]['reference']}',
                                    style: AppTextStyles.c16black500(),
                                  )
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.circle,size: 10, color: Colors.yellow.shade600,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: Text(
                                    '${snapshot.data[0]['priority']}',
                                    style: TextStyle(
                                      color: Colors.yellow.shade600,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Cairo'
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                '${snapshot.data[0]['client']['full_name']}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w600
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(child: Text('Enquiry date: ${dateTimeConversion.getDDMMMYYY(snapshot.data[0]['enquiry_date'])}', style: AppTextStyles.c14grey400(),maxLines: 2,))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          children: [
                            RawChip(
                              backgroundColor: Colors.grey,
                              label: Text('${snapshot.data[0]['type']}'),
                              labelStyle: AppTextStyles.c14black500(),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            RawChip(
                              backgroundColor: Colors.grey,
                              label: snapshot.data[0]['source']!=null?Text('${snapshot.data[0]['lead_source']} (${snapshot.data[0]['source']['name']})'):Text('${snapshot.data[0]['lead_source']}'),
                              labelStyle: AppTextStyles.c14black500(),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            snapshot.data[0]['created_by_id'] == null?'Created by: System':'Created by: ${snapshot.data[0]['creator']['full_name']}',
                            style: AppTextStyles.c12grey400(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          'CONTACT DETAILS: ',
                          style: AppTextStyles.c20black400(),
                        ),
                      ),
                      snapshot.data[0]['client']['mobile']!= null?InkWell(
                        onTap: () async {
                          _callNumber(snapshot.data[0]['client']['mobile']);
                          Future.delayed(Duration(seconds: 4),(){
                            showGeneralDialog(
                              barrierLabel: "Barrier",
                              barrierDismissible: true,
                              barrierColor: Colors.black.withOpacity(0.5),
                              transitionDuration: Duration(milliseconds: 700),
                              context: context,
                              pageBuilder: (_, __, ___) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                                    child: Container(

                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              'Update Lead: ${snapshot.data[0]['client']['full_name']}',
                                              style: AppTextStyles.c18black500(),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height *0.03,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                                                child: Text(
                                                  'Status:',
                                                  style: AppTextStyles.c14grey400(),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05),
                                                child: Container(
                                                  // decoration: BoxDecoration(
                                                  //     border: Border.all(width: 0.7),
                                                  //     borderRadius: BorderRadius.circular(15)
                                                  // ),
                                                  width: MediaQuery.of(context).size.width * 0.6,
                                                  child: DropdownButtonHideUnderline(
                                                    child: AwesomeDropDown(
                                                      dropDownList: statusList,
                                                      dropDownIcon: Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Colors.black,
                                                        size: 23,
                                                      ),
                                                      elevation: 1,
                                                      dropDownBorderRadius: 0,
                                                      dropDownTopBorderRadius: 0,
                                                      dropDownBottomBorderRadius: 0,
                                                      dropDownIconBGColor: Colors.transparent,
                                                      dropDownOverlayBGColor: Colors.transparent,
                                                      dropDownBGColor: Colors.white,
                                                      selectedItem: snapshot.data[0]['sub_status'],
                                                      onDropDownItemClick: (val){
                                                        status = val;
                                                        print(status);
                                                      },
                                                      isPanDown: _isPanDown,
                                                      isBackPressedOrTouchedOutSide: _isBackPressedOrTouchedOutSide,
                                                      dropStateChanged: (isOpened) {
                                                        _isDropDownOpened = isOpened;
                                                        if (!isOpened) {
                                                          _isBackPressedOrTouchedOutSide = false;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height *0.01,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                                            child: Text(
                                              'Notes :',
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                fontFamily: "Cairo",
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.w400,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height * 0.015,
                                          ),
                                          Material(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(width: 0.7),
                                                    borderRadius: BorderRadius.circular(15)
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8.2),
                                                  child: TextField(
                                                    decoration: InputDecoration(
                                                        border: InputBorder.none
                                                    ),
                                                    controller: notesController,
                                                    style: AppTextStyles.c14grey400(),
                                                    keyboardType: TextInputType.multiline,
                                                    maxLines: 3,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context).size.height *0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              TextButton(
                                                onPressed: (){
                                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                                                },
                                                child: Center(
                                                  child: Text(
                                                    'Cancel',
                                                    style: AppTextStyles.c14black500(),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  EditLeadController elc = EditLeadController(id: widget.id);
                                                  bool postedStatus = await elc.updateStatus(status);
                                                  print(postedStatus);
                                                  /*setState(() {
                                                    Navigator.of(context,rootNavigator: true).pop('dialog');
                                                  });*/
                                                  bool postedNotes = false;
                                                  if(notesController.text != null && notesController.text != ''){
                                                    postedNotes = await elc.sendNote(notesController.text);
                                                    if(postedStatus && postedNotes){
                                                      Fluttertoast.showToast(
                                                          msg: 'Status updated successfully',
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                          backgroundColor: Colors.green,
                                                          textColor: Colors.white
                                                      );
                                                      Navigator.of(context,rootNavigator: true).pop('dialog');
                                                    } else if(postedStatus == true && postedNotes == false){
                                                      Fluttertoast.showToast(
                                                          msg: 'Status updated successfully, Notes not updated due to error',
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                          backgroundColor: Colors.red,
                                                          textColor: Colors.white
                                                      );
                                                      Navigator.of(context,rootNavigator: true).pop();
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: 'Error! Status did not update',
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                          backgroundColor: Colors.red,
                                                          textColor: Colors.white
                                                      );
                                                      Navigator.of(context,rootNavigator: true).pop('dialog');
                                                    }
                                                    // Navigator.of(context,rootNavigator: true).pop('dialog');
                                                  }
                                                },
                                                child: Center(
                                                  child: Text(
                                                    'Submit',
                                                    style: AppTextStyles.c14black500(),
                                                  ),
                                                ),
                                              ),

                                            ],
                                          )
                                        ],
                                      ),
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
                          });
                          // launchApp.launchCall('tel:${snapshot.data[0]['client']['mobile']}');
                        },
                        child: RawChip(
                          backgroundColor: Colors.grey,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.phone,size: 15,),
                              SizedBox(
                                width: 5,
                              ),
                              Text('${snapshot.data[0]['client']['mobile']}'),
                            ],
                          ),
                          labelStyle: AppTextStyles.c14black500(),
                        ),
                      ):SizedBox(width: 0,height: 0,),
                      (snapshot.data[0]['client']['phone']!=null && snapshot.data[0]['client']['phone']!= '971' && snapshot.data[0]['client']['phone'] != '')?InkWell(
                        onTap: () async {
                          _callNumber(snapshot.data[0]['client']['phone']);
                          setState(() {
                            showGeneralDialog(
                              barrierLabel: "Barrier",
                              barrierDismissible: true,
                              barrierColor: Colors.black.withOpacity(0.5),
                              transitionDuration: Duration(milliseconds: 700),
                              context: context,
                              pageBuilder: (_, __, ___) {
                                return Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(),
                                );
                              },
                              transitionBuilder: (_, anim, __, child) {
                                return SlideTransition(
                                  position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
                                  child: child,
                                );
                              },
                            );
                          });
                          // launchApp.launchCall('tel:${snapshot.data[0]['client']['phone']}');
                        },
                        child: RawChip(
                          backgroundColor: Colors.grey,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.tablet_android,size: 15,),
                              SizedBox(
                                width: 5,
                              ),
                              Text('${snapshot.data[0]['client']['phone']}'),
                            ],
                          ),
                          labelStyle: AppTextStyles.c14black500(),
                        ),
                      ):SizedBox(width: 0,height: 0,),
                      (snapshot.data[0]['client']['email']!=null && snapshot.data[0]['client']['email'] != '')?InkWell(
                        onTap: (){
                          launchApp.launchmail('${snapshot.data[0]['client']['email']}');
                        },
                        child: RawChip(
                          backgroundColor: Colors.grey,
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.email,size: 15,),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(child: Text('${snapshot.data[0]['client']['email']}',maxLines: 2,overflow: TextOverflow.ellipsis,)),
                            ],
                          ),
                          labelStyle: AppTextStyles.c14black500(),
                        ),
                      ):SizedBox(width: 0,height: 0,),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        height: 0.2,
                        thickness: 0.7,
                        color: Colors.grey,
                      ),
                      (snapshot.data[0]['listing'] != null)?GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListingDetailsLandingPage(title: snapshot.data[0]['listing']['reference'], id: snapshot.data[0]['listing']['id'],selectedIndex: 0,)));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              'PROPERTY DETAILS: ',
                              style: AppTextStyles.c20black400(),
                            ),
                          ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                children: [
                                  RawChip(
                                    backgroundColor: Colors.grey,
                                    label: Text('${snapshot.data[0]['listing']['reference']}'),
                                    labelStyle: AppTextStyles.c14black500(),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  RawChip(
                                    backgroundColor: Colors.grey,
                                    label: Text('${snapshot.data[0]['listing']['property_for']}'),
                                    labelStyle: AppTextStyles.c14black500(),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  RawChip(
                                    backgroundColor: Colors.grey,
                                    label: Text('${snapshot.data[0]['listing']['category']['name']}'),
                                    labelStyle: AppTextStyles.c14black500(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                children: [
                                  (snapshot.data[0]['listing']['beds'] != null && snapshot.data[0]['listing']['beds'] != '')?RawChip(
                                    backgroundColor: Colors.grey,
                                    label: Text('${snapshot.data[0]['listing']['beds']} beds'),
                                    labelStyle: AppTextStyles.c14black500(),
                                  ):SizedBox(width: 0,height: 0,),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  (snapshot.data[0]['listing']['furnished'] != null && snapshot.data[0]['listing']['furnished'] != '')?RawChip(
                                    backgroundColor: Colors.grey,
                                    label: Text('${snapshot.data[0]['listing']['furnished']}'),
                                    labelStyle: AppTextStyles.c14black500(),
                                  ):SizedBox(width: 0,height: 0,),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  RawChip(
                                    backgroundColor: Colors.grey,
                                    label: Text('AED ${FormatCurrency().CurrencyCheck(double.parse(snapshot.data[0]['listing']['price']))}'),
                                    labelStyle: AppTextStyles.c14black500(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                children: [
                                  RawChip(
                                    backgroundColor: Colors.grey,
                                    label: Text('${snapshot.data[0]['listing']['property_location']}'),
                                    labelStyle: AppTextStyles.c14black500(),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(
                              height: 0.2,
                              thickness: 0.7,
                              color: Colors.grey,
                            ),

                          ],
                        ),
                      ):SizedBox(width: 0,height: 0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              'STATUS HISTORY: ',
                              style: AppTextStyles.c20black400(),
                            ),
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: GlobalColors.globalColor()
                                )
                            ),
                            onPressed: () async {
                              showGeneralDialog(
                                barrierLabel: "Barrier",
                                barrierDismissible: true,
                                barrierColor: Colors.black.withOpacity(0.5),
                                transitionDuration: Duration(milliseconds: 700),
                                context: context,
                                pageBuilder: (_, __, ___) {
                                  return Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                                      child: Container(

                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Text(
                                                'Update Lead Status: ${snapshot.data[0]['client']['full_name']}',
                                                style: AppTextStyles.c18black500(),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height *0.03,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                                                  child: Text(
                                                    'Status:',
                                                    style: AppTextStyles.c14grey400(),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.05),
                                                  child: Container(
                                                    // decoration: BoxDecoration(
                                                    //     border: Border.all(width: 0.7),
                                                    //     borderRadius: BorderRadius.circular(15)
                                                    // ),
                                                    width: MediaQuery.of(context).size.width * 0.6,
                                                    child: DropdownButtonHideUnderline(
                                                      child: AwesomeDropDown(
                                                        dropDownList: statusList,
                                                        dropDownIcon: Icon(
                                                          Icons.arrow_drop_down,
                                                          color: Colors.black,
                                                          size: 23,
                                                        ),
                                                        elevation: 1,
                                                        dropDownBorderRadius: 0,
                                                        dropDownTopBorderRadius: 0,
                                                        dropDownBottomBorderRadius: 0,
                                                        dropDownIconBGColor: Colors.transparent,
                                                        dropDownOverlayBGColor: Colors.transparent,
                                                        dropDownBGColor: Colors.white,
                                                        selectedItem: snapshot.data[0]['sub_status'],
                                                        onDropDownItemClick: (val){
                                                          status = val;
                                                          print(status);
                                                        },
                                                        isPanDown: _isPanDown,
                                                        isBackPressedOrTouchedOutSide: _isBackPressedOrTouchedOutSide,
                                                        dropStateChanged: (isOpened) {
                                                          _isDropDownOpened = isOpened;
                                                          if (!isOpened) {
                                                            _isBackPressedOrTouchedOutSide = false;
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height *0.01,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.05),
                                              child: Text(
                                                'Notes :',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontFamily: "Cairo",
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height * 0.015,
                                            ),
                                            Material(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.04),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(width: 0.7),
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 8.2),
                                                    child: TextField(
                                                      decoration: InputDecoration(
                                                          border: InputBorder.none
                                                      ),
                                                      controller: notesController,
                                                      style: AppTextStyles.c14grey400(),
                                                      keyboardType: TextInputType.multiline,
                                                      maxLines: 3,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context).size.height *0.01,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                TextButton(
                                                  onPressed: (){
                                                    Navigator.of(context, rootNavigator: true).pop('dialog');
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      'Cancel',
                                                      style: AppTextStyles.c14black500(),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    EditLeadController elc = EditLeadController(id: widget.id);
                                                    bool postedStatus = await elc.updateStatus(status);
                                                    print(postedStatus);
                                                    /*setState(() {
                                                    Navigator.of(context,rootNavigator: true).pop('dialog');
                                                  });*/
                                                    bool postedNotes = false;
                                                    if(notesController.text != null && notesController.text != ''){
                                                      postedNotes = await elc.sendNote(notesController.text);
                                                      if(postedStatus && postedNotes){
                                                        Fluttertoast.showToast(
                                                            msg: 'Status updated successfully',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.BOTTOM,
                                                            backgroundColor: Colors.green,
                                                            textColor: Colors.white
                                                        );
                                                        Navigator.of(context,rootNavigator: true).pop('dialog');
                                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LeadsDetailsDashboard(id: widget.id,title: snapshot.data[0]['reference'],)));
                                                      } else if(postedStatus == true && postedNotes == false){
                                                        Fluttertoast.showToast(
                                                            msg: 'Status updated successfully, Notes not updated due to error',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.BOTTOM,
                                                            backgroundColor: Colors.red,
                                                            textColor: Colors.white
                                                        );
                                                        Navigator.of(context,rootNavigator: true).pop('dialog');
                                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LeadsDetailsDashboard(id: widget.id,title: snapshot.data[0]['reference'],)));
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg: 'Error! Status did not update',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.BOTTOM,
                                                            backgroundColor: Colors.red,
                                                            textColor: Colors.white
                                                        );
                                                        Navigator.of(context,rootNavigator: true).pop('dialog');
                                                      }
                                                      // Navigator.of(context,rootNavigator: true).pop('dialog');
                                                    } else {
                                                      if(postedStatus){
                                                        Fluttertoast.showToast(
                                                            msg: 'Status updated successfully',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.BOTTOM,
                                                            backgroundColor: Colors.green,
                                                            textColor: Colors.white
                                                        );
                                                        Navigator.of(context,rootNavigator: true).pop('dialog');
                                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LeadsDetailsDashboard(id: widget.id,title: snapshot.data[0]['reference'],)));
                                                      }
                                                    }
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      'Submit',
                                                      style: AppTextStyles.c14black500(),
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            )
                                          ],
                                        ),
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
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: GlobalColors.globalColor(),
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  'Update Status',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Cairo',
                                    color: GlobalColors.globalColor()
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      for(int i = 0;i < snapshot.data[0]['status_history'].length; i++)
                        Card(
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
                                    Row(
                                      children: [
                                        Icon(Icons.circle,size: 9,color: leadsSubStatusColor(snapshot.data[0]['status_history'][i]['sub_status']),),
                                        Padding(
                                          padding:EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            '${snapshot.data[0]['status_history'][i]['sub_status']}',
                                            style: TextStyle(
                                                color: leadsSubStatusColor(snapshot.data[0]['status_history'][i]['sub_status']),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Cairo'
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${dateTimeConversion.getDDMMMYYY(snapshot.data[0]['status_history'][i]['created_at'])}',
                                      style: AppTextStyles.c14grey400(),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                child: Text(
                                  snapshot.data[0]['status_history'][i]['created_by_id'] == null?'Created by: System':'Created by: ${snapshot.data[0]['status_history'][i]['created_by_id']}',
                                  style: AppTextStyles.c16black500(),
                                ),
                              ),
                              /*Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 5),
                                      child: Text(
                                        'By: ${snapshot.data[0][i]['user']['full_name']}',
                                        style: AppTextStyles.c12grey400(),
                                      ),
                                    )*/
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: AnimatedSearch(),);
            }
          },
        ),
      ),
    );
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

  _callNumber(String phone) async {
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

