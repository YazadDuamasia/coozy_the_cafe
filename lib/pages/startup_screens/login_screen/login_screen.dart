import 'dart:math';
import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/bloc/bloc.dart';
import 'package:coozy_the_cafe/pages/pages.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:coozy_the_cafe/widgets/widgets.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  final bool? isFirstTime;

  const LoginScreen({Key? key, required this.isFirstTime}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController? emailTextEditingController,
      passwordTextEditingController;
  FocusNode? emailFocusNode, passwordFocusNode;

  bool? isButtonLoading = false;

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: ["email"],
  // );

  // late GoogleSignInAccount? _currentUser;

  List<Color> listParticleColor = <Color>[];
  late Image image1;

  Size? size;
  Orientation? orientation;

  // bool? isSignInLoading = false;
  LoginScreenCubit? _loginScreenCubit;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loginScreenCubit?.fetchInitialInfo();
      _loginScreenCubit?.dispose();
      // NotificationApi.init(initSchedluled: true);
      // NotificationApi.requestNotificationPermission();
    });
    emailTextEditingController = TextEditingController(text: "yazad@gmail.com");
    passwordTextEditingController =
        TextEditingController(text: "Yazad147852+-*");
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    for (int i = 0; i < 25; i++) {
      listParticleColor.add(
        Color(new Random().nextInt(0xffffffff)).withAlpha(0xff),
      );
    }
    // _googleSignIn.onCurrentUserChanged
    //     .listen((GoogleSignInAccount? account) async {
    //   _currentUser = account;
    //   navigationRoutes.navigateToHomePage();
    // });

    super.initState();

    image1 = Image.asset(
      StringImagePath.login_large_left_size_image,
      fit: BoxFit.fill,
    );
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    orientation = MediaQuery.of(context).orientation;
    _loginScreenCubit = BlocProvider.of<LoginScreenCubit>(
      context,
      listen: false,
    );

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          navigationRoutes.goBackToExitApp();
          return true;
        },
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: true,
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
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

  mobileLayout() {
    return BlocConsumer<LoginScreenCubit, LoginScreenState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is LoginScreenNoInternetState) {
          return NoInternetPage(
            onPressedRetryButton: () async {
              _loginScreenCubit?.fetchInitialInfo();
            },
          );
        }
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
            child: Stack(
              children: [
                CircularParticle(
                  // key: UniqueKey(),
                  awayRadius: 100,
                  numberOfParticles: 250,
                  connectDots: false,
                  enableHover: false,
                  hoverColor: Theme.of(context).indicatorColor,
                  hoverRadius: 50,
                  speedOfParticles: 1.3,
                  width: size!.width,
                  height: size!.height,
                  onTapAnimation: true,
                  particleColor: Colors.white.withAlpha(150),
                  awayAnimationDuration: const Duration(milliseconds: 600),
                  maxParticleSize: 8,
                  isRandSize: true,
                  isRandomColor: true,
                  randColorList: listParticleColor,
                  awayAnimationCurve: Curves.easeInOutBack,
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Theme(
                          data: Theme.of(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Center(
                                  child: SizedBox(
                                    width: size!.width * .85,
                                    child: Card(
                                      elevation: 2,
                                      child: Theme(
                                        data: Theme.of(context),
                                        child: Column(
                                          children: [
                                            AutofillGroup(
                                              child: Form(
                                                key: _formKey,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    5,
                                                                    10,
                                                                    0),
                                                            child: Text(
                                                              widget.isFirstTime ==
                                                                      true
                                                                  ? AppLocalizations.of(
                                                                              context)
                                                                          ?.translate(StringValue
                                                                              .login_welcome) ??
                                                                      "Welcome"
                                                                  : AppLocalizations.of(
                                                                              context)
                                                                          ?.translate(
                                                                              StringValue.login_welcome_back) ??
                                                                      "Welcome Back",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headlineMedium!
                                                                  .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    10,
                                                                    10,
                                                                    0),
                                                            child:
                                                                TextFormEmailField(
                                                                    context),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                                    10,
                                                                    10,
                                                                    10,
                                                                    10),
                                                            child:
                                                                TextFormPasswordField(
                                                                    context),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    sign_in(),
                                                    const SizedBox(
                                                      height: 25,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                                  context)
                                                              ?.translate(
                                                                  StringValue
                                                                      .login_did_account) ??
                                                          "Don't have an account ?",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge!,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Center(
                                                    child: TextButton(
                                                      onPressed: () async {
                                                        navigationRoutes
                                                            .navigateToSignUpPage();
                                                      },
                                                      style: ButtonStyle(
                                                        padding:
                                                            WidgetStateProperty
                                                                .all<
                                                                    EdgeInsets>(
                                                          const EdgeInsets.only(
                                                              left: 30,
                                                              right: 30,
                                                              bottom: 5,
                                                              top: 5),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                    context)
                                                                ?.translate(
                                                                    StringValue
                                                                        .login_sign_up_btn) ??
                                                            "Sign Up",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Divider(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black,
                                                    height: 1,
                                                    endIndent: 25,
                                                    indent: 25,
                                                    thickness: 1,
                                                  ),
                                                ),
                                                HoverUpDownWidget(
                                                  animationDuration:
                                                      const Duration(
                                                          milliseconds: 1500),
                                                  childWidget: Text(
                                                    AppLocalizations.of(context)
                                                            ?.translate(
                                                                StringValue
                                                                    .login_or) ??
                                                        "Or",
                                                    textAlign: TextAlign.center,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .dark
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Divider(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  height: 1,
                                                  endIndent: 25,
                                                  indent: 25,
                                                  thickness: 1,
                                                )),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            social_media_login_row(),
                                            const SizedBox(
                                              height: 15,
                                            ),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  tabletLayout() {
    return BlocConsumer<LoginScreenCubit, LoginScreenState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is LoginScreenNoInternetState) {
          return NoInternetPage(
            onPressedRetryButton: () async {
              _loginScreenCubit?.fetchInitialInfo();
            },
          );
        }
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
            child: Stack(
              children: [
                CircularParticle(
                  // key: UniqueKey(),
                  awayRadius: 100,
                  numberOfParticles: 250,
                  connectDots: false,
                  enableHover: false,
                  hoverColor: Theme.of(context).indicatorColor,
                  hoverRadius: 50,
                  speedOfParticles: 1.3,
                  width: size!.width,
                  height: size!.height,
                  onTapAnimation: true,
                  particleColor: Colors.white.withAlpha(150),
                  awayAnimationDuration: const Duration(milliseconds: 600),
                  maxParticleSize: 8,
                  isRandSize: true,
                  isRandomColor: true,
                  randColorList: listParticleColor,
                  awayAnimationCurve: Curves.easeInOutBack,
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: size!.width,
                    height: size!.height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 10, bottom: 10, right: 20),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: image1),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0.0, top: 5, bottom: 5, right: 5.0),
                              child: ListView(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  Theme(
                                    data: Theme.of(context),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: SizedBox(
                                              width: size!.width * .85,
                                              child: Card(
                                                elevation: 2,
                                                child: Theme(
                                                  data: Theme.of(context),
                                                  child: Column(
                                                    children: [
                                                      AutofillGroup(
                                                        child: Form(
                                                          key: _formKey,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          10,
                                                                          5,
                                                                          10,
                                                                          0),
                                                                      child:
                                                                          Text(
                                                                        widget.isFirstTime == true
                                                                            ? AppLocalizations.of(context)?.translate(StringValue.login_welcome) ??
                                                                                "Welcome"
                                                                            : AppLocalizations.of(context)?.translate(StringValue.login_welcome_back) ??
                                                                                "Welcome Back",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineMedium!
                                                                            .copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          10,
                                                                          0),
                                                                      child: TextFormEmailField(
                                                                          context),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          10,
                                                                          10),
                                                                      child: TextFormPasswordField(
                                                                          context),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              sign_in(),
                                                              const SizedBox(
                                                                height: 25,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 5,
                                                                      right: 5),
                                                              child: Text(
                                                                AppLocalizations.of(
                                                                            context)
                                                                        ?.translate(
                                                                            StringValue.login_did_account) ??
                                                                    "Don't have an account ?",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Center(
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  navigationRoutes
                                                                      .navigateToSignUpPage();
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  padding:
                                                                      MaterialStateProperty
                                                                          .all<
                                                                              EdgeInsets>(
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            30,
                                                                        right:
                                                                            30,
                                                                        bottom:
                                                                            5,
                                                                        top: 5),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  AppLocalizations.of(
                                                                              context)
                                                                          ?.translate(
                                                                              StringValue.login_sign_up_btn) ??
                                                                      "Sign Up",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Divider(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .dark
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              height: 1,
                                                              endIndent: 25,
                                                              indent: 25,
                                                              thickness: 1,
                                                            ),
                                                          ),
                                                          HoverUpDownWidget(
                                                            animationDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        1500),
                                                            childWidget: Text(
                                                              AppLocalizations.of(
                                                                          context)
                                                                      ?.translate(
                                                                          StringValue
                                                                              .login_or) ??
                                                                  "Or",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    color: Theme.of(context).brightness ==
                                                                            Brightness
                                                                                .dark
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child: Divider(
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            height: 1,
                                                            endIndent: 25,
                                                            indent: 25,
                                                            thickness: 1,
                                                          )),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      social_media_login_row(),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
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
                                ],
                              ),
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
        );
      },
    );
  }

  desktopLayout() {
    return BlocConsumer<LoginScreenCubit, LoginScreenState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is LoginScreenNoInternetState) {
          return NoInternetPage(
            onPressedRetryButton: () async {
              _loginScreenCubit?.fetchInitialInfo();
            },
          );
        }
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
            child: Stack(
              children: [
                CircularParticle(
                  // key: UniqueKey(),
                  awayRadius: 100,
                  numberOfParticles: 250,
                  connectDots: false,
                  enableHover: false,
                  hoverColor: Theme.of(context).indicatorColor,
                  hoverRadius: 50,
                  speedOfParticles: 1.3,
                  width: size!.width,
                  height: size!.height,
                  onTapAnimation: true,
                  particleColor: Colors.white.withAlpha(150),
                  awayAnimationDuration: const Duration(milliseconds: 600),
                  maxParticleSize: 8,
                  isRandSize: true,
                  isRandomColor: true,
                  randColorList: listParticleColor,
                  awayAnimationCurve: Curves.easeInOutBack,
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    width: size!.width,
                    height: size!.height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 10, bottom: 10, right: 20),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: image1),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0.0, top: 5, bottom: 5, right: 5.0),
                              child: ListView(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  Theme(
                                    data: Theme.of(context),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Center(
                                            child: SizedBox(
                                              width: size!.width * .85,
                                              child: Card(
                                                elevation: 2,
                                                child: Theme(
                                                  data: Theme.of(context),
                                                  child: Column(
                                                    children: [
                                                      AutofillGroup(
                                                        child: Form(
                                                          key: _formKey,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          10,
                                                                          5,
                                                                          10,
                                                                          0),
                                                                      child:
                                                                          Text(
                                                                        widget.isFirstTime == true
                                                                            ? AppLocalizations.of(context)?.translate(StringValue.login_welcome) ??
                                                                                "Welcome"
                                                                            : AppLocalizations.of(context)?.translate(StringValue.login_welcome_back) ??
                                                                                "Welcome Back",
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headlineMedium!
                                                                            .copyWith(
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          10,
                                                                          0),
                                                                      child: TextFormEmailField(
                                                                          context),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          10,
                                                                          10),
                                                                      child: TextFormPasswordField(
                                                                          context),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              sign_in(),
                                                              const SizedBox(
                                                                height: 25,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 5,
                                                                      right: 5),
                                                              child: Text(
                                                                AppLocalizations.of(
                                                                            context)
                                                                        ?.translate(
                                                                            StringValue.login_did_account) ??
                                                                    "Don't have an account ?",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge!,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Center(
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  navigationRoutes
                                                                      .navigateToSignUpPage();
                                                                },
                                                                style:
                                                                    ButtonStyle(
                                                                  padding:
                                                                      MaterialStateProperty
                                                                          .all<
                                                                              EdgeInsets>(
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            30,
                                                                        right:
                                                                            30,
                                                                        bottom:
                                                                            5,
                                                                        top: 5),
                                                                  ),
                                                                ),
                                                                child: Text(
                                                                  AppLocalizations.of(
                                                                              context)
                                                                          ?.translate(
                                                                              StringValue.login_sign_up_btn) ??
                                                                      "Sign Up",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Divider(
                                                              color: Theme.of(context)
                                                                          .brightness ==
                                                                      Brightness
                                                                          .dark
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              height: 1,
                                                              endIndent: 25,
                                                              indent: 25,
                                                              thickness: 1,
                                                            ),
                                                          ),
                                                          HoverUpDownWidget(
                                                            animationDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        1500),
                                                            childWidget: Text(
                                                              AppLocalizations.of(
                                                                          context)
                                                                      ?.translate(
                                                                          StringValue
                                                                              .login_or) ??
                                                                  "Or",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                    color: Theme.of(context).brightness ==
                                                                            Brightness
                                                                                .dark
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                              child: Divider(
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .dark
                                                                ? Colors.white
                                                                : Colors.black,
                                                            height: 1,
                                                            endIndent: 25,
                                                            indent: 25,
                                                            thickness: 1,
                                                          )),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      social_media_login_row(),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
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
                                ],
                              ),
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
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    precacheImage(image1.image, context);
  }

  Widget TextFormEmailField(context) {
    return StreamBuilder(
        stream: _loginScreenCubit?.userNameStream,
        builder: (context, snapshot) {
          return TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailTextEditingController!,
            focusNode: emailFocusNode,
            textInputAction: TextInputAction.next,
            autofillHints: const [AutofillHints.email],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.mail_outline_outlined,
                size: 24,
              ),
              label: Text(AppLocalizations.of(context)
                      ?.translate(StringValue.login_email_label) ??
                  "Email"),
              hintText: AppLocalizations.of(context)
                      ?.translate(StringValue.login_email_hint) ??
                  "Enter your Email address.",
              isDense: true,
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(5),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
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
            onChanged: (text) {
              _loginScreenCubit?.updateUserName(text);
            },
            validator: (value) {
              Pattern emailPattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regexEmail = RegExp(emailPattern.toString());
              if (value!.isNotEmpty) {
                if (regexEmail.hasMatch(value)) {
                  return null;
                } else {
                  return AppLocalizations.of(context)?.translate(
                          StringValue.login_email_validator_error_msg) ??
                      "Please enter a valid email";
                }
              } else {
                return AppLocalizations.of(context)?.translate(
                        StringValue.login_email_validator_empty_error_msg) ??
                    "Email is required.";
              }
            },
            onFieldSubmitted: (value) async {
              Future.microtask(
                  () => FocusScope.of(context).requestFocus(passwordFocusNode));
            },
          );
        });
  }

  Widget TextFormPasswordField(context) {
    return StreamBuilder(
        stream: _loginScreenCubit?.passwordStream,
        builder: (context, snapshot) {
          return TextFormField(
            controller: passwordTextEditingController!,
            focusNode: passwordFocusNode,
            textInputAction: Constants.getIsMobileApp()
                ? TextInputAction.done
                : TextInputAction.next,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            autofillHints: const [AutofillHints.password],
            decoration: InputDecoration(
              prefixIcon: const Icon(FontAwesomeIcons.userLock),
              label: Text(
                // "Password",
                AppLocalizations.of(context)
                        ?.translate(StringValue.login_password_label) ??
                    "Password",
              ),
              hintText: AppLocalizations.of(context)
                      ?.translate(StringValue.login_password_hint) ??
                  "Enter your password.",
              isDense: true,
              border: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(5),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(5),
              ),
              disabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
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
            onChanged: (text) {
              _loginScreenCubit?.updatePassword(text);
            },
            validator: (value) {
              // r'^
              //   (?=.*[A-Z])          // should contain at least one upper case
              //   (?=.*[a-z])          // should contain at least one lower case
              //   (?=.*?[0-9])         // should contain at least one digit
              //   (?=.*?[!@#\$&*~+-])    // should contain at least one Special character
              //     .{8,}             // Must be at least 8 characters in length
              // $
              RegExp regex = RegExp(
                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~+-]).{8,}$');
              if (value!.isEmpty) {
                // return "Please enter password";
                return AppLocalizations.of(context)?.translate(
                        StringValue.login_password_validator_error_empty_msg) ??
                    "Please enter password";
              } else if (!regex.hasMatch(value)) {
                // return 'Enter valid password';
                return AppLocalizations.of(context)?.translate(
                        StringValue.login_password_validator_error_msg) ??
                    "Enter your password.";
              } else {
                return null;
              }
            },
            onFieldSubmitted: (value) {
              Future.microtask(
                () => FocusScope.of(context).requestFocus(
                  FocusNode(),
                ),
              );
            },
          );
        });
  }

  Widget sign_in() {
    return StreamBuilder(
        stream: _loginScreenCubit?.buttonLoadingStream,
        builder: (context, snapshot) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () async {
                      _loginScreenCubit?.updateButtonLoading(true);
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await callLoginApi();
                      } else {
                        _loginScreenCubit?.updateButtonLoading(false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal),
                    ),
                    child: (snapshot.data == null || snapshot.data == false)
                        ? Text(
                            // "Login",
                            AppLocalizations.of(context)?.translate(
                                    StringValue.login_inactive_btn) ??
                                "Login",
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                // "Please Wait...",
                                AppLocalizations.of(context)?.translate(
                                        StringValue
                                            .login_loading_inactive_btn) ??
                                    "Please Wait...",
                              ),
                            ],
                          ),
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget social_media_login_row() {
    return SizedBox(
      width: size!.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message:
                // "Login Via Facebook",
                AppLocalizations.of(context)
                        ?.translate(StringValue.login_via_facebook_tooltip) ??
                    "Login Via Facebook",
            waitDuration: const Duration(seconds: 1),
            showDuration: const Duration(seconds: 2),
            padding: const EdgeInsets.all(10),
            preferBelow: true,
            child: HoverUpDownWidget(
              animationDuration: const Duration(milliseconds: 1500),
              childWidget: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  padding: const EdgeInsets.only(left: 8),
                  backgroundColor: Theme.of(context).primaryColorLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                icon: Center(
                  child: Icon(FontAwesomeIcons.facebookF,
                      size: 24, color: Theme.of(context).colorScheme.primary),
                ),
                label: const Text(""),
              ),
            ),
          ),
          Tooltip(
            message:
                // "Login Via Google",
                AppLocalizations.of(context)
                        ?.translate(StringValue.login_via_google_tooltip) ??
                    "Login Via Google",
            waitDuration: const Duration(seconds: 1),
            showDuration: const Duration(seconds: 2),
            padding: const EdgeInsets.all(10),
            preferBelow: true,
            child: HoverUpDownWidget(
              animationDuration: const Duration(milliseconds: 1800),
              childWidget: ElevatedButton.icon(
                onPressed: _handleGoogleSignIn,
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  padding: const EdgeInsets.only(left: 8),
                  backgroundColor: Theme.of(context).primaryColorLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                icon: const Center(
                  child: Icon(FontAwesomeIcons.google, size: 24),
                ),
                label: const Text(""),
              ),
            ),
          ),
          Tooltip(
            message:
                // "Login Via Phone Number",
                AppLocalizations.of(context)?.translate(
                        StringValue.login_via_phone_number_tooltip) ??
                    "Login Via Phone Number",
            waitDuration: const Duration(seconds: 1),
            showDuration: const Duration(seconds: 2),
            padding: const EdgeInsets.all(10),
            preferBelow: true,
            child: HoverUpDownWidget(
              animationDuration: const Duration(milliseconds: 2000),
              childWidget: ElevatedButton.icon(
                onPressed: () async {
                  navigationRoutes.navigateToSignInViaPhoneNumberPage(
                      isForLogin: true);
                  // Navigator.pushNamed(context, RouteName.otpScreenRoute);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  padding: const EdgeInsets.only(left: 8),
                  backgroundColor: Theme.of(context).primaryColorLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                icon: const Center(
                  child: Icon(CustomIcon.smartphone, size: 26),
                ),
                label: const Text(""),
              ),
            ),
          ),
        ],
      ),
    );
  }

  clearTextData() {
    emailTextEditingController!.clear();
    passwordTextEditingController!.clear();
  }

  Future<void> _handleGoogleSignIn() async {
    try {
    /*  GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );*/

      // Use the `credential` to sign in to your app.
      // For example, you can use FirebaseAuth to sign in the user:
      // final User user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    } catch (error) {
      ScaffoldMessenger.of(context)
        ..removeCurrentMaterialBanner()
        ..showMaterialBanner(
          _showMaterialBanner(
            context,
            AppLocalizations.of(context)
                    ?.translate(StringValue.login_google_login_error) ??
                "Unable to SignIn with google",
          ),
        );
      Constants.debugLog(
          LoginScreen, "_handleGoogleSignIn:error: ${error.toString()}");
    }
  }

  callLoginApi() {
    _loginScreenCubit?.updateButtonLoading(false);
    NotificationApi.showNotification(
        id: 0, title: "Login Successfully.", body: "", payload: "");
    navigationRoutes.navigateToHomePage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    emailTextEditingController?.dispose();
    passwordTextEditingController?.dispose();
    emailFocusNode?.dispose();
    passwordFocusNode?.dispose();

    super.dispose();
  }

  _showMaterialBanner(BuildContext context, String? msg) {
    return MaterialBanner(
      leading: const Icon(Icons.error),
      content: Text(msg ?? ""),
      actions: [
        TextButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner(
                reason: MaterialBannerClosedReason.hide);
          },
          child: Text(
            // 'Ok',
            AppLocalizations.of(context)?.translate(StringValue.common_ok) ??
                "Ok",
          ),
        ),
      ],
    );
  }
}
