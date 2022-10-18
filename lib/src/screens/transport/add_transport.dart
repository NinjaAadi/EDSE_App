import 'package:edse_app/src/blocs/blocs/add_transport.dart';
import 'package:edse_app/src/blocs/providers/add_transport.dart';
import 'package:flutter/material.dart';

class AddTransport extends StatelessWidget {
  const AddTransport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AddTransportBloc addTransportBloc = AddTransportProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add course"),
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter transport address',
              ),
              onChanged: (value) {
                addTransportBloc.addTransportDetails({"address": value});
              },
            ),
            Container(
              margin: const EdgeInsets.all(15.0),
            ),
            TextField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter pin code',
              ),
              onChanged: (value) {
                addTransportBloc.addTransportDetails({"pinCode": value});
              },
            ),
            Container(
              margin: EdgeInsets.all(15.0),
            ),
            StreamBuilder(
              stream: addTransportBloc.addTransportStream,
              builder: (context, snapshot) {
                return Container();
              },
            ),
            StreamBuilder(
              stream: addTransportBloc.buttonDetailsStream,
              builder: (context, snapshot) {
                if (snapshot.data != null && snapshot.data == "loading") {
                  return CircularProgressIndicator();
                } else {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () async {
                        final res = await addTransportBloc.submit();
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
