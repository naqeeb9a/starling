import 'package:flutter/material.dart';

Color viewingStatusColors(String status){
  switch (status){
    case 'Scheduled':
      {
        return Color(0xFF4DD0E1);
      }
      break;
    case 'Cancelled':
      {
        return Color(0xFF33b5e5);
      }
      break;
    case 'Successful':
      {
        return Color(0xFF64dd17);
      }
      break;
    case 'Unsuccessful':
      {
        return Color(0xFFF50057);
      }
      break;
    default:
      {
        return Color(0xFF9e9e9e);
      }
  }
}