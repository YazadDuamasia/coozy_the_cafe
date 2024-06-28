import 'package:coozy_the_cafe/pages/main_screen/employee_attendance_screen/attendance_screen.dart';
import 'package:coozy_the_cafe/pages/main_screen/employee_attendance_screen/employee_screen.dart';
import 'package:coozy_the_cafe/pages/main_screen/employee_attendance_screen/leave_screen.dart';
import 'package:flutter/material.dart';

class EmployeeAttendanceScreen extends StatefulWidget {
  const EmployeeAttendanceScreen({Key? key}) : super(key: key);

  @override
  _EmployeeAttendanceScreenState createState() =>
      _EmployeeAttendanceScreenState();
}

class _EmployeeAttendanceScreenState extends State<EmployeeAttendanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Staff Attendance Management'),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Employees'),
                Tab(text: 'Attendance'),
                Tab(text: 'Leaves'),
              ],
              indicatorColor: Theme.of(context).dividerColor,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              unselectedLabelStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              labelStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              EmployeeScreen(),
              AttendanceScreen(),
              LeaveScreen()
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
