import 'package:edse_app/src/blocs/providers/add_timetable/add_class_timetable.dart';
import 'package:edse_app/src/models/class.dart';
import 'package:edse_app/src/models/course.dart';
import 'package:search_choices/search_choices.dart';
import 'package:edse_app/src/models/day.dart';
import 'package:edse_app/src/models/time.dart';
import 'package:edse_app/src/widgets/spinner.dart';
import 'package:flutter/material.dart';

class AddClassTimeTable extends StatelessWidget {
  const AddClassTimeTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addClassTimeTableBloc = AddClassTimeTableProvider.of(context);

    //Add all the courses id to the map
    return StreamBuilder(
      stream: addClassTimeTableBloc.preDataStream,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Add class's timetable"),
            ),
            body: LoadingContainer(),
          );
        } else {
          return Scaffold(
              appBar: AppBar(
                title: const Text("Add class's timetable"),
              ),
              body: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter class id',
                      ),
                      onChanged: (value) {
                        addClassTimeTableBloc.addTeacherId(value);
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
                            addClassTimeTableBloc,
                            snapshot.data!["times"],
                            snapshot.data!["courses"]);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: submitButton(context, addClassTimeTableBloc),
                  ),
                  //Dummy Container for listening to stream
                  StreamBuilder(
                    stream: addClassTimeTableBloc.addClassTimeTableStream,
                    builder: (context, snapshot) => Container(),
                  )
                ],
              ));
        }
      },
    );
  }

  Widget dayTimeTable(DayModel day, addClassTimeTableBloc,
      List<TimeModel> timeArr, List<CourseModel> courses) {
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
            child:
                dayTimeTableForm(day, timeArr, courses, addClassTimeTableBloc),
          )
        ],
      ),
    );
  }

  Widget dayTimeTableForm(day, List<TimeModel> timeArr,
      List<CourseModel> courses, addClassTimeTableBloc) {
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
                          day, timeArr[i], courses, addClassTimeTableBloc),
                    ),
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
      List<CourseModel> listData, addClassTimeTableBloc) {
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

        addClassTimeTableBloc.addClassTimeTable(data);
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

  Widget submitButton(context, addClassTimeTableBloc) {
    return Align(
        alignment: Alignment.centerLeft,
        child: StreamBuilder(
          stream: addClassTimeTableBloc.buttonStateStream,
          builder: (context, snapshot) {
            print(snapshot.data);
            if (snapshot.data != null && snapshot.data == "loading") {
              return CircularProgressIndicator();
            } else {
              return ElevatedButton(
                onPressed: () async {
                  final res = await addClassTimeTableBloc.submitTimeTable();
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
