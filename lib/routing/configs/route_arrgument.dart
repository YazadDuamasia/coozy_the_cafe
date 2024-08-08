import 'dart:convert';

import 'package:coozy_the_cafe/model/category.dart';
import 'package:coozy_the_cafe/model/menu_item.dart';
import 'package:coozy_the_cafe/model/sub_category.dart';

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

  Map<String, dynamic> toMap() =>
      {
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

UpdateMenuCategoryScreenArgument updateMenuCategoryScreenArgumentFromMap(
    String str) => UpdateMenuCategoryScreenArgument.fromMap(json.decode(str));

String updateMenuCategoryScreenArgumentToMap(
    UpdateMenuCategoryScreenArgument data) => json.encode(data.toMap());

class UpdateMenuCategoryScreenArgument {
  var categoryId;

  UpdateMenuCategoryScreenArgument({
    required this.categoryId,

  });

  factory UpdateMenuCategoryScreenArgument.fromMap(Map<String, dynamic> json) =>
      UpdateMenuCategoryScreenArgument(
          categoryId: json['categoryId'] != null ? json['categoryId'] : null
      );

  Map<String, dynamic> toMap() =>
      {
        'categoryId': categoryId ?? null,

      };

  static String updateMenuCategoryScreenArgument({categoryId}) {
    Map<String, dynamic> map = {
      'categoryId': categoryId,
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
        phoneNumber: json["phoneNumber"] ?? null,
        isForgetPassword: json["isForgetPassword"] ?? null,
        otpNumber: json["otpNumber"] ?? null,
        appSignature: json["appSignature"] ?? null,
        isLoginScreen: json["isLoginScreen"] ?? null,
        customerID: json["customerID"] ?? null,
      );

  Map<String, dynamic> toMap() =>
      {
        "phoneNumber": phoneNumber ?? null,
        "isForgetPassword": isForgetPassword ?? null,
        "otpNumber": otpNumber ?? null,
        "appSignature": appSignature ?? null,
        "isLoginScreen": isLoginScreen ?? null,
        "customerID": customerID ?? null,
      };

  static String addOtpVerfiy({required phoneNumber,
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

//-------------------------------------------------------------------------------------------------------------------//

class AddEditMenuItemArgument {
  AddEditMenuItemArgument({
    this.menuItem,
  });

  MenuItem? menuItem;

  factory AddEditMenuItemArgument.fromMap(Map<String, dynamic> json) =>
      AddEditMenuItemArgument(
        menuItem: json["menuItem"] != null
            ? MenuItem.fromJson(json["menuItem"])
            : null,
      );

  Map<String, dynamic> toMap() => {
    "menuItem": menuItem?.toJson(),
  };

  static String addEditMenuItemToJson(AddEditMenuItemArgument data) =>
      json.encode(data.toMap());

  static AddEditMenuItemArgument addEditMenuItemFromJson(String str) =>
      AddEditMenuItemArgument.fromMap(json.decode(str));
}