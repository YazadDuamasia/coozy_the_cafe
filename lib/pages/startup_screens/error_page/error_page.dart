import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorPage extends StatefulWidget {
  final GestureTapCallback? onPressedRetryButton;

  const ErrorPage({super.key, required this.onPressedRetryButton});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  void initState() {
    super.initState();
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
                  StringImagePath.error_loader_lottie,
                  width: MediaQuery.of(context).size.width * .65,
                  height: MediaQuery.of(context).size.height * .55,
                  fit: BoxFit.scaleDown,
                ),
              ),
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
    super.dispose();
  }
}
