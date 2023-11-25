import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedGlassWidget extends StatelessWidget {
  final Widget child;
  final double sigmaX;
  final double sigmaY;
  final double opacity;

  const FrostedGlassWidget({
    Key? key,
    required this.child,
    this.sigmaX = 10.0,
    this.sigmaY = 10.0,
    this.opacity = 0.1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ClipRect(
      child:new BackdropFilter(
        filter: new ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: child,
      ),
    );
  }
}
