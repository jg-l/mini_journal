import 'package:intl/intl.dart';

extension EntryDateFormat on DateTime {
  String entryDate() {
    final DateFormat formatter = DateFormat('MMM d y');
    return formatter.format(this);
  }

  String entryTime() {
    final DateFormat formatter = DateFormat('jm');
    return formatter.format(this);
  }
}
