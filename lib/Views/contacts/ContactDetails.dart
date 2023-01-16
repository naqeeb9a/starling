import 'dart:convert';

import 'package:crm_app/CodeSnippets/LaunchUrlSnippet.dart';
import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/appbars/CommonAppBars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class ContactDetails extends StatelessWidget {

  final int id;
  String reference;
  String fullName;
  String mobile;
  String phone;
  String email;
  ContactDetails({this.id,this.reference,this.fullName,this.mobile,this.phone,this.email});

  LaunchUrlSnippet launchApp = LaunchUrlSnippet();
  var data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '$fullName',
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
          Container(
            height: MediaQuery.of(context).size.height * 0.22,
            color: GlobalColors.globalColor(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.045),
                  child: Center(
                    child: CircleAvatar(
                      foregroundColor: Colors.blue,
                      foregroundImage: NetworkImage('https://ui-avatars.com/api/?background=EEEEEE&color=3F729B&name=$fullName&size=128&font-size=0.33'),
                      radius: 50,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  '$reference',
                  style: AppTextStyles.c16white600(),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'CONTACT DETAILS: ',
              style: AppTextStyles.c20black400(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: InkWell(
              onTap: (){
                _callNumber(mobile);
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
                    Text('$mobile'),
                  ],
                ),
                labelStyle: AppTextStyles.c14black500(),
              ),
            ),
          ),
          if(phone != '971')
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: InkWell(
                onTap: (){
                  _callNumber(phone);
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
                      Text('$phone'),
                    ],
                  ),
                  labelStyle: AppTextStyles.c14black500(),
                ),
              ),
            ),
          (email!=null && email != '')?Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: InkWell(
              onTap: (){
                launchApp.launchmail('$email');
              },
              child: RawChip(
                backgroundColor: Colors.grey,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mail,size: 15,),
                    SizedBox(
                      width: 5,
                    ),
                    Text('$email'),
                  ],
                ),
                labelStyle: AppTextStyles.c14black500(),
              ),
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
        ],
      ),
    );
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
