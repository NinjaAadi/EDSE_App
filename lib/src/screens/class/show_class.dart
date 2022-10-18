import 'package:edse_app/src/blocs/blocs/class_students.dart';
import 'package:edse_app/src/blocs/providers/fetch_class.dart';
import 'package:edse_app/src/models/class.dart';
import 'package:edse_app/src/router/route_constants.dart';
import 'package:edse_app/src/widgets/spinner.dart';
import 'package:flutter/material.dart';
import '../../blocs/providers/class_students.dart';

class TeacherClasses extends StatelessWidget {
  const TeacherClasses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchClassBloc = FetchClassProvider.of(context);
    final classStudentBloc = ClassStudentsProvider.of(context);

    return Scaffold(
        appBar: AppBar(title: const Text('My classes')),
        body: Container(
          child: StreamBuilder(
            stream: fetchClassBloc.classesForTeacherStream,
            builder: (context, AsyncSnapshot<List<ClassModel>> snapshot) {
              if (!snapshot.hasData) {
                return LoadingContainer();
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTileWidget(
                        context, snapshot.data![index], classStudentBloc);
                  },
                );
              }
            },
          ),
        ));
  }

  Widget ListTileWidget(context, ClassModel classItem, classStudentBloc) {
    return ListTile(
      trailing: Container(
          width: 50,
          child: Row(children: [
            Expanded(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      await classStudentBloc
                          .addClassStudents(classItem.students);
                      Navigator.pushNamed(context, ShowAllStudentsForClass);
                    },
                    icon: const Icon(Icons.remove_red_eye_outlined),
                  ),
                ],
              ),
            )
          ])),
      title: Text(classItem.name),
    );
  }
}
