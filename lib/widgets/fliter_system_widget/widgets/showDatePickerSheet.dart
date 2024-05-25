import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/**
 * dateAndTime
    DateTime? selectedDate = await showDatePickerSheet(
    context: context,
    pickerMode: CupertinoDatePickerMode.dateAndTime,
    initialDate: DateTime.now(),
    );

    if (selectedDate != null) {
    // Handle the selected date
    print('Selected Date: $selectedDate');
    } else {
    // User canceled
    print('Date selection canceled');
    }

 **/

/**
 * Time
    DateTime? selectedDate = await showDatePickerSheet(
    context: context,
    pickerMode: CupertinoDatePickerMode.time,
    initialDate: DateTime.now(),
    );

    if (selectedDate != null) {
    // Handle the selected date
    print('Selected Date: $selectedDate');
    } else {
    // User canceled
    print('Date selection canceled');
    }

 **/
Future<DateTime?> showDatePickerSheet(
    {required BuildContext? context,
    required CupertinoDatePickerMode? pickerMode,
    required DateTime? initialDate,
    Color? backgroundColor,
    DateTime? minimumDate,
    DateTime? maximumDate,
    DatePickerDateOrder? dateOrder,
    String? textButtonCancel,
    String? textButtonOkay}) async {
  Completer<DateTime?> completer = Completer();
  DateTime? selectedDate = initialDate ?? DateTime.now();
  showModalBottomSheet(
    context: context!,
    builder: (_) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  // completer.complete(null); // User canceled, resolve with null
                  Navigator.pop(context);
                },
                child: Text(
                  textButtonCancel ?? "cancel",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  completer
                      .complete(selectedDate); // Resolve with the selected date
                  Navigator.pop(context);
                },
                child: Text(
                  textButtonOkay ?? "Ok",
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: CupertinoDatePicker(
            mode: pickerMode ?? CupertinoDatePickerMode.dateAndTime,
            initialDateTime: initialDate ?? DateTime.now(),
            minimumDate: minimumDate,
            maximumDate: maximumDate,
            // backgroundColor: backgroundColor??Colors.white,
            dateOrder: dateOrder,
            onDateTimeChanged: (DateTime newDate) {
              selectedDate = newDate; // Update the selected date
            },
          ),
        ),
      ],
    ),
  );

  return completer.future;
}

/**
    TimeOfDay selectedTime = TimeOfDay(hour: 2, minute: 30);
    String durationString = timeOfDayToDurationString(selectedTime);
    print('Selected Time: $durationString'); // Output: "2 hours 30 minutes"
 **/
Future<TimeOfDay?> showTimePickerSheet(
    {required BuildContext? context,
    bool? use24hFormat,
    int? minuteInterval,
    Color? backgroundColor,
    TimeOfDay? initialTime,
    String? textButtonCancel,
    String? textButtonOkay}) async {
  Completer<TimeOfDay?> completer = Completer();
  TimeOfDay selectedTime = initialTime ?? TimeOfDay.now();
  showModalBottomSheet(
    context: context!,
    backgroundColor: backgroundColor,
    builder: (_) => Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  completer.complete(null); // User canceled, resolve with null
                  Navigator.pop(context);
                },
                child: Text(
                  textButtonCancel ?? "cancel",
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () {
                  completer
                      .complete(selectedTime); // Resolve with the selected time
                  Navigator.pop(context);
                },
                child: Text(
                  textButtonOkay ?? "Ok",
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: DateTime.now(),
            use24hFormat: use24hFormat ?? false,
            minuteInterval: minuteInterval ?? 1,
            backgroundColor: Colors.transparent,
            onDateTimeChanged: (DateTime newTime) async {
              selectedTime =
                  TimeOfDay.fromDateTime(newTime); // Update the selected time
            },
          ),
        ),
      ],
    ),
  );

  return completer.future;
}
