import 'package:flutter/material.dart';
Color leadsSourceColor(String status){
  switch(status){
    case 'Bayut':
      {
        return Color(0xFF28B16D);
      }
      break;
    case 'Cold Calling':
      {
        return Color(0xFF24CBE5);
      }
      break;
    case 'Company Lead':
      {
        return Color(0xFF64E572);
      }
      break;
    case 'Dubizzle':
      {
        return Color(0xFFBB2025);
      }
      break;
    case 'Personal':
      {
        return Color(0xFF2F7ED8);
      }
      break;
    case 'Property Finder':
      {
        return Color(0xFFEF5E4E);
      }
      break;
    case 'Website':
      {
        return Color(0xFF0046BF);
      }
      break;
    default:
      {
        return Color(0xFF808080);
      }
      break;
  }
}