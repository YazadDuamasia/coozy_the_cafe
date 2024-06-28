import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternetPage extends StatefulWidget {
  final GestureTapCallback? onPressedRetryButton;

  const NoInternetPage({super.key, required this.onPressedRetryButton});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  final ValueNotifier<bool> _isVisible = ValueNotifier(true);
  final double _animationThreshold = 0.65;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(_handleAnimationProgressChanged);
  }

  void _handleAnimationProgressChanged() {
    if (_controller.value >= _animationThreshold) {
      _isVisible.value = false;
    } else {
      _isVisible.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Lottie.asset(
                  StringImagePath.lost_connection_lottie,
                  controller: _controller,
                  onLoaded: (composition) {
                    // Configure the AnimationController with the duration of the
                    // Lottie file and start the animation.
                    _controller
                      ..duration = composition.duration
                      ..forward()
                      ..repeat();
                  },
                  width: MediaQuery.of(context).size.width * .65,
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isVisible,
                builder: (context, isVisible, child) {
                  return Visibility(
                    visible: isVisible,
                    child: const Text("No Internet Connection"),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.onPressedRetryButton,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _isVisible.dispose();
    super.dispose();
  }
}
