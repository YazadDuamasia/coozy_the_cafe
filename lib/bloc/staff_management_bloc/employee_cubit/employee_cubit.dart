import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coozy_the_cafe/database_helper/DatabaseHelper.dart';
import 'package:coozy_the_cafe/model/attendance/employee.dart';
import 'package:equatable/equatable.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final DatabaseHelper _databaseHelper;

  EmployeeCubit(this._databaseHelper) : super(EmployeeInitial());

  Future<void> fetchEmployees() async {
    try {
      emit(EmployeeLoading());
      final employees = await _databaseHelper.getEmployees();
      emit(EmployeeLoaded(employees));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      await _databaseHelper.addEmployee(employee);
      fetchEmployees();
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      await _databaseHelper.updateEmployee(employee);
      fetchEmployees();
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> deleteEmployee(int id) async {
    try {
      await _databaseHelper.deleteEmployee(id);
      fetchEmployees();
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }
}