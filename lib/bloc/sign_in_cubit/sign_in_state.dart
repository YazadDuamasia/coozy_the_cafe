part of 'sign_in_cubit.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();
}

class SignUpInitial extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignUpLoadingState extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignUpLoadedState extends SignUpState {
  @override
  List<Object> get props => [];
}

class SignUpErrorState extends SignUpState {
  String? errorMsg;

  SignUpErrorState(this.errorMsg);

  @override
  List<Object> get props => [errorMsg!];
}

class SignUpNoInternetState extends SignUpState {
  @override
  List<Object> get props => [];
}
