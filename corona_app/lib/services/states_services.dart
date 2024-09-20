import 'dart:convert';
import 'package:corona_app/model/world_state_model.dart';
import 'package:corona_app/services/utilities/app_url.dart';
import 'package:http/http.dart' as http;

class StatesServices {
  Future<WorldStatesModel> fetchWorldStateModel() async {
    final response = await http
        .get(Uri.parse(AppUrl.worldStatesUrl)); // Changed to worldStatesUrl

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return WorldStatesModel.fromJson(data);
    } else {
      throw Exception(
          'Failed to load world states. Status code: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> countriesListApi() async {
    var data;
    final response = await http
        .get(Uri.parse(AppUrl.countriesList)); // Changed to worldStatesUrl

    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          'Failed to countries list. Status code: ${response.statusCode}');
    }
  }
}
