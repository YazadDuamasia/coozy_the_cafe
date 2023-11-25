import 'package:coozy_cafe/bloc/bloc.dart';
import 'package:coozy_cafe/bloc/category_form_bloc/category_form_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> blocProviders = [
  BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()..loadTheme()),
  BlocProvider<HomePageBottomNavCubit>(
      create: (context) => HomePageBottomNavCubit()),
  BlocProvider<CategoryFormBloc>(create: (context) => CategoryFormBloc()),
];
