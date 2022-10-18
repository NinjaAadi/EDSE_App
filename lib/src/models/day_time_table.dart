import 'package:edse_app/src/models/day.dart';
import 'package:edse_app/src/models/teacher_period.dart';

class DayTimeTable {
  late final DayModel dayName;
  late final List<TeacherPeriodModel> dayTimeTable;
  DayTimeTable.fromJson(parsedJson) {
    dayName = DayModel.fromJson(parsedJson["dayName"]);
    List<TeacherPeriodModel> tempDayTimeTable = [];
    for (var i = 0; i < parsedJson["dayTimeTable"].length; i++) {
      tempDayTimeTable
          .add(TeacherPeriodModel.fromJson(parsedJson["dayTimeTable"][i]));
    }
    dayTimeTable = tempDayTimeTable;
  }
}
