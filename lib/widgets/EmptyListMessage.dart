import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:flutter/cupertino.dart';

class EmptyListMessage extends StatelessWidget {
  String message;
  EmptyListMessage({this.message});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$message',style: AppTextStyles.c14grey400(),),
    );
  }
}