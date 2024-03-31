import 'package:coozy_cafe/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> blocProviders = [
  BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()..loadTheme()),
  BlocProvider<LoginScreenCubit>(create: (context) => LoginScreenCubit()),
  BlocProvider<LoginWithPhoneCubit>(create: (context) => LoginWithPhoneCubit()),
  BlocProvider<SignUpCubit>(create: (context) => SignUpCubit()),
  BlocProvider<HomePageBottomNavCubit>(
      create: (context) => HomePageBottomNavCubit()),
  BlocProvider<TableScreenBloc>(create: (context) => TableScreenBloc()),
  BlocProvider<MenuCategoryFullListCubit>(
      create: (context) => MenuCategoryFullListCubit()),
  BlocProvider<AddMenuCategoryCubit>(
      create: (context) => AddMenuCategoryCubit()),
  // BlocProvider<EditMenuCategoryCubit>(
  //   create: (context) => EditMenuCategoryCubit(),
  // ),
  BlocProvider<MenuSubCategoryBloc>(
    create: (context) => MenuSubCategoryBloc(),
  ),
  BlocProvider<EditMenuCategoryBloc>(
    create: (context) => EditMenuCategoryBloc(),
  ),  BlocProvider<RecipesFullListCubit>(
    create: (context) => RecipesFullListCubit(),
  ),
];
