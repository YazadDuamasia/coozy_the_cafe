import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utlis.dart';

class DateUtil {
  static const DATE_FORMAT = "yyyy-MM-ddTHH:mm:ss.SSSSSSZ";

  // 'yyyy-MM-dd HH:mm' =>"2022-02-21 04:14"
  static const DATE_FORMAT1 = 'yyyy-MM-dd HH:mm';

  // 'yyyy-MM-dd HH:mm' =>"21-02-2022 04:14"
  // ignore: constant_identifier_names
  static const DATE_FORMAT2 = 'dd-MM-yyyy HH:mm';

  // 'yyyy-MM-dd HH:mm' =>"21-Feb-2022 04:14"
  static const DATE_FORMAT3 = 'dd-MMM-yyyy HH:mm';

  // 'yy-MM-dd hh:mm:ss aaa' =>"22-02-21 04:15:03 AM"
  static const DATE_FORMAT4 = 'yy-MM-dd hh:mm:ss aaa';

  //"MM-dd-yyyy hh:mm tt" for server which exactly to equal "MM-dd-yyyy hh:mm aaa"
  // 'MM-dd-yy  hh:mm:ss aaa' =>"02-21-22 04:15:03 AM"
  static const DATE_FORMAT5 = 'MM-dd-yy hh:mm:ss aaa';

  // 'dd-MM-yy  hh:mm:ss aaa' =>"21-02-22 04:15:03 AM"
  static const DATE_FORMAT6 = 'dd-MM-yy hh:mm:ss aaa';

  // 'yyyy-MM-dd'=>"2022-02-21"
  static const DATE_FORMAT7 = 'yyyy-MM-dd';

  // 'MM-dd-yyyy'=>"02-21-2022"
  static const DATE_FORMAT8 = 'MM-dd-yyyy';

  // 'dd-MM-yyyy'=>"21-02-2022"
  static const DATE_FORMAT9 = 'dd-MM-yyyy';

  // 'yyyy-MM-dd'=>"21-Feb-2022"
  static const DATE_FORMAT10 = 'dd-MMM-yyyy';

  // 'dd/MM/yyyy hh:mm:ss aaa'=>"11/02/2022 04:16:58 AM"
  static const DATE_FORMAT11 = 'dd/MM/yyyy hh:mm:ss aaa';

  // 'eeee'=>"Friday"
  static const DATE_FORMAT12 = 'eeee';

  // 'EEE'=>"Fri"
  static const DATE_FORMAT13 = 'EEE';

  // 'MMMM'=>"February"
  static const DATE_FORMAT14 = 'MMMM';

  // 'dd-MM-yyyy hh:mm:ss aaa =>"11-02-2022 04:16:58 AM"
  static const DATE_FORMAT15 = 'dd-MM-yyyy hh:mm:ss aaa';

  // 'hh:mm:ss aaa'=>"04:16:58 AM"
  static const TIME_FORMAT1 = 'hh:mm:ss aaa';

  // 'hh:mm aaa'=>"04:16 AM"
  static const TIME_FORMAT2 = 'hh:mm aaa';

  static String? localFormat(String? utcTime, String dateFormat) {
    String? updatedDt;
    try {
      if (utcTime != null) {
        var strToDateTime = DateTime.parse(utcTime);
        final convertLocal = strToDateTime.toLocal();
        updatedDt = DateFormat(dateFormat).format(convertLocal);
      }
    } catch (e) {
      Constants.debugLog(DateUtil, "LocalFormat:error:${e.toString()}");
    }
    return updatedDt;
  }

  static String? localFormatDateTime(DateTime? utcTime, String dateFormat) {
    String? updatedDt;
    try {
      if (utcTime != null) {
        final convertLocal = utcTime.toLocal();
        updatedDt = DateFormat(dateFormat).format(convertLocal);
      }
    } catch (e) {
      Constants.debugLog(DateUtil, "LocalFormat:error:${e.toString()}");
    }
    return updatedDt;
  }

  static DateTime? stringToLocalDate(String? utcTime, String dateFormat) {
    try {
      if (utcTime != null) {
        return DateFormat(dateFormat).parse(utcTime).toLocal();
      }
    } catch (e) {
      Constants.debugLog(
          DateUtil, "StringToLocalDate: error - ${e.toString()}");
    }
    return null;
  }

  static DateTime stringToDate(String? time, String dateFormat) {
    DateTime? input;
    try {
      if (time != null) {
        input = DateFormat(dateFormat).parse(time);
      }
    } catch (e) {
      Constants.debugLog(DateUtil, "StingToDate:error:${e.toString()}");
      input = null;
    }
    return input!;
  }

  static String? dateToString(DateTime? time, String? dateFormat) {
    if (time == null) {
      return null;
    }
    try {
      return DateFormat(dateFormat).format(time);
    } catch (e) {
      return null;
    }
  }

  static DateTime? simpleDateFormatChanger(
      DateTime? inputDate, String? dateFormat) {
    if (inputDate == null || dateFormat == null) return null;

    try {
      final formattedDate = DateFormat(dateFormat).format(inputDate);
      final parsedDate = DateFormat(dateFormat).parse(formattedDate);
      return parsedDate;
    } catch (e) {
      return null;
    }
  }

  static String? simpleStringFormatChanger(
      String? inputDate, String? dateFormat) {
    if (inputDate == null || dateFormat == null) return null;
    try {
      return DateFormat(dateFormat)
          .format(DateFormat(dateFormat).parse(inputDate));
    } catch (e) {
      return null;
    }
  }

  static bool isDateHasValidDateFormat(DateTime? time, String? dateFormat) {
    try {
      DateFormat(dateFormat).format(time!);
      return true;
    } catch (e) {
      return false;
      // throw Exception('Invalid date format');
    }
  }

  static bool isStringHasCorrectDateFormat(String? time, String? dateFormat) {
    try {
      DateFormat(dateFormat).parse(time ?? '');
      return true;
    } catch (e) {
      return false;
      // throw Exception('Invalid date format');
    }
  }

  static DateTime? stringToLocalDateTime(String? utcTime, String dateFormat) {
    try {
      if (utcTime != null) {
        // Parse the input string using the provided date format
        var parsedDateTime = DateFormat(dateFormat).parse(utcTime);

        // Convert the parsed UTC DateTime to local DateTime
        return parsedDateTime.toLocal();
      }
    } catch (e) {
      Constants.debugLog(
          DateUtil, "StringToLocalDateTime: error - ${e.toString()}");
    }
    return null;
  }

  static DateTime? stringToDateTime(String? date, String dateFormat) {
    try {
      if (date != null) {
        // Parse the input string using the provided date format
        var parsedDateTime = DateFormat(dateFormat).tryParse(date);

        // Convert the parsed UTC DateTime to local DateTime
        return parsedDateTime;
      }
    } catch (e) {
      Constants.debugLog(DateUtil, "stringToDateTime: error - ${e.toString()}");
    }
    return null;
  }

  // Convert DateTime to TimeOfDay
  static TimeOfDay dateTimeToTimeOfDay(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  // Convert TimeOfDay to DateTime
  static DateTime timeOfDayToDateTime(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    return DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  }

  // Format TimeOfDay as string
  static String formatTimeOfDay(TimeOfDay timeOfDay, String pattern) {
    final dateTime = timeOfDayToDateTime(timeOfDay);
    return DateFormat(pattern).format(dateTime);
  }

  static TimeOfDay parseTimeOfDay(String time, String format) {
    DateTime? dateTime =
        DateFormat(format ?? DateUtil.TIME_FORMAT2).tryParse(time);
    return TimeOfDay(hour: dateTime?.hour ?? 0, minute: dateTime?.minute ?? 0);
  }

  String formatDuration(Duration duration) {
    // Format duration into "HH:mm"
    String hours = (duration.inHours % 24).toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');

    return '$hours:$minutes';
  }

  static String? calculateRemainingTime(
      {String? fromTime, String? toTime, required String? format}) {
    try {
      DateTime? startDateTime =
          DateFormat(format).tryParse(fromTime!);
      DateTime? endDateTime =
          DateFormat(format).tryParse(toTime!);

      // Calculate the difference
      Duration difference = startDateTime!.difference(endDateTime!);

      // Convert the difference to hours and minutes
      int days = difference.inDays;
      int hours = difference.inHours % 24;
      int minutes = difference.inMinutes % 60;
      StringBuffer stringBuffer = StringBuffer("");
      if (days != 0) {
        stringBuffer.write("$days days");
      } else if (hours != 0) {
        if (days != 0) {
          stringBuffer.write(", $hours hours");
        } else {
          stringBuffer.write("$hours hours");
        }
      }
      if (minutes != 0) {
        if (hours != 0) {
          stringBuffer.write(", $minutes minutes");
        } else {
          stringBuffer.write("$minutes minutes");
        }
      }

      String? dateValue = stringBuffer.toString();
      // Return formatted string
      return dateValue;
    } catch (e) {
      // Handle parsing errors
      print("error:${e}");
      return null;
    }
  }

  static int? calculateTimeDifferenceInSeconds(
      String checkInTime, String checkOutTime) {
    try {
      DateTime checkInDateTime = DateFormat.jm().parse(checkInTime);
      DateTime checkOutDateTime = DateFormat.jm().parse(checkOutTime);

      // Calculate the difference
      Duration? difference = checkOutDateTime.difference(checkInDateTime);
      Constants.debugLog(DateUtil,
          "calculateTimeDifferenceInMinutes:difference:${difference.inMinutes.toString()}");
      return difference.inSeconds;
    } catch (error) {
      Constants.debugLog(
          DateUtil, "calculateTimeDifferenceInMinutes:Error:${error}");
      return null;
    }
  }
}
