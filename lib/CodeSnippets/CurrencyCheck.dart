import 'package:intl/intl.dart';
class FormatCurrency{

  String CurrencyCheck(double currency)
  {
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'ar_AE',name: "");
    String formatedCurrency=formatCurrency.format(currency);
    return formatedCurrency;
  }
}