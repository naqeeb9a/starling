import 'dart:ui';

import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/leads/NewLeadsListingPage.dart';
import 'package:crm_app/controllers/leadsController.dart';
import 'package:crm_app/controllers/tasksController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class LeadsFilterPage extends StatefulWidget {
  String q;
  LeadsFilterPage({this.q});

  @override
  _LeadsFilterPageState createState() => _LeadsFilterPageState();
}

class _LeadsFilterPageState extends State<LeadsFilterPage> {
  List<String> filter = [];

  final box = GetStorage();

  final format = DateFormat("yyyy-MM-dd HH:mm");
  TextEditingController enquiryFromDateTimeController;
  TextEditingController enquiryToDateTimeController;
  DateTime selectedEnquiryFromDate;
  DateTime selectedEnquiryToDate;

  List users;
  List sources;
  List<String> userNames = [];
  String selectedUser;
  int agentId;
  String selectedSrc;
  int srcId;
  List<String> statusList = ['Called No reply','In Progress','Invalid Inquiry','Invalid Number','Not Interested','Not Yet Contacted','Offer Made','Prospect','Successful','Unsuccessful','Viewing'];
  String status;



  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false;

  Future<List> getUsers() async {
    TasksController tc = TasksController();
    users = await tc.getUsers();
    return users;
  }

  Future<List> getSource() async {
    LeadsDetails lc = LeadsDetails();
    sources = await lc.getSources();
    return sources;
  }

  @override
  void initState() {
    selectedUser = box.read('full_name');
    super.initState();
  }

  TextEditingController reference = TextEditingController();

  @override
  void dispose(){
    reference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List permissions = box.read('permissions');
    return GestureDetector(
      onTap: _removeFocus,
      onPanDown: (focus) {
        _isPanDown = true;
        _removeFocus();
      },
      child: Stack(
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
              backgroundColor: GlobalColors.globalColor(),
              elevation: 10,
              leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 27,),
              ),
              title: Center(
                child: Text(
                  'FILTER LEADS',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    color: Colors.white,

                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationsListPage()));
                    },
                    child: Icon(Icons.notifications, color: Colors.white,size: 27,),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: TextFormField(
                      controller: reference,
                      decoration: InputDecoration(
                          labelText: 'Reference',
                          labelStyle: TextStyle(
                            fontSize: 16.0,
                            fontFamily: "Cairo",
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: GlobalColors.globalColor()),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: GlobalColors.globalColor()),
                          ),
                          focusColor: GlobalColors.globalColor()
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),

                  if(permissions.contains('leads_view_other'))
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Agent:',
                            style: AppTextStyles.c14grey400(),
                          ),
                          FutureBuilder(
                              future: getUsers(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                if(snapshot.hasData){
                                  for(var x in snapshot.data){
                                    userNames.add(x['full_name']);
                                  }
                                  return Container(
                                    width: MediaQuery.of(context).size.width * 0.67,
                                    child: DropdownButtonFormField(
                                      items: users.map((dynamic user){
                                        return DropdownMenuItem<dynamic>(
                                          child: Text(
                                            '${user['full_name']}',
                                            style: AppTextStyles.c14grey400(),
                                          ),
                                          value: user['id'],
                                        );
                                      }).toList(),
                                      value: agentId,
                                      selectedItemBuilder: (BuildContext context) {
                                        return userNames.map<Widget>((String item) {
                                          return Text(item,style: AppTextStyles.c14grey400(),);
                                        }).toList();
                                      },
                                      onChanged: (value){
                                        setState(() {
                                          agentId = value;
                                        });
                                      },
                                      hint: Text('Select User',style: AppTextStyles.c14grey400(),),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: AnimatedSearch(),
                                  );
                                }
                              }
                          ),

                        ],
                      ),
                    ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),


                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Source:',
                          style: AppTextStyles.c14grey400(),
                        ),
                        FutureBuilder(
                          future: getSource(),
                          builder: (BuildContext context, AsyncSnapshot snapshot){
                            if(snapshot.hasData){
                              if(snapshot.data == []){
                                return Container(
                                  width: MediaQuery.of(context).size.width * 0.67,
                                  child: DropdownButton<String>(
                                    items: [],
                                    onChanged: null,
                                    disabledHint: Text(
                                      'No Sources',
                                      style: AppTextStyles.c14grey400(),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  width: MediaQuery.of(context).size.width * 0.67,
                                  child: DropdownButtonFormField(
                                    items: sources.map((dynamic value){
                                      return DropdownMenuItem(
                                        value: value['id'],
                                        child: Text(
                                          value['name'] != null?'${value['name']}':'No Name',
                                          style: AppTextStyles.c14grey400(),
                                        ),
                                      );
                                    }).toList(),
                                    selectedItemBuilder: (BuildContext context){
                                      return sources.map((item){
                                        return Text(item['name'],style: AppTextStyles.c14grey400(),);
                                      }).toList();
                                    },
                                    value: srcId,
                                    onChanged: (value){
                                      srcId = value;
                                    },
                                    hint: Text(
                                      'Select source',
                                      style: AppTextStyles.c14grey400(),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return AnimatedSearch();
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),

                  //ENQUIRY FROM - TO DATE
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Container(
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Enquiry:',
                          labelStyle: AppTextStyles.c16grey500(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: GlobalColors.globalColor())
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'From:',
                                    style: AppTextStyles.c14grey400(),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.7),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: DateTimeField(
                                      controller: enquiryFromDateTimeController,
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
                                            lastDate: DateTime.now());
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
                                        selectedEnquiryFromDate = value;
                                        print(selectedEnquiryFromDate.toString());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'To:',
                                    style: AppTextStyles.c14grey400(),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(width: 0.7),
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.6,
                                    child: DateTimeField(
                                      controller: enquiryToDateTimeController,
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
                                            lastDate: DateTime.now());
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
                                        selectedEnquiryToDate = value;
                                        print(selectedEnquiryToDate.toString());
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                          child: Text(
                            'Status:',
                            style: AppTextStyles.c14grey400(),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.67,
                          child: DropdownButtonFormField<String>(
                            elevation: 0,
                            selectedItemBuilder: (BuildContext context){
                              return statusList.map((String v){
                                return Row(
                                  children: [
                                    Center(
                                      child: Text(
                                        v,
                                        style: AppTextStyles.c14grey400(),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList();
                            },
                            value: status,
                            disabledHint: Center(
                              child: Text(
                                'No Sources',
                                style: AppTextStyles.c14grey400(),
                              ),
                            ),
                            hint: Center(
                              child: Text(
                                'Select status',
                                style: AppTextStyles.c14grey400(),
                              ),
                            ),
                            iconDisabledColor: Colors.grey.shade400,
                            items: statusList.map((String value){
                              return DropdownMenuItem<String>(
                                child: Center(child: Text(value)),
                                value: value,
                              );
                            }).toList(),
                            onChanged: (value){
                              setState(() {
                                status = value;
                                print(status);
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor())
                      ),
                      onPressed: (){
                        if(reference.text != null && reference.text != ''){
                          filter.add('%7B%22column%22:%22reference%22,%22operator%22:%22like%22,%22value%22:%22%25${reference.text}%25%22%7D');
                        }
                        if(agentId != null && agentId != 0){
                          filter.add('%7B%22column%22:%22agent_id%22,%22operator%22:%22=%22,%22value%22:$agentId%7D');
                        }
                        if(srcId != null && srcId != 0){
                          filter.add('%7B%22column%22:%22source_id%22,%22operator%22:%22=%22,%22value%22:$srcId%7D');
                        }
                        if(status != null){
                          filter.add('%7B%22column%22:%22sub_status%22,%22operator%22:%22=%22,%22value%22:%22${Uri.encodeComponent(status)}%22%7D');
                        }
                        if(selectedEnquiryFromDate != null && selectedEnquiryToDate != null){
                          String fDate = selectedEnquiryFromDate.toString().split('.')[0];
                          String formatted = DateFormat('yyyy-MM-dd').format(selectedEnquiryFromDate);
                          String ftime = DateFormat('HH:mm').format(selectedEnquiryFromDate);
                          String tDate = selectedEnquiryToDate.toString().split('.')[0];
                          String tformatted = DateFormat('yyyy-MM-dd').format(selectedEnquiryToDate);
                          String ttime = DateFormat('HH:mm').format(selectedEnquiryToDate);
                          filter.add('%7B%22column%22:%22enquiry_date%22,%22operator%22:%22between%22,%22value%22:%5B%22${Uri.encodeComponent(formatted)}%20$ftime%22,%22${Uri.encodeComponent(tformatted)}%20$ttime%22%5D%7D');
                        } else if (selectedEnquiryFromDate != null && selectedEnquiryToDate == null){

                          String fDate = selectedEnquiryFromDate.toString().split('.')[0];
                          String formatted = DateFormat('yyyy-MM-dd').format(selectedEnquiryFromDate);
                          String ftime = DateFormat('HH:mm').format(selectedEnquiryFromDate);
                          filter.add('%7B%22column%22:%22enquiry_date%22,%22operator%22:%22between%22,%22value%22:%5B%22${Uri.encodeComponent(formatted)}%20$ftime:00%22,%22$formatted%2023:59:59%22%5D%7D');
                        } else if(selectedEnquiryFromDate == null && selectedEnquiryToDate != null){
                          Fluttertoast.showToast(msg: 'Please enter a from date for enquiry',textColor: Colors.white, backgroundColor: Colors.red,toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.BOTTOM);
                        }

                        agentId!=null && agentId!=0?Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewLeadsListingPage(q: widget.q, filter: filter,agentId: agentId,))):Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewLeadsListingPage(q: widget.q, filter: filter,)));
                      },
                      child: Center(
                        child: Text(
                          'Apply Filters',
                          style: AppTextStyles.c16white600(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
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

}
