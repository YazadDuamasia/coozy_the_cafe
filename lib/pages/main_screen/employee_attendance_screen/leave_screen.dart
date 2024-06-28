import 'package:coozy_the_cafe/bloc/staff_management_bloc/leave_cubit/leave_cubit.dart';
import 'package:coozy_the_cafe/model/attendance/leave.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaveScreen extends StatefulWidget {
  const LeaveScreen({Key? key}) : super(key: key);
  @override
  _LeaveScreenState createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LeaveCubit>().fetchLeaves();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LeaveCubit, LeaveState>(
        listener: (context, state) {
          if (state is LeaveError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message??"")));
          }
        },
        builder: (context, state) {
          if (state is LeaveLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LeaveLoaded) {
            return ListView.builder(
              itemCount: state.leaves?.length??0,
              itemBuilder: (context, index) {
                final leave = state.leaves![index];
                return ListTile(
                  title: Text('Employee ID: ${leave.employeeId}'),
                  subtitle: Text('Start Date: ${leave.startDate}'),
                  onTap: () {
                    _showEditLeaveDialog(context, leave);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<LeaveCubit>().deleteLeave(leave.id!);
                    },
                  ),
                );
              },
            );
          }
          return Center(child: Text('No Leave Records'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddLeaveDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddLeaveDialog(BuildContext context) {
    final employeeIdController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Leave'),
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
                final leave = Leave(
                  employeeId: int.parse(employeeIdController.text),
                  startDate: DateTime.parse(startDateController.text),
                  endDate: DateTime.parse(endDateController.text),
                  reason: reasonController.text,
                );
                context.read<LeaveCubit>().addLeave(leave);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showEditLeaveDialog(BuildContext context, Leave leave) {
    final employeeIdController = TextEditingController(text: leave.employeeId.toString());
    final startDateController = TextEditingController(text: leave.startDate?.toIso8601String());
    final endDateController = TextEditingController(text: leave.endDate?.toIso8601String());
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
  }
}