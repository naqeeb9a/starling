import 'dart:convert';

import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/CodeSnippets/LaunchUrlSnippet.dart';
import 'package:crm_app/controllers/editLeadController.dart';
import 'package:crm_app/controllers/leadsController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/LeadsSubStatusColors.dart';
import 'package:crm_app/widgets/ColorFunctions/PriorityColors.dart';
import 'package:crm_app/widgets/loaders/CircularLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewLeadDetailPage extends StatefulWidget {

  final int id;
  NewLeadDetailPage({this.id});

  @override
  _NewLeadDetailPageState createState() => _NewLeadDetailPageState();
}

class _NewLeadDetailPageState extends State<NewLeadDetailPage> {

  Future<List<dynamic>> getLeads(){
    LeadsDetails lc = LeadsDetails();
    return lc.getLeadsDetails(widget.id);
  }


  LaunchUrlSnippet launchApp = LaunchUrlSnippet();

  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false;

  List<String> statusList = ['Called No reply','In Progress','Invalid Inquiry','Invalid Number','Not Interested','Not Yet Contacted','Offer Made','Prospect','Successful','Unsuccessful','Viewing'];
  String status;
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getLeads(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          return GestureDetector(
            onTap: _removeFocus,
            onPanDown: (focus) {
              _isPanDown = true;
              _removeFocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(color: Color(0xFFDCDADA), width: 2),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFFFFFFF),
                        ),


                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 2.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                                  color: GlobalColors.globalColor(),
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),
                                      child: Text(
                                        'LEAD CONTACT',
                                        style: AppTextStyles.c16white600(),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.account_circle,
                                          color: GlobalColors.globalColor(),
                                          size: 55
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            '${snapshot.data[0]['client']['full_name']}',
                                            style: AppTextStyles.c16black600(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      snapshot.data[0]['client']!=null&&snapshot.data[0]['client']['mobile']!=null&&snapshot.data[0]['client']['mobile']!=''? Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              launchApp.launchWhatsapp('${snapshot.data[0]['client']['mobile']}');
                                            },
                                            child: Image.asset('assets/images/whatsapp.png',scale: 2),
                                          ),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          GestureDetector(
                                            onTap: (){
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
                                                              borderRadius: BorderRadius.circular(15)
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
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(
                                                                  horizontal: MediaQuery.of(context).size.width * 0.05
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'Status:',
                                                                      style: AppTextStyles.c14grey400(),
                                                                    ),
                                                                    Container(
                                                                      // decoration: BoxDecoration(
                                                                      //     border: Border.all(width: 0.7),
                                                                      //     borderRadius: BorderRadius.circular(15)
                                                                      // ),
                                                                      width: MediaQuery.of(context).size.width * 0.6,
                                                                      child: DropdownButtonFormField(
                                                                        items: statusList.map((value){
                                                                          return DropdownMenuItem(
                                                                            value: status,
                                                                            child: Text(
                                                                              '$value',
                                                                              style: AppTextStyles.c14grey400(),
                                                                            ),
                                                                          );
                                                                        }).toList(),
                                                                        value: status,
                                                                        selectedItemBuilder: (BuildContext context){
                                                                          return statusList.map((value){
                                                                            return Text(
                                                                              '$value',
                                                                              style: AppTextStyles.c14grey400(),
                                                                            );
                                                                          }).toList();
                                                                        },
                                                                        hint: Text(
                                                                          'Select Status',
                                                                          style: AppTextStyles.c14grey400(),
                                                                        ),
                                                                        onChanged:(value){
                                                                          status = value;
                                                                        },
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
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
                                      snapshot.data[0]['client']!=null&&snapshot.data[0]['client']['email']!=null&&snapshot.data[0]['client']['email']!=''? GestureDetector(
                                        onTap: (){
                                          launchApp.launchmail('${snapshot.data[0]['client']['email']}');
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
                            SizedBox(
                              height: 20,
                            ),
                            //MOBILE
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              child: Text(
                                'Mobile:',
                                style: AppTextStyles.c12grey400(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0x88F2F2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${snapshot.data[0]['client']['mobile']}',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //EMAIL
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              child: Text(
                                'Email:',
                                style: AppTextStyles.c12grey400(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0x88F2F2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          snapshot.data[0]['client']!=null&&snapshot.data[0]['client']['email']!=null&&snapshot.data[0]['client']['email']!=''?'${snapshot.data[0]['client']['email']}':'No Email',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //LANGUAGE
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              child: Text(
                                'Language:',
                                style: AppTextStyles.c12grey400(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0x88F2F2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          snapshot.data[0]['client']['language']!=null&&snapshot.data[0]['client']['language']!=''?'${snapshot.data[0]['client']['language']}':'Not Defined',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //COUNTRY
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              child: Text(
                                'Country:',
                                style: AppTextStyles.c12grey400(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0x88F2F2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          snapshot.data[0]['client']['country']!=null&&snapshot.data[0]['client']['country']!=''?'${snapshot.data[0]['client']['country']['name']}':'Not Defined',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              child: Text(
                                'Lead Assigned To:',
                                style: AppTextStyles.c12grey400(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0x88F2F2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          snapshot.data[0]['agent']!=null?'${snapshot.data[0]['agent']['full_name']}': 'No Agent',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          side: new BorderSide(color: Color(0xFFDCDADA), width: 2),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFFFFFFFF),
                        ),


                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 2.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                                  color: GlobalColors.globalColor(),
                                ),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),
                                      child: Text(
                                        'LEAD DETAILS',
                                        style: AppTextStyles.c16white600(),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '● ${snapshot.data[0]['sub_status']}',
                                        style: TextStyle(
                                            color: leadsSubStatusColor(snapshot.data[0]['sub_status']),
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Montserrat-SemiBold'
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: (){
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
                                                                width: MediaQuery.of(context).size.width * 0.6,
                                                                child: Material(
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
                                                                      'Select Status',
                                                                      style: AppTextStyles.c14grey400(),
                                                                    ),
                                                                    onChanged: (value){
                                                                      status = value;
                                                                    },
                                                                  ),
                                                                  shadowColor: Colors.transparent,
                                                                  color: Colors.transparent,
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
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: GlobalColors.globalColor(),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.circle,size: 12, color: leadPriority(snapshot.data[0]['priority']),),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          '${snapshot.data[0]['priority']}',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            //LEAD REFERENCE
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              child: Text(
                                'Lead Reference:',
                                style: AppTextStyles.c12grey400(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0x88F2F2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      width: MediaQuery.of(context).size.width * 0.8,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${snapshot.data[0]['reference']}',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            snapshot.data[0]['campaign']!=null?Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                  child: Text(
                                    'Campaign:',
                                    style: AppTextStyles.c12grey400(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0x88F2F2F2),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          width: MediaQuery.of(context).size.width * 0.8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '${snapshot.data[0]['campaign']['title']}',
                                              style: AppTextStyles.c14grey400(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ):SizedBox(width: 0,),
                            //LISTING REFERENCE
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              child: Text(
                                'Listing Reference:',
                                style: AppTextStyles.c12grey400(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0x88F2F2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          snapshot.data[0]['listing']!=null?'${snapshot.data[0]['listing']['reference']}':'No Listing Found',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //ENQUIRY DATE
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              child: Text(
                                'Enquiry date:',
                                style: AppTextStyles.c12grey400(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0x88F2F2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${DateTimeConversion().getDDMMMYYYandTIME(snapshot.data[0]['created_at'])}',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //SOURCE
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              child: Text(
                                'Source:',
                                style: AppTextStyles.c12grey400(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0x88F2F2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          snapshot.data[0]['source']!=null?'${snapshot.data[0]['source']['name']}':'Not Defined',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //LEAD TYPE
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                              child: Text(
                                'Type:',
                                style: AppTextStyles.c12grey400(),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0x88F2F2F2),
                                        borderRadius: BorderRadius.circular(5),
                                      ),

                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${snapshot.data[0]['type']}',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: NetworkLoading(),
          );
        }
      },
    );
  }

  void _removeFocus() {
    if (_isDropDownOpened) {
      setState(() {
        _isBackPressedOrTouchedOutSide = true;
      });
    }
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
