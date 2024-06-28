import 'package:coozy_the_cafe/bloc/staff_management_bloc/attendance_cubit/attendance_cubit.dart';
import 'package:coozy_the_cafe/model/attendance/attendance.dart';
import 'package:coozy_the_cafe/model/attendance/employee.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/staff_management_bloc/employee_cubit/employee_cubit.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Employee>? employeeList;

  @override
  void initState() {
    super.initState();
    context.read<AttendanceCubit>().fetchAttendance();
    final state = context.read<EmployeeCubit>().state as EmployeeLoaded;
    employeeList = state.employees;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AttendanceCubit, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message ?? "")));
          }
        },
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is AttendanceLoaded) {
            return ListView.builder(
              itemCount: state.attendance?.length ?? 0,
              addRepaintBoundaries: true,
              addAutomaticKeepAlives: false,
              itemBuilder: (context, index) {
                final attendance = state.attendance![index];
                Employee? selectedEmployee = employeeList?.firstWhere(
                    (element) => element.id == attendance.employeeId);
                return ListTile(
                  title: Text('Employee: ${selectedEmployee?.name ?? ""}'),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Text('Check-in: ${attendance.checkIn}'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Text('Check-out: ${attendance.checkOut}'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child:
                                Text('currentDate: ${attendance.currentDate}'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                                'over Time Ended: ${attendance.overTimeEnded}'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                                'over Time Durations: ${attendance.overTimeDurationsInSeconds}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          _showEditAttendanceDialog(context, attendance);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          context
                              .read<AttendanceCubit>()
                              .deleteAttendance(attendance.id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(child: Text('No Attendance Records'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAttendanceDialog(context);
        },
        tooltip: "Add Employee Attendance",
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddAttendanceDialog(BuildContext context) async {
    Constants.showLoadingDialog(context);

    final checkInController = TextEditingController(text: "");
    final checkOutController = TextEditingController(text: "");

    final checkInFocusNode = FocusNode();
    final checkOutFocusNode = FocusNode();

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    Employee? selectedEmployee;

    var overTimeEndedValue;
    int? overTimeDurationsInSeconds = 0;

    TimeOfDay? checkInTime = TimeOfDay.now();
    TimeOfDay? checkOutTime = TimeOfDay.now();

    final state = context.read<EmployeeCubit>().state as EmployeeLoaded;
    final List<Employee>? employeeList = state.employees;

    Navigator.pop(context);
    await showModalBottomSheet(
      context: context,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
          bottom: Radius.circular(0.0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height * 0.10,
        maxHeight: MediaQuery.of(context).size.height * 0.65,
      ),
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Add Attendance",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      DropdownButtonFormField<Employee>(
                        value: selectedEmployee,
                        onChanged: (newValue) {
                          selectedEmployee = newValue;
                        },
                        items: employeeList?.map<DropdownMenuItem<Employee>>(
                            (Employee employee) {
                          return DropdownMenuItem<Employee>(
                            value: employee,
                            child: Text(employee.name ?? ""),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          labelText: 'Employee name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an employee name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: checkInController,
                              focusNode: checkInFocusNode,
                              readOnly: true,
                              onTap: () async {
                                DateTime now = DateTime.now();
                                DateTime initialDateTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  checkInTime!.hour,
                                  checkInTime!.minute,
                                );
                                DateTime? tempPickedDateTime =
                                    initialDateTime;

                                await showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ColoredBox(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            .40,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                CupertinoButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoButton(
                                                  child: const Text('Done'),
                                                  onPressed: () {
                                                    checkInTime = TimeOfDay(
                                                      hour: tempPickedDateTime
                                                              ?.hour ??
                                                          0,
                                                      minute:
                                                          tempPickedDateTime
                                                                  ?.minute ??
                                                              0,
                                                    );
                                                    checkInController.text =
                                                        DateUtil
                                                            .formatTimeOfDay(
                                                      checkInTime!,
                                                      DateUtil.TIME_FORMAT2,
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                initialDateTime:
                                                    initialDateTime,
                                                onDateTimeChanged:
                                                    (DateTime newDateTime) {
                                                  tempPickedDateTime =
                                                      newDateTime;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              decoration: InputDecoration(
                                labelText: "Starting Shift Time",
                                suffix: Visibility(
                                  visible: checkInController.text.isNotEmpty,
                                  child: GestureDetector(
                                    onTap: () {
                                      checkInTime = null;
                                      checkInController.clear();
                                    },
                                    child: const Icon(Icons.clear),
                                  ),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter start working time.";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: checkOutController,
                              focusNode: checkOutFocusNode,
                              readOnly: true,
                              onTap: () async {
                                DateTime now = DateTime.now();
                                DateTime initialDateTime = DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  checkOutTime!.hour,
                                  checkOutTime!.minute,
                                );
                                DateTime? tempPickedDateTime =
                                    initialDateTime;

                                await showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ColoredBox(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surface,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            .40,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                CupertinoButton(
                                                  child: const Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                CupertinoButton(
                                                  child: const Text('Done'),
                                                  onPressed: () {
                                                    checkOutTime = TimeOfDay(
                                                      hour: tempPickedDateTime
                                                              ?.hour ??
                                                          0,
                                                      minute:
                                                          tempPickedDateTime
                                                                  ?.minute ??
                                                              0,
                                                    );
                                                    checkOutController.text =
                                                        DateUtil
                                                            .formatTimeOfDay(
                                                      checkOutTime!,
                                                      DateUtil.TIME_FORMAT2,
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                initialDateTime:
                                                    initialDateTime,
                                                onDateTimeChanged:
                                                    (DateTime newDateTime) {
                                                  tempPickedDateTime =
                                                      newDateTime;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              decoration: InputDecoration(
                                labelText: "Ending Shift Time",
                                suffix: Visibility(
                                  visible: checkOutController.text.isNotEmpty,
                                  child: GestureDetector(
                                    onTap: () {
                                      checkOutTime = null;
                                      checkOutController.clear();
                                    },
                                    child: const Icon(Icons.clear),
                                  ),
                                ),
                              ),
                              autovalidateMode: AutovalidateMode.disabled,
                              onChanged: (value) {
                                if (checkInController.text.isEmpty ||
                                    checkOutController.text.isEmpty) {
                                  overTimeEndedValue = null;
                                  overTimeDurationsInSeconds = 0;
                                } else {
                                  overTimeEndedValue =
                                      DateUtil.calculateRemainingTime(
                                    currentTime:
                                        selectedEmployee?.endWorkingTime,
                                    targetTime: checkOutController.text,
                                  );
                                  overTimeDurationsInSeconds = DateUtil
                                      .calculateTimeDifferenceInSeconds(
                                    checkInController.text,
                                    checkOutController.text,
                                  );
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter check out shift time.";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                final isValid =
                                    _formKey.currentState?.validate();
                                if (!isValid!) {
                                  return;
                                }
                                _formKey.currentState?.save();
                                final attendance = Attendance(
                                  id: null,
                                  employeeId: selectedEmployee?.id,
                                  currentDate: DateUtil.dateToString(
                                      DateTime.now(), DateUtil.DATE_FORMAT9),
                                  checkIn: checkInController.text,
                                  checkOut: checkOutController.text,
                                );
                                context
                                    .read<AttendanceCubit>()
                                    .addAttendance(attendance);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Add'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditAttendanceDialog(
    BuildContext context,
    Attendance attendance,
  ) async {
    Constants.showLoadingDialog(context);

    TextEditingController checkInController =
        TextEditingController(text: attendance.checkIn);
    TextEditingController checkOutController =
        TextEditingController(text: attendance.checkOut);

    var state = context.read<EmployeeCubit>().state as EmployeeLoaded;
    List<Employee>? employeeList = state.employees;
    Employee? selectedEmployee = employeeList
        ?.firstWhere((element) => element.id == attendance.employeeId);

    Navigator.pop(context);

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 10),
              TextField(
                controller: checkInController,
                readOnly: true,
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                      DateFormat.Hm().parse(checkInController.text),
                    ),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      checkInController.text = DateFormat.Hm().format(
                        DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          selectedTime.hour,
                          selectedTime.minute,
                        ),
                      );
                    });
                  }
                },
                decoration: InputDecoration(labelText: 'Check-in Time'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: checkOutController,
                readOnly: true,
                onTap: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(
                      DateFormat.Hm().parse(checkOutController.text),
                    ),
                  );
                  if (selectedTime != null) {
                    setState(() {
                      checkOutController.text = DateFormat.Hm().format(
                        DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          selectedTime.hour,
                          selectedTime.minute,
                        ),
                      );
                    });
                  }
                },
                decoration: InputDecoration(labelText: 'Check-out Time'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: Text('Save'),
                onPressed: () async {
                  final updatedAttendance = Attendance(
                    id: attendance.id,
                    employeeId: attendance.employeeId,
                    checkIn: checkInController.text,
                    checkOut: checkOutController.text,
                  );

                  // Calculate remaining time and time difference
                  final remainingTime = DateUtil.calculateRemainingTime(
                    currentTime: selectedEmployee?.endWorkingTime,
                    targetTime: checkOutController.text,
                  );

                  final timeDifferenceInSeconds =
                      DateUtil.calculateTimeDifferenceInSeconds(
                    checkInController.text,
                    checkOutController.text,
                  );

                  // You can handle these values as needed, e.g., save them to the database or display in the UI
                  print('Remaining Time: $remainingTime');
                  print('Time Difference in Seconds: $timeDifferenceInSeconds');

                  context
                      .read<AttendanceCubit>()
                      .updateAttendance(updatedAttendance);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
