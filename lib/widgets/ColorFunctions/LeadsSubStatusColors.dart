import 'package:flutter/material.dart';
Color leadsSubStatusColor(String status){
  switch(status){
    case 'Called No reply':
    case 'Called No Reply':
      {
        return Color(0xFFD1CB02);
      }
      break;
    case '● In Progress':
    case 'In Progress':
      {
        return Color(0xFF3F9247);
      }
      break;
    case 'Invalid Inquiry':
      {
        return Color(0xFFFF9655);
      }
      break;
    case '● Invalid Number':
    case 'Invalid Number':
      {
        return Color(0xFFF4D30B);
      }
      break;
    case 'Not Interested':
      {
        return Color(0xFF24CBE5);
      }
      break;
    case 'Not Yet Contacted':
      {
        return Color(0xFFED561B);
      }
      break;
    case 'Offer Made':
      {
        return Color(0xFF2F7ED8);
      }
      break;
    case 'Prospect':
      {
        return Color(0xFF0D233A);
      }
      break;
    case 'Successful':
      {
        return Color(0xFF50B432);
      }
      break;
    case '● Unsuccessful':
    case 'Unsuccessful':
      {
        return Color(0xFFD87F4E);
      }
      break;
    case 'Viewing':
      {
        return Color(0xFF6AF9C4);
      }
      break;
    default:
      {
        return Color(0xFF9E9E9E);
      }
  }
}