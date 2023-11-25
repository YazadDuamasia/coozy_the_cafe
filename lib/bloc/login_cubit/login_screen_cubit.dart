import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/rxdart.dart';

part 'login_screen_state.dart';

class LoginScreenCubit extends Cubit<LoginScreenState> {
  LoginScreenCubit() : super(LoginScreenInitialState()){
    fetchInitialInfo();
  }
  void fetchInitialInfo() async {
    InternetConnection().onStatusChange.listen(
          (result) async {
        if (result == InternetStatus.connected) {
          emit(LoginScreenLoadingState());

          emit(LoginScreenLoadedState());
        } else {
          emit(LoginScreenNoInternetState());
        }
      },
    );
  }

  //define controllers
  final _userNameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _captchaController = BehaviorSubject<String>();
  final _buttonLoading = BehaviorSubject<bool>();
  final _buttonRefreshing = BehaviorSubject<bool>();

  //get data
  Stream<String> get userNameStream => _userNameController.stream;

  Stream<String> get passwordStream => _passwordController.stream;

  Stream<String> get captchaStream => _captchaController.stream;

  Stream<bool> get buttonLoadingStream => _buttonLoading.stream;

  Stream<bool> get buttonRefreshingStream => _buttonRefreshing.stream;

  //clear the data
  void dispose() {
    updateUserName('');
    updatePassword('');
    updateButtonLoading(false);
    updateButtonRefreshing(false);
  }

  //validation of UserName
  void updateUserName(String userName) {
    Pattern emailPattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regexEmail = RegExp(emailPattern.toString());
    if (userName.isNotEmpty) {
      if (regexEmail.hasMatch(userName)) {
        _userNameController.sink.add(userName);
      } else {
        _userNameController.sink.addError("Please enter a valid email");
      }
    } else {
      _userNameController.sink.addError("Email is required.");
    }
    // bool? isEmailValid = EmailValidator.validate(userName);
    // Constants.debugLog(LoginScreenCubit, "isEmailValid:$isEmailValid");
    // bool? noOneLetterDomain = userName.split('.').last.length > 1;
    // Constants.debugLog(
    //     LoginScreenCubit, "noOneLetterDomain:$noOneLetterDomain");
    // if (!isEmailValid && !noOneLetterDomain) {
    //   _userNameController.sink.addError("Please enter a valid email");
    // } else {
    //   _userNameController.sink.add(userName);
    // }
  }

  //validation of Password
  void updatePassword(String password) {
    if (password.isEmpty) {
      _passwordController.sink.addError("Please enter your password");
    } else if (password.length < 5) {
      _passwordController.sink.addError("Please enter more then 4 words");
    } else {
      _passwordController.sink.add(password);
    }
  }

  void updateButtonLoading(bool? isloading) {
    _buttonLoading.sink.add(isloading!);
  }

  void updateButtonRefreshing(bool? isRefreshing) {
    _buttonRefreshing.sink.add(isRefreshing!);
  }

  //check validation
  Stream<bool> get validateForm => Rx.combineLatest2(
        userNameStream,
        passwordStream,
        (a, b) => true,
      );
}
