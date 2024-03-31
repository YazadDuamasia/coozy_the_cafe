import 'dart:convert';
import 'dart:ui';


import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/bloc/bloc.dart';
import 'package:coozy_cafe/config/config.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:coozy_cafe/widgets/country_pickers/country.dart';
import 'package:coozy_cafe/widgets/phone_number_text_form_widget/phone_number_text_form_field.dart';
import 'package:coozy_cafe/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:geolocator/geolocator.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  List<String> images = [
    StringImagePath.sign_up_large_left_size_image1,
    StringImagePath.sign_up_large_left_size_image2,
    StringImagePath.sign_up_large_left_size_image3,
  ];

  Size? size;
  Orientation? orientation;
  Position? currentPosition;

  late Image appLogoLight;
  GlobalKey<FormState>? _formKey;
  bool checkedValue = false;

  TextEditingController? _firstNameTextEditingController;
  TextEditingController? _lastNameTextEditingController;
  TextEditingController? _userNameTextEditingController;
  TextEditingController? _emailTextEditingController;
  TextEditingController? _phoneNumberTextEditingController;
  TextEditingController? _genderController;
  TextEditingController? _passwordTextEditingController;
  TextEditingController? _confirmPasswordTextEditingController;
  TextEditingController? _birthDateController;

  FocusNode? _firstNameFocusNode;
  FocusNode? _lastNameFocusNode;
  FocusNode? _userNameFocusNode;
  FocusNode? _emailFocusNode;
  FocusNode? _phoneNumberFocusNode;
  FocusNode? _genderFocusNode;
  FocusNode? _passwordFocusNode;
  FocusNode? _confirmPasswordFocusNode;
  FocusNode? _birthDateFocusNode;

  int? groupValue;
  String? selectedGender;

  DateTime? date;

  // Country? _selectedDialogCountry;

  SignUpCubit? _signUpCubit;
  ScrollController? _scrollController;

  @override
  void initState() {
    appLogoLight = Image.asset(
      AppAssetPaths.appLogo,
      fit: BoxFit.scaleDown,
      color: Colors.black,
    );

    _formKey = GlobalKey<FormState>();
    _scrollController = ScrollController();
    _firstNameTextEditingController = TextEditingController(text: "");
    _lastNameTextEditingController = TextEditingController(text: "");
    _userNameTextEditingController = TextEditingController(text: "");
    _emailTextEditingController = TextEditingController(text: "");
    _passwordTextEditingController = TextEditingController(text: "");
    _confirmPasswordTextEditingController = TextEditingController(text: "");
    _phoneNumberTextEditingController = TextEditingController(text: "");
    _birthDateController = TextEditingController(text: "");

    _genderController = TextEditingController(text: " ");
    _firstNameFocusNode = FocusNode();
    _lastNameFocusNode = FocusNode();
    _userNameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _phoneNumberFocusNode = FocusNode();
    _genderFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    _birthDateFocusNode = FocusNode();

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<SignUpCubit>();
      cubit.fetchInitialInfo();
      cubit.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    orientation = MediaQuery.of(context).orientation;

    _signUpCubit = BlocProvider.of<SignUpCubit>(
      context,
      listen: false,
    );
    return WillPopScope(
      onWillPop: () async {
        navigationRoutes.goBack();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Theme(
            data: Theme.of(context),
            child: ResponsiveLayout(
              mobile: mobileLayout(),
              tablet: tabletLayout(),
              desktop: desktopLayout(),
            ),
          ),
        ),
      ),
    );
  }

  Widget mobileLayout() {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is SignUpLoadingState || state is SignUpInitial) {
          return Container();
        } else if (state is SignUpLoadedState) {
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
            child: Center(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 15),
                              child: Text(
                                'Hey there,',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 15),
                              child: Text(
                                'Create an Account',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildTextFormField(
                                  controller: _firstNameTextEditingController,
                                  focusNode: _firstNameFocusNode,
                                  autofillHints: [AutofillHints.name],
                                  onFieldSubmitted: (value) async {
                                    FocusScope.of(context)
                                        .requestFocus(_lastNameFocusNode);
                                  },
                                  labelText: "First Name",
                                  hintText: "First Name",
                                  stream: _signUpCubit?.firstNameController,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.text,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "First name is required.";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildTextFormField(
                                  controller: _lastNameTextEditingController,
                                  focusNode: _lastNameFocusNode,
                                  autofillHints: [AutofillHints.familyName],
                                  onFieldSubmitted: (value) async {
                                    FocusScope.of(context)
                                        .requestFocus(_emailFocusNode);
                                  },
                                  labelText: "Last Name",
                                  hintText: "Last Name",
                                  stream: _signUpCubit?.lastNameController,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Last name is required.";
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildTextFormField(
                                  controller: _emailTextEditingController,
                                  focusNode: _emailFocusNode,
                                  autofillHints: [AutofillHints.email],
                                  onFieldSubmitted: (value) async {
                                    FocusScope.of(context)
                                        .requestFocus(_passwordFocusNode);
                                  },
                                  labelText: "Email",
                                  hintText: "Email",
                                  stream: _signUpCubit?.emailController,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.emailAddress,
                                  validator: (value) {
                                    Pattern emailPattern =
                                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                    RegExp regexEmail =
                                        RegExp(emailPattern.toString());
                                    if (value!.isNotEmpty) {
                                      if (regexEmail.hasMatch(value)) {
                                        return null;
                                      } else {
                                        return AppLocalizations.of(context)
                                                ?.translate(StringValue
                                                    .login_email_validator_error_msg) ??
                                            "Please enter a valid email";
                                      }
                                    } else {
                                      return AppLocalizations.of(context)
                                              ?.translate(StringValue
                                                  .login_email_validator_empty_error_msg) ??
                                          "Email is required.";
                                    }
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                buildTextFormField(
                                  controller: _userNameTextEditingController,
                                  focusNode: _userNameFocusNode,
                                  autofillHints: [AutofillHints.username],
                                  labelText: "User Name",
                                  hintText: "User Name",
                                  stream: _signUpCubit?.userNameController,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.text,
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return "Please enter your username.";
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (value) async {
                                    FocusScope.of(context)
                                        .requestFocus(_passwordFocusNode);
                                  },
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: buildPasswordTextFormField(),
                                ),
                              ],
                            ),
                            phone_number_widget(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                StreamBuilder(
                                  stream: _signUpCubit?.dobController,
                                  builder: (context, snapshot) {
                                    return Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () => _selectDate(context),
                                            child: AbsorbPointer(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 15),
                                                child: TextFormField(
                                                  onChanged: (value) {
                                                    _signUpCubit
                                                        ?.updateDob(value);
                                                  },
                                                  readOnly: true,
                                                  controller:
                                                      _birthDateController,
                                                  focusNode:
                                                      _birthDateFocusNode,
                                                  decoration: InputDecoration(
                                                    labelText: "Date of birth",
                                                    hintText: "Date of birth",
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    disabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .error),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    focusedErrorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .error),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                  ),
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Date of birth is required.";
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                  onFieldSubmitted:
                                                      (String value) {
                                                    FocusScope.of(context)
                                                        .requestFocus();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 15, right: 10),
                                    child: gender(),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: buildConfirmPasswordTextFormField(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      sign_up_button(),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is SignUpNoInternetState) {
          return Container();
        } else if (state is SignUpErrorState) {
          return Container();
        } else {
          return Container();
        }
        return Container();
      },
    );
  }

  Widget tabletLayout() {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is SignUpLoadingState || state is SignUpInitial) {
          _signUpCubit?.updateCountryIosCode(null);
          return Container();
        } else if (state is SignUpLoadedState) {
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
                              child: AbsorbPointer(
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    // enlargeCenterPage: true,
                                    aspectRatio: 16 / 9,
                                    pauseAutoPlayOnTouch: true,
                                    initialPage: 0,
                                    pauseAutoPlayInFiniteScroll: false,
                                    autoPlayAnimationDuration: const Duration(seconds: 1),
                                    viewportFraction: 1.0,
                                    height: size!.height,
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
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const ClampingScrollPhysics(),
                          child: Card(
                            elevation: 2,
                            // margin: const EdgeInsets.only(
                            //     left: 10, right: 10, top: 10, bottom: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 15),
                                        child: Text(
                                          'Hey there,',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 15),
                                        child: Text(
                                          'Create an Account',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          buildTextFormField(
                                            controller:
                                                _firstNameTextEditingController,
                                            focusNode: _firstNameFocusNode,
                                            autofillHints: [AutofillHints.name],
                                            onFieldSubmitted: (value) async {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _lastNameFocusNode);
                                            },
                                            labelText: "First Name",
                                            hintText: "First Name",
                                            stream: _signUpCubit
                                                ?.firstNameController,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType: TextInputType.text,
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "First name is required.";
                                              } else {
                                                return null;
                                              }
                                            },
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
                                          buildTextFormField(
                                            controller:
                                                _lastNameTextEditingController,
                                            focusNode: _lastNameFocusNode,
                                            autofillHints: [
                                              AutofillHints.familyName
                                            ],
                                            onFieldSubmitted: (value) async {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _emailFocusNode);
                                            },
                                            labelText: "Last Name",
                                            hintText: "Last Name",
                                            stream: _signUpCubit
                                                ?.lastNameController,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Last name is required.";
                                              } else {
                                                return null;
                                              }
                                            },
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
                                          buildTextFormField(
                                            controller:
                                                _emailTextEditingController,
                                            focusNode: _emailFocusNode,
                                            autofillHints: [
                                              AutofillHints.email
                                            ],
                                            onFieldSubmitted: (value) async {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _passwordFocusNode);
                                            },
                                            labelText: "Email",
                                            hintText: "Email",
                                            stream:
                                                _signUpCubit?.emailController,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType:
                                                TextInputType.emailAddress,
                                            validator: (value) {
                                              Pattern emailPattern =
                                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                              RegExp regexEmail = RegExp(
                                                  emailPattern.toString());
                                              if (value!.isNotEmpty) {
                                                if (regexEmail
                                                    .hasMatch(value)) {
                                                  return null;
                                                } else {
                                                  return AppLocalizations.of(
                                                              context)
                                                          ?.translate(StringValue
                                                              .login_email_validator_error_msg) ??
                                                      "Please enter a valid email";
                                                }
                                              } else {
                                                return AppLocalizations.of(
                                                            context)
                                                        ?.translate(StringValue
                                                            .login_email_validator_empty_error_msg) ??
                                                    "Email is required.";
                                              }
                                            },
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
                                          buildTextFormField(
                                            controller:
                                                _userNameTextEditingController,
                                            focusNode: _userNameFocusNode,
                                            autofillHints: [
                                              AutofillHints.username
                                            ],
                                            labelText: "User Name",
                                            hintText: "User Name",
                                            stream: _signUpCubit
                                                ?.userNameController,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType: TextInputType.text,
                                            validator: (value) {
                                              if (value.toString().isEmpty) {
                                                return "Please enter your username.";
                                              }
                                              return null;
                                            },
                                            onFieldSubmitted: (value) async {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _passwordFocusNode);
                                            },
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
                                            child: buildPasswordTextFormField(),
                                          ),
                                        ],
                                      ),
                                      phone_number_widget(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          StreamBuilder(
                                            stream: _signUpCubit?.dobController,
                                            builder: (context, snapshot) {
                                              return Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () =>
                                                          _selectDate(context),
                                                      child: AbsorbPointer(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  right: 10,
                                                                  top: 15),
                                                          child: TextFormField(
                                                            onChanged: (value) {
                                                              _signUpCubit
                                                                  ?.updateDob(
                                                                      value);
                                                            },
                                                            readOnly: true,
                                                            controller:
                                                                _birthDateController,
                                                            focusNode:
                                                                _birthDateFocusNode,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Date of birth",
                                                              hintText:
                                                                  "Date of birth",
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              disabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .error),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .error),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                            ),
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Date of birth is required.";
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                            onFieldSubmitted:
                                                                (String value) {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 15, right: 10),
                                              child: gender(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child:
                                                buildConfirmPasswordTextFormField(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                sign_up_button(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is SignUpNoInternetState) {
          return Container();
        } else if (state is SignUpErrorState) {
          return Container();
        } else {
          return Container();
        }
        return Container();
      },
    );
  }

  Widget desktopLayout() {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is SignUpLoadingState || state is SignUpInitial) {
          _signUpCubit?.updateCountryIosCode(null);
          return Container();
        } else if (state is SignUpLoadedState) {
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
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const ClampingScrollPhysics(),
                          child: Card(
                            elevation: 2,
                            // margin: const EdgeInsets.only(
                            //     left: 10, right: 10, top: 10, bottom: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 15),
                                        child: Text(
                                          'Hey there,',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, top: 15),
                                        child: Text(
                                          'Create an Account',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          buildTextFormField(
                                            controller:
                                                _firstNameTextEditingController,
                                            focusNode: _firstNameFocusNode,
                                            autofillHints: [AutofillHints.name],
                                            onFieldSubmitted: (value) async {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _lastNameFocusNode);
                                            },
                                            labelText: "First Name",
                                            hintText: "First Name",
                                            stream: _signUpCubit
                                                ?.firstNameController,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType: TextInputType.text,
                                            onChanged: (value) {},
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "First name is required.";
                                              } else {
                                                return null;
                                              }
                                            },
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
                                          buildTextFormField(
                                            controller:
                                                _lastNameTextEditingController,
                                            focusNode: _lastNameFocusNode,
                                            autofillHints: [
                                              AutofillHints.familyName
                                            ],
                                            onFieldSubmitted: (value) async {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _emailFocusNode);
                                            },
                                            labelText: "Last Name",
                                            hintText: "Last Name",
                                            stream: _signUpCubit
                                                ?.lastNameController,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType: TextInputType.text,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Last name is required.";
                                              } else {
                                                return null;
                                              }
                                            },
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
                                          buildTextFormField(
                                            controller:
                                                _emailTextEditingController,
                                            focusNode: _emailFocusNode,
                                            autofillHints: [
                                              AutofillHints.email
                                            ],
                                            onFieldSubmitted: (value) async {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _passwordFocusNode);
                                            },
                                            labelText: "Email",
                                            hintText: "Email",
                                            stream:
                                                _signUpCubit?.emailController,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType:
                                                TextInputType.emailAddress,
                                            validator: (value) {
                                              Pattern emailPattern =
                                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                              RegExp regexEmail = RegExp(
                                                  emailPattern.toString());
                                              if (value!.isNotEmpty) {
                                                if (regexEmail
                                                    .hasMatch(value)) {
                                                  return null;
                                                } else {
                                                  return AppLocalizations.of(
                                                              context)
                                                          ?.translate(StringValue
                                                              .login_email_validator_error_msg) ??
                                                      "Please enter a valid email";
                                                }
                                              } else {
                                                return AppLocalizations.of(
                                                            context)
                                                        ?.translate(StringValue
                                                            .login_email_validator_empty_error_msg) ??
                                                    "Email is required.";
                                              }
                                            },
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
                                          buildTextFormField(
                                            controller:
                                                _userNameTextEditingController,
                                            focusNode: _userNameFocusNode,
                                            autofillHints: [
                                              AutofillHints.username
                                            ],
                                            labelText: "User Name",
                                            hintText: "User Name",
                                            stream: _signUpCubit
                                                ?.userNameController,
                                            textInputAction:
                                                TextInputAction.next,
                                            textInputType: TextInputType.text,
                                            validator: (value) {
                                              if (value.toString().isEmpty) {
                                                return "Please enter your username.";
                                              }
                                              return null;
                                            },
                                            onFieldSubmitted: (value) async {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      _passwordFocusNode);
                                            },
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
                                            child: buildPasswordTextFormField(),
                                          ),
                                        ],
                                      ),
                                      phone_number_widget(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          StreamBuilder(
                                            stream: _signUpCubit?.dobController,
                                            builder: (context, snapshot) {
                                              return Expanded(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () =>
                                                          _selectDate(context),
                                                      child: AbsorbPointer(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  right: 10,
                                                                  top: 15),
                                                          child: TextFormField(
                                                            onChanged: (value) {
                                                              _signUpCubit
                                                                  ?.updateDob(
                                                                      value);
                                                            },
                                                            readOnly: true,
                                                            controller:
                                                                _birthDateController,
                                                            focusNode:
                                                                _birthDateFocusNode,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Date of birth",
                                                              hintText:
                                                                  "Date of birth",
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              disabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .disabledColor,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .primary,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .primary),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              errorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .error),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              focusedErrorBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .error),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                            ),
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                            validator: (value) {
                                                              if (value!
                                                                  .isEmpty) {
                                                                return "Date of birth is required.";
                                                              } else {
                                                                return null;
                                                              }
                                                            },
                                                            onFieldSubmitted:
                                                                (String value) {
                                                              FocusScope.of(
                                                                      context)
                                                                  .requestFocus();
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 15, right: 10),
                                              child: gender(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child:
                                                buildConfirmPasswordTextFormField(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                sign_up_button(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is SignUpNoInternetState) {
          return Container();
        } else if (state is SignUpErrorState) {
          return Container();
        } else {
          return Container();
        }
        return Container();
      },
    );
  }

  Widget sign_up_button() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10, top: 15, bottom: 15),
            child: StreamBuilder(
                stream: _signUpCubit?.buttonLoadingStream,
                builder: (context, snapshot) {
                  return ElevatedButton(
                    onPressed: () async {
                      _signUpCubit?.updateButtonLoading(true);
                      if (_formKey!.currentState!.validate()) {
                        await callSignUpApi();
                      } else {
                        _signUpCubit?.updateButtonLoading(false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                      ),
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal),
                    ),
                    child: snapshot.data == false
                        ? const Text("Submit")
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Please Wait...")
                            ],
                          ),
                  );
                }),
          ),
        )
      ],
    );
  }

  Widget buildPasswordTextFormField() {
    return StreamBuilder(
      stream: _signUpCubit?.passwordObscureTextController,
      builder: (context, isPasswordVisibleSnapshot) {
        return StreamBuilder(
          stream: _signUpCubit?.passwordController,
          builder: (context, snapshot) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: TextFormField(
                          controller: _passwordTextEditingController,
                          focusNode: _passwordFocusNode,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) => FocusScope.of(context)
                              .requestFocus(_phoneNumberFocusNode),
                          validator: (value) {
                            if (snapshot.hasError) {
                              return snapshot.error.toString();
                            } else {
                              return null;
                            }
                          },
                          obscureText: isPasswordVisibleSnapshot.data ?? true,
                          autofillHints: const [AutofillHints.password],
                          onChanged: (value) {
                            _signUpCubit?.updatePassword(value);
                            _signUpCubit?.checkPassword(value);
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(20),
                            hintText: "Password",
                            labelText: "Password",
                            isDense: true,
                            suffixIcon: IconButton(
                              onPressed: () async {
                                Constants.debugLog(SignUpPage,
                                    "onPressed:${isPasswordVisibleSnapshot.data}");

                                _signUpCubit?.updatePasswordObscureText(
                                    isPasswordVisibleSnapshot.data!);
                                // _SignUpCubit?.
                              },
                              icon: Icon(
                                isPasswordVisibleSnapshot.data == true
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                              ),
                            ),
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
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Visibility(
                  visible: _passwordFocusNode!.hasFocus,
                  replacement: const SizedBox.shrink(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15.0, top: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StreamBuilder(
                                stream: _signUpCubit?.isPasswordSizeRequire,
                                builder: (context, snapshot) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: snapshot.data ?? false
                                            ? Colors.green
                                            : Colors.transparent,
                                        border: snapshot.data ?? false
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text("Contains at least 8 characters")
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StreamBuilder(
                                stream: _signUpCubit?.isPasswordOneLowerCase,
                                builder: (context, snapshot) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: snapshot.data ?? false
                                            ? Colors.green
                                            : Colors.transparent,
                                        border: snapshot.data ?? false
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                                "Contains at least 1 LowerCase character")
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StreamBuilder(
                                stream: _signUpCubit?.isPasswordOneUpperCase,
                                builder: (context, snapshot) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: snapshot.data ?? false
                                            ? Colors.green
                                            : Colors.transparent,
                                        border: snapshot.data ?? false
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                                "Contains at least 1 Uppercase character")
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StreamBuilder(
                                stream: _signUpCubit?.isPasswordOneNumCase,
                                builder: (context, snapshot) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: snapshot.data ?? false
                                            ? Colors.green
                                            : Colors.transparent,
                                        border: snapshot.data ?? false
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              width: 10,
                            ),
                            const Flexible(
                                child: Text("Contains at least 1 number"))
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StreamBuilder(
                                stream: _signUpCubit?.isPasswordOneSpecialChar,
                                builder: (context, snapshot) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        color: snapshot.data ?? false
                                            ? Colors.green
                                            : Colors.transparent,
                                        border: snapshot.data ?? false
                                            ? Border.all(
                                                color: Colors.transparent)
                                            : Border.all(
                                                color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                  );
                                }),
                            const SizedBox(
                              width: 10,
                            ),
                            const Flexible(
                                child: Text(
                                    "Contains at least 1 special character like !@#\$&*~+-"))
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildConfirmPasswordTextFormField() {
    return StreamBuilder(
      stream: _signUpCubit?.confirmPasswordObscureTextController,
      builder: (context, isConfirmPasswordVisibleSnapshot) {
        return StreamBuilder(
          stream: _signUpCubit?.confirmPasswordController,
          builder: (context, snapshot) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: TextFormField(
                controller: _confirmPasswordTextEditingController,
                focusNode: _confirmPasswordFocusNode,
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(FocusNode()),
                validator: (value) {
                  if (snapshot.hasError) {
                    return snapshot.error.toString();
                  } else {
                    return null;
                  }
                },
                obscureText: isConfirmPasswordVisibleSnapshot.data ?? true,
                autofillHints: const [AutofillHints.password],
                onChanged: (value) {
                  _signUpCubit?.updateConfirmPassword(value);
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  hintText: "Confirm Password",
                  labelText: "ConfirmPassword",
                  isDense: true,
                  suffixIcon: IconButton(
                    onPressed: () async {
                      Constants.debugLog(SignUpPage,
                          "onPressed:${isConfirmPasswordVisibleSnapshot.data}");

                      _signUpCubit?.updateConfirmPasswordObscureText(
                          isConfirmPasswordVisibleSnapshot.data!);
                    },
                    icon: Icon(
                      isConfirmPasswordVisibleSnapshot.data == true
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                    ),
                  ),
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
              ),
            );
          },
        );
      },
    );
  }

/*
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
                stream: _signUpCubit?.phoneNumberIosCodeController,
                builder: (context, phoneIosCodeSnapshot) {
                  // return IntlPhoneField(
                  //   controller: _phoneNumberTextEditingController,
                  //   focusNode: _phoneNumberFocusNode,
                  //   keyboardType: TextInputType.number,
                  //   initialCountryCode:
                  //       phoneIosCodeSnapshot.data?.isoCode ?? "IN",
                  //   showDropdownIcon: true,
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   onChanged: (phone) {
                  //     _signUpCubit!
                  //         .updatePhoneNumberPassword(phone.completeNumber);
                  //     print(phone.completeNumber);
                  //   },
                  //   pickerDialogStyle: PickerDialogStyle(
                  //     searchFieldInputDecoration: InputDecoration(
                  //       hintText: 'Search...',
                  //       label: const Text("Search"),
                  //       isDense: true,
                  //       prefixIcon: const Icon(
                  //         Icons.search,
                  //         size: 24,
                  //       ),
                  //       border: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Theme.of(context).colorScheme.primary,
                  //           width: 2,
                  //         ),
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //       disabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Theme.of(context).disabledColor,
                  //         ),
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Theme.of(context).colorScheme.primary,
                  //         ),
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //           color: Theme.of(context).colorScheme.primary,
                  //           width: 2,
                  //         ),
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //       errorBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //             color: Theme.of(context).colorScheme.error),
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //       focusedErrorBorder: OutlineInputBorder(
                  //         borderSide: BorderSide(
                  //             color: Theme.of(context).colorScheme.error),
                  //         borderRadius: BorderRadius.circular(5),
                  //       ),
                  //     ),
                  //     searchFieldCursorColor:
                  //         Theme.of(context).primaryColorLight,
                  //     searchFieldPadding: const EdgeInsets.all(5),
                  //   ),
                  //   onCountryChanged: (country) {
                  //     print('Country changed to: ' + country.name);
                  //   },
                  //   textInputAction: TextInputAction.next,
                  //   decoration: InputDecoration(
                  //     contentPadding: const EdgeInsets.all(9),
                  //     border: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Theme.of(context).colorScheme.primary,
                  //       ),
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //     disabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Theme.of(context).disabledColor,
                  //       ),
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Theme.of(context).colorScheme.primary,
                  //       ),
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //           color: Theme.of(context).colorScheme.primary),
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //     errorBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //           color: Theme.of(context).colorScheme.error),
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //     focusedErrorBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //           color: Theme.of(context).colorScheme.error),
                  //       borderRadius: BorderRadius.circular(5),
                  //     ),
                  //     isDense: true,
                  //     labelText: "Phone Number",
                  //     hintText: "XXX-XXX-XXXX",
                  //   ),
                  //   onSubmitted: (String value) {
                  //     FocusScope.of(context).requestFocus(_birthDateFocusNode);
                  //   },
                  // );
                  return TextFormField(
                    focusNode: _phoneNumberFocusNode,
                    controller: _phoneNumberTextEditingController,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,+]')),
                    ],
                    keyboardType: TextInputType.number,
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
                      hintText: "XXX-XXX-XXXX",
                      prefix: TextButton(
                        onPressed: () async {
                          _openCountryPickerDialog();
                        },
                        child: Text(
                          "+${phoneIosCodeSnapshot.data?.phoneCode ?? ""}",
                        ),
                      ),
                    ),
                    autofillHints: const [AutofillHints.telephoneNumberLocal],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      _signUpCubit!.updatePhoneNumber(value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Phone number is required.";
                      } else if (value.length < 10 || value.length > 11) {
                        return "Phone number is invalid.";
                      } else {
                        return null;
                      }
                    },
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(_birthDateFocusNode);
                    },
                  );
                }),
          ),
        ),
      ],
    );
  }
*/

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
              stream: _signUpCubit?.phoneNumberIosCodeController,
              builder: (context, phoneIosCodeSnapshot) {
                return PhoneNumberTextFormField(
                  controller: _phoneNumberTextEditingController,
                  focusNode: _phoneNumberFocusNode,
                  showDropdownIcon: true,
                  showCountryFlag: false,
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
                  onCountryChanged: (Country country) =>Constants.debugLog(SignUpPage, "Country changed to:  + ${country.name}"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  invalidNumberMessage:AppLocalizations.of(
                      context)
                      ?.translate(
                      StringValue
                          .common_common_phoneNumber_validator_error_msg) ??
                      "Please enter a valid phone number.",
                  onChanged: (number) {
                    _signUpCubit!.updatePhoneNumber(number.completeNumber);
                  },
                  initialCountryCode:
                      phoneIosCodeSnapshot.data?.isoCode ?? "IN",
                  priorityList: [
                    CountryPickerUtils.getCountryByIsoCode('IN'),
                    CountryPickerUtils.getCountryByIsoCode('US'),
                  ],
                  onSubmitted: (String value) {
                    FocusScope.of(context).requestFocus(_birthDateFocusNode);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextFormField(
      {TextEditingController? controller,
      FocusNode? focusNode,
      String? hintText,
      String? labelText,
      Widget? prefixIcon,
      Iterable<String>? autofillHints,
      TextInputType? textInputType,
      TextInputAction? textInputAction,
      ValueChanged<String>? onFieldSubmitted,
      Stream? stream,
      validator,
      ValueChanged<String>? onChanged}) {
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: textInputType,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: onChanged,
                textInputAction: textInputAction,
                onFieldSubmitted: onFieldSubmitted,
                validator: validator,
                autofillHints: autofillHints,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(20),
                  hintText: hintText,
                  labelText: labelText,
                  isDense: true,
                  prefixIcon: prefixIcon,
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
              ),
            ),
          );
        });
  }

  Widget gender() {
    return StreamBuilder(
        stream: _signUpCubit?.genderController,
        builder: (context, snapshot) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 5,
                ),
                child: TextFormField(
                  focusNode: _genderFocusNode,
                  controller: _genderController,
                  cursorColor: Colors.transparent,
                  readOnly: true,
                  onChanged: (value) {
                    _signUpCubit?.updateGender(selectedGender!);
                  },
                  validator: (value) {
                    if (snapshot.hasError == true) {
                      return snapshot.error.toString();
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "Gender",
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const SizedBox(
                              width: 5,
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                applyElevationOverlayColor: false,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                radioTheme: RadioThemeData(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return null;
                                    }
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Theme.of(context)
                                          .colorScheme
                                          .primary;
                                    }
                                    return null;
                                  }),
                                ),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  selectedGender = "Male";
                                  _genderController!.text = " ";
                                  _signUpCubit?.updateGender(selectedGender!);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Radio<String>(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "Male",
                                        groupValue: selectedGender,
                                        onChanged: (value) {
                                          selectedGender = value;
                                          _genderController!.text = " ";
                                          _signUpCubit
                                              ?.updateGender(selectedGender!);
                                        },
                                      ),
                                    ),
                                    const Text(
                                      "Male",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                radioTheme: RadioThemeData(
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.disabled)) {
                                      return null;
                                    }
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return Theme.of(context)
                                          .colorScheme
                                          .primary;
                                    }
                                    return null;
                                  }),
                                ),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  selectedGender = "Female";
                                  _genderController!.text = " ";
                                  _signUpCubit?.updateGender(selectedGender!);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Radio<String>(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: "Female",
                                        groupValue: selectedGender,
                                        onChanged: (value) {
                                          selectedGender = value;
                                          _genderController!.text = " ";
                                          _signUpCubit
                                              ?.updateGender(selectedGender!);
                                        },
                                      ),
                                    ),
                                    const Text(
                                      "Female",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
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
              Constants.debugLog(SignUpPage,
                  "_openCountryPickerDialog:onValuePicked:country:${country.name}");
              _signUpCubit?.updateCountryIosCode(country);
            },
            itemBuilder: _buildDialogItem,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('IN'),
              CountryPickerUtils.getCountryByIsoCode('US'),
            ],
          ),
        ),
      );

  _selectDate(BuildContext context) async {
    DateTime? datePick;

    if (Constants.isIOS() || Constants.isMacOS()) {
      datePick = await showModalBottomSheet<DateTime?>(
        context: context,
        builder: (context) {
          DateTime? tempPickedDate;
          return SizedBox(
            height: 250,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    minimumDate: DateTime(DateTime.now().year - 80),
                    initialDateTime: date ?? DateTime.now(),
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime? dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      datePick = await showDatePicker(
        context: context,
        initialDate: date ?? DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 80),
        lastDate: DateTime.now(),
        helpText: "Date of birth",
      );
    }

    if (datePick != null && datePick != date) {
      if (DateTime.now().year - datePick.year < 18) {
        Constants.customTimerPopUpDialogMessage(
            classObject: SignUpPage,
            isLoading: true,
            titleIcon: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(
                Icons.person,
                size: 50,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            context: context,
            descriptions: "You must be 18+ years old to register.",
            textColorDescriptions: Colors.white);
      } else {
        date = datePick;
        String? pick = DateUtil.dateToString(datePick, "dd-MM-yyyy");
        Constants.debugLog(SignUpPage, "DOB:Date:$pick");
        _birthDateController!.text = pick!;
      }
    }
  }

  Future<void> callSignUpApi() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );

    String? _firstNameText = _firstNameTextEditingController!.text.toString();
    String? _lastNameText = _lastNameTextEditingController!.text.toString();
    String? _emailText = _emailTextEditingController!.text.toString();
    String? _userNameText = _userNameTextEditingController!.text.toString();
    String? _passwordText = _passwordTextEditingController!.text.toString();
    String? _countryCodeText = _signUpCubit?.phoneNumberIosCodeController.value?.phoneCode ?? "+91";
    String? _phNumberText = _phoneNumberTextEditingController!.text.toString();
    String? _birthDateText = _birthDateController!.text.toString();
    String? genderText = selectedGender.toString();
    String? phoneNumber = "+$_countryCodeText $_phNumberText";
    Map<String, dynamic> body = {
      "first_name": _firstNameText,
      "last_name": _lastNameText,
      "email_address": _emailText,
      "user_name": _userNameText,
      "_countryCodeText": _countryCodeText,
      "_phNumberText": _phNumberText,
      "birth_date": _birthDateText,
      "gender": genderText,
      "phoneNumber": phoneNumber,
      "password": _passwordText,
    };
    Constants.debugLog(SignUpPage, "body:${json.encode(body)}");
    _signUpCubit?.updateButtonLoading(false);
  }

  @override
  void dispose() {
    _firstNameTextEditingController?.dispose();
    _lastNameTextEditingController?.dispose();
    _userNameTextEditingController?.dispose();
    _emailTextEditingController?.dispose();
    _phoneNumberTextEditingController?.dispose();
    _genderController?.dispose();
    _passwordTextEditingController?.dispose();
    _confirmPasswordTextEditingController?.dispose();
    _birthDateController?.dispose();

    _firstNameFocusNode?.dispose();
    _lastNameFocusNode?.dispose();
    _userNameFocusNode?.dispose();
    _emailFocusNode?.dispose();
    _phoneNumberFocusNode?.dispose();
    _genderFocusNode?.dispose();
    _passwordFocusNode?.dispose();
    _confirmPasswordFocusNode?.dispose();
    _birthDateFocusNode?.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    precacheImage(appLogoLight.image, context);
    super.didChangeDependencies();
  }
}
