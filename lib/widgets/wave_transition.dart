import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaveTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final Color color;

  const WaveTransition({
    super.key,
    required this.child,
    required this.animation,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipPath(
          clipper: _WaveClipper(animation.value),
          child: child,
        );
      },
      child: child,
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  final double progress;

  _WaveClipper(this.progress);

  @override
  Path getClip(Size size) {
    final path = Path();
    final y = size.height * (1 - progress);

    final firstControlPoint = Offset(
      size.width * .25,
      y - 30.0 * math.sin(progress * math.pi),
    );
    final firstEndPoint = Offset(
      size.width * .5,
      y + 30.0 * math.sin(progress * math.pi),
    );
    final secondControlPoint = Offset(
      size.width * .75,
      y - 30.0 * math.sin(progress * math.pi),
    );
    final secondEndPoint = Offset(
      size.width,
      y + 30.0 * math.sin(progress * math.pi),
    );

    path.lineTo(0.0, 0.0);
    path.lineTo(0.0, y);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) => true;
}

class WavePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Color waveColor;

  WavePageRoute({
    required this.page,
    this.waveColor = Colors.white,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return WaveTransition(
              animation: animation,
              color: waveColor,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        );
} 