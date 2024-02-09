import 'dart:ui';

import 'package:flutter/material.dart';

class BlurWidget extends StatefulWidget {
  final Widget? child;
  final double? sigmaX;
  final double? sigmaY;

  const BlurWidget({
    super.key,
    this.child,
    this.sigmaX = 10,
    this.sigmaY = 10,
  });

  @override
  _BlurWidgetState createState() => _BlurWidgetState();
}

class _BlurWidgetState extends State<BlurWidget> {
  double? _sigmaX;
  double? _sigmaY;

  @override
  void initState() {
    super.initState();
    _sigmaX = widget.sigmaX;
    _sigmaY = widget.sigmaY;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: _sigmaX ?? 0.0, sigmaY: _sigmaY ?? 0.0),
      child: widget.child,
    );
  }
}
