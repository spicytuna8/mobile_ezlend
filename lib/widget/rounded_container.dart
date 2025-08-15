import 'package:flutter/material.dart';

class RoundedDiagonalClipper extends CustomClipper<Path> {
  double _getY(double x) {
    return x * 0.13;
  }

  @override
  Path getClip(Size size) {
    var roundnessFactor = 50.0;
    var equalization = 10.0;
    var path = Path();

    path.moveTo(0, roundnessFactor);
    path.lineTo(0, size.height - 0);

    path.quadraticBezierTo(0, size.height, roundnessFactor, size.height);
    path.lineTo(size.width - 0, size.height);

    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 0);

    path.lineTo(size.width, _getY(size.width) + roundnessFactor - equalization);
    path.quadraticBezierTo(
        size.width,
        _getY(size.width),
        size.width - roundnessFactor + equalization,
        _getY(size.width - roundnessFactor + equalization));

    path.lineTo(
        roundnessFactor + equalization, _getY(roundnessFactor + equalization));
    path.quadraticBezierTo(0, 0, 0, roundnessFactor + equalization);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
