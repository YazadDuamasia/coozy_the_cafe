import 'dart:async';
import 'dart:convert';


import 'package:coozy_cafe/routing/routs.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:coozy_cafe/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sms_autofill/sms_autofill.dart';


class OtpVerificationPage extends StatefulWidget {
  final String? phoneNumber;
  String? otpNumber;
  String? appSignature;

  final customerID;
  final bool? isForgetPassword;
  final bool? isLoginScreen;

  OtpVerificationPage(
      {Key? key,
      this.phoneNumber,
      this.otpNumber,
      this.appSignature,
      this.customerID,
      this.isForgetPassword,
      this.isLoginScreen})
      : super(key: key);

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage>
    with TickerProviderStateMixin, CodeAutoFill {
  Size? size;
  var orientation;
  static const int kStartValue = 60;
  TextEditingController? textEditingController;
  StreamController<ErrorAnimationType>? errorAnimationController;
  AnimationController? controller;
  bool hasError = false;
  String currentText = "";

  @override
  void initState() {
    textEditingController = TextEditingController(text: "");
    errorAnimationController = StreamController<ErrorAnimationType>();
    errorAnimationController!.add(ErrorAnimationType.shake);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: kStartValue),
    );
    controller!.forward(from: 0.0);
    setState(() {});
    super.initState();
    listenOtp();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    orientation = MediaQuery.of(context).orientation;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          back_press_handle();
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Theme(
            data: Theme.of(context),
            child: SizedBox(
              width: size!.width,
              height: size!.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: InkWell(
                          customBorder: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          onTap: () async {
                            back_press_handle();
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 0, top: 5, right: 5, bottom: 5),
                            child: Icon(
                              Icons.chevron_left,
                              size: 35,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Center(
                                child: CircleAvatar(
                                  radius: 65,
                                  backgroundColor: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.light
                                      ? const Color(0xFFDEE0FF)
                                      : const Color(0xFF303F90),
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Icon(CustomIcon.open_message,
                                        size: 80,
                                        color: MediaQuery.of(context)
                                                    .platformBrightness ==
                                                Brightness.light
                                            ? null
                                            : Colors.grey.shade500),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Verification Code",
                                      textAlign: TextAlign.center,
                                      maxLines: 3,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: MediaQuery.of(context)
                                                          .platformBrightness ==
                                                      Brightness.light
                                                  ? Colors.black
                                                  : Colors.grey.shade300),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 28.0, top: 10, right: 28),
                              child: Text(
                                "Please enter verification code sent to your mobile number ${widget.phoneNumber??""}",
                                maxLines: 6,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            otp_pin_code_layout(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "Didn't receive code?",
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  CountDownTimer(
                                    animation: StepTween(
                                      begin: kStartValue,
                                      end: 0,
                                    ).animate(controller!),
                                    onPressed: () async {
                                      await callApiForSendOtp();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> listenOtp() async {
    try {
      await SmsAutoFill().unregisterListener();
      listenForCode();
      await SmsAutoFill().listenForCode();
      Stream<String> data = SmsAutoFill().code;
      data.listen((event) {
        Constants.debugLog(OtpVerificationPage, event);
      });
      Constants.debugLog(OtpVerificationPage, "Otp listen is called");
    } on Exception catch (e) {
      Constants.debugLog(OtpVerificationPage, "listenOtp:Error:$e");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    errorAnimationController?.close();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Future<void> codeUpdated() async {
    Constants.debugLog(OtpVerificationPage, "Otp code has updated");
    setState(() {
      textEditingController!.text = code!;
    });
    // setState(() {});
  }

  static String loadSmsSendParams(phoneNumber, messageBody) {
    Map<String, dynamic> map = {
      'PhoneTo': phoneNumber.toString(),
      'SmsMessage': messageBody.toString(),
    };
    return json.encode(map);
  }

  Future<void> callApiForSendOtp() async {
    controller!.forward(from: 0.0);
    setState(() {});
    widget.appSignature = await SmsAutoFill().getAppSignature;
    widget.otpNumber = Constants.randomNumberGenerator(1000, 9999).toString();
    String SmsMessage =
        "<#> Your code is ${widget.otpNumber}\t Code:${widget.appSignature}";
    Constants.debugLog(OtpVerificationPage, SmsMessage);
    String parms = loadSmsSendParams(widget.phoneNumber, SmsMessage);
    await listenOtp();
  }

  Future<void> back_press_handle() async {
   navigationRoutes.goBack();
  }

  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  otp_pin_code_layout() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: SizedBox(
            // height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // color: Colors.green,
            child: ListView(
              primary: false,
              shrinkWrap: true,
              children: <Widget>[
                const SizedBox(height: 5),
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 25.0, left: 25.0, top: 5.0, bottom: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: PinCodeTextField(
                            appContext: context,
                            controller: textEditingController,
                            blinkWhenObscuring: true,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            animationType: AnimationType.fade,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            errorAnimationController: errorAnimationController,
                            length: 4,
                            enableActiveFill: false,
                            obscureText: false,
                            obscuringCharacter: '*',
                            /*obscuringWidget: FlutterLogo(
                                      size: 24,
                                    ),*/

                            textStyle: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            pastedTextStyle: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                            cursorColor: Theme.of(context)
                                .textSelectionTheme
                                .cursorColor,

                            validator: (v) {
                              return null;

                              // if (v!.length < 3) {
                              //   return "Please Entered OTP Completely";
                              // } else {
                              //   return null;
                              // }
                            },

                            errorTextSpace: 24,
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(10),

                              // fieldHeight: 55,
                              // fieldWidth: 55,
                              borderWidth: 3,
                              selectedFillColor:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.white,
                              activeColor:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? const Color(0xFF006495)
                                      : const Color(0xFF8FCDFF),
                              selectedColor:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? const Color(0xFF778DB6)
                                      : const Color(0xFF1848DE),
                            ),

                            boxShadows: [
                              BoxShadow(
                                offset: const Offset(0, 1),
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.light
                                        ? Colors.black12
                                        : Colors.grey.shade800,
                                blurRadius: 10,
                              )
                            ],
                            // onCompleted: (value) {
                            //   if (widget.otpNumber == value) {
                            //     print(value);
                            //   } else {
                            //     textEditingController.clear();
                            //   }
                            // },
                            // onTap: () {
                            //   print("Pressed");
                            // },
                            onChanged: (value) {
                              setState(() {
                                currentText = value;
                              });
                            },

                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9.]")),
                              TextInputFormatter.withFunction(
                                  (oldValue, newValue) {
                                try {
                                  final text = newValue.text;
                                  if (text.isNotEmpty) double.parse(text);
                                  return newValue;
                                } catch (e) {
                                  return oldValue;
                                }
                              }),
                            ],
                            beforeTextPaste: (text) {
                              return true;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 25.0, left: 25.0, top: 0.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        onClickVerify();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 10, top: 10),
                        child: Text(
                          "Verify",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onClickVerify() async {
    if (textEditingController!.text == widget.otpNumber) {
      if (widget.isLoginScreen == false) {
        if (widget.isForgetPassword == false) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteName.homeScreenRoute,
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            RouteName.loginRoute,
            (Route<dynamic> route) => false,
          );
        }
      } else {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.homeScreenRoute,
          (Route<dynamic> route) => false,
        );
      }
    }
  }
}
