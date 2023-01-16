import 'dart:ui';

import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/Views/leads/NewLeadsDetailLandingPage.dart';
import 'package:crm_app/controllers/addViewingController.dart';
import 'package:crm_app/controllers/leadsController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class NewLeadAddTaskPage extends StatefulWidget {
  final int leadId;
  NewLeadAddTaskPage({this.leadId});

  @override
  _NewLeadAddTaskPageState createState() => _NewLeadAddTaskPageState();
}

class _NewLeadAddTaskPageState extends State<NewLeadAddTaskPage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm");
  DateTime selectedDate;


  final box = GetStorage();

  String currentUser,selectedUser;
  String selectedPriority = 'Low';
  String selectedStatus = 'Pending';
  List<String> userNames = [];
  List<String> noPermissionUserNames = [];
  int assignToId;
  List users;
  List<String> priority = ['Low','Medium','High','Urgent'];
  List<String> status = ['Pending','In Progress','Completed'];

  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false;

  @override
  void initState() {
    currentUser = box.read('full_name');
    selectedUser = currentUser;
    noPermissionUserNames.add(currentUser);

    super.initState();
  }

  Future<List> getUsers() async{
    AddViewingController avc = AddViewingController();
    users = await avc.getUserData();
    return users;
  }



  @override
  Widget build(BuildContext context) {

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
              leading: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios,color: Colors.white,size: 27,),
              ),
              title: Center(
                child: Text(
                  'Add New Task',
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
                )
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
                      controller: titleController,
                      decoration: InputDecoration(
                          labelText: 'Title *',
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Cairo",
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontFeatures: <FontFeature>[
                                FontFeature.superscripts(),
                              ]
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: GlobalColors.globalColor()),
                          ),
                          focusColor: GlobalColors.globalColor()
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: DateTimeField(
                      controller: dateTimeController,
                      decoration: InputDecoration(
                          labelText: 'Due Date *',
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Cairo",
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontFeatures: <FontFeature>[
                                FontFeature.superscripts(),
                              ]
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: GlobalColors.globalColor()),
                          ),
                          focusColor: GlobalColors.globalColor()
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: Text(
                      'Assigned To',
                      style: AppTextStyles.c14grey400(),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                  FutureBuilder(
                    future: getUsers(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot.hasData){
                        for(var i in snapshot.data){
                          userNames.add(i['full_name']);
                        }
                        return AwesomeDropDown(
                          dropDownList: userNames,
                          isPanDown: _isPanDown,
                          isBackPressedOrTouchedOutSide: _isBackPressedOrTouchedOutSide,
                          dropStateChanged: (isOpened) {
                            _isDropDownOpened = isOpened;
                            if (!isOpened) {
                              _isBackPressedOrTouchedOutSide = false;
                            }
                          },
                          dropDownIcon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                            size: 23,
                          ),
                          elevation: 0.5,

                          dropDownBorderRadius: 0,
                          dropDownTopBorderRadius: 0,
                          dropDownBottomBorderRadius: 0,
                          dropDownIconBGColor: Colors.transparent,
                          dropDownOverlayBGColor: Colors.transparent,
                          dropDownBGColor: Colors.white,
                          selectedItem: currentUser,
                          onDropDownItemClick: (value){
                            selectedUser = value;
                            print(selectedUser);
                          },
                        );
                      } else {
                        return Center(
                          child: AnimatedSearch(),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: Text(
                      'Priority *',
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                  AwesomeDropDown(
                    dropDownList: priority,
                    isPanDown: _isPanDown,
                    isBackPressedOrTouchedOutSide: _isBackPressedOrTouchedOutSide,
                    dropStateChanged: (isOpened) {
                      _isDropDownOpened = isOpened;
                      if (!isOpened) {
                        _isBackPressedOrTouchedOutSide = false;
                      }
                    },
                    dropDownIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                      size: 23,
                    ),
                    elevation: 0.5,

                    dropDownBorderRadius: 0,
                    dropDownTopBorderRadius: 0,
                    dropDownBottomBorderRadius: 0,
                    dropDownIconBGColor: Colors.transparent,
                    dropDownOverlayBGColor: Colors.transparent,
                    dropDownBGColor: Colors.white,
                    selectedItem: selectedPriority,
                    onDropDownItemClick: (value){
                      selectedPriority = value;
                      print(selectedPriority);
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: Text(
                      'Status *',
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                  AwesomeDropDown(
                    dropDownList: status,
                    isPanDown: _isPanDown,
                    isBackPressedOrTouchedOutSide: _isBackPressedOrTouchedOutSide,
                    dropStateChanged: (isOpened) {
                      _isDropDownOpened = isOpened;
                      if (!isOpened) {
                        _isBackPressedOrTouchedOutSide = false;
                      }
                    },
                    dropDownIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                      size: 23,
                    ),
                    elevation: 0.5,

                    dropDownBorderRadius: 0,
                    dropDownTopBorderRadius: 0,
                    dropDownBottomBorderRadius: 0,
                    dropDownIconBGColor: Colors.transparent,
                    dropDownOverlayBGColor: Colors.transparent,
                    dropDownBGColor: Colors.white,
                    selectedItem: selectedStatus,
                    onDropDownItemClick: (value){
                      selectedStatus = value;
                      print(selectedStatus);
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
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
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
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
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
                    child: ElevatedButton(
                      onPressed: () async {
                        LeadsDetails ld = LeadsDetails();
                        bool isAdded;
                        if(titleController.text == null || selectedDate == null){
                          Fluttertoast.showToast(
                              msg: 'Error! Please enter the required fields',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white
                          );
                        } else {
                          for(var x in users){
                            if(x['full_name'] == selectedUser){
                              assignToId = x['id'];
                              break;
                            }
                          }
                          List finalList = [{
                            'object_id': widget.leadId,
                            'object_type': 'lead'
                          }];
                          isAdded = await ld.addLeadTask(assignToId, notesController.text, selectedDate.toString(), finalList, 'lead', selectedPriority, selectedStatus, titleController.text);
                          if(isAdded){
                            Fluttertoast.showToast(
                                msg: 'Task Created Successfully',
                                textColor: Colors.white,
                                backgroundColor: Colors.green,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM
                            );
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> NewLeadsDetailLandingPage(id: widget.leadId,)));
                          } else {
                            Fluttertoast.showToast(
                                msg: 'An error occurred while creating please try later',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.red,
                                textColor: Colors.white
                            );
                          }
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor())
                      ),
                      child: Center(
                        child: Text(
                          'Add Task',
                          style: AppTextStyles.c16white600(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
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
