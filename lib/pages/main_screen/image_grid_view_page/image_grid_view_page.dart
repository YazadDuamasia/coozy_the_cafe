import 'package:coozy_the_cafe/bloc/bloc.dart';
import 'package:coozy_the_cafe/pages/pages.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageGridScreen extends StatefulWidget {
  @override
  _ImageGridScreenState createState() => _ImageGridScreenState();
}

class _ImageGridScreenState extends State<ImageGridScreen> {
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<PostGridPageCubit>(context).fetchInitialData();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          BlocProvider.of<PostGridPageCubit>(context).loadMore();
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Dynamic Grid with Cached Images'),
        ),
        body: BlocConsumer<PostGridPageCubit, PostGridPageState>(
          listener: (context, state) {
            setState(() {});
          },
          builder: (context, state) {
            if (state is PostGridPageInitial ||
                state is PostGridPageLoadingState) {
              return LoadingPage();
            } else if (state is PostGridPageLoadedState) {
              List<Map<String, dynamic>>? data = state.data;
              if (data == null || data.isEmpty) {
                return empty_view(context);
              } else {
                return list_view(data);
              }
            } else if (state is PostGridPageErrorState) {
              return ErrorPage(
                onPressedRetryButton: () {
                  BlocProvider.of<PostGridPageCubit>(context)
                      .fetchInitialData();
                },
              );
            } else if (state is PostGridPageNoInternetState) {
              return NoInternetPage(
                onPressedRetryButton: () {
                  BlocProvider.of<PostGridPageCubit>(context)
                      .fetchInitialData();
                },
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Column empty_view(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text(
                "No Data found",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget list_view(List<Map<String, dynamic>>? data) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: StaggeredGrid.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(
                      data!.length,
                      (index) {
                        final image = data[index];
                        final String imageUrl = image['download_url'];
                        var imageWidth = image['image_width'] ?? 0;
                        var imageHeight = image['image_height'] ?? 0;
                        double? placeholderHeight;
                        try {
                          placeholderHeight = (imageHeight / imageWidth) *
                              MediaQuery.of(context).size.width /
                              3;
                        } catch (e) {
                          placeholderHeight = 250;

                          print(e);
                        }
                        return StaggeredGridTile.fit(
                          crossAxisCellCount: 1,
                          child: cachedNetworkImage(
                              imageUrl, context, placeholderHeight),
                        );
                      },
                    ).toList(growable: true),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.all(5.0),
    //   child: MasonryGridView.count(
    //     crossAxisCount: 3,
    //     controller: _scrollController,
    //     shrinkWrap: true,
    //     crossAxisSpacing: 10,
    //     physics: BouncingScrollPhysics(),
    //     addSemanticIndexes: true,
    //     addRepaintBoundaries: true,
    //     addAutomaticKeepAlives: false,
    //     mainAxisSpacing: 10,
    //     itemCount: data?.length ?? 0,
    //     keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    //     itemBuilder: (context, index) {
    //       final image = data![index];
    //       final String imageUrl = image['download_url'];
    //       var imageWidth = image['image_width'] ?? 0;
    //       var imageHeight = image['image_height'] ?? 0;
    //       double? placeholderHeight;
    //       try {
    //         placeholderHeight = (imageHeight / imageWidth) *
    //             MediaQuery.of(context).size.width /
    //             3;
    //       } catch (e) {
    //         placeholderHeight = 250;
    //         print(e);
    //       }
    //       return StaggeredGridTile.fit(
    //         crossAxisCellCount: 1,
    //         child: cachedNetworkImage(imageUrl, context, placeholderHeight),
    //       );
    //     },
    //   ),
    // );
  }

  /*
     final image = data![index];
          final String imageUrl = image['download_url'];
          var imageWidth = image['image_width'] ?? 0;
          var imageHeight = image['image_height'] ?? 0;
          double? placeholderHeight;
          try {
            placeholderHeight = (imageHeight / imageWidth) *
                MediaQuery.of(context).size.width /
                3;
          } catch (e) {
            placeholderHeight = 250;

            print(e);
          }
          return cachedNetworkImage(imageUrl, context, placeholderHeight);*/
  Widget cachedNetworkImage(
      String imageUrl, BuildContext context, double? placeholderHeight) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: FadeInImage.assetNetwork(
          placeholder: StringImagePath.image_placeholder,
          image: imageUrl,
          height: placeholderHeight,
          placeholderFit: BoxFit.fill,
          fit: BoxFit.fill,
        ),
      ),
    );
    // return CachedNetworkImage(
    //   imageUrl: imageUrl,
    //   width: MediaQuery.of(context).size.width,
    //   fit: BoxFit.fill,
    //   imageBuilder: (context, imageProvider) {
    //     return Container(
    //       width: MediaQuery.of(context).size.width,
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //       child: Image(
    //         image: imageProvider,
    //         fit: BoxFit.fill,
    //         filterQuality: FilterQuality.high,
    //       ),
    //     );
    //   },
    //   placeholder: (context, url) => Container(
    //     width: MediaQuery.of(context).size.width,
    //     height: placeholderHeight,
    //     decoration: BoxDecoration(
    //       color: Colors.amberAccent,
    //       borderRadius: BorderRadius.circular(10),
    //     ),
    //     child: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   ),
    //   errorWidget: (context, url, error) => Container(
    //     width: MediaQuery.of(context).size.width,
    //     height: 200.0,
    //     color: Colors.red.shade300,
    //     child: const Icon(
    //       Icons.error,
    //       size: 50,
    //       color: Colors.white,
    //     ),
    //   ),
    // );
  }
}
