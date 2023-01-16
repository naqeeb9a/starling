import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:crm_app/Views/listings/NewListingLandingPage.dart';
import 'package:crm_app/controllers/tasksController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ListingFilterPage extends StatefulWidget {

  String q;
  ListingFilterPage({this.q});

  @override
  _ListingFilterPageState createState() => _ListingFilterPageState();
}

class _ListingFilterPageState extends State<ListingFilterPage> {

  final box= GetStorage();

  TextEditingController reference = TextEditingController();


  List<String> publishStatus = ['Published', 'Unpublished'];
  List<String> status = ['Approved', 'Archived', 'Draft', 'Pending', 'Rejected', 'Scheduled', 'Prospect'];
  List<String> type = ['Commercial', 'Residential'];
  List<String> listingFor = ['Rental', 'Sale'];
  List users;
  List<String> userNames = [];
  int agentId;


  String publishedStatus;
  String selectedStatus;
  String selectedType;
  String selectedListingFor;
  String selectedUser;

  final format = DateFormat("yyyy-MM-dd HH:mm");
  TextEditingController createdFromDateTimeController;
  TextEditingController createdToDateTimeController;
  DateTime selectedCreatedFromDate;
  DateTime selectedCreatedToDate;

  Future<List> getUsers() async {
    TasksController tc = TasksController();
    users = await tc.getUsers();
    return users;
  }



  @override
  void initState(){
    selectedUser = box.read('full_name');
    super.initState();
  }

  @override
  void dispose(){
    reference.dispose();
    super.dispose();
  }

  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false;



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
                icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 30,),
              ),
              title: Center(
                child: Text(
                  'Listings Filter',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                //REFERENCE
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

                if(permissions.contains('listings_view_other'))
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
                                  width: MediaQuery.of(context).size.width * 0.6,
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
                if(permissions.contains('listings_view_other'))
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),


                //PUBLISHED STATUS
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Publish Status:',
                        style: AppTextStyles.c14grey400(),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: DropdownButtonFormField<String>(
                          items: publishStatus.map((value){
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: AppTextStyles.c14grey400(),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            'Select publish status',
                            style: AppTextStyles.c14grey400(),
                          ),
                          selectedItemBuilder: (BuildContext context){
                            return publishStatus.map((val){
                              return Text(
                                val,
                                style: AppTextStyles.c14grey400(),
                              );
                            }).toList();
                          },
                          onChanged: (value){
                            setState(() {
                              publishedStatus = value;
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
                  padding: const EdgeInsets.all(7.0),
                  child: Container(
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Created at (Select a range):',
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
                                    controller: createdFromDateTimeController,
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
                                      selectedCreatedFromDate = value;
                                      print(selectedCreatedFromDate.toString());
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
                                    controller: createdToDateTimeController,
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
                                      selectedCreatedToDate = value;
                                      print(selectedCreatedToDate.toString());
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
                      Text(
                        'Status:',
                        style: AppTextStyles.c14grey400(),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: DropdownButtonFormField<String>(
                          items: status.map((value){
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: AppTextStyles.c14grey400(),
                              ),
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext context){
                            return status.map((value){
                              return Text(
                                value,
                                style: AppTextStyles.c14grey400(),
                              );
                            }).toList();
                          },
                          value: selectedStatus,
                          onChanged: (value){
                            setState(() {
                              selectedStatus = value;
                            });
                          },
                          hint: Text('Select Status',style: AppTextStyles.c14grey400(),),
                        ),
                      )
                    ],
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
                      Text(
                        'Type:',
                        style: AppTextStyles.c14grey400(),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: DropdownButtonFormField(
                          items: type.map((value){
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: AppTextStyles.c14grey400(),
                              ),
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext context){
                            return type.map((value){
                              return Text(
                                value,
                                style: AppTextStyles.c14grey400(),
                              );
                            }).toList();
                          },
                          value: selectedType,
                          hint: Text('Select Type',style: AppTextStyles.c14grey400(),),
                          onChanged: (value){
                            setState(() {
                              selectedType = value;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),


                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Listing For:',
                        style: AppTextStyles.c14grey400(),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: DropdownButtonFormField(
                          items: listingFor.map((value){
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: AppTextStyles.c14grey400(),
                              ),
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext context){
                            return listingFor.map((value){
                              return Text(
                                value,
                                style: AppTextStyles.c14grey400(),
                              );
                            }).toList();
                          },
                          hint: Text('Select Listing For',style: AppTextStyles.c14grey400(),),
                          value: selectedListingFor,
                          onChanged: (value){
                            setState(() {
                              selectedListingFor = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),


                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor()),
                    ),
                    onPressed: (){
                      List<String> fil = [];
                      String filter = '';
                      if(reference.text != null && reference.text != ''){
                        filter = '%7B%22column%22:%22reference%22,%22operator%22:%22like%22,%22value%22:%22%25${reference.text}%25%22%7D';
                        fil.add('%7B%22column%22:%22reference%22,%22operator%22:%22like%22,%22value%22:%22%25${reference.text}%25%22%7D');
                      }
                      if(agentId != null){
                        fil.add('%7B%22column%22:%22assigned_to_id%22,%22operator%22:%22=%22,%22value%22:$agentId%7D');
                      }
                      if(publishedStatus != 'Select' && publishedStatus != null) {
                        filter = filter != ''?filter + ',%7B%22column%22:%22portal_status%22,%22operator%22:%22=%22,%22value%22:%22$publishedStatus%22%7D':'%7B%22column%22:%22portal_status%22,%22operator%22:%22=%22,%22value%22:%22$publishedStatus%22%7D';
                        fil.add('%7B%22column%22:%22portal_status%22,%22operator%22:%22=%22,%22value%22:%22$publishedStatus%22%7D');
                      }
                      if(selectedStatus != 'Select' && selectedStatus != null) {
                        filter = filter != ''?filter + ',%7B%22column%22:%22listing_status%22,%22operator%22:%22=%22,%22value%22:%22$selectedStatus%22%7D':'%7B%22column%22:%22listing_status%22,%22operator%22:%22=%22,%22value%22:%22$selectedStatus%22%7D';
                        fil.add('%7B%22column%22:%22listing_status%22,%22operator%22:%22=%22,%22value%22:%22$selectedStatus%22%7D');
                      }
                      if(selectedType != 'Select' && selectedType != null){
                        filter = filter != ''?filter + ',%7B%22column%22:%22property_type%22,%22operator%22:%22=%22,%22value%22:%22$selectedType%22%7D':'%7B%22column%22:%22property_type%22,%22operator%22:%22=%22,%22value%22:%22$selectedType%22%7D';
                        fil.add('%7B%22column%22:%22property_type%22,%22operator%22:%22=%22,%22value%22:%22$selectedType%22%7D');
                      }
                      if(selectedListingFor != 'Select' && selectedListingFor != null){
                        filter = filter != ''?filter + ',%7B%22column%22:%22property_for%22,%22operator%22:%22=%22,%22value%22:%22$selectedListingFor%22%7D':'%7B%22column%22:%22property_for%22,%22operator%22:%22=%22,%22value%22:%22$selectedListingFor%22%7D';
                        fil.add('%7B%22column%22:%22property_for%22,%22operator%22:%22=%22,%22value%22:%22$selectedListingFor%22%7D');
                      }
                      if(selectedCreatedFromDate != null && selectedCreatedToDate != null){
                        String fDate = selectedCreatedFromDate.toString().split('.')[0];
                        String formatted = DateFormat('yyyy-MM-dd').format(selectedCreatedFromDate);
                        String ftime = DateFormat('HH:mm').format(selectedCreatedFromDate);
                        String tDate = selectedCreatedToDate.toString().split('.')[0];
                        String tformatted = DateFormat('yyyy-MM-dd').format(selectedCreatedToDate);
                        String ttime = DateFormat('HH:mm').format(selectedCreatedToDate);
                        fil.add('%7B%22column%22:%22created_at%22,%22operator%22:%22between%22,%22value%22:%5B%22${Uri.encodeComponent(formatted)}%20$ftime%22,%22${Uri.encodeComponent(tformatted)}%20$ttime%22%5D%7D');
                      } else if (selectedCreatedFromDate != null && selectedCreatedToDate == null){

                        String fDate = selectedCreatedFromDate.toString().split('.')[0];
                        String formatted = DateFormat('yyyy-MM-dd').format(selectedCreatedFromDate);
                        String ftime = DateFormat('HH:mm').format(selectedCreatedFromDate);
                        fil.add('%7B%22column%22:%22created_at%22,%22operator%22:%22between%22,%22value%22:%5B%22${Uri.encodeComponent(formatted)}%20$ftime:00%22,%22$formatted%2023:59:59%22%5D%7D');
                      } else if(selectedCreatedFromDate == null && selectedCreatedToDate != null){
                        Fluttertoast.showToast(msg: 'Please enter a from date for enquiry',textColor: Colors.white, backgroundColor: Colors.red,toastLength: Toast.LENGTH_LONG,gravity: ToastGravity.BOTTOM);
                      }
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewListingLandingPage(filter: fil, q: widget.q,)));
                    },
                    child: Center(
                      child: Text(
                        'Apply Filters',
                        style: AppTextStyles.c18white600(),
                      ),
                    ),
                  ),
                )
              ],
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
