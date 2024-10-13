import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class ImageGridScreen extends StatefulWidget {
  @override
  _ImageGridScreenState createState() => _ImageGridScreenState();
}

class _ImageGridScreenState extends State<ImageGridScreen> {
  List<Map<String, dynamic>> _images = [];
  Map<String, CachedNetworkImageProvider> _imageProviderMap =
      {}; // Store CachedNetworkImageProviders
  Map<String, Size> _imageSizeMap = {}; // To store image sizes
  int _page = 1;
  int _limit = 100;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchImages();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchImages();
      }
    });
  }

  Future<void> _fetchImages() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('https://picsum.photos/v2/list?page=$_page&limit=$_limit'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      for (var imageData in data) {
        final imageUrl = imageData['download_url'];
        final imageProvider = CachedNetworkImageProvider(imageUrl);

        // Load the image and get its dimensions in one go
        _loadImageDimensions(imageProvider, imageUrl);

        setState(() {
          _images.add({
            'id': imageData['id'],
            'author': imageData['author'],
            'url': Uri.tryParse(imageData["url"]).toString() ?? "",
            'download_url':
                Uri.tryParse(imageData["download_url"]).toString() ?? "",
          });
          _imageProviderMap[imageUrl] = imageProvider;
        });
      }
      setState(() {
        _page++; // Increment page for next fetch
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Size> _calculateImageSize(String imageUrl) async {
    final imageProvider = CachedNetworkImageProvider(imageUrl);
    final Completer<ui.Image> completer = Completer<ui.Image>();

    imageProvider
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));

    final ui.Image image = await completer.future;
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  Future<void> _loadImageDimensions(
      CachedNetworkImageProvider imageProvider, String imageUrl) async {
    final Size imageSize = await compute(_calculateImageSize, imageUrl);

    // Store the image size once resolved
    setState(() {
      _imageSizeMap[imageUrl] = imageSize;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Grid with Cached Images'),
      ),
      body: _images.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : MasonryGridView.builder(
              controller: _scrollController,
              addSemanticIndexes: true,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.normal,
                parent: AlwaysScrollableScrollPhysics(),
              ),
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              addRepaintBoundaries: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              addAutomaticKeepAlives: true,
              itemCount: _images.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _images.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final image = _images[index];
                final String imageUrl = image['download_url'];
                final Size? imageSize = _imageSizeMap[imageUrl];

                // Calculate dynamic height based on image size
                final double placeholderHeight = imageSize != null
                    ? (imageSize.height / imageSize.width) *
                        MediaQuery.of(context).size.width /
                        3
                    : 150.0; // Default static height for error or if size not loaded

                return StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.fill,
                    // height: placeholderHeight,
                    fadeInDuration: const Duration(seconds: 2),
                    // 2-second fade-in animation
                    fadeOutDuration: const Duration(milliseconds: 500),
                    placeholder: (context, url) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: placeholderHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200.0, // Static height for error
                      color: Colors.red.shade300,
                      child: const Icon(Icons.error),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
