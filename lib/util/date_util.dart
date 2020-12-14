import 'package:intl/intl.dart';

class DateUtil {

  static DateTime parseFromServer(String dateParam) {
    dateParam = dateParam.replaceAll('T', ' ');
    dateParam = dateParam.replaceAll('.000Z', '');
    if (dateParam == '0000-00-00') {
        return null;
    }
    return new DateFormat('y-M-d').add_Hms().parse(dateParam);
  }

  static String formatToyMMMd(DateTime dateParam) {
    if (dateParam == null) {
      return "-";
    }
    return DateFormat.yMMMd().format(dateParam);
  }
}