import 'package:flutter/material.dart';

class FadeAnimationWidget extends StatefulWidget {
  Duration delay;
  Widget child;

  FadeAnimationWidget({super.key, required this.delay, required this.child});

  @override
  _FadeAnimationWidgetState createState() => _FadeAnimationWidgetState();
}

class _FadeAnimationWidgetState extends State<FadeAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create an animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    final curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);

    // Create a tween to define the opacity animation
    _animation = Tween<double>(begin: 0, end: 1).animate(curve);

    // Start the animation after the specified delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
