import 'package:edse_app/src/models/teacher_time_table.dart';
import 'package:edse_app/src/resources/time_table/teacher_time_table_api_provider.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/subjects.dart';

class TeacherTimeTableBloc {
  final _teacherTimeTableController = BehaviorSubject<TeacherTimeTableModel>();
  final teacherTimeTableApiProvider = TeacherTimeTableApiProvider();
  //Define the sink and the stream
  get teacherTimeTableStream => _teacherTimeTableController.stream;

  get addTeacherTimeTable => _teacherTimeTableController.sink.add;

  fetchTimeTable() async {
    var loginObj = Hive.box('loginObj');
    final id = loginObj.get('id');
    final response =
        await teacherTimeTableApiProvider.fetchTeacherTimeTable(id);
    await addTeacherTimeTable(response);
  }
}
