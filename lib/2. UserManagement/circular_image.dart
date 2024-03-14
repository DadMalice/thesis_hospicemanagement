import 'package:flutter/material.dart';

class CircularImageWidget extends StatelessWidget {
  final String imageUrl;
  final double size;

  CircularImageWidget({
    required this.imageUrl,
    this.size = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: AssetImage(imageUrl),
      backgroundColor: Colors
          .grey, // You can set a fallback color if the image fails to load
    );
  }
}
