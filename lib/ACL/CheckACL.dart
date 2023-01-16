
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool canAccess (String permission){
  final box = GetStorage();
  List<dynamic> permissions = box.read('permissions');
  if(permissions.contains(permission)){
    return true;
  } else {
    return false;
  }
}