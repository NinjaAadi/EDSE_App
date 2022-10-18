import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:edse_app/src/resources/course/course_api_provider.dart';
import 'package:edse_app/src/resources/role/role_api_provider.dart';
import 'package:edse_app/src/resources/transport/transport_api_provider.dart';
import 'package:rxdart/rxdart.dart';

class AddStudentProfileBloc {
  final _addStudentProfileController = BehaviorSubject<Map<String, dynamic>>();
  Map<String, dynamic> finalResponse = {
    "fullName": "",
    "address": "",
    "phoneNumber": "",
    "fatherName": "",
    "motherName": "",
    "parentNumber": "",
    "gender": "",
    "transportAddress": "",
    "courses": "",
    "roles": "",
    "file": nullptr,
    "birthday": "",
  };

  //Controller for fetching the roles, transports, and courses
  final _fetchDataForStudentProfileAddition =
      BehaviorSubject<Map<String, dynamic>>();

  //Stream for button
  final _submitButtonController = BehaviorSubject<String>();

  //Getters and sink and stream for the data from which we have to select
  get addPreSelection => _fetchDataForStudentProfileAddition.sink.add;
  get preSelectionStream => _fetchDataForStudentProfileAddition.stream;

  //Getters for sink and stream
  get addStudentProfile => _addStudentProfileController.sink.add;
  get studentProfileAddStream => _addStudentProfileController.stream
      .transform(_addStudentProfileTransformer());

  //Sink and stream for submit button
  get setButtonValue => _submitButtonController.sink.add;
  get buttonValueStream => _submitButtonController.stream;
  //Stream transformer which starts with an initial map of all the values
  _addStudentProfileTransformer() {
    return ScanStreamTransformer(
        (Map<String, dynamic> cache, Map<String, dynamic> data, index) {
      data.forEach((key, value) {
        cache[key] = value;
      });
      finalResponse = cache;
      return cache;
    }, <String, dynamic>{
      "fullName": "",
      "address": "",
      "phoneNumber": "",
      "fatherName": "",
      "motherName": "",
      "parentNumber": "",
      "gender": "",
      "transportAddress": "",
      "courses": "",
      "role": "",
      "file": nullptr,
      "birthday": "",
    });
  }

  submitProfile() async {
    try {
      setButtonValue("Loading");
      final url = "${dotenv.env["API_URL"]}/profile/student/createProfile";
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(http.MultipartFile(
          'file',
          finalResponse["file"].readAsBytes().asStream(),
          finalResponse["file"].lengthSync(),
          filename: finalResponse["file"].path.split("/").last));
      finalResponse.forEach((key, value) {
        if (key != "file") {
          request.fields[key] = value;
        }
      });
      http.Response response =
          await http.Response.fromStream(await request.send());
      setButtonValue("Good");
      return json.decode(response.body);
    } catch (error) {
      print(error);
      setButtonValue("Good");
      return {"success": false, "messege": "Server error"};
    }
  }

  fetchInitialDetails(String forWhich) async {
    final roleApiProvider = RoleApiProvider();
    final transportApiProvider = TransportApiProvider();
    final courseApiProvider = CourseApiProvider();
    final roles = await roleApiProvider.fetchAllRoles(forWhich);
    final transports = await transportApiProvider.fetchTransports();
    final courses = await courseApiProvider.fetchAllCourses();
    Map<String, dynamic> details = {
      "roles": roles,
      "transports": transports,
      "courses": courses
    };
    await addPreSelection(details);
  }
}
