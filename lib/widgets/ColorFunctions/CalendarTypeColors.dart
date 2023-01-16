import 'package:flutter/material.dart';

Color calendarColor(String type) {
  switch(type){
    case 'lead_view':
      {
        return Colors.blue.shade300;
      }
      break;
    case 'task':
      {
        return Colors.red.shade400;
      }
      break;
    default:
      {
        return Colors.lightGreen;
      }
  }
}