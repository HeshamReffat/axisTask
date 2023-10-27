import 'package:axistask/providers/main_provider.dart';
import 'package:axistask/utils/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OriginalImageScreen extends StatefulWidget {
  final String imageUrl;

  const OriginalImageScreen({super.key, required this.imageUrl});

  @override
  State<OriginalImageScreen> createState() => _OriginalImageScreenState();
}

class _OriginalImageScreenState extends State<OriginalImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            scrolledUnderElevation: 0.0,
            title: const Text(
              "Image View",
              style: TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  ImageViewer(url: "original${widget.imageUrl}"),
                  const SizedBox(
                    height: 20.0,
                  ),
                  provider.savingImage
                      ? const CircularProgressIndicator()
                      : InkWell(
                          onTap: () {
                            provider
                                .saveNetworkImage(widget.imageUrl)
                                .then((value) {
                              var snackBar = const SnackBar(
                                  content: Text('Image Saved To Gallery'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            });
                          },
                          child: Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Center(
                              child: Text(
                                "Save Image",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
