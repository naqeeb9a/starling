import 'package:crm_app/globals/globalColors.dart';
import 'package:crm_app/textstyle/AppTextStyles.dart';
import 'package:flutter/material.dart';

class BasicAppBar extends StatelessWidget with PreferredSizeWidget{

  Color bgColor;
  Widget title;
  final Size preferredSize;
  BasicAppBar({this.bgColor,this.title,Key key,}): preferredSize = Size.fromHeight(50.0),super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: InkWell(
        onTap: (){
        },
        child: Icon(
          Icons.menu,
          color: GlobalColors.globalColor(),
        ),
      ),
      backgroundColor: bgColor == null? Colors.white:bgColor,
      title: title == null? '': title,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.notifications,
            color: GlobalColors.globalColor()
          ),
        )
      ],
    );
  }
}

class PagesAppBar extends StatelessWidget with PreferredSizeWidget{

  Color bgColor;
  Widget title;
  final Size preferredSize;
  PagesAppBar({this.bgColor,this.title,Key key,}): preferredSize = Size.fromHeight(50.0),super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 10,
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: (){
          Navigator.pop(context);
        },
        icon: bgColor != GlobalColors.globalColor()?Icon(Icons.arrow_back_ios, color: GlobalColors.globalColor(), size: 27,):Icon(Icons.arrow_back_ios, color: Colors.white, size: 27,),
      ),
      title: title != null? title : Image.asset('assets/images/fclogoDB.jpg',scale: 73.0,),
    );
  }
}