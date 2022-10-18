import 'package:edse_app/src/models/class.dart';
import 'package:edse_app/src/resources/class/fetch_class_api_provider.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/subjects.dart';

class FetchClassBloc {
  final _FetchClassForTeacherController = BehaviorSubject<List<ClassModel>>();
  final allClassApiProvider = AllClassApiProvider();
  //Getters and setters
  get addClassesForTeachers => _FetchClassForTeacherController.sink.add;
  //Stream
  get classesForTeacherStream => _FetchClassForTeacherController.stream;

  //Fetch all classes function
  fetchAllClasses() async {
    final response =
        await allClassApiProvider.fetchClasses(Hive.box('loginObj').get('id'));
    addClassesForTeachers(response);
  }
}
