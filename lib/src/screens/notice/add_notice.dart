import 'dart:ffi';
import 'dart:io';
import 'package:edse_app/src/blocs/blocs/add_notice.dart';
import 'package:edse_app/src/blocs/providers/add_notice.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:core';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddNotice extends StatelessWidget {
  const AddNotice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddNoticeBloc addNoticeBloc = AddNoticeProvider.of(context);
    //For Image
    final ImagePicker imagePicker = ImagePicker();

    void filePicker() async {
      try {
        final XFile? image =
            await imagePicker.pickImage(source: ImageSource.gallery);
        File file = File(image!.path);
        addNoticeBloc.addNotice({"file": file});
      } catch (error) {
        print(error);
      }
    }

    //For date
    void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
      addNoticeBloc.addNotice({
        "date": DateTime.parse(args.value.startDate.toString())
            .millisecondsSinceEpoch
            .toString()
      });
    }

    //Submit function
    submit() async {
      //print("hello");
      return await addNoticeBloc.submitNotice();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Notice"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: StreamBuilder(
                  stream: addNoticeBloc.addNoticeStream,
                  builder:
                      (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    return DropdownButton(
                      value: snapshot.data == null
                          ? null
                          : snapshot.data!["forWhich"] == ""
                              ? (null)
                              : (snapshot.data!["forWhich"]),
                      underline: Container(
                        height: 1,
                        color: Colors.grey[600],
                      ),
                      focusColor: Colors.blue[600],
                      isExpanded: true,
                      hint: Container(
                        child: const Text("Enter person type"),
                        margin: const EdgeInsets.only(bottom: 25.0),
                      ),
                      items: <String>[
                        "Student",
                        "Teacher",
                        "All",
                        "NonTeachingStaff",
                      ].map((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Colors.grey[800]),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        addNoticeBloc.addNotice({"forWhich": value as dynamic});
                      },
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    filePicker();
                  },
                  child: Text('Upload notice photo'),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: StreamBuilder(
                  stream: addNoticeBloc.addNoticeStream,
                  builder:
                      (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.hasData && snapshot.data!["file"] != nullptr) {
                      return Text(basename(snapshot.data!["file"].path));
                    }
                    return const Text("");
                  },
                ),
              ),
              Container(margin: EdgeInsets.only(top: 10.0)),
              Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  onChanged: ((value) => {
                        addNoticeBloc.addNotice({"heading": value}),
                      }),
                  decoration: const InputDecoration(labelText: "Enter heading"),
                ),
              ),
              Container(margin: EdgeInsets.only(top: 10.0)),
              Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  onChanged: ((value) => {
                        addNoticeBloc.addNotice({"body": value}),
                      }),
                  decoration: const InputDecoration(labelText: "Enter body"),
                ),
              ),
              Container(margin: EdgeInsets.only(top: 25.0)),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select date",
                  style:
                      TextStyle(color: const Color(0xff808080), fontSize: 16.0),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SfDateRangePicker(
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                ),
              ),
              Container(margin: EdgeInsets.only(top: 10.0)),
              Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  onChanged: ((value) => {
                        addNoticeBloc.addNotice({"signedBy": value}),
                      }),
                  decoration:
                      const InputDecoration(labelText: "Enter signedBy's id"),
                ),
              ),
              Container(margin: EdgeInsets.only(top: 10.0)),
              Align(
                alignment: Alignment.centerLeft,
                child: StreamBuilder(
                  stream: addNoticeBloc.buttonValueStream,
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
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget popUp(BuildContext context, String? msg) {
    return AlertDialog(
      title: const Text('Failed to add notice'),
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
