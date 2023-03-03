import 'package:flutter/material.dart';

class ImageViewerChat extends StatelessWidget {
  String imageUrl;
  ImageViewerChat({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(image: NetworkImage(imageUrl))),
    );
  }
}
