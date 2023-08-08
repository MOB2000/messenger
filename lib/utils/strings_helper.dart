import 'package:intl/intl.dart';

class StringsHelper {
  StringsHelper._();

  static String formatDate(DateTime dateTime) {
    return DateFormat('d/M h:m').format(dateTime);
  }
}
