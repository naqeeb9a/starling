import 'dart:convert';

import 'package:crm_app/CodeSnippets/DateTimeConversion.dart';
import 'package:crm_app/CodeSnippets/LaunchUrlSnippet.dart';
import 'package:crm_app/Views/leads/LeadsDetailsCommonPage.dart';
import 'package:crm_app/Views/leads/LeadsDetailsDashboardPage.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:crm_app/widgets/ColorFunctions/LeadsSubStatusColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadsListingCard extends StatelessWidget {
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

 LeadsListingCard({this.id,this.reference,this.status,this.sub_status,this.enquiry_date,this.client_firstName,this.client_lastName,this.type,this.phone,this.email,this.assignedToId});

 DateTimeConversion dateTimeConversion = DateTimeConversion();
 LaunchUrlSnippet launchApp = LaunchUrlSnippet();
 final box = GetStorage();
 int userId;
 var data;



  @override
  Widget build(BuildContext context) {
   getDetails();
   print(assignedToId);
   print(userId);
   List permissions = box.read('permissions');
    return InkWell(
      onTap: (){
       if(permissions.contains('leads_detail_other') || assignedToId == userId){
        print(userId);
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LeadsDetailsDashboard(id: id,title: reference,)));
       }
      },
      child: Container(
       child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text(
              '$reference',
              style: AppTextStyles.c14black500(),
             ),
            Row(
              children: [
               Icon(Icons.circle,size: 9,color: leadsSubStatusColor(sub_status),),
                Padding(
                  padding:EdgeInsets.only(left: 4.0),
                  child: Text(
                   '$sub_status',
                   style: TextStyle(
                    color: leadsSubStatusColor(sub_status),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Cairo'
                   ),
                  ),
                ),
              ],
            ),
            Text(
             '${dateTimeConversion.getDDMMMYYY(enquiry_date)}',
             style: AppTextStyles.c14grey400(),
            )
           ],
         ),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Flexible(
            child: Text(
             client_lastName != null?'$client_firstName $client_lastName':'$client_firstName',
             style: AppTextStyles.c18black500(),
             maxLines: 2,
             overflow: TextOverflow.ellipsis,
            ),
           ),
           Icon(
            Icons.keyboard_arrow_right,
            size: 30,
            color: Colors.grey,
           )
          ],
         ),
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           Text(
            '$type',
            style: AppTextStyles.c14grey400(),
           ),

           Padding(
             padding: EdgeInsets.only(top: 5.0,right: 30),
             child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
               phone != null && phone != ''? Row(
                 children: [
                   Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: GestureDetector(
                     onTap: (){
                      launchApp.launchWhatsapp('$phone');
                     },
                     child: Image.asset('assets/images/icons/socialIcons/WhatsApp.png',scale: 18,),
                    ),
                   ),
                  Padding(
                   padding: const EdgeInsets.only(bottom: 8.0,left: 5),
                   child: GestureDetector(
                    onTap: (){
                     _callNumber(phone);
                     // launchApp.launchCall('tel:$phone');
                    },
                    child: Image.asset('assets/images/icons/socialIcons/Call.png',scale: 18,),
                   ),
                  ),
                 ],
               ):SizedBox(
                width: 0,
                height: 0,
               ),
               email!=null || email != '' ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0,left: 5),
                child: GestureDetector(
                 onTap: (){
                  launchApp.launchmail('$email');
                 },
                 child: Image.asset('assets/images/icons/socialIcons/Email.png',scale: 18,),
                ),
               ):SizedBox(
                width: 0,
                height: 0,
               ),
               if((phone == null || phone == '') && (email == null || email == ''))
                Container(
                 width: MediaQuery.of(context).size.width * 0.1,
                 height: MediaQuery.of(context).size.height * 0.03,
                 color: Colors.white70,
                 child: Center(
                  child: Text(
                   'No phone/email available',
                   style: AppTextStyles.c12lightGrey400(),
                  ),
                 ),
                )
              ],
             ),
           )
          ],
         ),
        ],
       ),
      ),
    );
  }


  getDetails() async {
   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
   userId = sharedPreferences.get('user_id');
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
