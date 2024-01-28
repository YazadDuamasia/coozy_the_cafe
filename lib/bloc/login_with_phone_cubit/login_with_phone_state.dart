part of 'login_with_phone_cubit.dart';

abstract class LoginWithPhoneState extends Equatable {
  const LoginWithPhoneState();
}

class LoginWithPhoneInitial extends LoginWithPhoneState {
  @override
  List<Object> get props => [];
}

class LoginWithPhoneLoadingState extends LoginWithPhoneState {
  @override
  List<Object> get props => [];
}

class LoginWithPhoneLoadedState extends LoginWithPhoneState {
  @override
  List<Object> get props => [];
}

class LoginWithPhoneErrorState extends LoginWithPhoneState {
  String? errorMsg;

  LoginWithPhoneErrorState(this.errorMsg);

  @override
  List<Object> get props => [errorMsg!];
}

class LoginWithPhoneNoInternetState extends LoginWithPhoneState {
  @override
  List<Object> get props => [];
}
