import 'package:edse_app/src/models/teacher_period.dart';
import 'package:edse_app/src/models/teacher_time_table.dart';
import 'package:edse_app/src/widgets/spinner.dart';
import 'package:flutter/material.dart';
import '../../blocs/providers/teacher_time_table.dart';

class TimeTable extends StatelessWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacherTimeTableBloc = TeacherTimeTableProvider.of(context);
    return StreamBuilder(
      stream: teacherTimeTableBloc.teacherTimeTableStream,
      builder: (context, AsyncSnapshot<TeacherTimeTableModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        } else {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(24.0),
            itemCount: snapshot.data!.timeTable.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10.0),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      snapshot.data!.timeTable[index].dayName.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(13.0),
                  ),
                  showTable(snapshot.data!.timeTable[index].dayTimeTable)
                ],
              );
            },
          );
        }
      },
    );
  }

  Widget showTable(List<TeacherPeriodModel> dayTimeTable) {
    final List<TableRow> children = [];
    children.add(const TableRow(children: [
      Text(
        "Time",
        style: TextStyle(fontSize: 18),
      ),
      Text(
        "Class",
        style: TextStyle(fontSize: 18),
      ),
      Text(
        "Course",
        style: TextStyle(fontSize: 18),
      ),
    ]));
    children.add(TableRow(children: [
      Container(
        padding: const EdgeInsets.all(5),
      ),
      Container(
        padding: const EdgeInsets.all(5),
      ),
      Container(
        padding: const EdgeInsets.all(5),
      )
    ]));
    for (var i = 0; i < dayTimeTable.length; i++) {
      children.add(TableRow(children: [
        Row(
          children: [
            Text(dayTimeTable[i].time.startTime),
            const Text("-"),
            Text(dayTimeTable[i].time.endTime),
          ],
        ),
        Text(dayTimeTable[i].className.name),
        Text(dayTimeTable[i].subject.name)
      ]));
    }
    return Table(
      children: children,
    );
  }
}
