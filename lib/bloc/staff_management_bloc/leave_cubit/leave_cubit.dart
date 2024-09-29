import 'package:coozy_the_cafe/database/database.dart';
import 'package:coozy_the_cafe/model/attendance/leave.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

part 'leave_state.dart';

class LeaveCubit extends Cubit<LeaveState> {
  final DatabaseHelper _databaseHelper;

  LeaveCubit(this._databaseHelper) : super(LeaveInitial());

  Future<void> fetchLeaves() async {
    try {
      emit(LeaveLoading());
      final leaves = await _databaseHelper.getLeaves();
      final updatedLeaves = <Leave>[];
      final today = DateTime.now();
      final dateFormat = DateFormat(DateUtil.DATE_FORMAT15);
      for (var leave in leaves!) {
        final startDate = leave.startDate != null ? dateFormat.parse(leave.startDate!) : null;
        final endDate = leave.endDate != null ? dateFormat.parse(leave.endDate!) : null;

        if (leave.currentStatus == 0 && startDate != null && startDate.isBefore(today)) {
          leave.currentStatus = 1;
          updatedLeaves.add(leave);
        }

        if (leave.currentStatus == 1 && endDate != null && endDate.isBefore(today)) {
          leave.currentStatus = 2;
          updatedLeaves.add(leave);
        }
      }

      if (updatedLeaves.isNotEmpty) {
        await _databaseHelper.updateLeavesBatch(updatedLeaves);
      }

      emit(LeaveLoaded(await _databaseHelper.getLeaves()));
    } catch (e) {
      emit(LeaveError(e.toString()));
    }
  }

  Future<void> addLeave(Leave leave) async {
    try {
      await _databaseHelper.addLeave(leave);
      fetchLeaves();
    } catch (e) {
      emit(LeaveError(e.toString()));
    }
  }

  Future<void> updateLeave(Leave leave) async {
    try {
      await _databaseHelper.updateLeave(leave);
      fetchLeaves();
    } catch (e) {
      emit(LeaveError(e.toString()));
    }
  }

  Future<void> deleteLeave(int id) async {
    try {
      await _databaseHelper.deleteLeave(id);
      fetchLeaves();
    } catch (e) {
      emit(LeaveError(e.toString()));
    }
  }
}
