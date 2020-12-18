import 'package:intl/intl.dart';

class DateUtil {

  static DateTime parseFromServer(String dateParam) {
    dateParam = dateParam.replaceAll('T', ' ');
    dateParam = dateParam.replaceAll('.000Z', '');
    if (dateParam == '0000-00-00') {
        return null;
    }
    if (!dateParam.contains(" ")) {
      return new DateFormat('y-M-d').parse(dateParam);
    }
    return new DateFormat('y-M-d').add_Hms().parse(dateParam);
  }

  static String formatToyMMMd(DateTime dateParam) {
    if (dateParam == null) {
      return "-";
    }
    return DateFormat.yMMMd().format(dateParam);
  }
  static String formatToyMdHm(DateTime dateParam) {
    if (dateParam == null) {
      return "-";
    }
    return '${DateFormat.yMMMd().add_Hm().format(dateParam)}';
  }
  static String formatToMMMMy(DateTime dateParam) {
    if (dateParam == null) {
      return "-";
    }
    return new DateFormat('MMMM y').format(dateParam);
  }
}