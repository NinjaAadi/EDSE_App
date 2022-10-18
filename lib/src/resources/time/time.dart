import 'dart:convert';

import 'package:edse_app/src/models/time.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TimeApiProvider {
  fetchData() async {
    try {
      final url = "${dotenv.env["API_URL"]}/time/getAllTime";
      final http.Response response = await http.get(Uri.parse(url));
      final times = json.decode(response.body)["data"];
      final List<TimeModel> timeArr = [];
      for (var i = 0; i < times.length; i++) {
        timeArr.add(TimeModel.fromJson(times[i]));
      }
      return timeArr;
    } catch (error) {
      print(error);
      return [];
    }
  }
}
