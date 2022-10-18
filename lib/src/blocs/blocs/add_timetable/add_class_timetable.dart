import 'dart:convert';
import 'package:edse_app/src/resources/class/fetch_class_api_provider.dart';
import 'package:edse_app/src/resources/course/course_api_provider.dart';
import 'package:edse_app/src/resources/day/day.dart';
import 'package:edse_app/src/resources/profile/teacher/teacher_api_provider.dart';
import 'package:edse_app/src/resources/time/time.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class AddClassTimeTableBloc {
  final _addClassTimeTableController = BehaviorSubject<Map<String, dynamic>>();
  final _preDataController = BehaviorSubject<Map<String, dynamic>>();
  //Stream controller for submit button
  final _submitButtonController = BehaviorSubject<String>();
  //Stream Controller for teacher's id
  final _classIdController = BehaviorSubject<String>();

  //Sink and stream for button controller
  get addButtonState => _submitButtonController.sink.add;
  get buttonStateStream => _submitButtonController.stream;

  //Sink and stream for controller
  get addClassTimeTable => _addClassTimeTableController.sink.add;
  get addClassTimeTableStream => _addClassTimeTableController.stream
      .transform(_classTimeTableTransformer());

  //Sink and stream for pre data
  get addPreData => _preDataController.sink.add;
  get preDataStream => _preDataController.stream;

  //Sink and stream for teacher id
  get addTeacherId => _classIdController.sink.add;
  get teacherIdStream => _classIdController.stream;

  //Final timetable to register
  late final timeTable;

  //Transformer function for adding time table
  _classTimeTableTransformer() {
    return ScanStreamTransformer(
        (Map<String, dynamic> cache, Map<String, dynamic> data, index) {
      if (data["initial"] != null) {
        cache = data;
      }
      if (data["course"] != null) {
        final dayId = data["course"]["dayId"];
        final timeId = data["course"]["time"];
        final courseId = data["course"]["courseId"];
        cache["initial"][dayId][timeId]["subject"] = courseId;
      }
      timeTable = cache;
      return cache;
    }, <String, dynamic>{});
  }

  //

  fetchInitialDetails() async {
    Map<String, dynamic> preData = {
      "days": [],
      "times": [],
      "courses": [],
    };
    final DayApiProvider dayApiProvider = DayApiProvider();
    final TimeApiProvider timeApiProvider = TimeApiProvider();
    final CourseApiProvider courseApiProvider = CourseApiProvider();

    var days = [];
    var courses = [];
    var times = [];

    days = await dayApiProvider.fetchData();
    times = await timeApiProvider.fetchData();
    courses = await courseApiProvider.fetchAllCourses();

    preData["days"] = days;
    preData["times"] = times;
    preData["courses"] = courses;

    Map<String, Map<String, Map<String, String>>> data = {};

    for (var i = 0; i < days.length; i++) {
      Map<String, Map<String, String>> currday = {};
      for (var j = 0; j < times.length; j++) {
        currday[times[j].id] = {"subject": ""};
      }
      data[days[i].id] = currday;
    }
    Map<String, dynamic> finalData = {"initial": data};
    addClassTimeTable(finalData);
    addPreData(preData);
  }

  submitTimeTable() async {
    try {
      await addButtonState("loading");
      final url = "${dotenv.env["API_URL"]}/timeTable/addTimeTable";

      List<Map<String, dynamic>> finalTimeTable = [];

      timeTable["initial"].forEach((key, value) {
        List<Map<String, dynamic>> finalDayTimeTable = [];
        value.forEach((key, value) {
          finalDayTimeTable.add({
            "time": key,
            "subject": value["subject"],
          });
        });
        finalTimeTable.add({"dayName": key, "dayTimeTable": finalDayTimeTable});
      });
      print(finalTimeTable);
      final timeTableData = {"timeTable": finalTimeTable};
      final http.Response response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(timeTableData));
      final res = json.decode(response.body);

      //If the time table registration is not valid then return false
      if (res["success"] == false) {
        await addButtonState("good");
        return res;
      }
      //If the time table is valid
      final timeTableId = res["id"];
      var classId = _classIdController.valueOrNull;

      classId ??= "";

      //Fetch the teacher profile and check whether it is valid or not
      final AllClassApiProvider classProfileApiProvider = AllClassApiProvider();
      //Get the profile
      final classData = await classProfileApiProvider.fetchClassById(classId);
      //Validate the class
      if (classData == null) {
        await addButtonState("good");
        return {"success": false, "messege": "Please enter a valid class id"};
      }

      //If valid then link the timetable with the class
      final classTimeTableLinkUrl =
          "${dotenv.env["API_URL"]}/timeTable/relateTimeTable?timeTableId=" +
              timeTableId +
              "&classId=" +
              classId;
      final http.Response finalResponse = await http.post(
          Uri.parse(classTimeTableLinkUrl),
          headers: {"Content-Type": "application/json"});
      await addButtonState("good");
      return json.decode(finalResponse.body);
    } catch (error) {
      print(error);
      addButtonState("good");
      return {"success": false, "messege": "Server error"};
    }
  }
}
