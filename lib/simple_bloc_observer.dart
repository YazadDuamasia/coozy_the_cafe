import 'package:coozy_cafe/utlis/components/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimpleBlocObserver extends BlocObserver {


  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    Constants.debugLog(SimpleBlocObserver, "${bloc.runtimeType} $event");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    Constants.debugLog(SimpleBlocObserver, "${bloc.runtimeType} $error");
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    Constants.debugLog(SimpleBlocObserver, "${bloc.runtimeType} $transition");
  }

  @override
  void onClose(BlocBase bloc) {
    Constants.debugLog(SimpleBlocObserver, "onClose: ${bloc.runtimeType}");
    super.onClose(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    Constants.debugLog(SimpleBlocObserver, "onChange: ${bloc.runtimeType}");
    super.onChange(bloc, change);
  }

  @override
  void onCreate(BlocBase bloc) {
    Constants.debugLog(SimpleBlocObserver, "onCreate: ${bloc.runtimeType}");
    super.onCreate(bloc);

  }
}
