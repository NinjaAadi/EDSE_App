import 'package:edse_app/src/blocs/providers/attendance.dart';
import 'package:edse_app/src/blocs/providers/class_students.dart';
import 'package:edse_app/src/blocs/providers/student_profile.dart';
import 'package:edse_app/src/models/profiles/student_profile.dart';
import 'package:edse_app/src/router/route_constants.dart';
import 'package:edse_app/src/widgets/spinner.dart';
import 'package:flutter/material.dart';

class ShowStudentList extends StatelessWidget {
  const ShowStudentList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final classStudentBloc = ClassStudentsProvider.of(context);
    final studentProfileBloc = StudentProfileProvider.of(context);
    final attendanceBloc = AttendanceProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student list"),
      ),
      body: StreamBuilder(
          stream: classStudentBloc.classStudentsStream,
          builder:
              (context, AsyncSnapshot<List<StudentProfileModel>> snapshot) {
            if (!snapshot.hasData) {
              return LoadingContainer();
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return showStudents(context, snapshot.data![index],
                        studentProfileBloc, attendanceBloc);
                  });
            }
          }),
    );
  }

  Widget showStudents(
      context, StudentProfileModel student, studentProfleBloc, attendanceBloc) {
    return ListTile(
      title: Text(student.fullName),
      subtitle: Text(student.id),
      trailing: Container(
        width: 150,
        child: Row(
          children: [
            StreamBuilder(
                stream: attendanceBloc.giveAttendanceStream,
                builder:
                    (context, AsyncSnapshot<Map<String?, String?>> snapshot) {
                  if (snapshot.hasData == true &&
                      snapshot.data![student.id] == "Loading") {
                    return Container(
                        child: CircularProgressIndicator(),
                        height: 30.0,
                        width: 30.0,
                        margin: EdgeInsets.only(left: 17.5));
                  } else {
                    return IconButton(
                        onPressed: () async {
                          final res = await attendanceBloc.addAttendanceStudent(
                              student.id, student.fullName);
                          final snackBar = SnackBar(
                            content: Text(res),
                            action: SnackBarAction(
                              label: 'Close',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: const Icon(Icons.check));
                  }
                }),
            StreamBuilder(
                stream: attendanceBloc.deleteAttendanceStream,
                builder:
                    (context, AsyncSnapshot<Map<String?, String?>> snapshot) {
                  if (snapshot.hasData == true &&
                      snapshot.data![student.id] == "Loading") {
                    return Container(
                        child: CircularProgressIndicator(),
                        height: 30.0,
                        width: 30.0,
                        margin: EdgeInsets.only(left: 17.5));
                  } else {
                    return IconButton(
                        onPressed: () async {
                          final res =
                              await attendanceBloc.deleteAttendanceStudent(
                                  student.id, student.fullName);
                          final snackBar = SnackBar(
                            content: Text(res),
                            action: SnackBarAction(
                              label: 'Close',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: const Icon(Icons.close_rounded));
                  }
                }),
            IconButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => popUp(context),
                );
                await studentProfleBloc.fetchProfileFromId(student.id);
                Navigator.pop(context);
                Navigator.pushNamed(context, StudentProfileRoute);
              },
              icon: const Icon(Icons.remove_red_eye_sharp),
            ),
          ],
        ),
      ),
    );
  }

  Widget popUp(BuildContext context) {
    return LoadingContainer();
  }
}
