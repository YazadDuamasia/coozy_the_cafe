import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coozy_the_cafe/parser/parser.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:rxdart/rxdart.dart';

part 'post_grid_page_state.dart';

class PostGridPageCubit extends Cubit<PostGridPageState> {
  int _page = 1;
  final int _limit = 10;
  bool _isLoading = false; // Flag to prevent multiple requests

  PostGridPageCubit() : super(PostGridPageInitial());
  final BehaviorSubject<PostGridPageState> _stateSubject = BehaviorSubject();

  Stream<PostGridPageState> get stateStream => _stateSubject.stream;
  List<Map<String, dynamic>> data = []; // Initialize to an empty list

  // Initial fetch
  Future<void> fetchInitialData() async {
    _page = 1; // Reset page to 1
    emit(PostGridPageLoadingState());
    await _fetchData();
  }

  // Pull to refresh
  Future<void> refreshData() async {
    _page = 1; // Reset page to 1
    data.clear(); // Clear existing data
    emit(PostGridPageLoadingState());
    await _fetchData();
  }

  // Load more
  Future<void> loadMore() async {
    if (_isLoading || state is PostGridPageLoadingState || state is PostGridPageErrorState) {
      return; // Prevent multiple requests
    }
    _isLoading = true; // Set loading to true
    _page++; // Increment page number
    print("Loading page: $_page");
    await _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      Uri url = Uri.parse('https://picsum.photos/v2/list?page=$_page&limit=$_limit');
      Map<String, dynamic>? result = await HttpCallGenerator.makeHttpRequest(
        url: url.toString(),
        method: HTTPMethod.GET,
      );

      if (result != null) {
        if (result["isError"] == true) {
          _handleError(result["errorType"], result["response"]);
        } else {
          List jsonData = json.decode(result["response"]);
          if (jsonData.isEmpty) {
            emit(PostGridPageErrorState(errorMessage: 'No data found'));
          } else {
            await _processImageData(jsonData);
            emit(PostGridPageLoadedState(data: List.from(data))); // Emit loaded state with updated data
          }
        }
      } else {
        emit(PostGridPageErrorState(errorMessage: 'No result from server'));
      }
    } catch (e) {
      emit(PostGridPageErrorState(errorMessage: 'An error occurred: $e'));
    } finally {
      _isLoading = false; // Reset loading flag
    }
  }

  Future<void> _processImageData(List jsonData) async {
    List<Future<void>> imageProcessingFutures = [];

    for (var imageData in jsonData) {
      String? downloadUrl = Uri.tryParse(imageData["download_url"])?.toString();
      if (downloadUrl == null) continue; // Skip if the URL is invalid

      final Completer<void> completer = Completer<void>();
      final imageProvider = NetworkImageWithRetry(downloadUrl);

      imageProvider.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
              (ImageInfo info, bool _) {
            double imageWidth = info.image.width.toDouble();
            double imageHeight = info.image.height.toDouble();
            print('Image width: $imageWidth, Image height: $imageHeight');

            data.add({
              'id': imageData['id'] ?? null,
              'author': imageData['author'] ?? null,
              'url': Uri.tryParse(imageData["url"]).toString() ?? null,
              'download_url': downloadUrl,
              'image_width': imageWidth,
              'image_height': imageHeight,
            });

            completer.complete();
          },
          onError: (dynamic error, StackTrace? stackTrace) {
            Constants.debugLog(PostGridPageCubit, "Error loading image: $error");
            completer.completeError('Failed to load image dimensions.');
          },
        ),
      );

      imageProcessingFutures.add(completer.future);
    }

    await Future.wait(imageProcessingFutures); // Wait for all images to be processed
  }

  void _handleError(String errorType, String response) {
    switch (errorType) {
      case "TimeoutException":
        emit(PostGridPageErrorState(errorMessage: response));
        break;
      case "SocketException":
        emit(PostGridPageNoInternetState());
        break;
      case "FormatException":
        emit(PostGridPageErrorState(errorMessage: response));
        break;
      case "ClientException":
        emit(PostGridPageErrorState(errorMessage: response));
        break;
      default:
        emit(PostGridPageErrorState(errorMessage: response));
        break;
    }
  }

  @override
  Future<void> close() {
    _stateSubject.close();
    return super.close();
  }
}