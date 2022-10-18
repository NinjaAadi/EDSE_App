import 'package:edse_app/src/blocs/providers/fetch_class.dart';
import 'package:edse_app/src/router/route_constants.dart';
import 'package:edse_app/src/screens/notice/notice.dart';
import '../../screens/login.dart';
import '../../screens/profile/teacher_profile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../transport/transport.dart';
import '../timetable/teacher_timetable.dart';
import '../../blocs/providers/teacher_time_table.dart';
import '../../blocs/providers/notice.dart';
import '../../blocs/providers/transport.dart';
import '../../blocs/providers/teacher_profile.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  //List of Widgets to show
  static List<Widget> widgetOptions = <Widget>[
    TeacherProfile(),
    Notice(),
    Transport(),
    TimeTable()
  ];
  int selectedIndex = 0;
  onItemTapped(int index, context, transportBloc, noticeBloc,
      teacherTimeTableBloc, teacherProfileBloc) {
    final loginObj = Hive.box('loginObj');
    if (loginObj.get("jwt") == null) {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const Login(),
        ),
      );
      return;
    }
    switch (index) {
      case 0:
        {
          //This is to be done when the user logins to get the initial data
          teacherProfileBloc.fetchProfile();
        }
        break;
      case 1:
        {
          //noticeBloc.fetchNotice("All");
        }
        break;
      case 2:
        {
          transportBloc.fetchTransport();
        }
        break;
      case 3:
        {
          teacherTimeTableBloc.fetchTimeTable();
        }
    }
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transportBloc = TransportProvider.of(context);
    final noticeBloc = NoticeProvider.of(context);
    final teacherTimeTableBloc = TeacherTimeTableProvider.of(context);
    final teacherProfileBloc = TeacherProfileProvider.of(context);
    final fetchClassBloc = FetchClassProvider.of(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Admin Home"),
        ),
        endDrawer: DrawerOpener(context, fetchClassBloc),
        bottomNavigationBar: BottomNavBar(
            context,
            selectedIndex,
            onItemTapped,
            transportBloc,
            noticeBloc,
            teacherTimeTableBloc,
            teacherProfileBloc),
        body: widgetOptions.elementAt(selectedIndex));
  }

  Widget BottomNavBar(context, selectedIndex, onItemTapped, transportBloc,
      noticeBloc, teacherTimeTableBloc, teacherProfileBloc) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_outlined),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.document_scanner_outlined),
          label: 'Notice',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_transportation_outlined),
          label: 'Transport',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.backup_table_outlined),
          label: 'Time Table',
        ),
      ],
      selectedItemColor: Colors.blue[400],
      currentIndex: selectedIndex,
      onTap: ((index) {
        onItemTapped(index, context, transportBloc, noticeBloc,
            teacherTimeTableBloc, teacherProfileBloc);
      }),
    );
  }

  Widget DrawerOpener(context, fetchClassBloc) {
    return Drawer(
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.only(right: 15.0, top: 35.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'X',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              )),
          Expanded(
              flex: 2,
              child: ListView(children: [
                (() {
                  if (Hive.box("loginObj").get('forDept') == "teacher") {
                    return ListTile(
                      leading: Icon(Icons.airplay_sharp),
                      title: Text("My classes"),
                      onTap: () async {
                        await fetchClassBloc.fetchAllClasses();
                        Navigator.pushNamed(context, ShowAllClass);
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }()),
                ListTile(
                  title: const Text("Search student/teacher"),
                  leading: const Icon(Icons.search),
                  onTap: () async {},
                ),
                (() {
                  if (true) {
                    return ListTile(
                      leading: Icon(Icons.people),
                      title: Text("Add profile"),
                      onTap: () async {
                        Navigator.pushNamed(context, AddProfileRoute);
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }()),
                (() {
                  if (true) {
                    return ListTile(
                      leading: Icon(Icons.card_membership_outlined),
                      title: Text("Add role"),
                      onTap: () async {
                        Navigator.pushNamed(context, AddRoleRoute);
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }()),
                (() {
                  if (true) {
                    return ListTile(
                      leading: Icon(Icons.bus_alert),
                      title: Text("Add transport"),
                      onTap: () async {
                        Navigator.pushNamed(context, AddTransportRoute);
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }()),
                (() {
                  if (true) {
                    return ListTile(
                      leading: Icon(Icons.book),
                      title: Text("Add course"),
                      onTap: () async {
                        Navigator.pushNamed(context, AddCourseRoute);
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }()),
                (() {
                  if (true) {
                    return ListTile(
                      leading: Icon(Icons.table_chart),
                      title: Text("Add time table"),
                      onTap: () async {
                        Navigator.pushNamed(context, AddTimeTableRoute);
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }()),
                (() {
                  if (true) {
                    return ListTile(
                      leading: Icon(Icons.cast_rounded),
                      title: Text("Add notice"),
                      onTap: () async {
                        Navigator.pushNamed(context, AddNoticeRoute);
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }()),
                (() {
                  if (true) {
                    return ListTile(
                      leading: Icon(Icons.cast_rounded),
                      title: Text("Add review"),
                      onTap: () async {
                        Navigator.pushNamed(context, AddReviewRoute);
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }()),
                (() {
                  if (true) {
                    return ListTile(
                      leading: Icon(Icons.cast_rounded),
                      title: Text("Add notice"),
                      onTap: () async {
                        Navigator.pushNamed(context, AddNoticeRoute);
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }()),
                (() {
                  if (true) {
                    return ListTile(
                      leading: Icon(Icons.cast_rounded),
                      title: Text("Add notice"),
                      onTap: () async {
                        Navigator.pushNamed(context, AddNoticeRoute);
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }()),
                (() {
                  if (true) {
                    return ListTile(
                      leading: Icon(Icons.cast_rounded),
                      title: Text("Add notice"),
                      onTap: () async {
                        Navigator.pushNamed(context, AddNoticeRoute);
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }()),
                ListTile(
                  title: const Text("Logout"),
                  leading: const Icon(Icons.logout),
                  onTap: () async {
                    //Remove the hive details
                    await Hive.box('loginObj').clear();
                    Navigator.pushReplacement<void, void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const Login(),
                      ),
                    );
                  },
                ),
              ])),
        ],
      ),
    );
  }
}
