import 'dart:convert';

//-------------------------------------------------------------------------------------------------------------------//

CommonScreenArgument addCommonScreenArgumentFromMap(String str) =>
    CommonScreenArgument.fromMap(json.decode(str));

String addCommonScreenArgumentToMap(CommonScreenArgument data) =>
    json.encode(data.toMap());

class CommonScreenArgument {
  CommonScreenArgument({
    required this.memberId,
  });

  var memberId;

  factory CommonScreenArgument.fromMap(Map<String, dynamic> json) =>
      CommonScreenArgument(
        memberId: json["memberId"],
      );

  Map<String, dynamic> toMap() => {
        "memberId": memberId,
      };

  static String addCommonArgument({memberId}) {
    Map<String, dynamic> map = {
      'memberId': memberId,
    };
    return json.encode(map);
  }
}

//-------------------------------------------------------------------------------------------------------------------//

OtpVerificationScreenArgument otpVerificationScreenArgumentFromMap(
        String str) =>
    OtpVerificationScreenArgument.fromMap(json.decode(str));

String otpVerificationScreenArgumentToMap(OtpVerificationScreenArgument data) =>
    json.encode(data.toMap());

class OtpVerificationScreenArgument {
  OtpVerificationScreenArgument({
    required this.phoneNumber,
    required this.isForgetPassword,
    required this.isLoginScreen,
    this.otpNumber,
    this.customerID,
    this.appSignature,
  });

  String? phoneNumber;
  bool? isForgetPassword;
  bool? isLoginScreen;
  String? otpNumber;
  dynamic appSignature;
  dynamic customerID;

  factory OtpVerificationScreenArgument.fromMap(Map<String, dynamic> json) =>
      OtpVerificationScreenArgument(
        phoneNumber: json["phoneNumber"],
        isForgetPassword: json["isForgetPassword"],
        otpNumber: json["otpNumber"],
        appSignature: json["appSignature"],
        isLoginScreen: json["isLoginScreen"],
        customerID: json["customerID"],
      );

  Map<String, dynamic> toMap() => {
        "phoneNumber": phoneNumber,
        "isForgetPassword": isForgetPassword,
        "otpNumber": otpNumber,
        "appSignature": appSignature,
        "isLoginScreen": isLoginScreen,
        "customerID": customerID,
      };

  static String addOtpVerfiy(
      {required phoneNumber,
      required isForgetPassword,
      required isLoginScreen,
      customerID,
      otpNumber,
      appSignature}) {
    Map<String, dynamic> map = {
      'phoneNumber': phoneNumber.toString(),
      'otpNumber': otpNumber,
      'customerID': customerID,
      'appSignature': appSignature,
      'isLoginScreen': isLoginScreen,
      'isForgetPassword': isForgetPassword,
    };
    return json.encode(map);
  }
}
