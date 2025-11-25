import 'package:flutter/material.dart';

class BlinkingEyes extends StatefulWidget {
  @override
  _BlinkingEyesState createState() => _BlinkingEyesState();
}

class _BlinkingEyesState extends State<BlinkingEyes>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500), // Blinking speed
    )..repeat(reverse: true); // Keep blinking automatically

    _blinkAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _blinkAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _blinkAnimation.value,
          child: child,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildEye(),
          const SizedBox(width: 40), // Space between eyes
          _buildEye(),
        ],
      ),
    );
  }

  Widget _buildEye() {
    return Container(
      width: 35,
      height: 15,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10), // Oval shape
      ),
    );
  }
}
