import 'package:axistask/data_source/remote/end_points.dart';
import 'package:axistask/utils/constants.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

abstract class Repository {
  Future<Response> getPeopleList({required int page});

  Future<Response> getPersonImages({required String id});

  Future<Response> getPersonDetails({required String id});
}

class RepositoryModule implements Repository {
  final headers = {
    "Accept": "application/json",
    "Authorization": "Bearer ${Constants.token}"
  };

  @override
  Future<Response> getPeopleList({required int page}) async {
    return await http.get(
      Uri.parse("${Constants.mainUrl}${EndPoints.peopleList}?page=$page"),
      headers: headers,
    );
  }

  @override
  Future<Response> getPersonImages({required String id}) async {
    return await http.get(
      Uri.parse("${Constants.mainUrl}${EndPoints.personImages(id)}"),
      headers: headers,
    );
  }

  @override
  Future<Response> getPersonDetails({required String id}) async {
    return await http.get(
      Uri.parse("${Constants.mainUrl}${EndPoints.personDetails(id)}"),
      headers: headers,
    );
  }
}
