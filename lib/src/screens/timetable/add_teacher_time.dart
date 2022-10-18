import 'package:edse_app/src/models/class.dart';
import 'package:edse_app/src/models/course.dart';
import 'package:edse_app/src/blocs/providers/add_timetable/add_teacher_timetable.dart';
import 'package:search_choices/search_choices.dart';
import 'package:edse_app/src/models/day.dart';
import 'package:edse_app/src/models/time.dart';
import 'package:edse_app/src/widgets/spinner.dart';
import 'package:flutter/material.dart';

class AddTeacherTimeTable extends StatelessWidget {
  const AddTeacherTimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addTeacherTimeTableBloc = AddTeacherTimeTableProvider.of(context);

    //Add all the courses id to the map
    return StreamBuilder(
      stream: addTeacherTimeTableBloc.preDataStream,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Add teacher's timetable"),
            ),
            body: LoadingContainer(),
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Add teacher's timetable"),
              ),
              body: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter teacher id',
                      ),
                      onChanged: (value) {
                        addTeacherTimeTableBloc.addTeacherId(value);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!["days"].length,
                      itemBuilder: (context, index) {
                        return dayTimeTable(
                            snapshot.data!["days"][index],
                            addTeacherTimeTableBloc,
                            snapshot.data!["times"],
                            snapshot.data!["courses"],
                            snapshot.data!["classes"]);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: submitButton(context, addTeacherTimeTableBloc),
                  ),
                  //Dummy Container for listening to stream
                  StreamBuilder(
                    stream: addTeacherTimeTableBloc.addTeacherTimeTableStream,
                    builder: (context, snapshot) => Container(),
                  )
                ],
              ));
        }
      },
    );
  }

  Widget dayTimeTable(
      DayModel day,
      addteacherTimeTableBloc,
      List<TimeModel> timeArr,
      List<CourseModel> courses,
      List<ClassModel> classes) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              day.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 25.0),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: dayTimeTableForm(
                day, timeArr, courses, classes, addteacherTimeTableBloc),
          )
        ],
      ),
    );
  }

  Widget dayTimeTableForm(
      day,
      List<TimeModel> timeArr,
      List<CourseModel> courses,
      List<ClassModel> classes,
      addTeacherTimeTableBloc) {
    final List<Widget> children = [];
    for (var i = 0; i < timeArr.length; i++) {
      children.add(
        Row(
          children: <Widget>[
            Expanded(
                child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                ),
                Row(
                  children: [
                    Text(
                      timeArr[i].endTime,
                      style: TextStyle(fontSize: 17),
                    ),
                    Text("-"),
                    Text(
                      timeArr[i].endTime,
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: getSearchableDropdown(
                          day, timeArr[i], courses, addTeacherTimeTableBloc),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: getSearchableDropdownForClass(
                          day, timeArr[i], classes, addTeacherTimeTableBloc),
                    )
                  ],
                ),
              ],
            )),
          ],
        ),
      );
    }
    return Column(
      children: children,
    );
  }

  Widget getSearchableDropdown(DayModel day, TimeModel currTime,
      List<CourseModel> listData, addTeacherTimeTableBloc) {
    List<DropdownMenuItem> items = [];
    for (var i = 0; i < listData.length; i++) {
      items.add(
        DropdownMenuItem(
          child: Text(listData[i].name),
          value: listData[i],
        ),
      );
    }
    return SearchChoices.single(
      items: items,
      hint: "Select courses",
      searchHint: "Select courses",
      onChanged: (value) {
        Map<String, Map<String, String>> data = {};
        data["course"] = {
          "dayId": day.id,
          "time": currTime.id,
          "courseId": value.id
        };

        addTeacherTimeTableBloc.addTeacherTimeTable(data);
      },
      isExpanded: true,
      searchFn: (String keyword, items) {
        List<int> ret = [];
        if (items != null && keyword.isNotEmpty) {
          keyword.split(" ").forEach((k) {
            int i = 0;
            items.forEach((item) {
              if (!ret.contains(i) &&
                  k.isNotEmpty &&
                  (item.value.name
                      .toString()
                      .toLowerCase()
                      .contains(k.toLowerCase()))) {
                ret.add(i);
              }
              i++;
            });
          });
        }
        if (keyword.isEmpty) {
          ret = Iterable<int>.generate(items.length).toList();
        }
        return (ret);
      },
    );
  }

  Widget getSearchableDropdownForClass(DayModel day, TimeModel currTime,
      List<ClassModel> listData, addteacherTimeTableBloc) {
    List<DropdownMenuItem> items = [];
    for (var i = 0; i < listData.length; i++) {
      items.add(
        DropdownMenuItem(
          child: Text(listData[i].name),
          value: listData[i],
        ),
      );
    }
    return SearchChoices.single(
      items: items,
      hint: "Select class",
      searchHint: "Select class",
      onChanged: (value) {
        Map<String, Map<String, String>> data = {};
        data["class"] = {
          "dayId": day.id,
          "time": currTime.id,
          "className": value.id
        };

        addteacherTimeTableBloc.addTeacherTimeTable(data);
      },
      isExpanded: true,
      searchFn: (String keyword, items) {
        List<int> ret = [];
        if (items != null && keyword.isNotEmpty) {
          keyword.split(" ").forEach((k) {
            int i = 0;
            items.forEach((item) {
              if (!ret.contains(i) &&
                  k.isNotEmpty &&
                  (item.value.name
                      .toString()
                      .toLowerCase()
                      .contains(k.toLowerCase()))) {
                ret.add(i);
              }
              i++;
            });
          });
        }
        if (keyword.isEmpty) {
          ret = Iterable<int>.generate(items.length).toList();
        }
        return (ret);
      },
    );
  }

  Widget submitButton(context, addTeacherTimeTableBloc) {
    return Align(
        alignment: Alignment.centerLeft,
        child: StreamBuilder(
          stream: addTeacherTimeTableBloc.buttonStateStream,
          builder: (context, snapshot) {
            print(snapshot.data);
            if (snapshot.data != null && snapshot.data == "loading") {
              return CircularProgressIndicator();
            } else {
              return ElevatedButton(
                onPressed: () async {
                  final res = await addTeacherTimeTableBloc.submitTimeTable();
                  final snackBar = SnackBar(
                    content: Text(res["messege"]),
                    action: SnackBarAction(
                      label: 'Close',
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  );
                  if (res["success"] == true) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          popUp(context, res["messege"]),
                    );
                  }
                },
                child: const Text("Submit"),
              );
            }
          },
        ));
  }

  Widget popUp(BuildContext context, String? msg) {
    return AlertDialog(
      title: const Text('Login Failed'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(msg!,
              style: TextStyle(
                color: Colors.red[400],
              )),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Close',
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
