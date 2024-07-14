import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/bloc/staff_management_bloc/attendance_cubit/attendance_cubit.dart';
import 'package:coozy_the_cafe/model/attendance/attendance.dart';
import 'package:coozy_the_cafe/model/attendance/employee.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:coozy_the_cafe/widgets/animated_hint_textfield/animated_hint_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../bloc/staff_management_bloc/employee_cubit/employee_cubit.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  ScrollController? scrollController;
  TextEditingController? _searchController;
  FocusNode? _searchFocusNode;
  List<Employee>? employeeList = [];
  List<Employee>? _filteredEmployees = [];
  List<Attendance>? attendance = [];
  List<Attendance>? _filteredAttendance = [];

  @override
  void initState() {
    super.initState();
    scrollController =
        ScrollController(debugLabel: "attendanceScreenScrollController");
    _searchController = TextEditingController(text: "");
    _searchFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // BlocProvider.of<EmployeeCubit>(context).fetchEmployees();
      BlocProvider.of<AttendanceCubit>(context).fetchAttendance();
    });
    _searchController!.addListener(_filterAttendance);
  }

  void _filterAttendance() {
    String query = _searchController!.text.toLowerCase();

    try {
      _filteredEmployees = employeeList?.where((employee) {
        return employee.name!.toLowerCase().contains(query) ||
            employee.phoneNumber!.toLowerCase().contains(query) ||
            employee.position!.toLowerCase().contains(query);
      }).toList();

      // Create a set of employee IDs for faster lookup
      Set<int?>? employeeIds = _filteredEmployees?.map((e) => e.id).toSet();

      // Filter attendance based on the filtered employees' employeeId
      _filteredAttendance = attendance?.where((attendance) {
        return employeeIds!.contains(attendance.employeeId);
      }).toList();
    } catch (e) {
      print(e);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AttendanceCubit, AttendanceState>(
          listener: (context, state) {
            if (state is AttendanceError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message ?? "")));
            }
            if (state is AttendanceLoaded) {
              final employeeCubitState =
                  context.read<EmployeeCubit>().state as EmployeeLoaded;
              employeeList = employeeCubitState.employees;
              _filteredEmployees = employeeList;
              attendance = state.attendance;
              _filteredAttendance = attendance;
              setState(() {});
            }
          },
          builder: (context, state) {
            if (state is AttendanceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AttendanceLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(10.0),
                  //   child: TextField(
                  //     controller: _searchController,
                  //     focusNode: _searchFocusNode,
                  //     decoration: InputDecoration(
                  //       hintText: 'Search employees...',
                  //       prefixIcon: const Icon(Icons.search),
                  //       suffixIcon: Visibility(
                  //         visible: (_searchController!.text == null ||
                  //                 _searchController!.text == "" ||
                  //                 _searchController!.text.isEmpty)
                  //             ? false
                  //             : true,
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               _searchController!.clear();
                  //               FocusManager.instance.primaryFocus?.unfocus();
                  //             });
                  //           },
                  //           child: const Icon(Icons.clear),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: AnimatedHintTextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            animationType: AnimationType.typer,
                            hintTextStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondaryContainer,
                              overflow: TextOverflow.ellipsis,
                            ),
                            textInputAction: TextInputAction.done,

                            hintTexts: const [
                              'Search employees by name',
                              'Search employees by mobile number',
                              'Search employees by position'
                            ],
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              suffixIcon: Visibility(
                                visible: (_searchController!.text == null ||
                                        _searchController!.text == "" ||
                                        _searchController!.text.isEmpty)
                                    ? false
                                    : true,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _searchController!.clear();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    });
                                  },
                                  child: const Icon(Icons.clear),
                                ),
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5, top: 5),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).disabledColor,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.error),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true,
                      interactive: true,
                      radius: const Radius.circular(10.0),
                      controller: scrollController,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<AttendanceCubit>(context)
                              .fetchAttendance();
                        },
                        child: SlidableAutoCloseBehavior(
                          child: ListView.builder(
                            itemCount: _filteredAttendance?.length ?? 0,
                            addRepaintBoundaries: true,
                            addAutomaticKeepAlives: false,
                            itemBuilder: (context, index) {
                              final attendance = _filteredAttendance![index];
                              Employee? selectedEmployee =
                                  employeeList?.firstWhere((element) =>
                                      element.id == attendance.employeeId);
                              return Slidable(
                                key: ValueKey(index),
                                closeOnScroll: true,

                                // The end action pane is the one at the right or the bottom side.
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (BuildContext context) async {
                                        Constants.showLoadingDialog(context);
                                        _showEditAttendanceDialog(
                                            context, attendance);
                                      },
                                      backgroundColor: Colors.lightBlueAccent,
                                      foregroundColor: Colors.white,
                                      icon: MdiIcons.circleEditOutline,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                      ),
                                      label: 'Edit',
                                    ),
                                    SlidableAction(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      autoClose: true,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(0),
                                        bottomLeft: Radius.circular(0),
                                      ),
                                      icon: Icons.delete,
                                      label: 'Delete',
                                      onPressed: (BuildContext ctx) {
                                        Constants.customPopUpDialogMessage(
                                          classObject: AttendanceScreen,
                                          context: this.context,
                                          titleIcon: Icon(
                                            Icons.info_outline,
                                            size: 40,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          title:
                                              "${AppLocalizations.of(context)?.translate(StringValue.attendace_screen_delete_title_dialog) ?? "Are you sure ?"}",
                                          descriptions:
                                              "${AppLocalizations.of(context)?.translate(StringValue.attendace_screen_delete_dialog_subTitle) ?? "Do you really want to delete this attendance information? You will not be able to undo this action."}",
                                          actions: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              TextButton(
                                                child: Text(
                                                  "${AppLocalizations.of(context)!.translate(StringValue.common_cancel)}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.light
                                                            ? Colors.white
                                                            : null,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(this.context),
                                              ),
                                              TextButton(
                                                child: Text(
                                                  "${AppLocalizations.of(context)!.translate(StringValue.common_okay)}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                                    .brightness ==
                                                                Brightness.light
                                                            ? Colors.white
                                                            : null,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(this.context);
                                                  BlocProvider.of<
                                                              AttendanceCubit>(
                                                          this.context)
                                                      .deleteAttendance(
                                                          attendance.id!);
                                                },
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                child: Card(
                                  elevation: 3,
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
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                                TextSpan(
                                                  text:
                                                      selectedEmployee?.name ??
                                                          "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    contentPadding: const EdgeInsets.all(10),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          attendance.checkIn ==
                                                                      null ||
                                                                  attendance
                                                                      .checkIn!
                                                                      .isEmpty
                                                              ? "N/A"
                                                              : attendance
                                                                  .checkIn,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          attendance.checkOut ==
                                                                      null ||
                                                                  attendance
                                                                      .checkOut!
                                                                      .isEmpty
                                                              ? "N/A"
                                                              : attendance
                                                                  .checkOut,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'working Time Durations: ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                    TextSpan(
                                                      text: attendance.workingTimeDurations ==
                                                                  null ||
                                                              attendance
                                                                  .workingTimeDurations!
                                                                  .isEmpty
                                                          ? "N/A"
                                                          : attendance
                                                              .workingTimeDurations,
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
                                        Visibility(
                                          visible:
                                              attendance.creationDate != null,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Expanded(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Creation on: ',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                        TextSpan(
                                                          text: attendance.creationDate ==
                                                                      null ||
                                                                  attendance
                                                                      .creationDate!
                                                                      .isEmpty
                                                              ? "N/A"
                                                              : attendance
                                                                  .creationDate,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible:
                                              attendance.modificationDate !=
                                                  null,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Expanded(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'Last modification on: ',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                        ),
                                                        TextSpan(
                                                          text: attendance.modificationDate ==
                                                                      null ||
                                                                  attendance
                                                                      .modificationDate!
                                                                      .isEmpty
                                                              ? "N/A"
                                                              : attendance
                                                                  .modificationDate,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
          format: DateUtil.TIME_FORMAT2);
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
            Expanded(
              child: Padding(
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
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: employee.name ?? "",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          TextSpan(
                                            text: "\nPosition: ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          TextSpan(
                                            text: "${employee.position ?? ""}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
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
                                            fromTime: selectedEmployee
                                                ?.endWorkingTime,
                                            toTime: checkOutController.text,
                                            format: DateUtil.TIME_FORMAT2);
                                    overTimeDurationsInSeconds = DateUtil
                                        .calculateTimeDifferenceInSeconds(
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
                                                    fontWeight:
                                                        FontWeight.w700),
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
                                            text:
                                                'Employee Working Durations: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                          TextSpan(
                                            text:
                                                employee?.workingHours ?? "N/A",
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
                                          format: DateUtil.TIME_FORMAT2);
                                  final attendance = Attendance(
                                    id: null,
                                    employeeId: selectedEmployee?.id,
                                    employeeWorkingDurations:
                                        selectedEmployee?.workingHours,
                                    creationDate: DateUtil.dateToString(
                                        DateTime.now(), DateUtil.DATE_FORMAT15),
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
                format: DateUtil.TIME_FORMAT2) ??
            "N/A");
    void _updateTotalWorkingTime() {
      final totalWorkingTime = DateUtil.calculateRemainingTime(
          fromTime: checkInController.text,
          toTime: checkOutController.text,
          format: DateUtil.TIME_FORMAT2);
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
                              text: 'Employee Name: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text: selectedEmployee?.name ?? "",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
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
                const SizedBox(height: 15),
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
                  height: 15,
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
                              text: 'Employee Working Durations: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(
                              text:
                                  attendance.employeeWorkingDurations ?? "N/A",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    )
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        child: const Text('Save'),
                        onPressed: () async {
                          final isValid = _formKey.currentState?.validate();
                          if (!isValid!) {
                            return;
                          }
                          _formKey.currentState?.save();
                          final workingTimeDurations =
                              DateUtil.calculateRemainingTime(
                                  fromTime: checkInController.text,
                                  toTime: checkOutController.text,
                                  format: DateUtil.TIME_FORMAT2);
                          final updatedAttendance = Attendance(
                            id: attendance.id,
                            employeeId: attendance.employeeId,
                            checkIn: checkInController.text,
                            checkOut: checkOutController.text,
                            modificationDate: DateUtil.dateToString(
                                DateTime.now(), DateUtil.DATE_FORMAT15),
                            workingTimeDurations: workingTimeDurations,
                          );

                          context
                              .read<AttendanceCubit>()
                              .updateAttendance(updatedAttendance);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController?.dispose();
    _searchFocusNode?.dispose();
    _searchController?.dispose();
    super.dispose();
  }
}
