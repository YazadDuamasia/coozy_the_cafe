import 'dart:async';
import 'dart:math' as math;

import 'package:app_settings/app_settings.dart';
import 'package:coozy_cafe/model/translator_language/translator_language.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_info/platform_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class Constants {
  static const String prefThemeModeKey = "user_theme";
  static const String appName = "Coozy Cafe";
  static const String prefFirstTimeVistedKey = "user_first_time_app";
  static Map<String, String> hashMap = <String, String>{};
  static String kValidHexPattern = r'^#?[0-9a-fA-F]{1,8}';

  Future<bool> _requestPermission(Permission permission) async {
    PermissionStatus status = await permission.status;
    switch (status) {
      case PermissionStatus.granted:
        return true;

      case PermissionStatus.denied:
        var result = await permission.request();
        return result == PermissionStatus.granted;

      case PermissionStatus.permanentlyDenied:
        try {
          return openAppSettings()
              .then((value) async => await _requestPermission(permission));
        } catch (e) {
          Constants.debugLog(Constants,
              "Constants:_requestPermission:permanentlyDenied:Error:${e}");
          return false;
        }

      default:
        return false;
    }
  }

  bool isFutureDate(String dateString) {
    try {
      DateTime? bookingDate = DateTime.tryParse(dateString)?.toUtc();
      DateTime today = DateTime.now().toUtc();
      return (bookingDate?.isAfter(today) ?? false) ||
          (bookingDate?.isAtSameMomentAs(today) ?? false);
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool isPastDate(String dateString) {
    try {
      DateTime? bookingDate = DateTime.tryParse(dateString)?.toUtc();
      DateTime today = DateTime.now().toUtc();
      return (bookingDate?.isAfter(today) ?? false);
    } catch (e) {
      print(e);
      return false;
    }
  }

  static String? getValueFromKey(
      String? internetString,
      String? startInternetString,
      String? appendInternetString,
      String? defaultString) {
    if (internetString == null || internetString.isEmpty) {
      return defaultString.toString();
    } else {
      if (Constants.hashMap.isEmpty) {
        return defaultString.toString();
      } else {
        if (Constants.hashMap
            .containsKey(internetString.toString().trim().toLowerCase())) {
          String? str = (startInternetString ?? "") +
              Constants.hashMap[internetString.toLowerCase()]!.toString() +
              (appendInternetString ?? "");
          return str;
        } else {
          Constants.debugLog(Constants, "String Not Found:$internetString");
          return defaultString.toString().trim();
        }
      }
    }
    /*
    if (internetString != null && internetString.isNotEmpty) {

      if (Constants.hashMap.isNotEmpty) {
        if (Constants.hashMap
            .containsKey(internetString.toString().trim().toLowerCase())) {
          String? str = (startInternetString ?? "") +
              Constants.hashMap[internetString.toLowerCase()]!.toString() +
              (appendInternetString ?? "");
          return str;
        } else {
          Constants.debugLog(Constants, "String Not Found:$internetString");
          return defaultString.toString().trim();
        }
      } else {
        return defaultString.toString();
      }
    } else {

      return defaultString.toString();
    }*/
  }

  static String getTextTimeAgo(
      {String? dateStr,
      required String? localizedCode,
      DateTime? dateTime,
      bool? allowFromNow}) {
    Constants.debugLog(Constants, "date:$dateStr");
    Constants.debugLog(Constants, "dateTime:$dateTime");
    if (dateStr != null && dateStr.isNotEmpty) {
      DateTime? passingDate = DateTime.tryParse(dateStr)?.toLocal();
      DateTime? now = DateTime.now().toLocal();
      Duration? duration = now.difference(passingDate!);
      DateTime? result = now.subtract(duration).toLocal();
      return timeago.format(result,
          locale: localizedCode,
          allowFromNow: allowFromNow ?? true,
          clock: now);
    } else if (dateTime != null) {
      DateTime? now = DateTime.now().toLocal();
      Duration? duration = now.difference(dateTime);
      DateTime? result = now.subtract(duration).toLocal();
      return timeago.format(result,
          locale: localizedCode,
          allowFromNow: allowFromNow ?? true,
          clock: now);
    } else {
      return "";
    }
  }

  ///print log at platform  level
  static void debugLog(Type? classObject, String? message) {
    try {
      var runtimeTypeName = (classObject).toString();
      if (kDebugMode) {
        // print("${runtimeTypeName.toString()}: $message");
        debugPrint("${runtimeTypeName.toString()}: $message");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  /*
  * * Usage
  * * Constants.debugLog(SplashScreen,"Hello");
  *
  */

  static Future<bool> isFirstTime(String? str) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool(str ?? "CommonFirstTime") ?? true;
    if (firstTime) {
      // first time
      await prefs.setBool(str ?? "CommonFirstTime", false);
      return true;
    } else {
      return false;
    }

    return false;
  }

/*
  //Usage
  Constants.isFirstTime("ConstantUniqueKey").then((isFirstTime) {
  if(isFirstTime==true){
  print("First time");
  }else{
  print("Not first time");
  }
  });
  */

  static bool getIsMobileApp() {
    try {
      if (platform.isMobile == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static bool isAndroid() {
    try {
      if (platform.isAndroid == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
      // print(e);
    }
  }

  static bool isIOS() {
    try {
      if (platform.isIOS == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static bool isMacOS() {
    try {
      if (platform.isMacOS == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<String> getCurrentPlatform() async {
    try {
      if (platform.isWeb) {
        return "web";
      } else if (platform.isMacOS) {
        return "macOS";
      } else if (platform.isLinux) {
        return "Linux";
      } else if (platform.isWindows) {
        return "Windows";
      } else if (platform.isAndroid) {
        return "Android";
      } else if (platform.isIOS) {
        return "iOS";
      } else {
        return "Unknown platform";
      }
    } catch (e) {
      print(e);
      return "Unknown platform";
    }
  }

  static int? randomNumberGenerator(int? min, int? max) {
    int? randomise = min! + math.Random().nextInt(max! - min);
    Constants.debugLog(Constants, "randomNumberMinMax:$randomise");
    if (randomise >= min && randomise <= max) {
      return randomise;
    } else {
      return randomNumberGenerator(min, max);
    }
  }

  static Future<void> showTransparentLoader(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: '',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Lottie.asset(
                  StringImagePath.loading_lottie,
                  fit: BoxFit.scaleDown,
                  width: MediaQuery.of(context).size.width * .65,
                  height: MediaQuery.of(context).size.height * .5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static progressDialogCustomMessage(
      {required bool? isLoading,
      required BuildContext? context,
      String? msgTitle,
      required String? msgBody,
      Color? colorTextTitle,
      required Color? colorTextBody}) async {
    AlertDialog dialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      content: Center(
        child: ColoredBox(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context!).size.width * 0.45,
                height: 3,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor,
                    size: 60,
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Visibility(
                visible: msgTitle?.isNotEmpty ?? false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        msgTitle ?? "",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: colorTextTitle!),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      msgBody ?? "",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: colorTextBody),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: 3,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
    );
    if (!isLoading!) {
      Navigator.pop(context, true);
    } else {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return dialog;
          });
    }
  }

  static void customAutoDismissAlertDialog({
    required Type? classObject,
    required BuildContext? context,
    Duration? showForHowDuration,
    Widget? titleIcon,
    String? title,
    bool? barrierDismissible,
    required String? descriptions,
    required GlobalKey<NavigatorState> navigatorKey,
  }) async {
    Constants.debugLog(classObject, "title:$title");
    AlertDialog dialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Stack(
        children: <Widget>[
          Positioned(
            left: 20,
            top: 0,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Theme.of(context!).colorScheme.primary,
              radius: 47,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                left: 20, top: 45 + 20, right: 20, bottom: 20),
            margin: const EdgeInsets.only(top: 45),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  visible: title?.isNotEmpty ?? false,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, bottom: 10, top: 0),
                          child: Text(
                            title ?? "",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : null,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: (descriptions == null || descriptions.isEmpty)
                      ? false
                      : true,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          descriptions ?? "",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.white
                                        : null,
                                    fontWeight: FontWeight.w700,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 2,
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(45)),
                child: titleIcon ?? Container(),
              ),
            ),
          ),
        ],
      ),
    );
    Timer? counter;

    counter = Timer(
      showForHowDuration ?? const Duration(seconds: 3),
      () {
        print("Timer callback executed");
        counter?.cancel();
        navigatorKey.currentState?.pop();
      },
    );

    await showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async {
              // Prevent manual dismissal by the user
              print("manual dismissal is been call by the user");
              if (counter!.isActive) {
                print("counter been cancel. ");
                counter.cancel();
              }
              return true;
            },
            child: dialog);
      },
    );
  }

  static void customTimerPopUpDialogMessage({
    required Type? classObject,
    required bool? isLoading,
    required BuildContext? context,
    Duration? showForHowDuration,
    Widget? titleIcon,
    String? title,
    required String? descriptions,
    required Color? textColorDescriptions,
  }) async {
    Timer? couter;
    Constants.debugLog(classObject, "title:$title");
    AlertDialog dialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Stack(
        children: <Widget>[
          Positioned(
            left: 20,
            top: 0,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Theme.of(context!).colorScheme.primary,
              radius: 47,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                left: 20, top: 45 + 20, right: 20, bottom: 20),
            margin: const EdgeInsets.only(top: 45),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  visible: title?.isNotEmpty ?? false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, bottom: 10, top: 0),
                              child: Text(
                                title ?? "",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : null,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        descriptions ?? "",
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.white
                                  : null,
                              fontWeight: FontWeight.w700,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 2,
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(45)),
                child: titleIcon ?? Container(),
              ),
            ),
          ),
        ],
      ),
    );
    if (!isLoading!) {
      if ((couter?.isActive ?? false) == true) {
        Constants.debugLog(
            Constants, "customTimerPopUpDialogMessage:Timer has stopped");
        couter?.cancel();
      }
      Navigator.pop(context);
    } else {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          couter = Timer(
            showForHowDuration ?? const Duration(seconds: 40),
            () async {
              if ((couter?.isActive ?? false) == true) {
                couter?.cancel();
              }
              Navigator.pop(context);
            },
          );
          return dialog;
        },
      );
    }
  }

  static void customPopUpDialogMessage(
      {required Type? classObject,
      required BuildContext? context,
      Widget? titleIcon,
      String? title,
      required String? descriptions,
      required Widget? actions}) async {
    Constants.debugLog(classObject, "title:$title");
    Constants.debugLog(classObject, "descriptions:$descriptions");
    AlertDialog dialog = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Stack(
        children: <Widget>[
          Positioned(
            left: 20,
            top: 0,
            right: 20,
            child: CircleAvatar(
              backgroundColor: Theme.of(context!).colorScheme.primary,
              radius: 47,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
                left: 20, top: 45 + 20, right: 20, bottom: 20),
            margin: const EdgeInsets.only(top: 45),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  visible: title?.isNotEmpty ?? false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, bottom: 10, top: 0),
                              child: Text(
                                title ?? "",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : null,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        descriptions ?? "",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.white
                                  : null,
                              fontWeight: FontWeight.w700,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                actions ?? Container()
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 2,
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(45)),
                child: titleIcon ?? Container(),
              ),
            ),
          ),
        ],
      ),
    );

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  static Future<Position?> getCurrentLocation(
      {BuildContext? context, LocationAccuracy? desiredAccuracy}) async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.deniedForever) {
      if (platform.isMobile) {
        showDialog(
          context: context!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Location permissions required'),
              content: const Text(
                  'Please go to app settings and grant location permissions.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text('OPEN APP SETTINGS'),
                  onPressed: () {
                    Navigator.pop(context);
                    AppSettings.openAppSettings();
                  },
                ),
              ],
            );
          },
        );
      } else {
        return Future.error('Location permissions are denied.');
      }
    } else if (permission == LocationPermission.denied) {
      // The user has denied location permissions.
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }
    // Get the current location.
    return await Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
        desiredAccuracy: LocationAccuracy.medium);
  }

  static void showToastMsg({required String? msg, bool? isForShortDuration}) {
    Fluttertoast.showToast(
      msg: '${msg}',
      timeInSecForIosWeb:
          isForShortDuration == null || isForShortDuration == true ? 3 : 5,
      toastLength: isForShortDuration == null || isForShortDuration == true
          ? Toast.LENGTH_SHORT
          : Toast.LENGTH_LONG,
      fontSize: 16,
      textColor: Colors.white,
      backgroundColor:
          Theme.of(navigatorKey.currentContext!).colorScheme.primaryContainer,
    );
  }

  static List<TranslatorLanguageModel> languages = jsonLanguagesData
      .map((data) => TranslatorLanguageModel.fromJson(data))
      .toList();

  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing dialog on outside tap
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10),
          content: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoActivityIndicator(
                    animating: true,
                    color: Theme.of(context).brightness==Brightness.dark?Colors.white:Theme.of(context).primaryColor,
                    radius: 15),
                const SizedBox(width: 16), // Space between indicator and text
                Text(
                  "Please wait...",
                  style: Theme.of(context).textTheme.bodyMedium,
                ), // Text indicating loading
              ],
            ),
          ),
        );
      },
    );
  }
}
