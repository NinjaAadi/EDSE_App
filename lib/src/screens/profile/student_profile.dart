import 'package:edse_app/src/blocs/providers/student_profile.dart';
import 'package:edse_app/src/models/attendance.dart';
import 'package:edse_app/src/models/profiles/student_profile.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:edse_app/src/widgets/spinner.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentProfileBloc = StudentProfileProvider.of(context);
    return StreamBuilder(
      stream: studentProfileBloc.studentProfileStream,
      builder: (context, AsyncSnapshot<StudentProfileModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        } else {
          return ProfileContainer(snapshot.data);
        }
      },
    );
  }

  Widget ProfileContainer(StudentProfileModel? studentProfile) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(margin: const EdgeInsets.only(top: 50.0)),
            ProfilePic(
                studentProfile!.profileImageURL, studentProfile.fullName),
            Container(margin: const EdgeInsets.only(top: 20.0)),
            PercentageIndicator("Attendance", studentProfile.attendance),
            KeyValueDisplay("Birthday", getDate(studentProfile.birthDay)),
            KeyValueDisplay("Address", studentProfile.address),
            KeyValueDisplay("Phone Number", studentProfile.phoneNumber),
            KeyValueDisplay("Gender", studentProfile.gender),
            KeyValueDisplay("Father's Name", studentProfile.fatherName),
            KeyValueDisplay("Mother's Name", studentProfile.motherName),
            KeyValueDisplay("Parent's Number", studentProfile.parentNumber),
            KeyValueDisplay("ClassName", studentProfile.className),
            CourseDisplay("Courses", studentProfile.courses),
            RoleDisplay("Roles", studentProfile.role),
            AddressDisplay("Transport", studentProfile.transport)
          ],
        ),
      ),
    );
  }

  Widget PercentageIndicator(String key, List<AttendanceModel> value) {
    double percentage = 0;
    for (var i = 0; i < value.length; i++) {
      if (value[i].isPresent == true) percentage++;
    }
    if (value.isNotEmpty) {
      percentage /= value.length;
    }
    percentage *= 100.0;
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
          Container(
            margin: EdgeInsets.only(top: 20.0),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: CircularPercentIndicator(
              radius: 35.0,
              lineWidth: 3.0,
              percent: percentage / 100,
              center: new Text("${percentage.toStringAsFixed(2)}%"),
              progressColor: Colors.blue[500],
            ),
          )
        ]));
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

  Widget AddressDisplay(String key, value) {
    List<Widget> children = [];
    for (var i = 0; i < value.length; i++) {
      children.add(Container(
        decoration: new BoxDecoration(color: Colors.blue[600]),
        padding: EdgeInsets.all(10.0),
        child: Text(
          value[i].address,
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
          ),
          (() {
            if (value.length == 0) {
              return const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("No transports registered"));
            } else {
              return const SizedBox.shrink();
            }
          }())
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
