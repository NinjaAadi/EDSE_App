import 'package:edse_app/src/blocs/blocs/add_course.dart';
import 'package:edse_app/src/blocs/providers/add_course.dart';
import 'package:flutter/material.dart';

class AddCourse extends StatelessWidget {
  const AddCourse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddCourseBloc addCourseBloc = AddCourseProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add course"),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(15.0),
            ),
            TextField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter course name',
              ),
              onChanged: (value) {
                addCourseBloc.addCourse({"name": value});
              },
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
            ),
            TextField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter course code',
              ),
              onChanged: (value) {
                addCourseBloc.addCourse({"subjectCode": value});
              },
            ),
            Container(
              margin: EdgeInsets.all(15.0),
            ),
            TextField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter course description',
              ),
              onChanged: (value) {
                addCourseBloc.addCourse({"description": value});
              },
            ),
            StreamBuilder(
              stream: addCourseBloc.addCourseStream,
              builder: (context, snapshot) {
                return Container();
              },
            ),
            Container(
              margin: EdgeInsets.all(15.0),
            ),
            StreamBuilder(
              stream: addCourseBloc.submitButtonDetailStream,
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.data == "loading") {
                  return CircularProgressIndicator();
                } else {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () async {
                        final res = await addCourseBloc.submit();
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
                      child: Text("Submit"),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget popUp(BuildContext context, String? msg) {
    return AlertDialog(
      title: const Text('Adding course failed'),
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
