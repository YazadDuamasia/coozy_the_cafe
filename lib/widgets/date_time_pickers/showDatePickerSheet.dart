import 'dart:async';
import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
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
Future<DateTime?> showDatePickerSheet({
  required BuildContext? context,
  required CupertinoDatePickerMode? pickerMode,
  required DateTime? initialDate,
  Color? backgroundColor,
  DateTime? minimumDate,
  DateTime? maximumDate,
  DatePickerDateOrder? dateOrder,
}) async {
  Completer<DateTime?> completer = Completer();
  DateTime? selectedDate = initialDate ?? DateTime.now();
  showModalBottomSheet(
    context: context!,
    builder: (_) =>
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      // completer.complete(null); // User canceled, resolve with null
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)
                          ?.translate(StringValue.common_cancel) ??
                          "cancel",
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .error,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      completer.complete(
                          selectedDate); // Resolve with the selected date
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)
                          ?.translate(StringValue.common_ok) ??
                          "Ok",
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: pickerMode ?? CupertinoDatePickerMode.dateAndTime,
                initialDateTime: initialDate ?? DateTime.now(),
                minimumDate: minimumDate ?? null,
                maximumDate: maximumDate ?? null,
                backgroundColor: backgroundColor ?? null,
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
Future<TimeOfDay?> showTimePickerSheet({
  required BuildContext? context,
  Color? backgroundColor,
  TimeOfDay? initialTime,
}) async {
  Completer<TimeOfDay?> completer = Completer();
  TimeOfDay selectedTime = initialTime ?? TimeOfDay.now();
  showModalBottomSheet(
    context: context!,
    builder: (_) =>
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      completer.complete(null); // User canceled, resolve with null
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      completer.complete(selectedTime); // Resolve with the selected time
                      Navigator.pop(context);
                    },
                    child: Text("Ok"),
                  ),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime.now(),
                backgroundColor: backgroundColor ?? null,
                onDateTimeChanged: (DateTime newTime) {
                  selectedTime = TimeOfDay.fromDateTime(newTime); // Update the selected time
                },
              ),
            ),
          ],
        ),
  );

  return completer.future;
}
