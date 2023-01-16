import 'dart:ui';

import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:crm_app/Views/Notifications/NotificationListingsPage.dart';
import 'package:crm_app/controllers/addContactController.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/loaders/AnimatedSearch.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

class AddContact extends StatefulWidget {
  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  final box = GetStorage();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobilePhoneController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  String country;
  String type;
  String language;
  String user;

  int countryId,languageId;

  List countries = [];
  List languages = [];
  List users = [];

  List<String> typeList = ['Buyer','Tenant','Seller','Landlord'];

  TextEditingController budgetController = TextEditingController();

  Future<List> getCountries() async {
    AddContactController acc = AddContactController();
    countries = await acc.getCountries();
    return countries;
  }

  Future<List> getLanguages() async {
    AddContactController acc = AddContactController();
    languages = await acc.getLanguages();
    return languages;
  }

  Future<List> getUsers() async {
    AddContactController acc = AddContactController();
    users = await acc.getUsers();
    return users;
  }

  bool _isBackPressedOrTouchedOutSide = false,
      _isDropDownOpened = false,
      _isPanDown = false;

  @override
  Widget build(BuildContext context) {
    List permissions = box.read('permissions');
    int roleId = box.read('role_id');
    String fullName = box.read('first_name') + ' ' +box.read('last_name');

    type = typeList[0];
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
                  'Add New Contact',
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

                  //FIRST NAME
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(
                          labelText: 'First Name *',
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
                      validator: (value){
                        if(value == null){
                          return 'Please enter the first name';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //LAST NAME
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                          labelText: 'Last Name *',
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
                      validator: (value){
                        if(value == null){
                          return 'Please enter the last name';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //COUNTRIES
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Country *',
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.67,
                          child: FutureBuilder(
                            future: getCountries(),
                            builder: (BuildContext context, AsyncSnapshot snapshot){
                              if(snapshot.hasData){
                                return DropdownButtonFormField(
                                  items: countries.map((value){
                                    return DropdownMenuItem(
                                      value: value['id'],
                                      child: Text(
                                        value['name'],
                                        style: AppTextStyles.c14grey400(),
                                      ),
                                    );
                                  }).toList(),
                                  hint: Text(
                                    'Select Country',
                                    style: AppTextStyles.c14grey400(),
                                  ),
                                  value: countryId,
                                  onChanged: (value){
                                    countryId = value;
                                  },
                                  selectedItemBuilder: (BuildContext context){
                                    return countries.map((value){
                                      return Text(
                                        value['name'],
                                        style: AppTextStyles.c14grey400(),
                                      );
                                    }).toList();
                                  },
                                );
                              } else {
                                return DropdownButtonFormField(
                                  items: [],
                                  disabledHint: Text(
                                    'No Countries',
                                    style: AppTextStyles.c14grey400(),
                                  ),
                                  onChanged: (value){}
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //MOBILE PHONE
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: TextFormField(
                      controller: mobilePhoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Mobile Phone *',
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Cairo",
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                              fontFeatures: <FontFeature>[
                                FontFeature.superscripts(),
                              ]
                          ),
                          helperText: 'Ex. 971 50 111 2233',
                          helperStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Cairo",
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: GlobalColors.globalColor()),
                          ),
                          focusColor: GlobalColors.globalColor()
                      ),
                      validator: (value){
                        if(value == null){
                          return 'Please enter the phone number';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //PHONE
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Phone',
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Cairo",
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                          ),
                          helperText: 'Ex. 971 50 111 2233',
                          helperStyle: TextStyle(
                            fontSize: 14.0,
                            fontFamily: "Cairo",
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w400,
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

                  //EMAIL
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Cairo",
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: GlobalColors.globalColor()),
                          ),
                          focusColor: GlobalColors.globalColor(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //TYPE
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Type *',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Cairo",
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.67,
                          child: DropdownButtonFormField(
                            items: typeList.map((value){
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                  style: AppTextStyles.c14grey400(),
                                ),
                              );
                            }).toList(),
                            value: type,
                            onChanged: (value){
                              type = value;
                            },
                            selectedItemBuilder: (BuildContext context){
                              return typeList.map((value){
                                return Text(
                                  value,
                                  style: AppTextStyles.c14grey400(),
                                );
                              }).toList();
                            },
                            hint: Text(
                              'Select your type',
                              style: AppTextStyles.c14grey400(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //LANGUAGE
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Language',
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.67,
                          child: FutureBuilder(
                            future: getLanguages(),
                            builder: (BuildContext context, AsyncSnapshot snapshot){
                              if(snapshot.hasData){
                                return DropdownButtonFormField(
                                  items: languages.map((value){
                                    return DropdownMenuItem(
                                      value: value['id'],
                                      child: Text(
                                        value['name'],
                                        style: AppTextStyles.c14grey400(),
                                      ),
                                    );
                                  }).toList(),
                                  value: languageId,
                                  onChanged: (value){
                                    languageId = value;
                                  },
                                  selectedItemBuilder: (BuildContext context){
                                    return languages.map((value){
                                      return Text(
                                        value['name'],
                                        style: AppTextStyles.c14grey400(),
                                      );
                                    }).toList();
                                  },
                                  hint: Text(
                                    'Select language',
                                    style: AppTextStyles.c14grey400(),
                                  ),
                                );
                              } else {
                                return DropdownButtonFormField(
                                    items: [],
                                    disabledHint: Text(
                                      'No Languages',
                                      style: AppTextStyles.c14grey400(),
                                    ),
                                    onChanged: (value){}
                                );
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //STATE
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: TextFormField(
                      controller: stateController,
                      decoration: InputDecoration(
                        labelText: 'State',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Cairo",
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: GlobalColors.globalColor()),
                        ),
                        focusColor: GlobalColors.globalColor(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //CITY
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Cairo",
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: GlobalColors.globalColor()),
                        ),
                        focusColor: GlobalColors.globalColor(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //ZIP CODE
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: TextFormField(
                      controller: zipController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Cairo",
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: GlobalColors.globalColor()),
                        ),
                        focusColor: GlobalColors.globalColor(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //ADDRESS
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: TextFormField(
                      controller: addressController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Cairo",
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: GlobalColors.globalColor()),
                        ),
                        focusColor: GlobalColors.globalColor(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  //ASSIGN TO AGENT
                  roleId == 3?Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: TextFormField(
                      enabled: false,
                      initialValue: fullName,
                      decoration: InputDecoration(
                        labelText: 'Agent',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Cairo",
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: GlobalColors.globalColor()),
                        ),
                        focusColor: GlobalColors.globalColor(),
                      ),
                    ),
                  ):Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Assigned agent :',
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
                          ],
                        ),
                      ),
                      FutureBuilder(
                        future: getUsers(),
                        builder: (BuildContext context, AsyncSnapshot snapshot){
                          if(snapshot.hasData){
                            List<String> users = [];
                            for(var x in snapshot.data){
                              users.add(x['full_name']);
                            }
                            user = users[0];
                            return AwesomeDropDown(
                              dropDownList: users,
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
                              selectedItem: user,
                              onDropDownItemClick: (value){
                                user = value;
                                print(user);
                              },
                            );
                          } else {
                            return AnimatedSearch();
                          }
                        }
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
                    child: TextFormField(
                      controller: budgetController,
                      maxLines: 2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Budget *',
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                          fontFamily: "Cairo",
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: GlobalColors.globalColor()),
                        ),
                        focusColor: GlobalColors.globalColor(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  //NOTES
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


                  //SAVE BUTTON
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.02),
                    child: ElevatedButton(
                      onPressed: () async {
                        if(countryId == 0){
                          countryId = null;
                        }
                        AddContactController acc = AddContactController();
                        bool isCreated = false;
                        isCreated  = await acc.createContact(addressController.text, cityController.text, countryId, emailController.text, firstNameController.text, languageId, lastNameController.text, mobilePhoneController.text, notesController.text, phoneController.text, stateController.text, type, zipController.text, double.parse(budgetController.text));
                        if(isCreated){
                          Fluttertoast.showToast(
                            msg: 'Contact successfully created',
                            backgroundColor: Colors.green,
                            gravity: ToastGravity.BOTTOM,
                            toastLength: Toast.LENGTH_LONG,
                            textColor: Colors.white,
                          );
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                            msg: 'An Error has occurred',
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.BOTTOM,
                            toastLength: Toast.LENGTH_LONG,
                            textColor: Colors.white,
                          );
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(GlobalColors.globalColor())
                      ),
                      child: Center(
                        child: Text(
                          'Add Contact',
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
