import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppLogo({
    super.key,
    this.size = 120,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo.svg',
      width: width ?? size * 1.4,
      height: height ?? size,
      fit: fit,
    );
  }
}
