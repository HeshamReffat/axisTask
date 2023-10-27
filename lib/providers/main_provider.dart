import 'dart:convert';
import 'dart:io';

import 'package:axistask/data_source/remote/repository.dart';
import 'package:axistask/models/person_details_model.dart';
import 'package:axistask/models/person_images_model.dart';
import 'package:axistask/models/persons_model.dart';
import 'package:axistask/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class AppProvider extends ChangeNotifier {
  Repository repository;

  AppProvider(this.repository);

//pagingNumbers
  int currentPage = 1;
  int lastPage = 1;

  //DataModels
  PersonsModel? personsModel;
  PersonDetailsModel? personDetailsModel;
  PersonImagesModel? personImagesModel;

  //Loaders
  bool loadingPersonsList = false;
  bool loadingPersonDetails = false;
  bool loadingPersonImages = false;
  bool savingImage = false;

  // database
  Database? db;
  DatabaseFactory dbFactory = databaseFactoryIo;

  Future getPersonsList() async {
    if (Constants.deviceConnected) {
      loadingPersonsList = true;
      currentPage = 1;
      await repository.getPeopleList(page: currentPage).then((value) async {
        loadingPersonsList = false;
        if (value.statusCode == 200) {
          //debugPrint(jsonDecode(value.body));
          Map<String, dynamic> body = jsonDecode(value.body);

          var store = StoreRef.main();
          await store.record('persons').put(db!, body, merge: true);
          Map<String, dynamic> data =
              await store.record('persons').get(db!) as Map<String, dynamic>;
          personsModel = PersonsModel.fromJson(data);
          lastPage = personsModel!.totalPages!;
          debugPrint(personsModel!.results![0].name);
        }
      }).catchError((error) {
        loadingPersonsList = false;
        debugPrint(error.toString());
      });
    } else {
      getPersonsFromDatabase();
    }
    notifyListeners();
  }

  getPersonsFromDatabase() async {
    loadingPersonsList = true;
    var store = StoreRef.main();
    Map<String, dynamic> data =
        await store.record('persons').get(db!) as Map<String, dynamic>;
    personsModel = PersonsModel.fromJson(data);
    lastPage = personsModel!.totalPages!;
    loadingPersonsList = false;
    debugPrint(personsModel!.results![0].name);
  }

  Future loadMorePersonsList() async {
    await repository.getPeopleList(page: currentPage).then((value) {
      if (value.statusCode == 200) {
        debugPrint(value.body);
        Map<String, dynamic> body = jsonDecode(value.body);
        for (var item in body["results"]) {
          personsModel!.results!.add(Results.fromJson(item));
        }
      }
    }).catchError((error) {
      debugPrint(error.toString());
    });
    notifyListeners();
  }

  void onRefresh(RefreshController refreshController) async {
    // monitor network fetch
    currentPage = 1;
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    getPersonsList();
    refreshController.refreshCompleted();
  }

  void onLoading(RefreshController refreshController) async {
    // monitor network fetch
    currentPage++;
    if (currentPage < lastPage) {
      loadMorePersonsList();
    } else {
      await Future.delayed(const Duration(milliseconds: 1000));
      refreshController.loadFailed();
      refreshController.loadNoData();
    }
    await Future.delayed(const Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    refreshController.loadComplete();
  }

  Future getPersonsImages({required String id}) async {
    loadingPersonImages = true;
    await repository.getPersonImages(id: id).then((value) {
      loadingPersonImages = false;
      if (value.statusCode == 200) {
        debugPrint(value.body);
        Map<String, dynamic> body = jsonDecode(value.body);
        personImagesModel = PersonImagesModel.fromJson(body);
      }
    }).catchError((error) {
      loadingPersonImages = false;
      debugPrint(error.toString());
    });
    notifyListeners();
  }

  Future getPersonsDetails({required String id}) async {
    loadingPersonDetails = true;
    await repository.getPersonDetails(id: id).then((value) {
      loadingPersonDetails = false;
      if (value.statusCode == 200) {
        debugPrint(value.body);
        Map<String, dynamic> body = jsonDecode(value.body);
        personDetailsModel = PersonDetailsModel.fromJson(body);
      }
    }).catchError((error) {
      loadingPersonDetails = false;
      debugPrint(error.toString());
    });
    notifyListeners();
  }

  Future saveNetworkImage(String url) async {
    savingImage = true;
    notifyListeners();
    var response = await http.get(
      Uri.parse("${Constants.imgUrl}original$url"),
    );
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.bodyBytes),
        quality: 100,
        name: "PersonImage");
    savingImage = false;
    debugPrint(result.toString());
    notifyListeners();
  }

  Future openDatabase() async {
    Directory root = await getTemporaryDirectory();
 // use the database factory to open the database
    db = await dbFactory.openDatabase(root.path + Constants().dbPath);
  }

  void init() async {
    await openDatabase();
    await getPersonsList();
  }
}
