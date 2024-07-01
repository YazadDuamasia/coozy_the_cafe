import 'package:coozy_the_cafe/model/attendance/employee.dart';
import 'package:coozy_the_cafe/model/attendance/leave.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../bloc/bloc.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({Key? key}) : super(key: key);

  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();
    scrollController =
        ScrollController(debugLabel: "attendanceScreenScrollController");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<LeaveCubit>(context).fetchLeaves();
    });
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
          },
          builder: (context, state) {
            if (state is LeaveLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LeaveLoaded) {
              final employeeCubitState = context.read<EmployeeCubit>().state as EmployeeLoaded;
              List<Employee>? employeeList = employeeCubitState.employees;
              return Scrollbar(
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
                      itemCount: state.leaves?.length ?? 0,
                      itemBuilder: (context, index) {
                        final leave = state.leaves![index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                          child: Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text('Employee ID: ${leave.employeeId}'),
                              subtitle: Text('Start Date: ${leave.startDate}'),
                              onTap: () {
                                // _showEditLeaveDialog(context, leave);
                              },
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  context
                                      .read<LeaveCubit>()
                                      .deleteLeave(leave.id!);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
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

    final ValueNotifier<String> totalLeaveTimeNotifier =
        ValueNotifier<String>('N/A');
    void _updateTotalWorkingTime() {
      final totalWorkingTime = DateUtil.calculateRemainingTime(
        toTime: startDateController.text,
        fromTime: endDateController.text,
      );
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
      isScrollControlled: true,
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
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 10),
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
                            setState(() {
                              selectedEmployee = newValue;
                            });
                          },
                          items: employeeList?.map<DropdownMenuItem<Employee>>(
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
                                              fontWeight: FontWeight.w700),
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
                          controller: startDateController,
                          readOnly: true,
                          onTap: () async {
                            DateTime? selectedTime = await showDatePicker(
                              context: context,
                              helpText: "Starting date for leave",
                              initialDate: startDateController.text == null ||
                                      startDateController.text.isEmpty
                                  ? DateTime.now()
                                  : DateUtil.stringToDate(
                                      startDateController.text,
                                      DateUtil.DATE_FORMAT15),
                              currentDate: DateTime.now(),
                              firstDate:
                                  DateTime(DateTime.now().year - 150, 1, 1),
                              lastDate:
                                  DateTime(DateTime.now().year + 150, 12, 31),
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

                            startDateController.text = DateUtil.dateToString(
                              dateTime,
                              DateUtil.DATE_FORMAT15,
                            )!;
                          },
                          decoration: InputDecoration(
                            labelText: "Start Date",
                            suffix: Visibility(
                              visible: startDateController.text.isNotEmpty,
                              child: GestureDetector(
                                onTap: () {
                                  startDateController.clear();
                                },
                                child: const Icon(Icons.clear),
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              initialDate: endDateController.text == null ||
                                      endDateController.text.isEmpty
                                  ? DateTime.now()
                                  : DateUtil.stringToDate(
                                      endDateController.text,
                                      DateUtil.DATE_FORMAT15),
                              currentDate: DateTime.now(),
                              firstDate:
                                  DateTime(DateTime.now().year - 150, 1, 1),
                              lastDate:
                                  DateTime(DateTime.now().year + 150, 12, 31),
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

                            endDateController.text = DateUtil.dateToString(
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  TextSpan(
                                    text: value ?? "N/A",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.none,
                          decoration: InputDecoration(
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
                            final isValid = _formKey.currentState?.validate();
                            if (!isValid!) {
                              return;
                            }
                            _formKey.currentState?.save();

                            Leave leave = Leave(
                                employeeId: selectedEmployee!.id,
                                creationDate: DateUtil.dateToString(
                                    DateTime.now(), DateUtil.DATE_FORMAT11),
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
        );
      },
    );
  }

  /*void _showEditLeaveDialog(BuildContext context, Leave leave) {
    final employeeIdController =
        TextEditingController(text: leave.employeeId.toString());
    final startDateController =
        TextEditingController(text: leave.startDate?.toIso8601String());
    final endDateController =
        TextEditingController(text: leave.endDate?.toIso8601String());
    final reasonController = TextEditingController(text: leave.reason);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Leave'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: employeeIdController,
                decoration: InputDecoration(labelText: 'Employee ID'),
              ),
              TextField(
                controller: startDateController,
                decoration: InputDecoration(labelText: 'Start Date'),
              ),
              TextField(
                controller: endDateController,
                decoration: InputDecoration(labelText: 'End Date'),
              ),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(labelText: 'Reason'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedLeave = Leave(
                  id: leave.id,
                  employeeId: int.parse(employeeIdController.text),
                  startDate: DateTime.parse(startDateController.text),
                  endDate: DateTime.parse(endDateController.text),
                  creationDate: DateUtil.dateToString(
                      DateTime.now(), DateUtil.DATE_FORMAT11),
                  reason: reasonController.text,
                );
                context.read<LeaveCubit>().updateLeave(updatedLeave);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }*/

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }
}
