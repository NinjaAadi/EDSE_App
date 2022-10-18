import 'package:edse_app/src/models/teacher_time_table.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TeacherTimeTableApiProvider {
  fetchTeacherTimeTable(String teacherId) async {
    try {
      final String url =
          "${dotenv.env["API_URL"]}/teacherTimeTable/getTimeTableForTeacher?teacherId=" +
              teacherId;
      http.Response response = await http
          .get(Uri.parse(url), headers: {"Content-type": "application/json"});
      final timeTable = json.decode(response.body);
      if (timeTable["data"] == null) return null;
      final convertedTimeTable =
          TeacherTimeTableModel.fromJson(timeTable["data"]);
      return convertedTimeTable;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
