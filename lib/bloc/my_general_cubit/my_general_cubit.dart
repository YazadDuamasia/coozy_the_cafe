import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

part 'my_general_state.dart';

class MyGeneralCubit extends Cubit<MyGeneralState> {
  MyGeneralCubit() : super(InitialState());

  final BehaviorSubject<MyGeneralState> _stateSubject = BehaviorSubject();

  Stream<MyGeneralState> get stateStream => _stateSubject.stream;

  Future<void> loadData() async {
    try {
      // Simulate loading data
      emit(LoadingState());

      // Replace this with your actual data loading logic
      List? data = await fetchDataFromApi();

      emit(LoadedState(data!));

      //   emit(NoInternetState());
    } catch (e) {
      emit(ErrorState('An error occurred: $e'));
    }
  }

  Future<List?> fetchDataFromApi() async {
    // Replace this with your actual data fetching logic
    // For example, make an HTTP request here
    // If there is no internet, return null
    return null;
  }

  @override
  Future<void> close() {
    _stateSubject.close();
    return super.close();
  }
}
