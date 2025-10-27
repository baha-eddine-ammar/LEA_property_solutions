import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogo({
    Key? key,
    this.size = 40,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.home_work_rounded,
          size: size,
          color: color ?? AppTheme.primaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          'LEA',
          style: TextStyle(
            fontSize: size * 0.6,
            fontWeight: FontWeight.bold,
            color: color ?? AppTheme.primaryColor,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class AppLogoWithText extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogoWithText({
    Key? key,
    this.size = 40,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(size: size, color: color),
        const SizedBox(height: 4),
        Text(
          'Property Solutions',
          style: TextStyle(
            fontSize: size * 0.3,
            fontWeight: FontWeight.w500,
            color: color ?? AppTheme.subtitleColor,
          ),
        ),
      ],
    );
  }
}
