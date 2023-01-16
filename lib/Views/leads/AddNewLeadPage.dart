import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/controllers/addLeadController.dart';
import 'package:crm_app/controllers/addViewingController.dart';
import 'package:crm_app/controllers/campaignController.dart';
import 'package:crm_app/controllers/leadsController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewLead extends StatefulWidget {

  int campaignId;
  String q;
  List<String> filter;
  AddNewLead(this.campaignId, this.q, this.filter);

  @override
  _AddNewLeadState createState() => _AddNewLeadState();
}

class _AddNewLeadState extends State<AddNewLead> {

  TextEditingController dateTimeController;
  DateTime selectedDate;
  final format = DateFormat("yyyy-MM-dd  hh:mm");


  List users;
  int agentId;
  List contacts;
  int clientId;
  List campaigns;
  int campaignId;
  List<String> medium = ['Call', 'Walk In', 'Email', 'Website'];
  List<String> leadType = ['Tenant', 'Buyer', 'Landlord', 'Seller'];
  List<String> statusList = ['Called No reply','In Progress','Invalid Inquiry','Invalid Number','Not Interested','Not Yet Contacted','Offer Made','Prospect','Successful','Unsuccessful','Viewing'];
  List<String> priorityList = ['Low', 'Normal', 'High', 'Urgent'];
  List sources;
  int srcId;
  String status;
  String selectedPriority;
  String selectedMedium;
  String selectedLeadType;

  Future<List> getUsers() async {
    AddViewingController avc = AddViewingController();
    users = await avc.getUserData();
    return users;
  }

  Future<List> getSource() async {
    LeadsDetails lc = LeadsDetails();
    sources = await lc.getSources();
    return sources;
  }

  Future<List> getContacts() async {
    LeadsDetails lc = LeadsDetails();
    contacts = await lc.getContacts();
    return contacts;
  }

  Future<List> getCampaigns() async{
    CampaignController cc = CampaignController();
    campaigns = await cc.getCampaigns();
    return campaigns;
  }


  final box = GetStorage();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
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
                'ADD LEAD',
                style: AppTextStyles.c20white500(),
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
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Client *',
                        style: AppTextStyles.c14grey400(),
                      ),
                      FutureBuilder(
                        future: getContacts(),
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          if(snapshot.hasData){
                            if(snapshot.data == []){
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.67,
                                child: DropdownButton<String>(
                                  items: [],
                                  onChanged: null,
                                  disabledHint: Text(
                                    'No Client',
                                    style: AppTextStyles.c14grey400(),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.67,
                                child: SearchField(
                                  suggestions: contacts.map((value){
                                    return SearchFieldListItem(
                                      value['full_name'],
                                      child: Text(
                                        '${value['full_name']}',
                                        style: AppTextStyles.c14grey400(),
                                      ),
                                    );
                                  }).toList(),
                                  suggestionState: Suggestion.expand,
                                  textInputAction: TextInputAction.search,
                                  hint: 'Enter name',
                                  hasOverlay: true,
                                  searchStyle: AppTextStyles.c14grey400(),
                                  validator: (x) {
                                    if (!contacts.contains(x) || x.isEmpty) {
                                      return 'Please Enter a valid client';
                                    }
                                    return null;
                                  },
                                  searchInputDecoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[700].withOpacity(0.8),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[700]),
                                    ),
                                  ),
                                  maxSuggestionsInViewPort: 4,
                                  itemHeight: 40,
                                  onSubmit: (value){
                                    setState(() {
                                      for(var x in contacts){
                                        if(x['full_name'] == value){
                                          clientId = x['id'];
                                          break;
                                        }
                                      }
                                    });
                                    print(clientId);
                                  },
                                  onSuggestionTap: (value){
                                    setState(() {
                                      for(var x in contacts){
                                        if(x['full_name'] == value){
                                          clientId = x['id'];
                                          break;
                                        }
                                      }
                                    });
                                    print(clientId);
                                  },
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
                if(permissions.contains('leads_view_other'))
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Agent *',
                          style: AppTextStyles.c14grey400(),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.67,
                          child: FutureBuilder(
                              future: getUsers(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                List<String> userNames = [];
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
                                  return AnimatedSearch();
                                }
                              }
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
                        'Enquiry Date: ',
                        style: AppTextStyles.c14grey400(),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.67,
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.7),
                            borderRadius: BorderRadius.circular(15)
                        ),
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
                                lastDate: DateTime(DateTime.now().year + 5)
                            );
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
                            print(format.format(selectedDate));
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
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Medium *',
                        style: AppTextStyles.c14grey400(),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.67,
                        child: DropdownButtonFormField(
                          items: medium.map((value){
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                '$value',
                                style: AppTextStyles.c14grey400(),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            'Select Medium',
                            style: AppTextStyles.c14grey400(),
                          ),
                          selectedItemBuilder: (BuildContext context){
                            return medium.map((value){
                              return Text(
                                value,
                                style: AppTextStyles.c14grey400(),
                              );
                            }).toList();
                          },
                          onChanged: (value){
                            selectedMedium = value;
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
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lead Type *',
                        style: AppTextStyles.c14grey400(),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.67,
                        child: DropdownButtonFormField(
                          items: leadType.map((value){
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                '$value',
                                style: AppTextStyles.c14grey400(),
                              ),
                            );
                          }).toList(),
                          hint: Text(
                            'Select Lead Type',
                            style: AppTextStyles.c14grey400(),
                          ),
                          selectedItemBuilder: (BuildContext context){
                            return leadType.map((value){
                              return Text(
                                value,
                                style: AppTextStyles.c14grey400(),
                              );
                            }).toList();
                          },
                          onChanged: (value){
                            selectedLeadType = value;
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
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Source *',
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
                                        '${value['name']}',
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                        child: Text(
                          'Status *',
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
                          'Priority *',
                          style: AppTextStyles.c14grey400(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.67,
                        child: DropdownButtonFormField<String>(
                          elevation: 0,
                          selectedItemBuilder: (BuildContext context){
                            return priorityList.map((String v){
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
                          value: selectedPriority,
                          disabledHint: Center(
                            child: Text(
                              'No Priorities',
                              style: AppTextStyles.c14grey400(),
                            ),
                          ),
                          hint: Center(
                            child: Text(
                              'Select priority',
                              style: AppTextStyles.c14grey400(),
                            ),
                          ),
                          iconDisabledColor: Colors.grey.shade400,
                          items: priorityList.map((String value){
                            return DropdownMenuItem<String>(
                              child: Center(child: Text(value)),
                              value: value,
                            );
                          }).toList(),
                          onChanged: (value){
                            setState(() {
                              selectedPriority = value;
                              print(selectedPriority);
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
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                        child: Text(
                          'Campaign:',
                          style: AppTextStyles.c14grey400(),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      FutureBuilder(
                        future: getCampaigns(),
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          if(snapshot.hasData){
                            if(snapshot.data == []){
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.67,
                                child: DropdownButton<String>(
                                  items: [],
                                  onChanged: null,
                                  disabledHint: Text(
                                    'No Campaigns',
                                    style: AppTextStyles.c14grey400(),
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                width: MediaQuery.of(context).size.width * 0.67,
                                child: DropdownButtonFormField(
                                  items: campaigns.map((dynamic value){
                                    return DropdownMenuItem(
                                      value: value['id'],
                                      child: Text(
                                        '${value['title']}',
                                        style: AppTextStyles.c14grey400(),
                                      ),
                                    );
                                  }).toList(),
                                  selectedItemBuilder: (BuildContext context){
                                    return campaigns.map((item){
                                      return Text(item['title'],style: AppTextStyles.c14grey400(),);
                                    }).toList();
                                  },
                                  value: campaignId,
                                  onChanged: (value){
                                    campaignId = value;
                                  },
                                  hint: Text(
                                    'Select campaign',
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
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: ElevatedButton(
                    onPressed: () async {
                      if(!permissions.contains('leads_view_other')){
                        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                        agentId = sharedPreferences.get('user_id');
                      }
                      AddLeadController alc = AddLeadController();
                      if(clientId == null || agentId == null || selectedMedium == null || selectedLeadType == null || srcId == null || status == null || selectedPriority == null){
                        Fluttertoast.showToast(
                            msg: 'Please fill out the required fields',
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            gravity: ToastGravity.BOTTOM,
                            toastLength: Toast.LENGTH_LONG
                        );
                        print(agentId);
                      } else {
                        bool addedNewLead = await alc.addLead(agentId, campaignId, clientId, selectedDate!=null?format.format(selectedDate): null, selectedMedium, selectedPriority, srcId, 'Active', status, selectedLeadType);
                        if(addedNewLead){
                          Fluttertoast.showToast(
                              msg: 'Lead Successfully created',
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              gravity: ToastGravity.BOTTOM,
                              toastLength: Toast.LENGTH_LONG
                          );
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: 'An Error occurred!',
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              gravity: ToastGravity.BOTTOM,
                              toastLength: Toast.LENGTH_LONG
                          );
                        }
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor())
                    ),
                    child: Center(
                      child: Text(
                        'Save Lead',
                        style: AppTextStyles.c16white600(),
                      ),
                    ),
                  ),
                )





              ],
            ),
          ),
        )
      ],
    );
  }
}
