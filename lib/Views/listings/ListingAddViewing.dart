import 'package:crm_app/Views/listings/ListingDetailsLandingPage.dart';
import 'package:crm_app/Views/listings/ListingsDetailsPage.dart';
import 'package:crm_app/Views/listings/NewListingsDetailsLandingPage.dart';
import 'package:crm_app/controllers/addViewingController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:crm_app/widgets/loaders/CircularLoader.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'dart:ui';


class ListingAddViewing extends StatefulWidget {

  final int id;
  final String title;
  ListingAddViewing({this.id,this.title});


  @override
  _ListingAddViewingState createState() => _ListingAddViewingState();
}

class _ListingAddViewingState extends State<ListingAddViewing> {
  DateTime current = DateTime.now();

  final format = DateFormat("yyyy-MM-dd HH:mm");

  DateTime selectedDate;
  String agent = 'Onlinist Support';
  String leadRef;

  TextEditingController dateTimeController;
  String currentUser;
  int role_id;
  int agentId = 0;
  int leadId = 0;
  bool isDropDownEnabled = false;
  final box = GetStorage();
  TextEditingController notesController = TextEditingController();
  bool detailsSent = false;


  List data = [];
  List leads = [];
  List<String> statusList = ['Scheduled','Cancelled','Successful','Unsuccessful'];
  String status = 'Scheduled';

  Future<List> getUsers() async{
    AddViewingController avc = AddViewingController();
    data = await avc.getUserData();
    return data;
  }

  Future<List> getLeads() async{
    AddViewingController avc = AddViewingController();
    leads = await avc.getLeads(widget.id);
    return leads;
  }

  @override
  void initState(){
    agent = box.read('full_name');
    agentId = box.read('agent_id');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = box.read('full_name');
    List permissions= box.read('permissions');

    role_id = box.read('role_id');
    if(role_id != 3){
      isDropDownEnabled = true;
    } else {
      isDropDownEnabled = false;
    }
    List<DropdownMenuItem<String>> statList = statusList.map((String value){
      return DropdownMenuItem<String>(
        child: Center(child: Text(value)),
        value: value,
      );
    }).toList();
    // print(data);
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
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Center(
              child: Text(
                'Add Viewing',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            backgroundColor: GlobalColors.globalColor(),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05,vertical: MediaQuery.of(context).size.height * 0.04),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                      child: Text(
                        'Date & Time * ',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Cairo",
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                          fontFeatures: <FontFeature>[
                            FontFeature.superscripts(),
                          ]
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.7),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: DateTimeField(
                        controller: dateTimeController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Select Date & time',
                          hintStyle: AppTextStyles.c14grey400(),
                          prefixIcon: Icon(Icons.calendar_today,size: 15,),
                        ),
                        format: format,
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                            );
                            return DateTimeField.combine(date, time);
                          } else {
                            return currentValue;
                          }
                        },
                        onChanged: (value){
                          selectedDate = value;
                          print(selectedDate.toString());
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if(permissions.contains('listings_view_other'))
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Agent*',
                        style: AppTextStyles.c14grey400(),
                      ),
                      FutureBuilder(
                        future: getUsers(),
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          if(snapshot.hasData){
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.67,
                              child: DropdownButtonFormField(
                                items: data.map((value){
                                  return DropdownMenuItem(
                                    value: value['id'],
                                    child: Text(
                                      '${value['full_name']}',
                                      style: AppTextStyles.c14grey400(),
                                    ),
                                  );
                                }).toList(),
                                selectedItemBuilder: (BuildContext context){
                                  return data.map((value){
                                    return Text(
                                      '${value['full_name']}',
                                      style: AppTextStyles.c14grey400(),
                                    );
                                  }).toList();
                                },
                                hint: Text(
                                  'Select User',
                                  style: AppTextStyles.c14grey400(),
                                ),
                                value: agentId,
                                onChanged: (value){
                                  agentId = value;
                                },
                              ),
                            );
                          } else {
                            return AnimatedSearch();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              if(permissions.contains('listings_view_other'))
                SizedBox(
                  height: MediaQuery.of(context).size.height *0.04,
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                      child: Text(
                        'Lead * ',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Cairo",
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400,
                            fontFeatures: <FontFeature>[
                              FontFeature.superscripts(),
                            ]
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    //lead future build with dropdownmenuitem
                    FutureBuilder(
                      future: getLeads(),
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(snapshot.hasData){
                          List<String> refs = [];
                          for(var i in snapshot.data){
                            refs.add(i['reference']);
                          }
                          // leadRef = refs[0];
                          List<DropdownMenuItem<dynamic>> refsList = refs.map((String value){
                            return DropdownMenuItem<dynamic>(
                              child: Center(child: Text(value)),
                              value: value,
                            );
                          }).toList();
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.7),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<dynamic>(
                                elevation: 0,
                                selectedItemBuilder: (BuildContext context){
                                  return refs.map((String v){
                                    return Padding(
                                      padding: EdgeInsets.only(left:15),
                                      child: Row(
                                        children: [
                                          Center(
                                            child: Text(
                                              v,
                                              style: AppTextStyles.c16black500(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList();
                                },
                                value: leadRef,
                                disabledHint: Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Center(
                                    child: Text(
                                      'No Leads',
                                      style: AppTextStyles.c14lightGrey400(),
                                    ),
                                  ),
                                ),
                                hint: Padding(
                                  padding: EdgeInsets.only(left: 15.0),
                                  child: Center(
                                    child: Text(
                                      'Lead',
                                      style: AppTextStyles.c14grey400(),
                                    ),
                                  ),
                                ),
                                iconDisabledColor: Colors.grey.shade400,
                                items: refsList,
                                onChanged: (value){
                                  setState(() {
                                    this.leadRef = value;
                                  });
                                  for(var i in snapshot.data){
                                    if( i['reference'] == leadRef){
                                      leadId = i['id'];
                                    }
                                  }
                                  print(leadId);
                                },
                              ),
                            ),
                          );
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(width: 0.7),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              disabledHint: Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  'No Leads',
                                  style: AppTextStyles.c14lightGrey400(),
                                ),
                              ),
                              hint: Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  currentUser,
                                  style: AppTextStyles.c14lightGrey400(),
                                ),
                              ),
                              iconDisabledColor: Colors.grey.shade400,
                              items: [],
                              onSaved: (value){
                                agent = currentUser;
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height *0.04,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                      child: Text(
                        'Status * ',
                        style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Cairo",
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400,
                            fontFeatures: <FontFeature>[
                              FontFeature.superscripts(),
                            ]
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.7),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          elevation: 0,
                          selectedItemBuilder: (BuildContext context){
                            return statusList.map((String v){
                              return Padding(
                                padding: EdgeInsets.only(left:15),
                                child: Row(
                                  children: [
                                    Center(
                                      child: Text(
                                        v,
                                        style: AppTextStyles.c16black500(),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList();
                          },
                          value: status,
                          disabledHint: Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Center(
                              child: Text(
                                'No Leads',
                                style: AppTextStyles.c14lightGrey400(),
                              ),
                            ),
                          ),
                          hint: Padding(
                            padding: EdgeInsets.only(left: 15.0),
                            child: Center(
                              child: Text(
                                'Status',
                                style: AppTextStyles.c14grey400(),
                              ),
                            ),
                          ),
                          iconDisabledColor: Colors.grey.shade400,
                          items: statList,
                          onChanged: (value){
                            setState(() {
                              status = value;
                              print(status);
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height *0.03,
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
                      fontFeatures: <FontFeature>[
                        FontFeature.superscripts(),
                      ]
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              Padding(
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
              SizedBox(
                height: MediaQuery.of(context).size.height *0.04,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width *0.04),
                child: ElevatedButton(
                  onPressed: () async {
                    String notes = notesController.text;
                    if(agentId == 0 || leadId == 0 || dateTimeController.toString() == null || dateTimeController.toString() == ''){
                      Fluttertoast.showToast(
                          msg: 'Some required fields are empty. Please give values to those fields',
                          textColor: Colors.white,
                          backgroundColor: Colors.red,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM
                      );
                    } else {
                      AddViewingController avc = AddViewingController();
                      detailsSent = await avc.sendData(agentId, selectedDate.toString(), leadId, widget.id, notes, status);
                      if(detailsSent){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => NewListingsDetailsLandingPage(id: widget.id,selectedIndex: 2,)));
                        Fluttertoast.showToast(
                            msg: 'Viewing Created Successfully',
                            textColor: Colors.white,
                            backgroundColor: Colors.green,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Some Error Occurred! Please try again',
                            textColor: Colors.white,
                            backgroundColor: Colors.red,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM
                        );
                      }
                    }
                  },
                  child: Center(
                    child: Text(
                      'Submit',
                      style: AppTextStyles.c16white600(),
                    ),
                  ),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )),
                    backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor())
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
