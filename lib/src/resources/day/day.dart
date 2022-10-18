import 'dart:convert';

import 'package:edse_app/src/models/day.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class DayApiProvider {
  fetchData() async {
    try {
      final url = "${dotenv.env["API_URL"]}/day/getAllDays";
      final http.Response response = await http.get(Uri.parse(url));
      final days = json.decode(response.body)["data"];
      final List<DayModel> dayArr = [];
      for (var i = 0; i < days.length; i++) {
        dayArr.add(DayModel.fromJson(days[i]));
      }
      return dayArr;
    } catch (error) {
      print(error);
      return [];
    }
  }
}
