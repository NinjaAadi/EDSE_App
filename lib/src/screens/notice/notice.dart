import 'package:edse_app/src/router/route_constants.dart';
import 'package:flutter/material.dart';
import '../../blocs/providers/notice.dart';

class Notice extends StatelessWidget {
  const Notice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noticeBloc = NoticeProvider.of(context);
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 140.0),
        child: Column(
          children: [
            showAllNotice(context, noticeBloc),
            Container(margin: const EdgeInsets.only(top: 25.0)),
            showStudentNotice(context, noticeBloc),
            Container(margin: const EdgeInsets.only(top: 25.0)),
            showTeacherNotice(context, noticeBloc),
            Container(margin: const EdgeInsets.only(top: 25.0)),
            showNonTeachingStaffNotice(context, noticeBloc),
            Container(margin: const EdgeInsets.only(top: 25.0)),
          ],
        ),
      ),
    );
  }

  Widget showAllNotice(context, noticeBloc) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton.icon(
        onPressed: () async {
          await noticeBloc.fetchNotice("All");
          Navigator.pushNamed(context, NoticeRoute);
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
        label: Text("Common"),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(160, 50),
        ),
        //.........
      ),
    );
  }

  Widget showTeacherNotice(context, noticeBloc) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton.icon(
        onPressed: () async {
          noticeBloc.fetchNotice("Teacher");
          Navigator.pushNamed(context, NoticeRoute);
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
        label: Text("Teacher"),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(160, 50),
        ),
        //.........
      ),
    );
  }

  Widget showStudentNotice(context, noticeBloc) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton.icon(
        onPressed: () async {
          noticeBloc.fetchNotice("Student");
          Navigator.pushNamed(context, NoticeRoute);
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
        label: Text("Student"),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(160, 50),
        ),
        //.........
      ),
    );
  }

  Widget showNonTeachingStaffNotice(context, noticeBloc) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ElevatedButton.icon(
        onPressed: () async {
          noticeBloc.fetchNotice("NonTeachingStaff");
          Navigator.pushNamed(context, NoticeRoute);
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
        label: Text("NTS"),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(160, 50),
        ),
        //.........
      ),
    );
  }
}
