import 'package:edse_app/src/models/day_time_table.dart';

class TeacherTimeTableModel {
  late final String id;
  late final List<DayTimeTable> timeTable;
  TeacherTimeTableModel.fromJson(parsedJson) {
    id = parsedJson["_id"];
    List<DayTimeTable> tempListForTimeTable = [];
    for (var i = 0; i < parsedJson["timeTable"].length; i++) {
      if (parsedJson["timeTable"][i]["dayName"] == null) {
        continue;
      }
      tempListForTimeTable
          .add(DayTimeTable.fromJson(parsedJson["timeTable"][i]));
    }
    timeTable = tempListForTimeTable;
  }
}
