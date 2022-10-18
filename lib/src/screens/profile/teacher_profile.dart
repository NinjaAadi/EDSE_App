import 'package:edse_app/src/blocs/providers/teacher_profile.dart';
import 'package:edse_app/src/models/profiles/teacher_profile.dart';
import 'package:edse_app/src/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TeacherProfile extends StatelessWidget {
  const TeacherProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teacherProfileBloc = TeacherProfileProvider.of(context);
    return StreamBuilder(
      stream: teacherProfileBloc.teacherProfileStream,
      builder: (context, AsyncSnapshot<TeacherProfileModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        } else {
          return ProfileContainer(snapshot.data);
        }
      },
    );
  }

  Widget ProfileContainer(TeacherProfileModel? teacherProfile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(margin: const EdgeInsets.only(top: 50.0)),
          ProfilePic(teacherProfile!.profileImageURL, teacherProfile.fullName),
          Container(margin: const EdgeInsets.only(top: 20.0)),
          KeyValueDisplay("Birthday", getDate(teacherProfile.birthDay)),
          KeyValueDisplay("Address", teacherProfile.address),
          KeyValueDisplay("Phone Number", teacherProfile.phoneNumber),
          KeyValueDisplay("Address", teacherProfile.address),
          KeyValueDisplay("Gender", teacherProfile.gender),
          CourseDisplay("Courses", teacherProfile.courses),
          RoleDisplay("Roles", teacherProfile.role)
        ],
      ),
    );
  }

  Widget ProfilePic(String url, String name) {
    return Center(
        child: Column(
      children: [
        CircleAvatar(
          child: ClipOval(
            child: Image.network(
                "${dotenv.env["API_HOST"]}/images/profiles/" + url,
                width: 118,
                height: 118,
                fit: BoxFit.cover),
          ),
          minRadius: 60.0,
        ),
        Container(margin: const EdgeInsets.only(top: 20.0)),
        Text(name, style: TextStyle(fontSize: 20))
      ],
    ));
  }

  Widget KeyValueDisplay(String key, String value) {
    return Container(
      padding: EdgeInsets.all(25.0),
      child: Column(children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Text(
              key,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Text(
              value,
            ),
          ),
        )
      ]),
    );
  }

  Widget CourseDisplay(String key, value) {
    List<Widget> children = [];
    for (var i = 0; i < value.length; i++) {
      children.add(Container(
        decoration: new BoxDecoration(color: Colors.blue[600]),
        padding: EdgeInsets.all(10.0),
        child: Text(
          value[i].subjectCode,
          style: TextStyle(color: Colors.white),
        ),
        margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
      ));
    }
    return Container(
        padding: EdgeInsets.all(25.0),
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                key,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: Wrap(
                direction: Axis.horizontal,
                children: children,
              ),
            ),
          )
        ]));
  }

  Widget RoleDisplay(String key, value) {
    List<Widget> children = [];
    for (var i = 0; i < value.length; i++) {
      children.add(Container(
        decoration: new BoxDecoration(color: Colors.blue[600]),
        padding: EdgeInsets.all(10.0),
        child: Text(
          value[i].title,
          style: TextStyle(color: Colors.white),
        ),
        margin: EdgeInsets.only(right: 10.0, bottom: 10.0),
      ));
    }
    return Container(
        padding: EdgeInsets.all(25.0),
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: Text(
                key,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(top: 15.0),
              child: Wrap(
                direction: Axis.horizontal,
                children: children,
              ),
            ),
          )
        ]));
  }

  String getDate(String noticeDate) {
    final finalNoticeDate = DateTime.parse("2022-02-19T11:13:42.125+00:00");
    return "${finalNoticeDate.day}" +
        "/" +
        "${finalNoticeDate.month}" +
        "/"
            "${finalNoticeDate.year}";
  }
}
