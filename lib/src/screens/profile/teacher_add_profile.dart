import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:edse_app/src/blocs/providers/add_profile/teacher.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:edse_app/src/models/course.dart';
import 'package:edse_app/src/models/role.dart';
import 'package:edse_app/src/models/transport.dart';
import 'package:edse_app/src/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';
import 'package:path/path.dart';

class AddTeacherProfile extends StatelessWidget {
  const AddTeacherProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final addTeacherProfileBloc = AddTeacherProfileProvider.of(context);

    return StreamBuilder(
      stream: addTeacherProfileBloc.preSelectionStream,
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Add student profile"),
              ),
              body: LoadingContainer());
        } else {
          //For multi select we need to convert the array to ItemModel array
          List courses = snapshot.data!["courses"];
          List transports = snapshot.data!["transports"];
          List roles = snapshot.data!["roles"];
          List<MultiSelectItem<CourseModel>> coursearr = [];
          List<MultiSelectItem<TransportModel>> transportarr = [];
          List<MultiSelectItem<RoleModel>> rolearr = [];
          for (var i = 0; i < courses.length; i++) {
            coursearr.add(MultiSelectItem(courses[i], courses[i].name));
          }
          for (var i = 0; i < transports.length; i++) {
            transportarr
                .add(MultiSelectItem(transports[i], transports[i].address));
          }
          for (var i = 0; i < roles.length; i++) {
            rolearr.add(MultiSelectItem(roles[i], roles[i].title));
          }

          //For Image
          final ImagePicker imagePicker = ImagePicker();

          void filePicker() async {
            try {
              final XFile? image =
                  await imagePicker.pickImage(source: ImageSource.gallery);
              File file = File(image!.path);
              addTeacherProfileBloc.addTeacherProfile({"file": file});
            } catch (error) {
              print(error);
            }
          }

          //For date
          void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
            // TODO: implement your code here
            addTeacherProfileBloc.addTeacherProfile({
              "birthday": DateTime.parse(args.value.startDate.toString())
                  .millisecondsSinceEpoch
                  .toString()
            });
          }

          //Submit function
          submit() async {
            return await addTeacherProfileBloc.submitProfile();
          }

          return Scaffold(
            appBar: AppBar(
              title: Text("Add teacher profile"),
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        onPressed: () {
                          filePicker();
                        },
                        child: Text('Upload profile photo'),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: StreamBuilder(
                          stream: addTeacherProfileBloc.teacherProfileAddStream,
                          builder: (context,
                              AsyncSnapshot<Map<String, dynamic>> snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!["file"] != nullptr) {
                              return Text(
                                  basename(snapshot.data!["file"].path));
                            }
                            return const Text("");
                          }),
                    ),
                    Container(margin: EdgeInsets.only(top: 20.0)),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select birthday",
                        style: TextStyle(
                            color: const Color(0xff808080), fontSize: 16.0),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SfDateRangePicker(
                        onSelectionChanged: _onSelectionChanged,
                        selectionMode: DateRangePickerSelectionMode.range,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        onChanged: ((value) => {
                              addTeacherProfileBloc
                                  .addTeacherProfile({"fullName": value})
                            }),
                        decoration:
                            InputDecoration(labelText: "Enter full name"),
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 10.0)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        onChanged: ((value) => {
                              addTeacherProfileBloc
                                  .addTeacherProfile({"address": value})
                            }),
                        decoration: InputDecoration(labelText: "Enter address"),
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 10.0)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        onChanged: ((value) => {
                              addTeacherProfileBloc
                                  .addTeacherProfile({"phoneNumber": value})
                            }),
                        decoration:
                            InputDecoration(labelText: "Enter phone number"),
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 10.0)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: StreamBuilder(
                        stream: addTeacherProfileBloc.teacherProfileAddStream,
                        builder: (context,
                            AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          return DropdownButton(
                            hint: const Text("Select gender"),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            value: snapshot.data == null
                                ? null
                                : snapshot.data!["gender"] == ""
                                    ? (null)
                                    : (snapshot.data!["gender"]),
                            items: const [
                              DropdownMenuItem(
                                value: "Male",
                                child: Text("Male"),
                              ),
                              DropdownMenuItem(
                                value: "Female",
                                child: Text("Female"),
                              ),
                              DropdownMenuItem(
                                value: "Others",
                                child: Text("Others"),
                              )
                            ],
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (value) {
                              addTeacherProfileBloc
                                  .addTeacherProfile({"gender": value});
                            },
                          );
                        },
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 20.0)),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select courses",
                        style: TextStyle(
                            color: const Color(0xff808080), fontSize: 17.0),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MultiSelectDialogField(
                        searchable: true,
                        searchHint: "Search courses",
                        searchIcon: Icon(Icons.search),
                        title: Text("Select Courses"),
                        items: coursearr,
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (List<CourseModel> values) {
                          String courses = "";
                          for (var i = 0; i < values.length; i++) {
                            courses += values[i].id;
                            courses += ",";
                          }
                          courses =
                              courses.substring(0, max(courses.length - 1, 0));
                          addTeacherProfileBloc
                              .addTeacherProfile({"courses": courses});
                        },
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 20.0)),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select transport address",
                        style: TextStyle(
                            color: const Color(0xff808080), fontSize: 17.0),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MultiSelectDialogField(
                        searchable: true,
                        searchHint: "Search address",
                        searchIcon: Icon(Icons.search),
                        title: Text("Select address"),
                        items: transportarr,
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (List<TransportModel> values) {
                          String transports = "";
                          for (var i = 0; i < values.length; i++) {
                            transports += values[i].id;
                            transports += ",";
                          }
                          transports = transports.substring(
                              0, max(transports.length - 1, 0));
                          addTeacherProfileBloc.addTeacherProfile(
                              {"transportAddress": transports});
                        },
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 20.0)),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Select roles",
                        style: TextStyle(
                            color: const Color(0xff808080), fontSize: 17.0),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MultiSelectDialogField(
                        searchable: true,
                        searchHint: "Search role",
                        searchIcon: Icon(Icons.search),
                        title: Text("Select roles"),
                        items: rolearr,
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (List<RoleModel> values) {
                          String roles = "";
                          for (var i = 0; i < values.length; i++) {
                            roles += values[i].id;
                            roles += ",";
                          }
                          roles = roles.substring(0, max(roles.length - 1, 0));
                          addTeacherProfileBloc
                              .addTeacherProfile({"role": roles});
                        },
                      ),
                    ),
                    Container(margin: EdgeInsets.only(top: 20.0)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: StreamBuilder(
                        stream: addTeacherProfileBloc.buttonValueStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data == "Loading") {
                            return CircularProgressIndicator();
                          }
                          return ElevatedButton(
                            onPressed: () async {
                              final res = await submit();
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
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
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
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
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
