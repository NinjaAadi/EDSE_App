import 'package:edse_app/src/blocs/providers/add_profile/non_teaching_staff.dart';
import 'package:edse_app/src/blocs/providers/add_profile/student.dart';
import 'package:edse_app/src/blocs/providers/add_profile/teacher.dart';
import 'package:edse_app/src/router/route_constants.dart';
import 'package:flutter/material.dart';

class AddProfile extends StatelessWidget {
  const AddProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addStudentProfileBloc = AddStudentProfileProvider.of(context);
    final addTeacherProfileBloc = AddTeacherProfileProvider.of(context);
    final addNonTeachingStaffProfileBloc =
        AddNonTeachingStaffProfileProvider.of(context);
    AddTeacherProfileProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Add Profile")),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 140.0),
          child: Column(
            children: [
              addStudentProfile(context, addStudentProfileBloc),
              Container(margin: const EdgeInsets.only(top: 25.0)),
              addTeacherProfile(context, addTeacherProfileBloc),
              Container(margin: const EdgeInsets.only(top: 25.0)),
              addNonTeachingStaffProfile(
                  context, addNonTeachingStaffProfileBloc)
            ],
          ),
        ),
      ),
    );
  }

  Widget addStudentProfile(context, addStudentProfileBloc) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton.icon(
        onPressed: () async {
          addStudentProfileBloc.fetchInitialDetails("Student");
          Navigator.pushNamed(context, AddStudentProfileRoute);
        },
        icon: const Icon(
          Icons.people,
        ),
        label: Text("Student"),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(160, 50),
        ),
        //.........
      ),
    );
  }

  Widget addTeacherProfile(context, addTeacherProfileBloc) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton.icon(
        onPressed: () async {
          addTeacherProfileBloc.fetchInitialDetails("Teacher");
          Navigator.pushNamed(context, AddTeacherProfileRoute);
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

  Widget addNonTeachingStaffProfile(context, addNonTeachingStaffProfileBloc) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton.icon(
        onPressed: () async {
          addNonTeachingStaffProfileBloc
              .fetchInitialDetails("NonTeachingStaff");
          Navigator.pushNamed(context, AddNonTeachingStaffProfileRoute);
        },
        icon: const Icon(
          Icons.people,
        ),
        label: Text("NTS"),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(160, 50),
        ),
        //.........
      ),
    );
  }
}
