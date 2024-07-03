import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/bloc/staff_management_bloc/employee_cubit/employee_cubit.dart';
import 'package:coozy_the_cafe/bloc/staff_management_bloc/leave_cubit/leave_cubit.dart';
import 'package:coozy_the_cafe/model/attendance/employee.dart';
import 'package:coozy_the_cafe/model/attendance/leave.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({Key? key}) : super(key: key);

  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  ScrollController? scrollController;
  Map<String, int> status = {
    "new": 0,
    "in_progress": 1,
    "completed": 2,
    "canceled": 3
  };

  TextEditingController? _searchController;
  FocusNode? _searchFocusNode;
  List<Employee>? employeeList = [];
  List<Employee>? _filteredEmployees = [];
  List<Leave>? leave = [];
  List<Leave>? _filteredLeave = [];

  int? _selectedStatus;

  @override
  void initState() {
    super.initState();
    scrollController =
        ScrollController(debugLabel: "leaveScreenScrollController");
    _searchController = TextEditingController(text: "");
    _searchFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<EmployeeCubit>(context).fetchEmployees();
      BlocProvider.of<LeaveCubit>(context).fetchLeaves();
    });
    _searchController!.addListener(_filterLeave);
  }

  void _filterLeave() {
    String query = _searchController!.text.toLowerCase();
    int? statusFilter = _selectedStatus;

    try {
      _filteredEmployees = employeeList?.where((employee) {
        return employee.name!.toLowerCase().contains(query) ||
            employee.phoneNumber!.toLowerCase().contains(query) ||
            employee.position!.toLowerCase().contains(query);
      }).toList();

      // Create a set of employee IDs for faster lookup
      Set<int?>? employeeIds = _filteredEmployees?.map((e) => e.id).toSet();

      // Check if the leave item matches the selected status and the search query
      _filteredLeave = leave?.where((leaveItem) {
        return employeeIds!.contains(leaveItem.employeeId) ||
            (statusFilter == null || leaveItem.currentStatus == statusFilter) ||
            leaveItem.reason!.toLowerCase().contains(query);
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
        body: BlocConsumer<LeaveCubit, LeaveState>(
          listener: (context, state) {
            if (state is LeaveError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message ?? "")));
            }
            if (state is LeaveLoaded) {
              final employeeCubitState =
                  context.read<EmployeeCubit>().state as EmployeeLoaded;
              employeeList = employeeCubitState.employees;
              _filteredEmployees = employeeList;
              leave = state.leaves;
              _filteredLeave = leave;
              setState(() {});
            }
          },
          builder: (context, state) {
            if (state is LeaveLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LeaveLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            decoration: InputDecoration(
                              hintText: 'Search employees...',
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
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showStatusDialog();
                          },
                          label: const Text("Filter"),
                          icon: Icon(MdiIcons.filter),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the radius as needed
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
                          BlocProvider.of<LeaveCubit>(context).fetchLeaves();
                        },
                        child: SlidableAutoCloseBehavior(
                          child: ListView.builder(
                            itemCount: _filteredLeave?.length ?? 0,
                            addRepaintBoundaries: true,
                            addAutomaticKeepAlives: false,
                            itemBuilder: (context, index) {
                              final leave = _filteredLeave![index];
                              Employee? selectedEmployee =
                                  employeeList?.firstWhere((element) =>
                                      element.id == leave.employeeId);
                              return Padding(
                                padding: const EdgeInsets.only(
                                    right: 5.0, left: 5.0),
                                child: Slidable(
                                  closeOnScroll: true,

                                  // The end action pane is the one at the right or the bottom side.
                                  endActionPane: ActionPane(
                                    motion: const DrawerMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed:
                                            (BuildContext context) async {
                                          Constants.showLoadingDialog(context);
                                          _showEditLeaveDialog(context, leave);
                                        },
                                        backgroundColor: Colors.lightBlueAccent,
                                        foregroundColor: Colors.white,
                                        icon: MdiIcons.circleEditOutline,
                                        borderRadius: const BorderRadius.only(
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
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(0),
                                          bottomLeft: Radius.circular(0),
                                        ),
                                        icon: Icons.delete,
                                        label: 'Delete',
                                        onPressed: (BuildContext ctx) {
                                          Constants.customPopUpDialogMessage(
                                            classObject: LeaveScreen,
                                            context: this.context,
                                            titleIcon: Icon(
                                              Icons.info_outline,
                                              size: 40,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            title: AppLocalizations.of(context)
                                                    ?.translate(StringValue
                                                        .attendace_screen_delete_title_dialog) ??
                                                "Are you sure ?",
                                            descriptions: AppLocalizations.of(
                                                        context)
                                                    ?.translate(StringValue
                                                        .attendace_screen_delete_dialog_subTitle) ??
                                                "Do you really want to delete this attendance information? You will not be able to undo this action.",
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
                                                                  Brightness
                                                                      .light
                                                              ? Colors.white
                                                              : null,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          this.context),
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
                                                                  Brightness
                                                                      .light
                                                              ? Colors.white
                                                              : null,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(this.context);
                                                    BlocProvider.of<LeaveCubit>(
                                                            this.context)
                                                        .deleteLeave(leave.id!);
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
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                  TextSpan(
                                                    text: selectedEmployee
                                                            ?.name ??
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
                                                        text: 'Starting Time: ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                      TextSpan(
                                                        text: leave.startDate ==
                                                                    null ||
                                                                leave.startDate!
                                                                    .isEmpty
                                                            ? "N/A"
                                                            : leave.startDate,
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
                                                        text: 'Ending Time: ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                      ),
                                                      TextSpan(
                                                        text: leave.endDate ==
                                                                    null ||
                                                                leave.endDate!
                                                                    .isEmpty
                                                            ? "N/A"
                                                            : leave.endDate,
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
                                          Padding(
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
                                                          text: 'Status: ',
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
                                                          text: leave.creationDate ==
                                                                      null ||
                                                                  leave
                                                                      .creationDate!
                                                                      .isEmpty
                                                              ? "N/A"
                                                              : leave
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
                                          Visibility(
                                            visible: leave.creationDate != null,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
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
                                                                'Creation on: ',
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
                                                            text: leave.creationDate ==
                                                                        null ||
                                                                    leave
                                                                        .creationDate!
                                                                        .isEmpty
                                                                ? "N/A"
                                                                : leave
                                                                    .creationDate,
                                                            style: Theme.of(
                                                                    context)
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
                                                leave.modificationDate != null,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
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
                                                            text: leave.modificationDate ==
                                                                        null ||
                                                                    leave
                                                                        .modificationDate!
                                                                        .isEmpty
                                                                ? "N/A"
                                                                : leave
                                                                    .modificationDate,
                                                            style: Theme.of(
                                                                    context)
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
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child:
                                                              Text("Reason :"),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: Text(
                                                              "${leave.reason ?? ""}"),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
            return const Center(child: Text('No Leave Records'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Constants.showLoadingDialog(context);
            _showAddLeaveDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _showAddLeaveDialog(
    BuildContext context,
  ) async {
    final startDateController = TextEditingController(text: "");
    final endDateController = TextEditingController(text: "");
    final reasonController = TextEditingController(text: "");

    int? _selectedStatusValue = 0; // Default value set to "new": 0
    final ValueNotifier<String> totalLeaveTimeNotifier =
        ValueNotifier<String>('N/A');
    void _updateTotalWorkingTime() {
      final totalWorkingTime = DateUtil.calculateRemainingTime(
          toTime: startDateController.text,
          fromTime: endDateController.text,
          format: DateUtil.DATE_FORMAT15);
      totalLeaveTimeNotifier.value = totalWorkingTime ?? 'N/A';
    }

    startDateController.addListener(_updateTotalWorkingTime);
    endDateController.addListener(_updateTotalWorkingTime);

    Employee? selectedEmployee;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    var state = context.read<EmployeeCubit>().state as EmployeeLoaded;
    List<Employee>? employeeList = state.employees;

    Navigator.pop(context);
    await showModalBottomSheet(
      context: context,
      elevation: 5,
      // isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height * 0.10,
        maxHeight: MediaQuery.of(context).size.height * 0.70,
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Add Leave",
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
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: DropdownButtonFormField<Employee>(
                                value: selectedEmployee,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedEmployee = newValue;
                                  });
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
                                            text: employee.position ?? "",
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
                                controller: startDateController,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? selectedTime = await showDatePicker(
                                    context: context,
                                    helpText: "Starting date for leave",
                                    initialDate:
                                        startDateController.text == null ||
                                                startDateController.text.isEmpty
                                            ? DateTime.now()
                                            : DateUtil.stringToDate(
                                                startDateController.text,
                                                DateUtil.DATE_FORMAT15),
                                    currentDate: DateTime.now(),
                                    firstDate: DateTime(
                                        DateTime.now().year - 150, 1, 1),
                                    lastDate: DateTime(
                                        DateTime.now().year + 150, 12, 31),
                                  );

                                  if (selectedTime == null)
                                    return; // Debugging purpose

                                  TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    helpText: "Starting time for leave",
                                    initialTime: DateUtil.parseTimeOfDay(
                                      startDateController.text.isNotEmpty
                                          ? startDateController.text
                                          : DateTime.now().toIso8601String(),
                                      DateUtil.DATE_FORMAT15,
                                    ),
                                  );

                                  if (time == null) return; // Debugging purpose

                                  var dateTime = DateTime(
                                    selectedTime.year,
                                    selectedTime.month,
                                    selectedTime.day,
                                    time.hour,
                                    time.minute,
                                  );

                                  startDateController.text =
                                      DateUtil.dateToString(
                                    dateTime,
                                    DateUtil.DATE_FORMAT15,
                                  )!;
                                },
                                decoration: InputDecoration(
                                  labelText: "Start Date",
                                  suffix: Visibility(
                                    visible:
                                        startDateController.text.isNotEmpty,
                                    child: GestureDetector(
                                      onTap: () {
                                        startDateController.clear();
                                      },
                                      child: const Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter leave ending date & time.";
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
                                controller: endDateController,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? selectedTime = await showDatePicker(
                                    context: context,
                                    helpText: "Ending date for leave",
                                    initialDate:
                                        endDateController.text == null ||
                                                endDateController.text.isEmpty
                                            ? DateTime.now()
                                            : DateUtil.stringToDate(
                                                endDateController.text,
                                                DateUtil.DATE_FORMAT15),
                                    currentDate: DateTime.now(),
                                    firstDate: DateTime(
                                        DateTime.now().year - 150, 1, 1),
                                    lastDate: DateTime(
                                        DateTime.now().year + 150, 12, 31),
                                  );

                                  if (selectedTime == null)
                                    return; // Debugging purpose

                                  TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    helpText: "Ending time for leave",
                                    initialTime: DateUtil.parseTimeOfDay(
                                      endDateController.text.isNotEmpty
                                          ? endDateController.text
                                          : DateTime.now().toIso8601String(),
                                      DateUtil.DATE_FORMAT15,
                                    ),
                                  );

                                  if (time == null) return; // Debugging purpose

                                  var dateTime = DateTime(
                                    selectedTime.year,
                                    selectedTime.month,
                                    selectedTime.day,
                                    time.hour,
                                    time.minute,
                                  );

                                  endDateController.text =
                                      DateUtil.dateToString(
                                    dateTime,
                                    DateUtil.DATE_FORMAT15,
                                  )!;
                                },
                                decoration: InputDecoration(
                                  labelText: "Ending Date",
                                  suffix: Visibility(
                                    visible: endDateController.text.isNotEmpty,
                                    child: GestureDetector(
                                      onTap: () {
                                        endDateController.clear();
                                      },
                                      child: const Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter leave ending date & time.";
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
                              child: DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                  labelText: "Current Status",
                                ),
                                value: _selectedStatusValue,
                                items: status.entries.map((entry) {
                                  return DropdownMenuItem<int>(
                                    value: entry.value,
                                    child: Text(AppLocalizations.of(context)!
                                            .translate(
                                                "leave_screen_option_${entry.key}") ??
                                        ""),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    _selectedStatusValue = newValue;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select a status'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<String?>(
                          valueListenable: totalLeaveTimeNotifier,
                          builder: (context, value, child) {
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
                                          text: 'Total Duration: ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w700),
                                        ),
                                        TextSpan(
                                          text: value ?? "N/A",
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
                                maxLines: 5,
                                controller: reasonController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.none,
                                decoration: const InputDecoration(
                                  labelText: 'Reason',
                                  contentPadding: EdgeInsets.all(10),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some reasons';
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
                              child: ElevatedButton(
                                child: const Text('Add'),
                                onPressed: () async {
                                  final isValid =
                                      _formKey.currentState?.validate();
                                  if (!isValid!) {
                                    return;
                                  }
                                  _formKey.currentState?.save();

                                  Leave leave = Leave(
                                      employeeId: selectedEmployee!.id,
                                      creationDate: DateUtil.dateToString(
                                          DateTime.now(),
                                          DateUtil.DATE_FORMAT15),
                                      currentStatus: _selectedStatusValue,
                                      isDeleted: 0,
                                      startDate: startDateController.text,
                                      endDate: endDateController.text,
                                      reason: reasonController.text);
                                  Constants.debugLog(
                                      LeaveScreen, "Add:${leave.toString()}");
                                  context.read<LeaveCubit>().addLeave(leave);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
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

  Future<void> _showEditLeaveDialog(BuildContext context, Leave leave) async {
    final startDateController =
        TextEditingController(text: leave.startDate ?? "");
    final endDateController = TextEditingController(text: leave.endDate ?? "");
    final reasonController = TextEditingController(text: leave.reason ?? "");

    int? _selectedStatusValue =
        leave.currentStatus ?? 0; // Default value set to "new": 0

    final ValueNotifier<String> totalLeaveTimeNotifier =
        ValueNotifier<String>('N/A');
    void _updateTotalWorkingTime() {
      final totalWorkingTime = DateUtil.calculateRemainingTime(
          toTime: startDateController.text,
          fromTime: endDateController.text,
          format: DateUtil.DATE_FORMAT15);
      totalLeaveTimeNotifier.value = totalWorkingTime ?? 'N/A';
    }

    startDateController.addListener(_updateTotalWorkingTime);
    endDateController.addListener(_updateTotalWorkingTime);

    Employee? selectedEmployee;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    var state = context.read<EmployeeCubit>().state as EmployeeLoaded;
    List<Employee>? employeeList = state.employees;
    selectedEmployee =
        employeeList?.firstWhere((element) => element.id == leave.employeeId);

    Navigator.pop(context);
    await showModalBottomSheet(
      context: context,
      elevation: 5,
      // isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: MediaQuery.of(context).size.height * 0.20,
        maxHeight: MediaQuery.of(context).size.height * 0.70,
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Edit Leave",
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
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: DropdownButtonFormField<Employee>(
                                value: selectedEmployee,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedEmployee = newValue;
                                  });
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
                                            text: employee.position ?? "",
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
                                controller: startDateController,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? selectedTime = await showDatePicker(
                                    context: context,
                                    helpText: "Starting date for leave",
                                    initialDate:
                                        startDateController.text == null ||
                                                startDateController.text.isEmpty
                                            ? DateTime.now()
                                            : DateUtil.stringToDate(
                                                startDateController.text,
                                                DateUtil.DATE_FORMAT15),
                                    currentDate: DateTime.now(),
                                    firstDate: DateTime(
                                        DateTime.now().year - 150, 1, 1),
                                    lastDate: DateTime(
                                        DateTime.now().year + 150, 12, 31),
                                  );

                                  if (selectedTime == null)
                                    return; // Debugging purpose

                                  TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    helpText: "Starting time for leave",
                                    initialTime: DateUtil.parseTimeOfDay(
                                      startDateController.text.isNotEmpty
                                          ? startDateController.text
                                          : DateTime.now().toIso8601String(),
                                      DateUtil.DATE_FORMAT15,
                                    ),
                                  );

                                  if (time == null) return; // Debugging purpose

                                  var dateTime = DateTime(
                                    selectedTime.year,
                                    selectedTime.month,
                                    selectedTime.day,
                                    time.hour,
                                    time.minute,
                                  );

                                  startDateController.text =
                                      DateUtil.dateToString(
                                    dateTime,
                                    DateUtil.DATE_FORMAT15,
                                  )!;
                                },
                                decoration: InputDecoration(
                                  labelText: "Start Date",
                                  suffix: Visibility(
                                    visible:
                                        startDateController.text.isNotEmpty,
                                    child: GestureDetector(
                                      onTap: () {
                                        startDateController.clear();
                                      },
                                      child: const Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter leave ending date & time.";
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
                                controller: endDateController,
                                readOnly: true,
                                onTap: () async {
                                  DateTime? selectedTime = await showDatePicker(
                                    context: context,
                                    helpText: "Ending date for leave",
                                    initialDate:
                                        endDateController.text == null ||
                                                endDateController.text.isEmpty
                                            ? DateTime.now()
                                            : DateUtil.stringToDate(
                                                endDateController.text,
                                                DateUtil.DATE_FORMAT15),
                                    currentDate: DateTime.now(),
                                    firstDate: DateTime(
                                        DateTime.now().year - 150, 1, 1),
                                    lastDate: DateTime(
                                        DateTime.now().year + 150, 12, 31),
                                  );

                                  if (selectedTime == null)
                                    return; // Debugging purpose

                                  TimeOfDay? time = await showTimePicker(
                                    context: context,
                                    helpText: "Ending time for leave",
                                    initialTime: DateUtil.parseTimeOfDay(
                                      endDateController.text.isNotEmpty
                                          ? endDateController.text
                                          : DateTime.now().toIso8601String(),
                                      DateUtil.DATE_FORMAT15,
                                    ),
                                  );

                                  if (time == null) return; // Debugging purpose

                                  var dateTime = DateTime(
                                    selectedTime.year,
                                    selectedTime.month,
                                    selectedTime.day,
                                    time.hour,
                                    time.minute,
                                  );

                                  endDateController.text =
                                      DateUtil.dateToString(
                                    dateTime,
                                    DateUtil.DATE_FORMAT15,
                                  )!;
                                },
                                decoration: InputDecoration(
                                  labelText: "Ending Date",
                                  suffix: Visibility(
                                    visible: endDateController.text.isNotEmpty,
                                    child: GestureDetector(
                                      onTap: () {
                                        endDateController.clear();
                                      },
                                      child: const Icon(Icons.clear),
                                    ),
                                  ),
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter leave ending date & time.";
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
                              child: DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                  labelText: "Current Status",
                                ),
                                value: _selectedStatusValue,
                                items: status.entries.map((entry) {
                                  return DropdownMenuItem<int>(
                                    value: entry.value,
                                    child: Text(AppLocalizations.of(context)!
                                            .translate(
                                                "leave_screen_option_${entry.key}") ??
                                        ""),
                                  );
                                }).toList(),
                                onChanged: (int? newValue) {
                                  setState(() {
                                    _selectedStatusValue = newValue;
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select a status'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ValueListenableBuilder<String?>(
                          valueListenable: totalLeaveTimeNotifier,
                          builder: (context, value, child) {
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
                                          text: 'Total Duration:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w700),
                                        ),
                                        TextSpan(
                                          text: value ?? "N/A",
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
                                maxLines: 5,
                                controller: reasonController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.none,
                                decoration: const InputDecoration(
                                  labelText: 'Reason',
                                  contentPadding: EdgeInsets.all(10),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some reasons';
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
                              child: ElevatedButton(
                                child: const Text('Update'),
                                onPressed: () async {
                                  final isValid =
                                      _formKey.currentState?.validate();
                                  if (!isValid!) {
                                    return;
                                  }
                                  _formKey.currentState?.save();

                                  Leave leave = Leave(
                                    employeeId: selectedEmployee!.id,
                                    creationDate: DateUtil.dateToString(
                                        DateTime.now(), DateUtil.DATE_FORMAT15),
                                    startDate: startDateController.text,
                                    endDate: endDateController.text,
                                    reason: reasonController.text,
                                    currentStatus: _selectedStatusValue,
                                  );
                                  Constants.debugLog(
                                      LeaveScreen, "Add:${leave.toString()}");
                                  context.read<LeaveCubit>().updateLeave(leave);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ],
                        ),
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

  void _showStatusDialog() {
    showDialog(
      context: this.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<int?>(
                title: Text('None'),
                value: null,
                groupValue: _selectedStatus,
                onChanged: (int? value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                  Navigator.of(context).pop();
                  _filterLeave();
                },
              ),
              ...status.keys.map((String? key) {
                return RadioListTile<int>(
                  title: Text(AppLocalizations.of(context)!
                          .translate("leave_screen_option_${key!}") ??
                      ""),
                  value: status[key]!,
                  groupValue: _selectedStatus,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                    Navigator.of(context).pop();
                    _filterLeave();
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    scrollController?.dispose();
    _searchController?.dispose();
    _searchFocusNode?.dispose();
    super.dispose();
  }
}
