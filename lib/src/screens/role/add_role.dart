import 'package:edse_app/src/blocs/blocs/add_role.dart';
import 'package:edse_app/src/blocs/blocs/add_transport.dart';
import 'package:edse_app/src/blocs/providers/add_role.dart';
import 'package:edse_app/src/blocs/providers/add_transport.dart';
import 'package:flutter/material.dart';

class AddRole extends StatelessWidget {
  const AddRole({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddRoleBloc addRoleBloc = AddRoleProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add role"),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter role title',
              ),
              onChanged: (value) {
                addRoleBloc.addRoleDetail({"title": value});
              },
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
            ),
            StreamBuilder(
              stream: addRoleBloc.addRoleStream,
              builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
                return DropdownButton(
                  value: snapshot.data == null
                      ? null
                      : snapshot.data!["roleFor"] == ""
                          ? (null)
                          : (snapshot.data!["roleFor"]),
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
                    "NonTeachingStaff",
                    "Admin",
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
                    addRoleBloc.addRoleDetail({"roleFor": value as String});
                  },
                );
              },
            ),
            StreamBuilder(
              stream: addRoleBloc.buttonDetailsStream,
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.data == "loading") {
                  return CircularProgressIndicator();
                } else {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () async {
                        final res = await addRoleBloc.submit();
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
