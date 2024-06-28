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
            return const Center(child: CircularProgressIndicator());
          } else if (state is AttendanceLoaded) {
            return ListView.builder(
              itemCount: state.attendance?.length ?? 0,
              addRepaintBoundaries: true,
              addAutomaticKeepAlives: false,
              itemBuilder: (context, index) {
                final attendance = state.attendance![index];
                Employee? selectedEmployee = employeeList?.firstWhere(
                    (element) => element.id == attendance.employeeId);
                return Card(
                  elevation: 5,
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Employee: ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                TextSpan(
                                  text: selectedEmployee?.name ?? "",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    contentPadding: const EdgeInsets.all(10),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Check-in Time: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700),
                                    ),
                                    TextSpan(
                                      text: attendance.checkIn == null ||
                                              attendance.checkIn!.isEmpty
                                          ? "N/A"
                                          : attendance.checkIn,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
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
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Check-out Time: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700),
                                    ),
                                    TextSpan(
                                      text: attendance.checkOut == null ||
                                              attendance.checkOut!.isEmpty
                                          ? "N/A"
                                          : attendance.checkOut,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
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
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'working Time Durations: ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w700),
                                    ),
                                    TextSpan(
                                      text: attendance.workingTimeDurations ==
                                                  null ||
                                              attendance
                                                  .workingTimeDurations!.isEmpty
                                          ? "N/A"
                                          : attendance.workingTimeDurations,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
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
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            _showEditAttendanceDialog(context, attendance);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            context
                                .read<AttendanceCubit>()
                                .deleteAttendance(attendance.id!);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No Attendance Records'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddAttendanceDialog(context);
        },
        tooltip: "Add Employee Attendance",
        child: const Icon(Icons.add),
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

    final ValueNotifier<String> totalWorkingTimeNotifier =
        ValueNotifier<String>('N/A');
    final ValueNotifier<Employee?> employeeWorkingHoursNotifier =
        ValueNotifier<Employee?>(null);

    void _updateTotalWorkingTime() {
      final totalWorkingTime = DateUtil.calculateRemainingTime(
        fromTime: checkInController.text,
        toTime: checkOutController.text,
      );
      totalWorkingTimeNotifier.value = totalWorkingTime ?? 'N/A';
    }

    checkInController.addListener(_updateTotalWorkingTime);
    checkOutController.addListener(_updateTotalWorkingTime);

    Navigator.pop(context);
    await showModalBottomSheet(
      context: context,
      elevation: 5,
      shape: const RoundedRectangleBorder(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: DropdownButtonFormField<Employee>(
                              value: selectedEmployee,
                              onChanged: (newValue) {
                                selectedEmployee = newValue;
                                employeeWorkingHoursNotifier.value =
                                    selectedEmployee;
                              },
                              items: employeeList
                                  ?.map<DropdownMenuItem<Employee>>(
                                      (Employee employee) {
                                return DropdownMenuItem<Employee>(
                                  value: employee,
                                  child: Text(employee.name ?? ""),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
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
                                DateTime? tempPickedDateTime = initialDateTime;

                                await showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ColoredBox(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                                      minute: tempPickedDateTime
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
                                DateTime? tempPickedDateTime = initialDateTime;

                                await showCupertinoModalPopup<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ColoredBox(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                                      minute: tempPickedDateTime
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
                                    fromTime: selectedEmployee?.endWorkingTime,
                                    toTime: checkOutController.text,
                                  );
                                  overTimeDurationsInSeconds =
                                      DateUtil.calculateTimeDifferenceInSeconds(
                                    checkInController.text,
                                    checkOutController.text,
                                  );
                                }
                              },
                              // validator: (value) {
                              //   if (value == null || value.isEmpty) {
                              //     return "Please enter check out shift time.";
                              //   } else {
                              //     return null;
                              //   }
                              // },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ValueListenableBuilder<String>(
                          valueListenable: totalWorkingTimeNotifier,
                          builder: (context, totalWorkingTime, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Total Working time: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w700),
                                        ),
                                        TextSpan(
                                          text: totalWorkingTime,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                      const SizedBox(height: 10),
                      ValueListenableBuilder<Employee?>(
                          valueListenable: employeeWorkingHoursNotifier,
                          builder: (context, employee, child) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Employee Working Durations: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w700),
                                        ),
                                        TextSpan(
                                          text: employee?.workingHours ?? "N/A",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
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
                                final workingTimeDurations =
                                    DateUtil.calculateRemainingTime(
                                  fromTime: checkInController.text,
                                  toTime: checkOutController.text,
                                );
                                final attendance = Attendance(
                                  id: null,
                                  employeeId: selectedEmployee?.id,
                                  currentDate: DateUtil.dateToString(
                                      DateTime.now(), DateUtil.DATE_FORMAT9),
                                  checkIn: checkInController.text,
                                  checkOut: checkOutController.text,
                                  workingTimeDurations: workingTimeDurations,
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
        TextEditingController(text: attendance.checkOut ?? "");

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    var state = context.read<EmployeeCubit>().state as EmployeeLoaded;
    List<Employee>? employeeList = state.employees;
    Employee? selectedEmployee = employeeList
        ?.firstWhere((element) => element.id == attendance.employeeId);

    final ValueNotifier<String> totalWorkingTimeNotifier =
        ValueNotifier<String>(DateUtil.calculateRemainingTime(
              fromTime: attendance.checkIn,
              toTime: attendance.checkOut,
            ) ??
            "N/A");
    void _updateTotalWorkingTime() {
      final totalWorkingTime = DateUtil.calculateRemainingTime(
        fromTime: checkInController.text,
        toTime: checkOutController.text,
      );
      totalWorkingTimeNotifier.value = totalWorkingTime ?? 'N/A';
    }

    checkInController.addListener(_updateTotalWorkingTime);
    checkOutController.addListener(_updateTotalWorkingTime);

    Navigator.pop(context);

    await showModalBottomSheet(
      context: context,
      elevation: 5,
      shape: const RoundedRectangleBorder(
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
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 10),
                TextFormField(
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
                        checkOutController.text = DateUtil.formatTimeOfDay(
                          selectedTime,
                          DateUtil.TIME_FORMAT2,
                        );
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Starting Shift Time",
                    suffix: Visibility(
                      visible: checkInController.text.isNotEmpty,
                      child: GestureDetector(
                        onTap: () {
                          checkInController.clear();
                        },
                        child: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter start working time.";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: checkOutController,
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? selectedTime = await showTimePicker(
                      context: context,
                      initialTime: checkOutController.text == null ||
                              checkOutController.text.isEmpty
                          ? TimeOfDay.now()
                          : TimeOfDay.fromDateTime(
                              DateFormat.Hm()
                                  .parse(checkOutController.text ?? ""),
                            ),
                    );
                    if (selectedTime != null) {
                      setState(() {
                        checkOutController.text = DateUtil.formatTimeOfDay(
                          selectedTime,
                          DateUtil.TIME_FORMAT2,
                        );
                      });
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Ending Shift Time",
                    suffix: Visibility(
                      visible: checkOutController.text.isNotEmpty,
                      child: GestureDetector(
                        onTap: () {
                          checkOutController.clear();
                        },
                        child: const Icon(Icons.clear),
                      ),
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter check out shift time.";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ValueListenableBuilder<String>(
                    valueListenable: totalWorkingTimeNotifier,
                    builder: (context, totalWorkingTime, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Total Working time: ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(
                                    text: totalWorkingTime,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    final workingTimeDurations =
                        DateUtil.calculateRemainingTime(
                      fromTime: checkInController.text,
                      toTime: checkOutController.text,
                    );
                    final updatedAttendance = Attendance(
                      id: attendance.id,
                      employeeId: attendance.employeeId,
                      checkIn: checkInController.text,
                      checkOut: checkOutController.text,
                      workingTimeDurations: workingTimeDurations,
                    );

                    context
                        .read<AttendanceCubit>()
                        .updateAttendance(updatedAttendance);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
