part of 'post_grid_page_cubit.dart';

sealed class PostGridPageState extends Equatable {
  const PostGridPageState();
}

final class PostGridPageInitial extends PostGridPageState {
  @override
  List<Object> get props => [];
}

class PostGridPageLoadingState extends PostGridPageState {
  @override
  List<Object> get props => [];
}

class PostGridPageLoadedState extends PostGridPageState {
  final List<Map<String, dynamic>>? data;

  const PostGridPageLoadedState({this.data});

  @override
  List<Object> get props => [data!];
}

class PostGridPageErrorState extends PostGridPageState {
  final String? errorMessage;

  const PostGridPageErrorState({this.errorMessage});

  @override
  List<Object> get props => [errorMessage!];
}

class PostGridPageNoInternetState extends PostGridPageState {
  @override
  List<Object> get props => [];
}
