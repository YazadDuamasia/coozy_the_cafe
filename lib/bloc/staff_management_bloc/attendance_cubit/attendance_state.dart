part of 'attendance_cubit.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<Attendance>? attendance;

  const AttendanceLoaded(this.attendance);

  @override
  List<Object> get props => [attendance!];
}

class AttendanceError extends AttendanceState {
  final String? message;

  const AttendanceError(this.message);

  @override
  List<Object> get props => [message!];
}