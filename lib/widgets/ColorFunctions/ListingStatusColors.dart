import 'package:flutter/material.dart';
Color listingStatusColor(String status){
  switch(status){
    case 'Approved':
      {
        return Color(0xFF78D376);
      }
      break;
    case 'Archived':
      {
        return Color(0xFFEF752F);
      }
      break;
    case 'Draft':
      {
        return Color(0xFF3B92E3);
      }
      break;
    case 'Pending':
      {
        return Color(0xFFF9D767);
      }
      break;
    case 'Rejected':
      {
        return Colors.red;
      }
      break;
    default:
      {
        return Colors.black;
      }
  }


}

List<String> updateStatuses (String status) {
  switch(status){
    case 'all':
      {
        return ['Draft', 'Pending', 'Approved', 'Rejected', 'Archived'];
      }
      break;
    case 'new':
      {
        return ['Draft', 'Pending'];
      }
      break;
    case 'draft':
      {
        return ['Draft', 'Pending'];
      }
      break;
    case 'pending':
      {
        return ['Draft', 'Pending', 'Archived'];
      }
      break;
    case 'save':
      {
        return ['Pending', 'Approved', 'Rejected'];
      }
      break;
    case 'scheduled':
      {
        return ['Approved', 'Rejected'];
      }
      break;
    case 'approved':
      {
        return ['Pending', 'Approved', 'Rejected', 'Archived'];
      }
      break;
    case 'rejected':
      {
        return ['Pending', 'Approved', 'Rejected', 'Archived'];
      }
      break;
    case 'archived':
      {
        return ['Archived'];
      }
      break;
    case 'current':
      {
        return ['Draft', 'Pending', 'Approved', 'Rejected'];
      }
      break;
    case 'archive':
      {
        return ['Unpublished', 'Archived'];
      }
      break;
    case 'portal':
      {
        return ['Unpublished', 'Published'];
      }
      break;
  }
}