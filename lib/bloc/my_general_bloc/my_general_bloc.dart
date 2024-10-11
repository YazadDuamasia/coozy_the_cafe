import 'dart:async';

import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/rxdart.dart';

part 'my_general_event.dart';

part 'my_general_state.dart';

class MyGeneralBloc extends Bloc<MyGeneralEvent, MyGeneralState> {
  MyGeneralBloc()
      : _connectionChecker = InternetConnection(),
        super(MyGeneralInitialState()) {
    on<FetchInitialGeneralEvent>(_handleInitialLoadingData);
    on<RefreshGeneralEvent>(_handleRefreshLoadingData);

    // Listen to the internet connection stream
    _connectionSubscription =
        _connectionChecker.onStatusChange.listen((status) {
      if (status == InternetStatus.disconnected) {
        emit(MyGeneralNoInternetState(error_str: ""));
      } else if (status == InternetStatus.connected) {
        add(FetchInitialGeneralEvent());
      } else {
        emit(MyGeneralNoInternetState(error_str: ""));
      }
    });
  }

  final InternetConnection _connectionChecker;
  StreamSubscription<InternetStatus>? _connectionSubscription;

  final BehaviorSubject<MyGeneralState> _stateSubject = BehaviorSubject();

  Stream<MyGeneralState> get stateStream => _stateSubject.stream;

  void emitState(MyGeneralState state) => _stateSubject.sink.add(state);

  @override
  Future<void> close() async {
    await _connectionSubscription?.cancel();
    await _stateSubject.close();
    return super.close();
  }

  FutureOr<void> _handleInitialLoadingData(
      FetchInitialGeneralEvent event, Emitter<MyGeneralState> emit) async {
    await _handleConnectionCheckUp();
    try {
      emit(MyGeneralLoadingState());

      Map<String, dynamic>? result;
      // result = await Repository.fetchReviewSchedule();
      if (result != null) {
        if (result["isError"]) {
          // Check the type of error and handle it accordingly
          switch (result["errorType"]) {
            case "TimeoutException":
              Constants.debugLog(
                  MyGeneralBloc, "Error: Timeout - ${result["response"]}");
              // Handle timeout-specific logic here
              emit(MyGeneralTimeOutErrorState(error_str: result["response"]));
              break;
            case "SocketException":
              Constants.debugLog(
                  MyGeneralBloc, "Error: No Internet - ${result["response"]}");
              Constants.debugLog(
                  MyGeneralBloc, "Error: No Internet - ${result["details"]}");
              // Handle no internet-specific logic here
              emit(MyGeneralNoInternetState(error_str: ""));
              break;
            case "FormatException":
              Constants.debugLog(MyGeneralBloc,
                  "Error: Bad Response Format - ${result["response"]}");
              Constants.debugLog(MyGeneralBloc,
                  "Error: Bad Response Format - ${result["details"]}");
              // Handle response format-specific logic here
              emit(MyGeneralErrorState(error_str: result["response"]));
              break;
            case "ClientException":
              Constants.debugLog(
                  MyGeneralBloc, "Error: Client Error - ${result["response"]}");
              Constants.debugLog(
                  MyGeneralBloc, "Error: Client Error - ${result["details"]}");
              // Handle client-specific logic here
              emit(MyGeneralErrorState(error_str: result["response"]));
              break;
            default:
              Constants.debugLog(MyGeneralBloc,
                  "Error: General Error - ${result["response"]}");
              Constants.debugLog(
                  MyGeneralBloc, "Error: General Error - ${result["details"]}");
              // Handle general error logic here
              emit(MyGeneralErrorState(error_str: result["response"]));
              break;
          }
        } else {
          emit(MyGeneralLoadedState());
        }
      } else {
        emit(MyGeneralErrorState(error_str: ""));
      }
    } catch (e) {
      emit(MyGeneralErrorState(error_str: e.toString()));
    }
  }

  FutureOr<void> _handleRefreshLoadingData(
      RefreshGeneralEvent event, Emitter<MyGeneralState> emit) async {
    await _handleConnectionCheckUp();
  }

  Future _handleConnectionCheckUp() async {
    bool? hasConnection = await _connectionChecker.hasInternetAccess;

    if (hasConnection == null || !hasConnection) {
      emit(MyGeneralNoInternetState(error_str: ""));
      return;
    }
  }
}
