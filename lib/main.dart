import 'dart:ui';

import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/bloc/bloc.dart';
import 'package:coozy_cafe/bloc_providers.dart';
import 'package:coozy_cafe/config/config.dart';
import 'package:coozy_cafe/model/language_model/language_model.dart';
import 'package:coozy_cafe/routing/routs.dart';
import 'package:coozy_cafe/simple_bloc_observer.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  GestureBinding.instance.resamplingEnabled = true;

  // Load the theme from shared preferences
  final prefs = await SharedPreferences.getInstance();
  final index = prefs.getInt('theme') ?? 0;
  Bloc.observer = SimpleBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<LanguageModel> languages = LanguageModel.getLanguages();

    return MultiBlocProvider(
      providers: blocProviders,
      child: BlocConsumer<ThemeCubit, ThemeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return PageStorage(
            bucket: bucketGlobal,
            child: MaterialApp(
              title: Constants.appName,
              debugShowCheckedModeBanner: false,

                 theme: ThemeData(
                useMaterial3: true,
                colorScheme: AppColor.lightColorScheme,
                fontFamily: "Sono",
                appBarTheme: AppBarTheme(
                  centerTitle: false,
                  titleTextStyle:
                      Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
                  backgroundColor: AppColor.lightColorScheme.primary,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                    // Set the default color for the leading icon
                    size: 24.0, // Set the default size for the leading icon
                  ),
                  actionsIconTheme: const IconThemeData(
                    color: Colors.white,
                    // Set the default color for the leading icon
                    size: 24.0, // Set the default size for the leading icon
                  ),
                ),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                brightness: Brightness.light,
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Theme.of(context).colorScheme.primary,
                  selectionColor:
                      Theme.of(context).primaryColor.withOpacity(0.7),
                  selectionHandleColor: Theme.of(context).primaryColor,
                ),
              ),
            darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: AppColor.darkColorScheme,
                fontFamily: "Sono",
                appBarTheme: AppBarTheme(
                  centerTitle: false,
                  titleTextStyle:
                      Theme.of(context).textTheme.headlineSmall!.copyWith(
                            color: Colors.white,
                          ),
                  backgroundColor: AppColor.darkColorScheme.primary,
                  iconTheme: const IconThemeData(
                    color: Colors.white,
                    // Set the default color for the leading icon
                    size: 24.0, // Set the default size for the leading icon
                  ),
                  actionsIconTheme: const IconThemeData(
                    color: Colors.white,
                    // Set the default color for the leading icon
                    size: 24.0, // Set the default size for the leading icon
                  ),
                ),
                visualDensity: VisualDensity.adaptivePlatformDensity,
                textSelectionTheme: TextSelectionThemeData(
                  cursorColor: Theme.of(context).colorScheme.primary,
                  selectionColor:
                      Theme.of(context).primaryColor.withOpacity(0.7),
                  selectionHandleColor: Theme.of(context).primaryColor,
                ),
                brightness: Brightness.dark,
              ),
              // themeAnimationCurve: Curves.linear,
              // themeAnimationDuration: const Duration(seconds: 2),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme
                              .of(context)
                              .disabledColor,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .primary,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .primary),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .error),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .error),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: ScrollConfiguration(
                    behavior:
                    ScrollConfiguration.of(context).copyWith(dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch,
                      PointerDeviceKind.trackpad,
                      PointerDeviceKind.stylus
                    }),
                    child: child!,
                  ),
                );
              },
              themeMode: state.themeMode,
              restorationScopeId: 'app',
              navigatorKey: navigatorKey,
              onGenerateRoute: RouteGenerator.generateRoute,
              initialRoute: RouteName.splashRoute,
              useInheritedMediaQuery: true,
              localizationsDelegates: [
                AppLocalizationsDelegate(languages),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: languages
                  .map((language) => Locale(language.code!, ''))
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
