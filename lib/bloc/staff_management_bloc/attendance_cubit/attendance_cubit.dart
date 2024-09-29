import 'package:coozy_the_cafe/database/database.dart';
import 'package:coozy_the_cafe/model/attendance/attendance.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final DatabaseHelper _databaseHelper;

  AttendanceCubit(this._databaseHelper) : super(AttendanceInitial());

  Future<void> fetchAttendance() async {
    try {
      emit(AttendanceLoading());
      final attendance = await _databaseHelper.getAttendance();
      emit(AttendanceLoaded(attendance));
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> addAttendance(Attendance attendance) async {
    try {
      await _databaseHelper.addAttendance(attendance);
      fetchAttendance();
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> updateAttendance(Attendance attendance) async {
    try {
      await _databaseHelper.updateAttendance(attendance);
      fetchAttendance();
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> deleteAttendance(int id) async {
    try {
      await _databaseHelper.deleteAttendance(id);
      fetchAttendance();
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }
}