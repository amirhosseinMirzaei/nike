import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageLoadingService extends StatelessWidget {
  final String imageUrl;
  final BorderRadius? borderRadius;
  const ImageLoadingService({
    super.key,
    required this.imageUrl,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
    );
    if (borderRadius != null) {
      return ClipRRect(borderRadius: BorderRadius.circular(15), child: image);
    } else
      return image;
  }
}
