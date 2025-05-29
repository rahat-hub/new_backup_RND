import 'dart:async';

import 'package:aviation_rnd/helper/snack_bar_helper.dart';
import 'package:intl/intl.dart';

abstract class DateTimeHelper {
  /// Private constructor to prevent instantiation
  DateTimeHelper._();

  /// Time difference between the server and the device
  static Duration _timeDifference = Duration.zero;

  /// Default date time format
  static final DateFormat _dateTimeFormat = DateFormat("MM/dd/yyyy HH:mm:ss");

  /// Set the current date time from the server
  /// &
  /// calculate the time difference between the server and the device
  static set currentDateTime(String systemDateTime) {
    final DateTime serverDateTime = _dateTimeFormat.tryParse(systemDateTime) ?? DateTime.now();
    _timeDifference = serverDateTime.difference(DateTime.now());
  }

  /// Get the current date time from the device as a string in the format "MM/dd/yyyy HH:mm:ss"
  ///
  /// Example: "12/31/1900 23:59:00"
  static String get currentDateTime => _dateTimeFormat.format(now);

  /// Get the current date time from the server as a DateTime object
  ///
  /// Example: DateTime(1900, 12, 31, 12, 0, 0)
  static DateTime get now {
    final DateTime currentTime = DateTime.now();
    return currentTime.add(_timeDifference).copyWith(second: currentTime.second, millisecond: currentTime.millisecond);
  }

  /// Get the current date time from the server as a string in the format "MM/dd/yyyy HH:mm:ss"
  ///
  /// Example: "12/31/1900 23:59:00"
  static String get serverDateTime => _dateTimeFormat.format(now);

  /// Get the current date time from the device as a string in the format "MM/dd/yyyy HH:mm:ss"
  ///
  /// Example: "12/31/1900 23:59:00"
  static String get deviceDateTime => _dateTimeFormat.format(DateTime.now());

  /// Change [DateTime] obj in the format "MM/dd/yyyy HH:mm"
  ///
  /// Example: "12/31/1900 23:59"
  static DateFormat get dateTimeFormat24H => DateFormat("MM/dd/yyyy HH:mm");

  /// Change [DateTime] obj in the format "MM/dd/yyyy HH:mm"
  ///
  /// Example: "12/31/1900 23:59"
  static DateFormat get dateTimeFormatDefault => dateTimeFormat24H;

  /// Change [DateTime] obj in the format "MM/dd/yyyy hh:mm a"
  ///
  /// Example: "12/31/1900 11:59 AM"
  static DateFormat get dateTimeFormat12H => DateFormat("MM/dd/yyyy hh:mm a");

  /// Change [DateTime] obj in the format "MM/dd/yyyy"
  ///
  /// Example: "12/31/1900"
  static DateFormat get dateFormatAsMDY => DateFormat("MM/dd/yyyy");

  /// Change [DateTime] obj in the format "MM/dd/yyyy"
  ///
  /// Example: "12/31/1900"
  static DateFormat get dateFormatDefault => dateFormatAsMDY;

  /// Change [DateTime] obj in the format "dd/MM/yyyy"
  ///
  /// Example: "31/12/1900"
  static DateFormat get dateFormatAsDMY => DateFormat("dd/MM/yyyy");

  /// Change [DateTime] obj in the format "yyyy/MM/dd"
  ///
  /// Example: "1900/12/31"
  static DateFormat get dateFormatAsYMD => DateFormat("yyyy/MM/dd");

  /// Change [DateTime] obj in the format "HH:mm"
  ///
  /// Example: "23:59"
  static DateFormat get timeFormatAs24H => DateFormat("HH:mm");

  /// Change [DateTime] obj in the format "HH:mm"
  ///
  /// Example: "23:59"
  static DateFormat get timeFormatDefault => timeFormatAs24H;

  /// Change [DateTime] obj in the format "hh:mm a"
  ///
  /// Example: "11:59 AM"
  static DateFormat get timeFormatAs12H => DateFormat("hh:mm a");

  ///Check if the time is valid or not
  ///
  ///Example: isValidTime(time: "12:00") => true
  static bool isValidTime({String? time}) {
    String strValue = time ?? "";
    String errorMsg = "";

    final int length = strValue.length;

    if (length == 4) {
      final String first1 = strValue.substring(0, 2);
      final String first2 = strValue.substring(2, 4);
      strValue = "$first1:$first2";
    }

    if (length == 3) {
      final String first1 = strValue.substring(0, 1);
      final String first2 = strValue.substring(1, 3);
      strValue = "0$first1:$first2";
    }

    final RegExp re = RegExp(r'^(\d{1,2}):(\d{2})(:00)?([ap]m)?$');

    if (strValue != '') {
      if (re.hasMatch(strValue)) {
        final List<List<String?>> regs = re.allMatches(strValue).map((RegExpMatch m) => m.groups(<int>[0, 1, 2, 3, 4])).toList();

        if (regs[0][4] != null) {
          // 12-hour time format with am/pm
          if (int.parse(regs[0][1].toString()) < 1 || int.parse(regs[0][1].toString()) > 12) {
            errorMsg = "Invalid value for hours: ${regs[0][1]}";
          }
        } else {
          // 24-hour time format
          if (int.parse(regs[0][1].toString()) > 23) {
            errorMsg = "Invalid value for hours: ${regs[0][1]}";
          }
        }
        if (errorMsg.isEmpty && int.parse(regs[0][2].toString()) > 59) {
          errorMsg = "Invalid value for minutes: ${regs[0][2]}";
        }
      } else {
        errorMsg = "Invalid time format: $strValue";
      }
    }

    if (errorMsg != "") {
      unawaited(SnackBarHelper.openSnackBar(isError: true, message: errorMsg));
      return false;
    } else {
      return true;
    }
  }

  ///Check if the date is valid or not
  ///
  ///Example: isValidDate(date: "12/31/1900") => true
  static bool isValidDate({required String date}) {
    String errorMsg = "";
    final String d = date;
    final RegExp regExp = RegExp(r'^\d{1,2}/\d{1,2}/\d{4}$');
    if (!regExp.hasMatch(d)) {
      errorMsg = "This Date Appears Invalid!\nPlease Check Your Date and Ensure It is in mm/dd/yyyy Format or Blank.";
    } else {
      final List<String> spd = d.split("/");
      final int month = int.parse(spd[0]);
      final int day = int.parse(spd[1]);
      final int year = int.parse(spd[2]);
      // check leap year
      final bool isLeapYear = ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
      final int i = isLeapYear ? 1 : 0;

      int dayUpperLimit = 30;
      switch (month) {
        case 2: // February
          dayUpperLimit = 28 + i;
        case 1: //January
        case 3: // March
        case 5: // May
        case 7: // July
        case 8: // August
        case 10: // October
        case 12: // December
          dayUpperLimit = 31;
      }

      // check valid month or day
      if (month > 12) {
        errorMsg = "This Date Appears Invalid!\nPlease Change Your Month, $month Is Not A Valid Month.";
      } else if (month <= 12 && day > dayUpperLimit) {
        if (month == 2 && day > 28 + i && day < 30) {
          errorMsg = "This Date Appears Invalid!\nPlease Change Your Day, $year Is Not A Leap Year.";
        } else {
          errorMsg = "This Date Appears Invalid!\nPlease Change Your Day, $day Is Not A Valid Day For Month: $month.";
        }
      } else if (month < 1 || day < 1 || year < 1) {
        errorMsg = "This Date Appears Invalid!\nPlease Change Your Date, $month/$day/$year Is Not A Valid Date.";
      }
    }
    if (errorMsg != "") {
      unawaited(SnackBarHelper.openSnackBar(isError: true, message: errorMsg));
      return false;
    } else {
      return true;
    }
  }
}
