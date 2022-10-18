import 'package:edse_app/src/models/profiles/student_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StudentProfileApiProvider {
  dynamic fetchProfile(String profileId) async {
    try {
      String url =
          "${dotenv.env["API_URL"]}/profile/student/getProfile?studentId=" +
              profileId;
      http.Response response = await http
          .get(Uri.parse(url), headers: {"Content-type": "application/json"});
      final profile =
          StudentProfileModel.fromJson(json.decode(response.body)["data"]);
      return profile;
    } catch (error) {
      return null;
    }
  }
}
