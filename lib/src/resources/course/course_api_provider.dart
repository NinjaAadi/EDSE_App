import 'dart:convert';

import 'package:edse_app/src/models/course.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CourseApiProvider {
  fetchAllCourses() async {
    try {
      final url = "${dotenv.env["API_URL"]}/course/getAllCourse";
      final http.Response response = await http.get(Uri.parse(url));
      final List<CourseModel> coursearr = [];
      final courses = json.decode(response.body)["data"];
      for (var i = 0; i < courses.length; i++) {
        coursearr.add(CourseModel.fromJson(courses[i]));
      }
      return coursearr;
    } catch (error) {
      print(error);
      return [];
    }
  }
}
