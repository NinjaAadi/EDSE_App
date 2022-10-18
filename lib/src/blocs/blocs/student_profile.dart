import 'package:edse_app/src/models/profiles/student_profile.dart';
import 'package:edse_app/src/resources/profile/student/student_profile_api_provider.dart';
import 'package:edse_app/src/screens/profile/student_profile.dart';
import 'package:rxdart/subjects.dart';

class StudentProfileBloc {
  final _studentProfileController = BehaviorSubject<StudentProfileModel>();
  final studentProfileApiProvider = StudentProfileApiProvider();
  //Sink and stream for student Profile
  get addStudentProfile => _studentProfileController.sink.add;

  //Stream for other listners
  get studentProfileStream => _studentProfileController.stream;


  //Function to add profile manually
  addProfile(StudentProfileModel studentProfile) {
    addStudentProfile(studentProfile);
  }

  fetchProfileFromId(String id) async {
    final profile = await studentProfileApiProvider.fetchProfile(id);
    addStudentProfile(profile);
  }
}
