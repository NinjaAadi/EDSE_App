import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class AddRoleBloc {
  //Controller functions
  final _addRoleController = BehaviorSubject<Map<String, String>>();
  final _addButtonController = BehaviorSubject<String>();

  var role = {"title": "", "roleFor": ""};

  //Sink and streams
  get addRoleDetail => _addRoleController.sink.add;
  get addRoleStream =>
      _addRoleController.stream.transform(addRoleTransformer());

  get addButtonDetails => _addButtonController.sink.add;
  get buttonDetailsStream => _addButtonController.stream;

  //Transformer
  addRoleTransformer() {
    return ScanStreamTransformer(
        (Map<String, String> cache, Map<String, String> data, index) {
      data.forEach((key, value) {
        cache[key] = value;
      });
      role = cache;
      return cache;
    }, <String, String>{});
  }

  //Submit function for adding transport
  submit() async {
    try {
      print(role);
      addButtonDetails("loading");
      String? roleFor = role["roleFor"];
      final url =
          "${dotenv.env["API_URL"]}/role/addRoleValue?roleFor=${roleFor}";

      http.Response response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"title": role["title"]}));
      final res = json.decode(response.body);
      addButtonDetails("good");
      return res;
    } catch (error) {
      print(error);
      addButtonDetails("good");
      return {"success": false, "messege": "Server error"};
    }
  }
}
