part of 'employee_cubit.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<Employee>? employees;

  const EmployeeLoaded(this.employees);

  @override
  List<Object> get props => [employees!];
}

class EmployeeError extends EmployeeState {
  final String? message;

  const EmployeeError(this.message);

  @override
  List<Object> get props => [message!];
}
