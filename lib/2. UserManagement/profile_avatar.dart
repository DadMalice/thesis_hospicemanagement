import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const ProfileAvatar({this.imageUrl, this.size = 100.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: imageUrl != null
              ? NetworkImage(
                  imageUrl!) // If you want to load image from network
              : const AssetImage('assets/images/default_avatar.png')
                  as ImageProvider<Object>, // Cast to ImageProvider<Object>
        ),
      ),
    );
  }
}
