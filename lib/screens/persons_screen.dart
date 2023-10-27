import 'package:axistask/providers/main_provider.dart';
import 'package:axistask/screens/person_details.dart';
import 'package:axistask/utils/constants.dart';
import 'package:axistask/utils/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PersonsList extends StatefulWidget {
  const PersonsList({super.key});

  @override
  State<PersonsList> createState() => _PersonsListState();
}

class _PersonsListState extends State<PersonsList> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        title: const Text(
          "Persons",
          style: TextStyle(fontSize: 22, color: Colors.black),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, _) {
          return provider.loadingPersonsList
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : provider.personsModel != null
                  ? SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: const WaterDropHeader(),
                      controller: _refreshController,
                      onRefresh: () {
                        provider.onRefresh(_refreshController);
                      },
                      onLoading: () {
                        provider.onLoading(_refreshController);
                      },
                      child: ListView.builder(
                        itemCount: provider.personsModel!.results!.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              if(Constants.deviceConnected) {
                                Future.wait([
                                  provider.getPersonsDetails(
                                      id: provider.personsModel!.results![index]
                                          .id
                                          .toString()),
                                  provider.getPersonsImages(
                                      id: provider.personsModel!.results![index]
                                          .id
                                          .toString()),
                                ]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PersonDetailsScreen(
                                            personName: provider
                                                .personsModel!.results![index]
                                                .name!),
                                  ),
                                );
                              }else{
                                var snackBar = const SnackBar(
                                    content: Text('Check Internet Connection'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            onDoubleTap: () {},
                            child: Card(
                              margin: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  ImageViewer(
                                      url:
                                          "w500${provider.personsModel!.results![index].profilePath}"),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    provider.personsModel!.results![index]
                                            .name ??
                                        "",
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),
                    );
        },
      ),
    );
  }
}
