import 'package:edse_app/src/models/profiles/teacher_profile.dart';
import 'package:edse_app/src/resources/profile/teacher/teacher_api_provider.dart';
import 'package:rxdart/subjects.dart';
import 'package:hive/hive.dart';

class TeacherProfileBloc {
  final apiProvider = TeacherProfileApiProvider();
  //Controller for teacher
  final _teacherProfileController = BehaviorSubject<TeacherProfileModel>();

  //Stream
  get teacherProfileStream => _teacherProfileController.stream;

  //Sink
  get teacherProfileAdd => _teacherProfileController.sink.add;
  //function to fetch the teacherProfile
  fetchProfile() async {
    var loginObj = Hive.box('loginObj');
    final id = loginObj.get('id');
    final profile = await apiProvider.fetchProfile(id);
    if (profile != null) {
      teacherProfileAdd(profile);
    }
  }
}
