import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:coozy_cafe/routing/routs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/bloc/bloc.dart';
import 'package:coozy_cafe/config/app_asset_paths/app_asset_paths.dart';
import 'package:coozy_cafe/pages/pages.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:coozy_cafe/widgets/country_pickers/country.dart';
import 'package:coozy_cafe/widgets/phone_number_text_form_widget/phone_number_text_form_field.dart';
import 'package:coozy_cafe/widgets/widgets.dart';

class LoginViaPhoneNumberPage extends StatefulWidget {
  final bool isUseForLogin;

  const LoginViaPhoneNumberPage({Key? key, required this.isUseForLogin})
      : super(key: key);

  @override
  State<LoginViaPhoneNumberPage> createState() =>
      _LoginViaPhoneNumberPageState();
}

class _LoginViaPhoneNumberPageState extends State<LoginViaPhoneNumberPage> {
  Size? size;
  var orientation;
  GlobalKey<FormState>? _formKey;
  TextEditingController? _phoneNumberController;
  FocusNode? _phoneNumberFocusNode;
  bool? isButtonclick;
  AnimationController? controller;
  Position? currentPosition;

  String? ipv4, ipv6;
  Position? position;
  ScrollController? _scrollController;
  LoginWithPhoneCubit? _loginWithPhoneCubit;

  List<String> images = [
    StringImagePath.sign_up_large_left_size_image1,
    StringImagePath.sign_up_large_left_size_image2,
    StringImagePath.sign_up_large_left_size_image3,
  ];
  late Image appLogoLight;

  /*TextEditingController? _otpController;
  FocusNode? _otpFocusNode;
  StreamController<ErrorAnimationType>? errorController;
  StreamController<ErrorAnimationType>? errorAnimationController;

  bool hasError = false;
  String currentText = "";*/



  @override
  void initState() {
    appLogoLight = Image.asset(
      AppAssetPaths.appLogo,
      fit: BoxFit.scaleDown,
      color: Colors.black,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<LoginWithPhoneCubit>();
      cubit.fetchInitialInfo();
      cubit.dispose(context);
    });
    _scrollController = ScrollController();
    _formKey = GlobalKey<FormState>();
    _phoneNumberController = TextEditingController(text: "");
    _phoneNumberFocusNode = FocusNode();
    /*_otpController = TextEditingController(text: "");
    _otpFocusNode = FocusNode();

    errorController = StreamController<ErrorAnimationType>();
    errorAnimationController = StreamController<ErrorAnimationType>();
    errorAnimationController!.add(ErrorAnimationType.shake);*/

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loginWithPhoneCubit = BlocProvider.of<LoginWithPhoneCubit>(
        context,
        listen: false,
      );
      _loginWithPhoneCubit?.fetchInitialInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    orientation = MediaQuery.of(context).orientation;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: Theme(
            data: Theme.of(context),
            child: ResponsiveLayout(
              mobile: mobileWidget(),
              tablet: tabletWidget(),
              desktop: tabletWidget(),
            ),
          ),
        ),
      ),
    );
  }

  Widget mobileWidget() {
    return BlocConsumer<LoginWithPhoneCubit, LoginWithPhoneState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoginWithPhoneLoadingState ||
            state is LoginWithPhoneInitial) {
          _loginWithPhoneCubit?.updateCountryIosCode(null);
          return const LoadingPage();
        } else if (state is LoginWithPhoneLoadedState) {
          return Theme(
            data: Theme.of(context),
            child: AnimateGradient(
              primaryBegin: Alignment.topLeft,
              primaryEnd: Alignment.bottomLeft,
              secondaryBegin: Alignment.bottomLeft,
              secondaryEnd: Alignment.topRight,
              duration: const Duration(seconds: 2),
              primaryColors: const [
                Color.fromRGBO(225, 109, 245, 1),
                Color.fromRGBO(78, 248, 231, 1),
                // Color.fromRGBO(134, 231, 214, 0.796078431372549),
                // Color.fromRGBO(83, 138, 214, 1)
              ],
              secondaryColors: const [
                Color.fromRGBO(5, 222, 250, 1),
                Color.fromRGBO(134, 231, 214, 0.8117647058823529),
              ],
              child: SizedBox(
                width: size!.width,
                height: size!.height,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 20,
                          top: 0,
                          right: 20,
                          child: CircleAvatar(
                            radius: 55.0,
                            backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 310 + 30,
                          right: 0,
                          child: CircleAvatar(
                            radius: 33.0,
                            backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                          ),
                        ),
                        Card(
                          margin: const EdgeInsets.only(top: 60.0, bottom: 45),
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            ),
                            side: BorderSide(
                              width: 5,
                              color:
                              Theme.of(context).colorScheme.secondaryContainer
                            ),
                          ),
                          child: Container(
                            width: size!.width,
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.only(top: 45, bottom: 10),
                            height: 310,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          "OTP Verification",
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall!,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 10, 0),
                                          child: Text(
                                            textAlign: TextAlign.start,
                                            "We will send you a One Time Password on your phone number.",
                                            softWrap: true,
                                            maxLines: 5,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  phone_number_widget(),
                                  /*     Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          child: PinCodeTextField(
                                            backgroundColor: Colors.transparent,
                                            appContext: context,
                                            pastedTextStyle: TextStyle(
                                              color: Colors.green.shade600,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            length: 6,
                                            blinkWhenObscuring: true,
                                            animationType: AnimationType.fade,
                                            validator: (v) {
                                              if (v!.length < 6) {
                                                return "Please Entered OTP Completely";
                                              } else {
                                                return null;
                                              }
                                            },
                                            errorTextSpace: 25,
                                            pinTheme: PinTheme(
                                              fieldOuterPadding: const EdgeInsets.all(5),
                                              shape: PinCodeFieldShape.underline,
                                              errorBorderColor: Colors.red,
                                              inactiveColor: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              selectedColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              activeColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            cursorColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            animationDuration:
                                                const Duration(milliseconds: 300),
                                            enableActiveFill: false,
                                            errorAnimationController:
                                                errorController,
                                            controller: _otpController,
                                            onChanged: (value) {
                                              currentText = value;
                                            },
                                            keyboardType: const TextInputType
                                                    .numberWithOptions(
                                                decimal: true, signed: false),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r"[0-9.]")),
                                              TextInputFormatter.withFunction(
                                                (oldValue, newValue) {
                                                  try {
                                                    final text = newValue.text;
                                                    if (text.isNotEmpty)
                                                      double.parse(text);
                                                    return newValue;
                                                  } catch (e) {
                                                    return oldValue;
                                                  }
                                                  return oldValue;
                                                },
                                              ),
                                            ],
                                            // textStyle: const TextStyle(color: Colors.black),
                                            beforeTextPaste: (text) {
                                              print("Allowing to paste $text");
                                              return true;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),*/
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 5.0,
                          left: 5.0,
                          right: 5.0,
                          child: Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              radius: 50.0,
                              child:  Icon(CustomIcon.password, size: 65,color: Theme.of(context).colorScheme.secondaryContainer),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 310 + 30,
                          left: 5.0,
                          right: 5.0,
                          child: Center(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              radius: 30.0,
                              child: StreamBuilder(
                                  stream:
                                      _loginWithPhoneCubit?.buttonLoadingStream,
                                  builder: (context, snapshot) {
                                    return ProgressButton(
                                      onPressed: (controller) async {
                                        this.controller = controller;
                                        submitData();
                                      },
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      strokeWidth: 4,
                                      color: Colors.grey.shade300,
                                      child:  Center(
                                        child: Icon(Icons.navigate_next_rounded,
                                            color:  Theme.of(context).colorScheme.secondaryContainer, size: 40),
                                      ),
                                    );
                                  }),
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
        } else if (state is LoginWithPhoneNoInternetState) {
          return NoInternetPage(
            onPressedRetryButton: () async {
              _loginWithPhoneCubit?.fetchInitialInfo();
            },
          );
        } else if (state is LoginWithPhoneErrorState) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Widget tabletWidget() {
    return BlocConsumer<LoginWithPhoneCubit, LoginWithPhoneState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoginWithPhoneLoadingState ||
            state is LoginWithPhoneInitial) {
          return const LoadingPage();
        } else if (state is LoginWithPhoneLoadedState) {
          return AnimateGradient(
            primaryBegin: Alignment.topLeft,
            primaryEnd: Alignment.bottomLeft,
            secondaryBegin: Alignment.bottomLeft,
            secondaryEnd: Alignment.topRight,
            duration: const Duration(seconds: 2),
            primaryColors: const [
              Color.fromRGBO(225, 109, 245, 1),
              Color.fromRGBO(78, 248, 231, 1),
              // Color.fromRGBO(99, 251, 215, 1),
              // Color.fromRGBO(83, 138, 214, 1)
            ],
            secondaryColors: const [
              Color.fromRGBO(5, 222, 250, 1),
              Color.fromRGBO(134, 231, 214, 1)
            ],
            child: SizedBox(
              key: UniqueKey(),
              width: size!.width,
              height: size!.height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      width: size!.width,
                      height: size!.height,
                      padding: const EdgeInsets.only(
                          left: 5.0, top: 10, bottom: 10, right: 5.0),
                      child: Stack(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  // enlargeCenterPage: true,
                                  aspectRatio: 16 / 9,
                                  pauseAutoPlayOnTouch: true,
                                  initialPage: 0,
                                  pauseAutoPlayInFiniteScroll: true,

                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  viewportFraction: 1.0,
                                  height: size!.height,
                                  onPageChanged: (index, reason) {
                                    // do something
                                  },
                                ),
                                items: images.map((image) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        child: Container(
                                          width: size!.width,
                                          height: size!.height,
                                          decoration: const BoxDecoration(
                                              color: Colors.white),
                                          child: Image.asset(
                                            image,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                  height: size!.height * .35,
                                  width: size!.width * .4,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200
                                          .withOpacity(0.5)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SizedBox(
                                        width: size!.width * .4,
                                        height: size!.height * .35,
                                        child: appLogoLight,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 0.0, top: 5, bottom: 5, right: 5.0),
                        child: Stack(
                          children: <Widget>[
                            Positioned(
                              left: 20,
                              top: 0,
                              right: 20,
                              child: CircleAvatar(
                                radius: 55.0,
                                backgroundColor:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? const Color(0xFF303F90)
                                        : const Color(0xFF00105A),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              top: 310 + 30,
                              right: 0,
                              child: CircleAvatar(
                                radius: 33.0,
                                backgroundColor:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? const Color(0xFF303F90)
                                        : const Color(0xFF00105A),
                              ),
                            ),
                            Card(
                              margin:
                                  const EdgeInsets.only(top: 60.0, bottom: 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                                side: BorderSide(
                                  width: 5,
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                      ? const Color(0xFF303F90)
                                      : const Color(0xFF00105A),
                                ),
                              ),
                              child: Container(
                                width: size!.width,
                                margin: const EdgeInsets.all(5),
                                padding:
                                    const EdgeInsets.only(top: 45, bottom: 10),
                                height: 310,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              "OTP Verification",
                                              softWrap: true,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall!,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 10, 10, 0),
                                              child: Text(
                                                textAlign: TextAlign.start,
                                                "We will send you a One Time Password on your phone number.",
                                                softWrap: true,
                                                maxLines: 5,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      phone_number_widget(),
                                      /*     Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          child: PinCodeTextField(
                                            backgroundColor: Colors.transparent,
                                            appContext: context,
                                            pastedTextStyle: TextStyle(
                                              color: Colors.green.shade600,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            length: 6,
                                            blinkWhenObscuring: true,
                                            animationType: AnimationType.fade,
                                            validator: (v) {
                                              if (v!.length < 6) {
                                                return "Please Entered OTP Completely";
                                              } else {
                                                return null;
                                              }
                                            },
                                            errorTextSpace: 25,
                                            pinTheme: PinTheme(
                                              fieldOuterPadding: const EdgeInsets.all(5),
                                              shape: PinCodeFieldShape.underline,
                                              errorBorderColor: Colors.red,
                                              inactiveColor: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                              selectedColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              activeColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            cursorColor: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            animationDuration:
                                                const Duration(milliseconds: 300),
                                            enableActiveFill: false,
                                            errorAnimationController:
                                                errorController,
                                            controller: _otpController,
                                            onChanged: (value) {
                                              currentText = value;
                                            },
                                            keyboardType: const TextInputType
                                                    .numberWithOptions(
                                                decimal: true, signed: false),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r"[0-9.]")),
                                              TextInputFormatter.withFunction(
                                                (oldValue, newValue) {
                                                  try {
                                                    final text = newValue.text;
                                                    if (text.isNotEmpty)
                                                      double.parse(text);
                                                    return newValue;
                                                  } catch (e) {
                                                    return oldValue;
                                                  }
                                                  return oldValue;
                                                },
                                              ),
                                            ],
                                            // textStyle: const TextStyle(color: Colors.black),
                                            beforeTextPaste: (text) {
                                              print("Allowing to paste $text");
                                              return true;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),*/
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 5.0,
                              left: 5.0,
                              right: 5.0,
                              child: Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 50.0,
                                  child:
                                      const Icon(CustomIcon.password, size: 65),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 310 + 30,
                              left: 5.0,
                              right: 5.0,
                              child: Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey.shade300,
                                  radius: 30.0,
                                  child: StreamBuilder(
                                      stream: _loginWithPhoneCubit
                                          ?.buttonLoadingStream,
                                      builder: (context, snapshot) {
                                        return ProgressButton(
                                          onPressed: (controller) async {
                                            this.controller = controller;
                                            submitData();
                                          },
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          strokeWidth: 4,
                                          color: Colors.grey.shade300,
                                          child: const Center(
                                            child: Icon(
                                                Icons.navigate_next_rounded,
                                                color: Colors.white,
                                                size: 35),
                                          ),
                                        );
                                      }),
                                ),
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
          );
        } else if (state is LoginWithPhoneNoInternetState) {
          return NoInternetPage(
            onPressedRetryButton: () async {
              _loginWithPhoneCubit?.fetchInitialInfo();
            },
          );
        } else if (state is LoginWithPhoneErrorState) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Widget phone_number_widget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 15),
            child: StreamBuilder(
              stream: _loginWithPhoneCubit?.phoneNumberIosCodeController,
              builder: (context, phoneIosCodeSnapshot) {
                return PhoneNumberTextFormField(
                  controller: _phoneNumberController,
                  focusNode: _phoneNumberFocusNode,
                  showDropdownIcon: true,
                  showCountryFlag: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(9),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).disabledColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.error),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    isDense: true,
                    labelText: "Phone Number",
                    hintText: "Enter your phone number",
                  ),
                  onCountryChanged: (Country country) =>
                      print('Country changed to: ' + country.name),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  invalidNumberMessage: AppLocalizations.of(context)?.translate(
                          StringValue
                              .common_common_phoneNumber_validator_error_msg) ??
                      "Please enter a valid phone number.",
                  onChanged: (number) {
                    Constants.debugLog(
                        LoginViaPhoneNumberPage, "number:$number");
                    _loginWithPhoneCubit!
                        .updatePhoneNumber(number.completeNumber, context);
                  },
                  initialCountryCode: phoneIosCodeSnapshot.data?.isoCode ?? "IN",
                  priorityList: [
                    CountryPickerUtils.getCountryByIsoCode('IN'),
                    CountryPickerUtils.getCountryByIsoCode('US'),
                  ],
                  onSubmitted: (String value) {
                    Future.microtask(() =>
                        FocusScope.of(context).requestFocus(new FocusNode()));
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    _phoneNumberController?.dispose();
    _phoneNumberFocusNode?.dispose();
    _scrollController?.dispose();
    // _otpController?.dispose();
    // _otpFocusNode?.dispose();
    super.dispose();
  }

  Future<void> verifySubmitPhoneNumber({String? phoneNumber}) async {
    Constants.debugLog(
        LoginViaPhoneNumberPage, "verifySubmit:phoneNumber:$phoneNumber");
    if (Constants.getIsMobileApp() == true) {
      var appSignatureId = await SmsAutoFill().getAppSignature;
      Constants.debugLog(
          LoginViaPhoneNumberPage, "appSignatureId:$appSignatureId");

      String otpCode = Constants.randomNumberGenerator(1000, 9999).toString();

      String SmsMessage = "<#> Your code is $otpCode\n$appSignatureId";

      Constants.debugLog(LoginViaPhoneNumberPage, "isMobileOS:$SmsMessage");

      await sendOtp(
        phoneNumber: phoneNumber,
        smsMessage: SmsMessage,
        appSignatureId: appSignatureId,
        otpCode: otpCode,
      );
    } else {
      String otpCode = Constants.randomNumberGenerator(1000, 9999).toString();
      String SmsMessage = "Your code is $otpCode.";
      Constants.debugLog(LoginViaPhoneNumberPage, SmsMessage);
      await sendOtp(
        phoneNumber: phoneNumber,
        smsMessage: SmsMessage,
        appSignatureId: null,
        otpCode: otpCode,
      );
    }
  }

  static String loadSmsSendParams(phoneNumber, messageBody) {
    Map<String, dynamic> map = {
      'PhoneTo': phoneNumber.toString(),
      'SmsMessage': messageBody.toString(),
    };
    return json.encode(map);
  }

  Future<void> sendOtp({
    String? phoneNumber,
    String? smsMessage,
    String? appSignatureId,
    String? otpCode,
  }) async {
    String parms = loadSmsSendParams(phoneNumber, smsMessage);

    String arg = OtpVerificationScreenArgument.addOtpVerfiy(
        phoneNumber: phoneNumber,
        isForgetPassword: false,
        otpNumber: otpCode,
        appSignature: appSignatureId ?? "",
        isLoginScreen: true);
    Constants.debugLog(LoginViaPhoneNumberPage, "arguments:$arg");

    var callback =
        await navigationRoutes.navigateToOtpVerificationPage(arguments: arg);

    if (callback == null || callback == true) {
      _phoneNumberController!.text = "";
      isButtonclick = false;
      controller!.reset();
    } else {
      _phoneNumberController!.text = "";
      isButtonclick = false;
      controller!.reset();
    }
  }

  Widget _buildDialogItem(Country country) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              country.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(width: 8.0),
          Text("+${country.phoneCode}"),
        ],
      );

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context),
          child: CountryPickerDialog(
            contentPadding: const EdgeInsets.all(8.0),
            titlePadding: const EdgeInsets.all(8.0),
            searchCursorColor: Theme.of(context).primaryColorLight,
            searchInputDecoration: InputDecoration(
              hintText: 'Search...',
              label: const Text("Search"),
              isDense: true,
              prefixIcon: const Icon(
                Icons.search,
                size: 24,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).disabledColor,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              errorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.error),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            isSearchable: true,
            searchEmptyView: Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      child: Lottie.asset(
                        "assets/lottie/country_location.json",
                        repeat: true,
                        alignment: Alignment.center,
                        fit: BoxFit.fitHeight,
                        height: size!.height * 0.30,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Expanded(
                        child: Text("Please enter proper world name..",
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            title: Row(
              children: [
                Flexible(
                    child: Text('Select your phone code',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyMedium)),
              ],
            ),
            onValuePicked: (country) async {
              Constants.debugLog(LoginViaPhoneNumberPage,
                  "_openCountryPickerDialog:onValuePicked:country:${country.phoneCode}");
              _loginWithPhoneCubit?.updateCountryIosCode(country);
            },
            itemBuilder: _buildDialogItem,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('IN'),
              CountryPickerUtils.getCountryByIsoCode('US'),
            ],
          ),
        ),
      );

  @override
  void didChangeDependencies() {
    precacheImage(appLogoLight.image, context);
    super.didChangeDependencies();
  }

  Future<void> submitData() async {
    String? _phNumberText = "";
    String? _countryCodeText = "";
    String? phoneNumber = "";
    _loginWithPhoneCubit!.updateButtonLoading(true);
    this.controller!.forward();
    await Future.delayed(
      const Duration(seconds: 1),
    );
    Constants.debugLog(LoginViaPhoneNumberPage, "ProgressButton:start");
    try {
      _countryCodeText =
          _loginWithPhoneCubit?.phoneNumberIosCodeController.value?.phoneCode ??
              "+91";
      _phNumberText = _phoneNumberController?.text.toString() ?? "";

      phoneNumber = "+$_countryCodeText $_phNumberText";
      Constants.debugLog(LoginViaPhoneNumberPage,
          "ProgressButton:countryCode:${_countryCodeText}");
      Constants.debugLog(
          LoginViaPhoneNumberPage, "ProgressButton:phNumber:${_phNumberText}");
      Constants.debugLog(LoginViaPhoneNumberPage,
          "ProgressButton:fullPhoneNumber:${phoneNumber}");
    } catch (e) {
      Constants.debugLog(LoginViaPhoneNumberPage,
          "ProgressButton:catch:Error::${e.toString()}");
    }

    if (_formKey!.currentState!.validate()) {
      //   print("valid");
      await verifySubmitPhoneNumber(phoneNumber: phoneNumber);
    } else {
      //   print("not valid");

      _loginWithPhoneCubit?.updateButtonLoading(false);
      this.controller!.reverse();
      Constants.debugLog(LoginViaPhoneNumberPage, "ProgressButton:Stop");
      Constants.showToastMsg(
          msg: AppLocalizations.of(context)?.translate(
                  StringValue.common_common_phoneNumber_validator_error_msg) ??
              "Please enter a valid phone number.");
    }
  }
}
