import '../blocs/providers/login.dart';
import 'package:edse_app/src/screens/teacher/home.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../blocs/providers/teacher_profile.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final loginBloc = LoginProvider.of(context);
    final teacherProfileBloc = TeacherProfileProvider.of(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          automaticallyImplyLeading: false,
        ),
        body: Container(
            margin: const EdgeInsets.all(30.0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                startLogo(),
                enterId(loginBloc),
                enterPassword(loginBloc),
                Container(
                  padding: const EdgeInsets.all(10.0),
                ),
                dropDownForType(loginBloc),
                Container(
                  padding: const EdgeInsets.all(8.0),
                ),
                submitButton(context, loginBloc, teacherProfileBloc),
              ],
            ))));
  }

//For student/teacher/non-teaching-staff
  Widget startLogo() {
    return Center(
      child: Container(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text('EDSE Manager', style: TextStyle(fontSize: 30)),
            Icon(Icons.school, size: 60, color: Colors.blue[500]),
          ],
        ),
        margin: const EdgeInsets.only(top: 20.0),
        padding: const EdgeInsets.all(30.0),
      ),
    );
  }

  //User Id
  Widget enterId(loginBloc) {
    return StreamBuilder(
        stream: loginBloc.loginStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: ((value) => {
                  loginBloc.addLoginCredentials({"Id": value})
                }),
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your id',
              hintText: 'Id',
              suffixIcon: Icon(Icons.account_circle_outlined),
            ),
          );
        });
  }

  //Password;
  Widget enterPassword(loginBloc) {
    return StreamBuilder(
        stream: loginBloc.loginStream,
        builder: (context, snapshot) {
          return TextFormField(
            onChanged: ((value) => {
                  loginBloc.addLoginCredentials({"Password": value})
                }),
            obscureText: true,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your password',
                hintText: 'Password',
                suffixIcon: Icon(Icons.password)),
          );
        });
  }

  Widget dropDownForType(loginBloc) {
    return StreamBuilder(
      stream: loginBloc.loginStream,
      builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
        return DropdownButton(
          value: snapshot.data == null
              ? null
              : snapshot.data!["For"] == ""
                  ? (null)
                  : (snapshot.data!["For"]),
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
            'student',
            'teacher',
            'nonTeachingStaff',
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
            loginBloc.addLoginCredentials({"For": value as String});
          },
        );
      },
    );
  }

  Widget submitButton(context, loginBloc, teacherProfileBloc) {
    return StreamBuilder(
        stream: loginBloc.loginStream,
        builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
          if (snapshot.hasData &&
              snapshot.data!["isLoading"] != null &&
              snapshot.data!["isLoading"] == "true") {
            return const CircularProgressIndicator();
          }
          return ElevatedButton.icon(
            onPressed: () async {
              var isLoginSuccessObj = await loginBloc.login();
              print(isLoginSuccessObj["messege"]);
              if (isLoginSuccessObj["success"] == false) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      popUp(context, isLoginSuccessObj["messege"]),
                );
              } else {
                final loginObj = Hive.box("loginObj");
                if (loginObj.get('forDept') == "teacher") {
                  await teacherProfileBloc.fetchProfile();
                }
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const AdminHome(),
                  ),
                );
              }
            },
            icon: const Icon(Icons.login), //icon data for elevated button
            label: Container(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: const Text("Login"),
            ), //label text
          );
        });
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
