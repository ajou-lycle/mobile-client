import 'package:flutter/material.dart';

import 'package:lycle/src/constants/ui.dart';

class RoundedImage extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final ImageProvider imageProvider;

  const RoundedImage({
    Key? key,
    this.width = double.infinity,
    this.height = double.infinity,
    this.radius = kDefaultRadius,
    required this.imageProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          image: DecorationImage(image: imageProvider)),
    );
  }
}
