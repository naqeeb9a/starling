import 'dart:convert';

import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/CodeSnippets/LaunchUrlSnippet.dart';
import 'package:crm_app/Views/leads/LeadsDetailsCommonPage.dart';
import 'package:crm_app/Views/leads/LeadsDetailsDashboardPage.dart';
import 'package:crm_app/Views/leads/NewLeadsDetailLandingPage.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/LeadSourceColors.dart';
import 'package:crm_app/widgets/ColorFunctions/LeadsSubStatusColors.dart';
import 'package:crm_app/widgets/ColorFunctions/PriorityColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewLeadListingCard extends StatelessWidget {

  final int id;
  String reference;
  String status;
  String sub_status;
  String enquiry_date;
  String client_firstName;
  String client_lastName;
  String type;
  String phone;
  String email;
  int assignedToId;
  String campaign;
  String source;
  String priority;
  String agent;


  NewLeadListingCard({this.id,this.reference,this.status,this.sub_status,this.enquiry_date,this.client_firstName,this.client_lastName,this.type,this.phone,this.email,this.assignedToId, this.campaign, this.source, this.priority, this.agent});

  LaunchUrlSnippet launchApp = LaunchUrlSnippet();
  var data;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> NewLeadsDetailLandingPage(id: id,)));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0,top: 10,right: 8,bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFB3B3B3),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        '$reference',
                        style: AppTextStyles.c10whiteB400(),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: leadsSubStatusColor(sub_status),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3,vertical: 5.0),
                      child: Center(
                        child: Text(
                          sub_status == 'Not Yet Contacted'?'NYC':'$sub_status',
                          style: AppTextStyles.c10whiteB400(),
                          overflow: TextOverflow.ellipsis,

                        ),
                      ),
                    ),
                  ),

                  source != ''&& source != null?Container(
                    decoration: BoxDecoration(
                      color: leadsSourceColor(source),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Center(
                        child: Text(
                          '$source',
                          style: AppTextStyles.c10whiteB400(),
                        ),
                      ),
                    ),
                  ):SizedBox(
                    width: 0,
                    height: 0,
                  ),

                  priority != ''&& priority != null?Row(
                    children: [
                      Icon(
                        Icons.circle,
                        size: 13,
                        color: leadPriority(priority),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        '$priority',
                        style: AppTextStyles.c12grey400(),
                      )
                    ],
                  ):SizedBox(width: 0,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              client_lastName!=null && client_lastName!=''?'$client_firstName $client_lastName': '$client_firstName',
                              style: AppTextStyles.c16black600(),
                              maxLines: 2,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Color(0xFF999999),
                                size: 14,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${DateTimeConversion().getDDMMMYYYandTIME(enquiry_date)}',
                                style: AppTextStyles.c12grey400(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          agent != null && agent != ''?Row(
                            children: [
                              Icon(
                                Icons.account_circle_rounded,
                                color: Color(0xFF999999),
                                size: 14,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                '$type',
                                style: AppTextStyles.c12grey400(),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ):SizedBox(width: 0,),
                          SizedBox(
                            width: 10,
                          ),
                          phone!=null && phone!=''?Row(
                            children: [
                              Icon(
                                Icons.smartphone,
                                size: 12,
                                color: Color(0xFF999999),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                '$phone',
                                style: AppTextStyles.c12grey400(),
                              ),
                            ],
                          ):SizedBox(width: 0,),
                          SizedBox(
                            width: 10,
                          ),

                        ],
                      ),
                    ),
                    email!=null && email!=''?Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 3),
                      child: Row(
                        children: [
                          Icon(
                            Icons.email,
                            size: 12,
                            color: Color(0xFF999999),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            '$email',
                            style: AppTextStyles.c12grey400(),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ):SizedBox(width: 0,),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0,top: 4,right: 8,bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      agent!=null && agent != ''?Container(
                        decoration: BoxDecoration(
                            color: Color(0xFFFB8500),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.support_agent,
                                size: 14,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Flexible(
                                child: Text(
                                  '$agent',
                                  style: AppTextStyles.c10whiteB400(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ):SizedBox(width: 0,),
                      SizedBox(width: 5,),
                      campaign!=null && campaign != ''?Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF758BFD),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.campaign,
                                size: 14,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Flexible(
                                child: Text(
                                  '$campaign',
                                  style: AppTextStyles.c10whiteB400(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ):SizedBox(width: 0,),
                    ],
                  ),
                  Row(
                    children: [
                      phone != null && phone != ''? Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              launchApp.launchWhatsapp('$phone');
                            },
                            child: Image.asset('assets/images/whatsapp.png',scale: 3),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          GestureDetector(
                            onTap: (){
                              _callNumber(phone);
                              // launchApp.launchCall('tel:$phone');
                            },
                            child: Image.asset('assets/images/call.png',scale: 3,),
                          ),
                        ],
                      ):SizedBox(
                        width: 0,
                        height: 0,
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      email!=null || email != '' ? GestureDetector(
                        onTap: (){
                          launchApp.launchmail('$email');
                        },
                        child: Image.asset('assets/images/email.png',scale: 3,),
                      ):SizedBox(
                        width: 0,
                        height: 0,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
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

