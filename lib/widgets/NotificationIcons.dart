import 'package:crm_app/globals/globalColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Icon getNotificationIcons(String type){

  switch(type){
    case 'lead_view':
      {
        return Icon(
          Icons.remove_red_eye,
          color: GlobalColors.globalColor(),
          size: 25,
        );
      }
      break;

    case 'listing':
      {
        return Icon(
          Icons.list,
          color: GlobalColors.globalColor(),
          size: 25,
        );
      }
      break;

    case 'lead':
      {
        return Icon(
          Icons.new_releases_outlined,
          color: GlobalColors.globalColor(),
          size: 25,
        );
      }
      break;

    case 'task':
      {
        return Icon(
          Icons.task,
          color: GlobalColors.globalColor(),
          size: 25,
        );
      }
      break;

    case 'user':
      {
        return Icon(
          Icons.people,
          color: GlobalColors.globalColor(),
          size: 25,
        );
      }
      break;

    case 'notice':
      {
        return Icon(
          Icons.volume_up_rounded,
          color: GlobalColors.globalColor(),
          size: 25,
        );
      }
      break;

    case 'call_center':
      {
        return Icon(
          Icons.phone,
          color: GlobalColors.globalColor(),
          size: 25,
        );
      }
      break;

    default:
      {
        return Icon(
          Icons.notifications,
          color: GlobalColors.globalColor(),
          size: 25,
        );
      }
  }

}