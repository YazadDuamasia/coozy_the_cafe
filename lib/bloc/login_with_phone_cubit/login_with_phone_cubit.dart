import 'dart:convert';
import 'dart:io';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:coozy_cafe/widgets/country_pickers/country.dart';
import 'package:coozy_cafe/widgets/widgets.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

part 'login_with_phone_state.dart';

class LoginWithPhoneCubit extends Cubit<LoginWithPhoneState> {
  LoginWithPhoneCubit() : super(LoginWithPhoneInitial()) {
    fetchInitialInfo();
  }

  void fetchInitialInfo() async {
    emit(LoginWithPhoneLoadingState());

    InternetStatus? connectionStatus =
        await InternetConnection().internetStatus;
    if (connectionStatus == InternetStatus.connected) {
      if (Constants.getIsMobileApp() == true) {
        try {
          final List<Locale> systemLocales =
              WidgetsBinding.instance.window.locales;
          String? isoCountryCode = systemLocales.first.countryCode;
          Constants.debugLog(
              LoginWithPhoneCubit, "isoCountryCode:${isoCountryCode!}");
          _phoneNumberIosCodeController
              .add(CountryPickerUtils.getCountryByIsoCode(isoCountryCode));
          emit(LoginWithPhoneLoadedState());
        } catch (e) {
          Constants.debugLog(LoginWithPhoneCubit,
              "updateCountryIosCode:getIsMobileApp:Error:${e.toString()}");
          var data = CountryPickerUtils.getCountryByIso3Code("IND");
          _phoneNumberIosCodeController.add(data);
          await Future.delayed(const Duration(seconds: 3));
          emit(LoginWithPhoneLoadedState());
        }
      } else {
        getPublicIp();
        emit(LoginWithPhoneLoadedState());
      }
    } else {
      emit(LoginWithPhoneNoInternetState());
    }
  }

  final _phoneNumberIosCodeController = BehaviorSubject<Country?>();
  final _buttonLoading = BehaviorSubject<bool>();

  Stream<bool> get buttonLoadingStream => _buttonLoading.stream;

  Stream<Country?> get phoneNumberIosCodeController =>
      _phoneNumberIosCodeController.stream;

  void dispose() {
    updateButtonLoading(false);
    updateCountryIosCode(null);
  }

  void updateButtonLoading(bool? isloading) {
    _buttonLoading.sink.add(isloading!);
  }

  void updateCountryIosCode(Country? country) async {
    if (country == null) {
      if (Constants.getIsMobileApp() == true) {
        try {
          final List<Locale> systemLocales =
              WidgetsBinding.instance.window.locales;
          String? isoCountryCode = systemLocales.first.countryCode;
          Constants.debugLog(
              LoginWithPhoneCubit, "isoCountryCode:${isoCountryCode!}");
          _phoneNumberIosCodeController.sink
              .add(CountryPickerUtils.getCountryByIsoCode(isoCountryCode));
        } catch (e) {
          Constants.debugLog(LoginWithPhoneCubit,
              "updateCountryIosCode:getIsMobileApp:Error:${e.toString()}");
          var data = CountryPickerUtils.getCountryByIso3Code("IND");
          _phoneNumberIosCodeController.sink.add(data);
        }
      } else {
        getPublicIp();
      }
    } else {
      _phoneNumberIosCodeController.add(country);
    }
  }

  void getPublicIp() async {
    String? ipv4 = await getPublicIp4();
    if (ipv4 != null) {
      var country_code = await getIpInfo(ipv4);
      Constants.debugLog(LoginWithPhoneCubit,
          ":getPublicIp:IPV4:country_code:${country_code}");
      if (country_code != null && country_code.isNotEmpty) {
        var data = CountryPickerUtils.getCountryByIso3Code(country_code);
        _phoneNumberIosCodeController.sink.add(data);
      }
    } else {
      String? ipv6 = await getPublicIp6();
      if (ipv6 != null) {
        var country_code = await getIpInfo(ipv6);
        Constants.debugLog(LoginWithPhoneCubit,
            ":getPublicIp:IPV6:country_code:${country_code}");
        if (country_code != null && country_code.isNotEmpty) {
          var data = CountryPickerUtils.getCountryByIso3Code(country_code);
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
        final country_code_iso3 = data['country_code_iso3'] as String;
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
        return country_code_iso3;
      } else {
        // print('Failed to get IP info');
        return null;
      }
    } on SocketException {
      await getIpInfo(ipAddress);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> close() {
    _phoneNumberIosCodeController.close();
    _buttonLoading.close();
    return super.close();
  }
}
