import 'package:edse_app/src/blocs/providers/add_timetable/add_class_timetable.dart';
import 'package:edse_app/src/blocs/providers/add_timetable/add_teacher_timetable.dart';
import 'package:edse_app/src/router/route_constants.dart';
import 'package:flutter/material.dart';

class AddTimeTable extends StatelessWidget {
  const AddTimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addTeacherTimeTableBloc = AddTeacherTimeTableProvider.of(context);
    final addClassTimeTableBloc = AddClassTimeTableProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Add Time Table")),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 140.0),
          child: Column(
            children: [
              addClassTimeTable(context, addClassTimeTableBloc),
              Container(margin: const EdgeInsets.only(top: 25.0)),
              addTeacherTimeTable(context, addTeacherTimeTableBloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget addClassTimeTable(context, addClassTimeTableBloc) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton.icon(
        onPressed: () async {
          addClassTimeTableBloc.fetchInitialDetails();
          Navigator.pushNamed(context, AddTimeTableForClassRoute);
        },
        icon: const Icon(
          Icons.people,
        ),
        label: const Text("Class"),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(160, 50),
        ),
        //.........
      ),
    );
  }

  Widget addTeacherTimeTable(context, addTeacherTimeTableBloc) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton.icon(
        onPressed: () async {
          addTeacherTimeTableBloc.fetchInitialDetails();
          Navigator.pushNamed(context, AddTimeTableForTeacherRoute);
        },
        icon: const Icon(
          Icons.people,
        ),
        label: Text("Teacher"),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(160, 50),
        ),
        //.........
      ),
    );
  }
}
