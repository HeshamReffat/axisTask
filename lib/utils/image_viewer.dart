import 'package:axistask/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class ImageViewer extends StatefulWidget {
  final String url;
  const ImageViewer({super.key, required this.url});

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
    //  height: 300,
      fit: BoxFit.contain,
      imageUrl: "${Constants.imgUrl}${widget.url}",
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
