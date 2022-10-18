import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';

class AddCourseBloc {
  final _addCourseController = BehaviorSubject<Map<String, String>>();
  final _buttonStateController = BehaviorSubject<String>();
  var course = {};
  //Sink and stream for course addition
  get addCourse => _addCourseController.sink.add;
  get addCourseStream =>
      _addCourseController.stream.transform(courseAdditionTransformer());

  //Sink and stream for submit button
  get addsubmitButtonDetail => _buttonStateController.sink.add;
  get submitButtonDetailStream => _buttonStateController.stream;

  //Transformer for course addition
  courseAdditionTransformer() {
    return ScanStreamTransformer(
        (Map<String, String> cache, Map<String, String> data, index) {
      data.forEach((key, value) {
        cache[key] = value;
      });
      course = cache;
      return cache;
    }, <String, String>{});
  }

  //submit function for course addition
  submit() async {
    try {
      addsubmitButtonDetail("loading");
      final url = "${dotenv.env["API_URL"]}/course/addCourse";

      final http.Response response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(course));
      final res = json.decode(response.body);
      print(res);
      addsubmitButtonDetail("good");
      return res;
    } catch (error) {
      addsubmitButtonDetail("good");
      print(error);
      return {"success": false, "messege": "Server error"};
    }
  }
}
