import 'package:crm_app/globals/globalColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../textstyle/AppTextStyles.dart';

class ProfileHeader extends StatelessWidget {

  final box = GetStorage();


  @override
  Widget build(BuildContext context) {

    String fullName = box.read('full_name').toString();
    String initials = box.read('initials');

    return Container(
      height: MediaQuery.of(context).size.height *0.075,
      color: GlobalColors.globalColor(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            color: Colors.white,
            width: 70,
            height: 100,
            child: Center(child: Text(initials,style: TextStyle(fontSize: 30,color: GlobalColors.globalColor(),fontFamily: 'Cairo'),)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(fullName.toUpperCase(),style: AppTextStyles.c18white600(),),
          ),

        ],
      ),
    );
  }
}
