import 'dart:ui';

import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/controllers/addViewingController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class AddViewingModule extends StatefulWidget {

  @override
  _AddViewingModuleState createState() => _AddViewingModuleState();
}

class _AddViewingModuleState extends State<AddViewingModule> {

  TextEditingController dateTimeController;
  DateTime selectedDate;
  final format = DateFormat("yyyy-MM-dd HH:mm");
  List users;
  List<String> userNames = [];
  List leads = [];
  List listings = [];
  List<String> leadRefs = ['Select'];
  List<String> listingRefs = ['Select'];
  List<String> statusList = ['Scheduled','Cancelled','Successful','Unsuccessful'];
  String status;
  String selectedUser = 'Select User';
  final box = GetStorage();
  int agentId;
  int leadId, listingId;
  int currentUserId;
  List permissions;
  Future leadFuture;
  Future listingFuture;
  TextEditingController notesController = TextEditingController();

  Future<List> getUsers() async {
    AddViewingController avc = AddViewingController();
    users = await avc.getUserData();
    return users;
  }

  void getLeads(int id) async {
    print(id);
    AddViewingController avc = AddViewingController();
    leads = await avc.getLeadsAddViewingModule(id);
  }

  Future<List> getLeadsAVC (int id) async {
    AddViewingController avc = AddViewingController();
    return avc.getLeadsAddViewingModule(id);
  }

  Future<List> getListings(int id) async {
    AddViewingController avc = AddViewingController();
    listings = await avc.getAddViewingModuleListings(id);
    return listings;
  }

  @override
  void initState() {
    agentId = box.read('user_id');
    selectedUser = box.read('full_name');
    super.initState();
    listingFuture = getListings(agentId);
    leadFuture = getLeadsAVC(agentId);
    status = 'Scheduled';
  }

  @override
  Widget build(BuildContext context) {

    List permissions = box.read('permissions');
    int roleId = box.read('role_id');

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
            leading: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios, color: Colors.white,size: 27,),
            ),
            backgroundColor: GlobalColors.globalColor(),
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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05,),
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
                      width: MediaQuery.of(context).size.width * 0.67,
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              roleId!=3?Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Agent *',
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
                                      style: AppTextStyles.c14black500(),
                                    ),
                                    value: user['id'],
                                  );
                                }).toList(),
                                value: agentId,
                                selectedItemBuilder: (BuildContext context) {
                                  return userNames.map<Widget>((String item) {
                                    return Text(item,style: AppTextStyles.c14black500(),);
                                  }).toList();
                                },
                                onChanged: (value){
                                  setState(() {
                                    agentId = value;
                                    listingFuture = getListings(agentId);
                                    leadFuture = getLeadsAVC(agentId);
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
              ):SizedBox(width: 0,height: 0,),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              provideLeadsDropDown(agentId),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              provideListingsDropDown(agentId),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Row(
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
                            'No Leads',
                            style: AppTextStyles.c14lightGrey400(),
                          ),
                        ),
                        hint: Center(
                          child: Text(
                            'Status',
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
                height: MediaQuery.of(context).size.height * 0.03,
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
                height: MediaQuery.of(context).size.height * 0.03,
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05,),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor())
                  ),
                  child: Center(
                    child: Text(
                      'Schedule',
                      style: AppTextStyles.c16white600(),
                    ),
                  ),
                  onPressed: () async {
                    String notes = notesController.text;
                    bool detailsSent;
                    if(agentId == 0 || dateTimeController.toString() == null || dateTimeController.toString() == ''){
                      Fluttertoast.showToast(
                          msg: 'Some required fields are empty. Please give values to those fields',
                          textColor: Colors.white,
                          backgroundColor: Colors.red,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM
                      );
                    } else {
                      AddViewingController avc = AddViewingController();
                      detailsSent = await avc.sendData(agentId, selectedDate.toString(), leadId, listingId, notes, status);
                      if(detailsSent){
                        Navigator.of(context).pop();
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
                ),
              )





            ],
          ),
        ),
      ],
    );
  }

  Widget provideLeadsDropDown (int agent){
    if (agent == null) {
      leadId = 0;
      // the user didn't select anything from the first dropdown so you probably want to show a disabled dropdown
      return DropdownButton<String>(
        items: [],
        onChanged: null,
        disabledHint: Text(
          'No Leads',
          style: AppTextStyles.c14grey400(),
        ),
      );
    } else {
      return FutureBuilder(
        future: leadFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          leads = snapshot.hasData ? snapshot.data : [];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lead *',
                  style: AppTextStyles.c14grey400(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.67,
                  child: DropdownButtonFormField(
                    hint: Text('Select lead', style: AppTextStyles.c14grey400(),),
                    items: leads.map((dynamic value){
                      return DropdownMenuItem(
                        value: value['id'],
                        child: Text(
                          '${value['client']['full_name']}',
                          style: AppTextStyles.c14grey400(),
                        ),
                      );
                    }).toList(),
                    selectedItemBuilder: (BuildContext context){
                      return leads.map<Widget>((item){
                        return Text('${item['client']['full_name']}',style: AppTextStyles.c14black500(),);
                      }).toList();
                    },
                    onChanged: (value){
                      setState(() {
                        leadId = value;
                        print(leadId);
                      });
                    },
                    disabledHint: Text(
                      'No Leads',
                      style: AppTextStyles.c14grey400(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget provideListingsDropDown (int agent){
    if (agent == null) {
      listingId = 0;
      // the user didn't select anything from the first dropdown so you probably want to show a disabled dropdown
      return DropdownButton<String>(
        items: [],
        onChanged: null,
        disabledHint: Text(
          'No Listings',
          style: AppTextStyles.c14grey400(),
        ),
      );
    } else {
      return FutureBuilder(
        future: listingFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          listings = snapshot.hasData ? snapshot.data : [];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Listing:',
                  style: AppTextStyles.c14grey400(),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.67,
                  child: DropdownButtonFormField(
                    hint: Text('Select listing', style: AppTextStyles.c14grey400(),),
                    items: listings.map((dynamic value){
                      return DropdownMenuItem(
                        value: value['id'],
                        child: Text(
                          '${value['reference']}',
                          style: AppTextStyles.c14grey400(),
                        ),
                      );
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        listingId = value;
                      });
                    },
                    disabledHint: Text(
                      'No Listings',
                      style: AppTextStyles.c14grey400(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

}
