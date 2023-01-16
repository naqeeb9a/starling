import 'dart:convert';
import 'dart:io';

import 'package:crm_app/ApiRoutes/api_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ListingUpdateController {
  final int id;

  ListingUpdateController({this.id});

  Future<bool> updateListing(String title,String description,int assignedToId, int beds, int baths, String buildUpArea, String buildingNo, int categoryId, int cheques, int cityId, String commission, String commissionPercent, String completionDate, String completionStatus, String constructionStatus, String deposit, String depositPercent, String floor, String frequency, String furnished, int isExclusive, int isFeatured, int isInvite, int isManaged, int isPoa, int isPremium, int isTenanted, int languageId, String listingStatus, int locationId, String occupancy, int ownerId, String parking, String paymentPlan, String permitNo, String plotArea, String portalStatus, String price, String pricePerSqFt, String projectStatus, String propertyDeveloper, String propertyOwnership, String propertyType, String scheduledDate, String sourceId, String streetNo, int subLocationId, int tenantId, String tenure, String type, String transactionNo, String unitNo, String view) async {

    String url = '${ApiRoutes.BASE_URL}/api/listings/$id';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'title': title,
      'description': description,
      'assigned_to_id': assignedToId,
      'baths': baths,
      'beds': beds,
      'build_up_area': buildUpArea!= null && buildUpArea != ''?double.parse(buildUpArea):0,
      'building_no': buildingNo,
      'category_id': categoryId,
      'cheques': cheques,
      'city_id': cityId,
      'commission': commission!= null && commission != ''?double.parse(commission):0,
      'commission_percent': commissionPercent!=null && commissionPercent!= ''?double.parse(commissionPercent): 0,
      'completion_date': completionDate,
      'completion_status': completionStatus,
      'construction_status': constructionStatus,
      'deposit': deposit!= null && deposit != ''?double.parse(deposit):0,
      'deposit_percent': depositPercent!= null && depositPercent != ''?double.parse(depositPercent):0,
      'floor': floor,
      'frequency': frequency,
      'furnished': furnished,
      'is_exclusive': isExclusive,
      'is_featured': isFeatured,
      'is_invite': isInvite,
      'is_managed': isManaged,
      'is_poa': isPoa,
      'is_premium': isPremium,
      'is_tenanted': isTenanted,
      'language_id': languageId,
      'listing_status': listingStatus,
      'location_id': locationId,
      'occupancy': occupancy,
      'owner_id': ownerId,
      'parking': parking!=null && parking!=''?int.parse(parking): 0,
      'payment_plan': paymentPlan,
      'permit_no': permitNo,
      'plot_area': plotArea!=null && plotArea!=''?double.parse(plotArea): 0,
      'portal_status': portalStatus,
      'price': price!=null && price!=''?double.parse(price):0,
      'price_per_sq_feet': pricePerSqFt!=null && pricePerSqFt!=''?double.parse(pricePerSqFt):0,
      'project_status': projectStatus,
      'property_developer': propertyDeveloper,
      'property_ownership': propertyOwnership,
      'property_type': propertyType,
      'scheduled_date': scheduledDate,
      'source_id': sourceId,
      'street_no': streetNo,
      'sub_location_id': subLocationId,
      'tenant_id': tenantId,
      'tenure': tenure,
      'type': type,
      'transaction_no': transactionNo,
      'unit_no': unitNo,
      'view': view
    };
    print(data);
    var response = await http.put(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader:
          'Bearer ${sharedPreferences.get('token')}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data)
    );

    print(response.body);

    if(response.statusCode == 201){
      return true;
    } else {
      print(response.body);
      return false;
    }
  }
}