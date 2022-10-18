import 'package:edse_app/src/models/notice.dart';
import 'package:edse_app/src/widgets/notice_refresh.dart';
import 'package:edse_app/src/widgets/spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../blocs/providers/notice.dart';

class ShowNotice extends StatelessWidget {
  const ShowNotice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final noticeBloc = NoticeProvider.of(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notice'),
        ),
        body: StreamBuilder(
          stream: noticeBloc.noticeStream,
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (!snapshot.hasData) {
              return LoadingContainer();
            } else {
              return NoticeRefresh(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data![0]!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return noticeTile(snapshot.data![0][index]);
                  },
                ),
                forDept: snapshot.data![1],
              );
            }
          },
        ));
  }

  Widget noticeTile(NoticeModel notice) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
            title: Text(notice.heading),
            subtitle: Text(
              getDate(notice.date),
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  notice.body,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              )),
          showImage(notice.noticeImageURL),
        ],
      ),
    );
  }

  Widget showImage(String noticeImageUrl) {
    return Image.network(
        "${dotenv.env["API_HOST"]}/images/notice/" + noticeImageUrl);
  }

  String getDate(String noticeDate) {
    final finalNoticeDate = DateTime.parse("2022-02-19T11:13:42.125+00:00");
    return "${finalNoticeDate.day}" +
        "/" +
        "${finalNoticeDate.month}" +
        "/"
            "${finalNoticeDate.year}";
  }
}
