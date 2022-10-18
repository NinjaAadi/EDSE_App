import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AttendanceBloc {
  final _giveAttendance = BehaviorSubject<Map<String?, String?>>();
  final _deleteAttendance = BehaviorSubject<Map<String?, String?>>();
  //Getters for sink and stream
  get giveAttendanceStream =>
      _giveAttendance.stream.transform(_attendanceTransformer());
  get deleteAttendanceStream =>
      _deleteAttendance.stream.transform(_attendanceTransformer());

  get addAttendance => _giveAttendance.sink.add;
  get deleteAttendance => _deleteAttendance.sink.add;

  //Transformers
  _attendanceTransformer() {
    return ScanStreamTransformer(
        (Map<String?, String?> cache, Map<String?, String?> data, index) {
      data.forEach((key, value) {
        cache[key] = value;
      });
      return cache;
    }, <String, String>{});
  }

  //Funtion to add attendance
  addAttendanceStudent(String id, String name) async {
    addAttendance({id: "Loading"});
    final jwt = Hive.box("loginObj").get("jwt");
    final url =
        '${dotenv.env["API_URL"]}/attendance/setAttendance?studentId=' + id;

    final http.Response response =
        await http.post(Uri.parse(url), headers: {"auth-token": jwt});
    final responseData = json.decode(response.body);
    addAttendance({id: "Good"});
    if (responseData["success"] == true) {
      return "Gave attendance to " + name;
    } else {
      return responseData["messege"];
    }
  }

  //Function to delete attendance
  deleteAttendanceStudent(String id, String name) async {
    deleteAttendance({id: "Loading"});
    final jwt = Hive.box("loginObj").get("jwt");
    final url =
        '${dotenv.env["API_URL"]}/attendance/deleteAttendance?studentId=' + id;

    final http.Response response =
        await http.post(Uri.parse(url), headers: {"auth-token": jwt});
    final responseData = json.decode(response.body);
    deleteAttendance({id: "Good"});
    if (responseData["success"] == true) {
      return "Deleted attendance for " + name;
    } else {
      return responseData["messege"];
    }
  }
}
