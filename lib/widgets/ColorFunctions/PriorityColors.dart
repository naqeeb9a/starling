import 'package:flutter/material.dart';

Color priorityColor(String priority){
  switch(priority){
    case 'Low':
      {
        return Color(0xFFFF9655);
      }
      break;
    case 'Medium':
      {
        return Color(0xFF64E572);
      }
      break;
    case 'High':
      {
        return Color(0xFF2F7ED8);
      }
      break;
    case 'Urgent':
      {
        return Color(0xFFED561B);
      }
      break;
    default:
      {
        return Color(0xFF0000FF);
      }
  }
}


Color taskStatus(String status){
  switch(status){
    case 'Pending':
      {
        return Color(0xFFCC0000);
      }
      break;
    case 'In Progress':
      {
        return Color(0xFFffbb33);
      }
      break;
    case 'Completed':
      {
        return Color(0xFF007E33);
      }
      break;
    default:
      {
        return Color(0xFF0000FF);
      }
  }
}

Color leadPriority(String status){
  switch(status){
    case 'Urgent':
      {
        return Color(0xFFFF0000);
      }
      break;
    case 'High':
      {
        return Color(0xFFFF930F);
      }
      break;
    case 'Normal':
      {
        return Color(0xFFFFF263);
      }
      break;
    case 'Low':
      {
        return Color(0xFF24CBE5);
      }
      break;
    case 'Dead':
      {
        return Color(0xFF808080);
      }
      break;
    default:
      {
        return Color(0xFF808080);
      }
      break;
  }
}