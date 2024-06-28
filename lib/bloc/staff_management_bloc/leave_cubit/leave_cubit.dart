import 'package:coozy_the_cafe/database_helper/DatabaseHelper.dart';
import 'package:coozy_the_cafe/model/attendance/leave.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'leave_state.dart';

class LeaveCubit extends Cubit<LeaveState> {
  final DatabaseHelper _databaseHelper;

  LeaveCubit(this._databaseHelper) : super(LeaveInitial());

  Future<void> fetchLeaves() async {
    try {
      emit(LeaveLoading());
      final leaves = await _databaseHelper.getLeaves();
      emit(LeaveLoaded(leaves));
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