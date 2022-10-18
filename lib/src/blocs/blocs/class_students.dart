import 'package:edse_app/src/models/profiles/student_profile.dart';
import 'package:rxdart/subjects.dart';

class ClassStudentsBloc {
  final _classStudentsControler = BehaviorSubject<List<StudentProfileModel>>();

  //Sink
  get addClassStudents => _classStudentsControler.sink.add;

  //Stream
  get classStudentsStream => _classStudentsControler.stream;

}
