import 'dart:convert';
import 'package:edse_app/src/resources/class/fetch_class_api_provider.dart';
import 'package:edse_app/src/resources/course/course_api_provider.dart';
import 'package:edse_app/src/resources/day/day.dart';
import 'package:edse_app/src/resources/profile/teacher/teacher_api_provider.dart';
import 'package:edse_app/src/resources/time/time.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class AddTeacherTimeTableBloc {
  final _addTeacherTimeTableController =
      BehaviorSubject<Map<String, dynamic>>();
  final _preDataController = BehaviorSubject<Map<String, dynamic>>();
  //Stream controller for submit button
  final _submitButtonController = BehaviorSubject<String>();
  //Stream Controller for teacher's id
  final _teacherIdController = BehaviorSubject<String>();

  //Sink and stream for button controller
  get addButtonState => _submitButtonController.sink.add;
  get buttonStateStream => _submitButtonController.stream;

  //Sink and stream for controller
  get addTeacherTimeTable => _addTeacherTimeTableController.sink.add;
  get addTeacherTimeTableStream => _addTeacherTimeTableController.stream
      .transform(_teacherTimeTableTransformer());

  //Sink and stream for pre data
  get addPreData => _preDataController.sink.add;
  get preDataStream => _preDataController.stream;

  //Sink and stream for teacher id
  get addTeacherId => _teacherIdController.sink.add;
  get teacherIdStream => _teacherIdController.stream;

  //Final timetable to register
  late final timeTable;

  //Transformer function for adding time table
  _teacherTimeTableTransformer() {
    return ScanStreamTransformer(
        (Map<String, dynamic> cache, Map<String, dynamic> data, index) {
      if (data["initial"] != null) {
        cache = data;
      }
      if (data["class"] != null) {
        //Find the day id
        //For that day find the time id
        //Set the class id there

        final dayId = data["class"]["dayId"];
        final timeId = data["class"]["time"];
        final classId = data["class"]["className"];
        cache["initial"][dayId][timeId]["className"] = classId;
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
      "classes": []
    };
    final DayApiProvider dayApiProvider = DayApiProvider();
    final TimeApiProvider timeApiProvider = TimeApiProvider();
    final CourseApiProvider courseApiProvider = CourseApiProvider();
    final AllClassApiProvider classApiProvider = AllClassApiProvider();
    var days = [];
    var courses = [];
    var times = [];
    var classes = [];
    days = await dayApiProvider.fetchData();
    times = await timeApiProvider.fetchData();
    courses = await courseApiProvider.fetchAllCourses();
    classes = await classApiProvider.fetchAllClasses();

    preData["days"] = days;
    preData["times"] = times;
    preData["courses"] = courses;
    preData["classes"] = classes;
    Map<String, Map<String, Map<String, String>>> data = {};

    for (var i = 0; i < days.length; i++) {
      Map<String, Map<String, String>> currday = {};
      for (var j = 0; j < times.length; j++) {
        currday[times[j].id] = {"subject": "", "className": ""};
      }
      data[days[i].id] = currday;
    }
    Map<String, dynamic> finalData = {"initial": data};
    addTeacherTimeTable(finalData);
    addPreData(preData);
  }

  submitTimeTable() async {
    try {
      await addButtonState("loading");
      final url = "${dotenv.env["API_URL"]}/teacherTimeTable/addTimeTable";

      List<Map<String, dynamic>> finalTimeTable = [];

      timeTable["initial"].forEach((key, value) {
        List<Map<String, dynamic>> finalDayTimeTable = [];
        value.forEach((key, value) {
          finalDayTimeTable.add({
            "time": key,
            "subject": value["subject"],
            "className": value["className"]
          });
        });
        finalTimeTable.add({"dayName": key, "dayTimeTable": finalDayTimeTable});
      });
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
      var teacherId = _teacherIdController.valueOrNull;
      teacherId ??= "";
      //Fetch the teacher profile and check whether it is valid or not
      final TeacherProfileApiProvider teacherProfileApiProvider =
          TeacherProfileApiProvider();
      //Get the profile
      final teacherProfile =
          await teacherProfileApiProvider.fetchProfile(teacherId);
      //Validate the teacher
      if (teacherProfile == null) {
        await addButtonState("good");
        return {"success": false, "messege": "Please enter a valid teacher id"};
      }
      print(timeTableId);
      //If valid then link the timetable with the profile
      final teacherTimeTableLinkUrl =
          "${dotenv.env["API_URL"]}/teacherTimeTable/relateTimeTable?timeTableId=" +
              timeTableId +
              "&teacherId=" +
              teacherId;
      final http.Response finalResponse = await http.post(
          Uri.parse(teacherTimeTableLinkUrl),
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
