import 'package:coozy_the_cafe/bloc/bloc.dart';
import 'package:coozy_the_cafe/database/database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> blocProviders = [
  BlocProvider<ThemeCubit>(create: (context) => ThemeCubit()..loadTheme()),
  BlocProvider<LoginScreenCubit>(create: (context) => LoginScreenCubit()),
  BlocProvider<LoginWithPhoneCubit>(create: (context) => LoginWithPhoneCubit()),
  BlocProvider<SignUpCubit>(create: (context) => SignUpCubit()),
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
  ),
  BlocProvider<RecipesFullListCubit>(
    create: (context) => RecipesFullListCubit(),
  ),
  BlocProvider<EmployeeCubit>(
    create: (context) => EmployeeCubit(DatabaseHelper())..fetchEmployees(),
  ),
  BlocProvider<AttendanceCubit>(
      create: (context) =>
          AttendanceCubit(DatabaseHelper())..fetchAttendance()),
  BlocProvider<LeaveCubit>(
      create: (context) => LeaveCubit(DatabaseHelper())..fetchLeaves()),
  BlocProvider<WaiterListScreenBloc>(
    create: (context) =>
        WaiterListScreenBloc()..add(InitialLoadWaiterListScreenEvent()),
  ),

];
