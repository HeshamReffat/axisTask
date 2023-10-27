import 'package:axistask/providers/main_provider.dart';
import 'package:axistask/screens/original_image_screen.dart';
import 'package:axistask/utils/constants.dart';
import 'package:axistask/utils/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonDetailsScreen extends StatefulWidget {
  final String personName;

  const PersonDetailsScreen({
    super.key,
    required this.personName,
  });

  @override
  State<PersonDetailsScreen> createState() => _PersonDetailsScreenState();
}

class _PersonDetailsScreenState extends State<PersonDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0.0,
            centerTitle: true,
            title: Text(
              widget.personName,
              style: const TextStyle(fontSize: 22, color: Colors.black),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                provider.loadingPersonDetails
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Center(
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: ImageViewer(
                                  url:
                                      "w500${provider.personDetailsModel!.profilePath ?? ''}"),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Name: ",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Text(
                                provider.personDetailsModel!.name ?? '',
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Birthday: ",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Text(
                                provider.personDetailsModel!.birthday??'',
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Bio: ",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black),
                              ),
                              Flexible(
                                child: Text(
                                  provider.personDetailsModel!.biography!,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  "Gallery: ",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                provider.personImagesModel != null &&
                        provider.personImagesModel!.profiles!.isNotEmpty
                    ? provider.loadingPersonImages
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                provider.personImagesModel!.profiles!.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10.0,
                              mainAxisExtent: 250.0,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if(Constants.deviceConnected) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OriginalImageScreen(
                                                imageUrl: provider
                                                    .personImagesModel!
                                                    .profiles![index]
                                                    .filePath!),
                                      ),
                                    );
                                  }else{
                                    var snackBar = const SnackBar(
                                        content: Text('Check Internet Connection'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: ImageViewer(
                                    url:
                                        "w500${provider.personImagesModel!.profiles![index].filePath}"),
                              );
                            })
                    : const Text("Gallery is Empty"),
              ],
            ),
          ),
        );
      },
    );
  }
}
