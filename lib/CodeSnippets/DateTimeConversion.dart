import 'package:intl/intl.dart';

class DateTimeConversion {
  String dateFormated(String date) {
    String dt = new DateFormat("yyyy-MM-dd").parse(date).toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(dt);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  String dateForService(String date) {
    String dt = new DateFormat("yyyy-MM-dd").parse(date).toString();
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(dt);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  String getDDMMMYYY(String date) {
    try
    {
      return DateFormat('dd MMM yyy').format(DateTime.parse(date));
    }
    catch(e){
      return '';
    }

  }

  String getDDMMMYYYandTIME(String date) {
    try
    {
      return DateFormat('dd MMM yyy | h:mm a ').format(DateTime.parse(date));
    }
    catch(e){
      return '';
    }

  }
}
