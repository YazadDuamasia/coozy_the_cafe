import 'dart:convert';
import 'dart:io';

import 'package:coozy_cafe/utlis/components/constants.dart';
import 'package:coozy_cafe/widgets/country_pickers/country.dart';
import 'package:coozy_cafe/widgets/country_pickers/utils/utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

part 'sign_in_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial()) {
    InternetConnection().onStatusChange.listen(
      (result) {
        if (result == InternetStatus.connected) {
          fetchInitialInfo();
        } else {
          emit(SignUpNoInternetState());
        }
      },
    );
  }

  void fetchInitialInfo() async {
    emit(SignUpLoadingState());
    if (Constants.getIsMobileApp() == true) {
      try {
        final List<Locale> systemLocales =
            WidgetsBinding.instance.window.locales;
        String? isoCountryCode = systemLocales.first.countryCode;
        Constants.debugLog(SignUpCubit, "isoCountryCode:${isoCountryCode!}");
        _phoneNumberIosCodeController
            .add(CountryPickerUtils.getCountryByIsoCode(isoCountryCode));
      } catch (e) {
        Constants.debugLog(SignUpCubit,
            "updateCountryIosCode:getIsMobileApp:Error:${e.toString()}");
        var data = CountryPickerUtils.getCountryByIso3Code("IND");
        _phoneNumberIosCodeController.add(data);
      }
    } else {
      getPublicIp();
    }

    emit(SignUpLoadedState());
  }

  //define controllers

  final _firstNameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _userNameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _phoneNumberIosCodeController = BehaviorSubject<Country?>();
  final _phoneNumberController = BehaviorSubject<String>();
  final _genderController = BehaviorSubject<String>();
  final _dobController = BehaviorSubject<String>();

  final _passwordController = BehaviorSubject<String>();
  final _passwordObscureTextController = BehaviorSubject<bool>();
  final _confirmPasswordController = BehaviorSubject<String>();
  final _confirmPasswordObscureTextController = BehaviorSubject<bool>();

  final _isPasswordOneNumCase = BehaviorSubject<bool>();
  final _isPasswordOneUpperCase = BehaviorSubject<bool>();
  final _isPasswordOneLowerCase = BehaviorSubject<bool>();
  final _isPasswordOneSpecialChar = BehaviorSubject<bool>();
  final _isPasswordSizeRequire = BehaviorSubject<bool>();

  final _buttonLoading = BehaviorSubject<bool>();

  void dispose() {
    updateDob('');
    checkPassword('');
    updatePhoneNumber('');
    updateConfirmPassword('');
    updateGender(" ");
    updatePasswordObscureText(false);
    updateConfirmPasswordObscureText(false);
    updateButtonLoading(false);
  }

  Stream<String> get passwordController => _passwordController.stream;

  Stream<bool> get isPasswordOneNumCase => _isPasswordOneNumCase.stream;

  Stream<bool> get isPasswordOneUpperCase => _isPasswordOneUpperCase.stream;

  Stream<bool> get isPasswordOneLowerCase => _isPasswordOneLowerCase.stream;

  Stream<bool> get isPasswordOneSpecialChar => _isPasswordOneSpecialChar.stream;

  Stream<bool> get isPasswordSizeRequire => _isPasswordSizeRequire.stream;

  Stream<String> get confirmPasswordController =>
      _confirmPasswordController.stream;

  Stream<String> get firstNameController => _firstNameController.stream;

  Stream<String> get lastNameController => _lastNameController.stream;

  Stream<String> get userNameController => _userNameController.stream;

  Stream<String> get emailController => _emailController.stream;

  ValueStream<Country?> get phoneNumberIosCodeController =>
      _phoneNumberIosCodeController.stream;

  Stream<String> get phoneNumberController => _phoneNumberController.stream;

  Stream<String> get genderController => _genderController.stream;

  Stream<String> get dobController => _dobController.stream;

  Stream<bool> get passwordObscureTextController =>
      _passwordObscureTextController.stream;

  Stream<bool> get confirmPasswordObscureTextController =>
      _confirmPasswordObscureTextController.stream;

  Stream<bool> get buttonLoadingStream => _buttonLoading.stream;

  void updateGender(String gender) {
    if (gender != " ") {
      _genderController.sink.add(gender);
    } else {
      _genderController.sink.addError("Please select your gender.");
    }
  }

  void updateCountryIosCode(Country? country) async {
    if (country == null) {
      if (Constants.getIsMobileApp() == true) {
        try {
          final List<Locale> systemLocales =
              WidgetsBinding.instance.window.locales;
          String? isoCountryCode = systemLocales.first.countryCode;
          Constants.debugLog(SignUpCubit, "isoCountryCode:${isoCountryCode!}");
          _phoneNumberIosCodeController
              .add(CountryPickerUtils.getCountryByIsoCode(isoCountryCode));
        } catch (e) {
          Constants.debugLog(SignUpCubit,
              "updateCountryIosCode:getIsMobileApp:Error:${e.toString()}");
          var data = CountryPickerUtils.getCountryByIso3Code("IND");
          _phoneNumberIosCodeController.add(data);
        }
      } else {
        getPublicIp();
      }
    } else {
      _phoneNumberIosCodeController.sink.add(country);
      // print("done");
    }
  }

  void updateDob(String pick) {
    _dobController.sink.add(pick);
  }

  void updatePasswordObscureText(bool data) {
    _passwordObscureTextController.sink.add(!data);
  }

  void updateConfirmPasswordObscureText(bool data) {
    _confirmPasswordObscureTextController.sink.add(!data);
  }

// should contain at least one upper case
// should contain at least one lower case
// should contain at least one digit
// should contain at least one Special character
// Must be at least 8 characters in length
  void updatePassword(String password) {
    RegExp regExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~+-]).{8,}$');
    if (regExp.hasMatch(password)) {
      _passwordController.sink.add(password);
    } else {
      _passwordController.sink.addError("Please fill password properly.");
    }
  }

  void checkPassword(String password) {
    final numericRegex = RegExp("^(?=.*[0-9])");
    final OneUpperCaseRegex = RegExp("^(?=.*[A-Z])");
    final OneLowerCaseRegex = RegExp("^(?=.*[a-z])");
    final OneSpeficCaseRegex = RegExp("^(?=.*[!@#\$&*~+-])");

    if (password.isEmpty) {
      _passwordController.addError("Please enter a valid email");
      _isPasswordOneLowerCase.sink.add(false);
      _isPasswordOneUpperCase.sink.add(false);
      _isPasswordOneNumCase.sink.add(false);
      _isPasswordOneSpecialChar.sink.add(false);
      _isPasswordSizeRequire.sink.add(false);
    } else {
      if (!OneLowerCaseRegex.hasMatch(password)) {
        _isPasswordOneLowerCase.sink.add(false);
      } else {
        _isPasswordOneLowerCase.sink.add(true);
      }

      if (!OneUpperCaseRegex.hasMatch(password)) {
        _isPasswordOneUpperCase.sink.add(false);
      } else {
        _isPasswordOneUpperCase.sink.add(true);
      }

      if (!numericRegex.hasMatch(password)) {
        _isPasswordOneNumCase.sink.add(false);
      } else {
        _isPasswordOneNumCase.sink.add(true);
      }

      if (!OneSpeficCaseRegex.hasMatch(password)) {
        _isPasswordOneSpecialChar.sink.add(false);
      } else {
        _isPasswordOneSpecialChar.sink.add(true);
      }
      if (password.length >= 8) {
        _isPasswordSizeRequire.sink.add(true);
      } else {
        _isPasswordSizeRequire.sink.add(false);
      }

      if (password.length >= 8) {
        _isPasswordSizeRequire.sink.add(true);
      } else {
        _isPasswordSizeRequire.sink.add(false);
      }
    }
  }

  Future<void> updateConfirmPassword(String confirmPassword) async {
    if (confirmPassword != null || confirmPassword.isNotEmpty) {
      String? password = "";
      try {
        password = _passwordController.valueOrNull;
      } catch (e) {
        password = "";
      }
      // print("password:$password");
      if (confirmPassword.compareTo(password ?? "") == 0) {
        _confirmPasswordController.sink.add(confirmPassword);
      } else {
        _confirmPasswordController.sink.addError("Password is not match up..");
      }
    } else {
      _confirmPasswordController.sink
          .addError("Please fill password properly.");
    }
  }

  void updateButtonLoading(bool? isloading) {
    _buttonLoading.sink.add(isloading!);
  }

  void updatePhoneNumber(String phNumber) {
    if (phNumber.isEmpty) {
      _phoneNumberController.addError("Please enter a valid phone number.");
    } else {
      _phoneNumberController.sink.add(phNumber);
    }
  }

  void getPublicIp() async {
    String? ipv4 = await getPublicIp4();
    if (ipv4 != null) {
      var countryCode = await getIpInfo(ipv4);
      Constants.debugLog(
          SignUpCubit, ":getPublicIp:IPV4:country_code:$countryCode");
      if (countryCode != null && countryCode.isNotEmpty) {
        var data = CountryPickerUtils.getCountryByIso3Code(countryCode);
        _phoneNumberIosCodeController.sink.add(data);
      }
    } else {
      String? ipv6 = await getPublicIp6();
      if (ipv6 != null) {
        var countryCode = await getIpInfo(ipv6);
        Constants.debugLog(
            SignUpCubit, ":getPublicIp:IPV6:country_code:$countryCode");
        if (countryCode != null && countryCode.isNotEmpty) {
          var data = CountryPickerUtils.getCountryByIso3Code(countryCode);
          _phoneNumberIosCodeController.sink.add(data);
        }
      } else {
        // print("No Ip Founded");
        var data = CountryPickerUtils.getCountryByIso3Code("IND");
        _phoneNumberIosCodeController.sink.add(data);
      }
    }
  }

  Future<String?> getPublicIp4() async {
    String? ipv4;
    try {
      http.Response? responseV4 = await http.get(
        Uri.parse('https://api.ipify.org?format=json'),
      );
      if (responseV4.statusCode == 200) {
        final data = jsonDecode(responseV4.body);
        ipv4 = data['ip'] as String;
        // print('Public IPv4 address: $ipv4');
      }
      // else if (responseV4.statusCode == 429) {
      //   await getPublicIp4();
      // }
      else {
        ipv4 = null;
        // print('Failed to get public IPv4 address');
      }
    } on SocketException {
      await getPublicIp4();
    } catch (e) {
      ipv4 = null;
      // print('Failed to get public IPv4 address');
      // print(e);
    }
    return ipv4;
  }

  Future<String?> getPublicIp6() async {
    String? ipv6;
    try {
      http.Response? responseV6 = await http.get(
        Uri.parse("https://api64.ipify.org/?format=json"),
      );
      if (responseV6.statusCode == 200) {
        final data = jsonDecode(responseV6.body);
        ipv6 = data['ip'] as String;
        // print('Public IPv6 address: $ipv6');
      }
      // else if (responseV6.statusCode == 429) {
      //   await getPublicIp6();
      // }
      else {
        ipv6 = null;
        // print('Failed to get public IPv6 address');
      }
    } on SocketException {
      await getPublicIp6();
    } catch (e) {
      ipv6 = null;
      // print('Failed to get public IPv6 address');
      // print(e);
    }
    return ipv6;
  }

  Future<String?> getIpInfo(String ipAddress) async {
    final url = 'https://ipapi.co/$ipAddress/json/';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // final country = data['country_name'] as String;
        final countryCodeIso3 = data['country_code_iso3'] as String;
        // final region = data['region'] as String;
        // final city = data['city'] as String;
        // final latitude = data['latitude'] as double;
        // final longitude = data['longitude'] as double;
        // final timezone = data['timezone'] as String;
        // final isp = data['org'] as String;
        //
        // print('Country: $country');
        // print('Region: $region');
        // print('City: $city');
        // print('Latitude: $latitude');
        // print('Longitude: $longitude');
        // print('Time zone: $timezone');
        // print('ISP: $isp');
        return countryCodeIso3;
      } else {
        print('Failed to get IP info');
        return null;
      }
    } on SocketException {
      await getIpInfo(ipAddress);
    } catch (e) {
      return null;
    }
    return null;
  }
}
