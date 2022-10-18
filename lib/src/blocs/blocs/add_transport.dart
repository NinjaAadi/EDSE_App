import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class AddTransportBloc {
  //Controller functions
  final _addTransportController = BehaviorSubject<Map<String, String>>();
  final _addButtonController = BehaviorSubject<String>();

  var transport = {};

  //Sink and streams
  get addTransportDetails => _addTransportController.sink.add;
  get addTransportStream =>
      _addTransportController.stream.transform(addTransportTransformer());

  get addButtonDetails => _addButtonController.sink.add;
  get buttonDetailsStream => _addButtonController.stream;

  //Transformer
  addTransportTransformer() {
    return ScanStreamTransformer(
        (Map<String, String> cache, Map<String, String> data, index) {
      data.forEach((key, value) {
        cache[key] = value;
      });
      transport = cache;
      return cache;
    }, <String, String>{});
  }

  //Submit function for adding transport
  submit() async {
    try {
      addButtonDetails("loading");
      final url = "${dotenv.env["API_URL"]}/transport/addTransportAddress";

      http.Response response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(transport));
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
