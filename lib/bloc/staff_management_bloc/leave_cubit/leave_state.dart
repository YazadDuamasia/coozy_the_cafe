part of 'leave_cubit.dart';

abstract class LeaveState extends Equatable {
  const LeaveState();

  @override
  List<Object> get props => [];
}

class LeaveInitial extends LeaveState {}

class LeaveLoading extends LeaveState {}

class LeaveLoaded extends LeaveState {
  final List<Leave>? leaves;

  const LeaveLoaded(this.leaves);

  @override
  List<Object> get props => [leaves!];
}

class LeaveError extends LeaveState {
  final String? message;

  const LeaveError(this.message);

  @override
  List<Object> get props => [message!];
}