import 'package:edse_app/src/models/notice.dart';
import 'package:edse_app/src/resources/notice/notice_api_provider.dart';
import 'package:rxdart/rxdart.dart';

class NoticeBloc {
  final _noticeController = BehaviorSubject<List<dynamic>>();

  final NoticeApiProvider apiProvider = NoticeApiProvider();

  //Getter for the sink and the stream
  get noticeStream => _noticeController.stream;

  get addNotice => _noticeController.sink.add;

  //Functions to get notice
  fetchNotice(String dept) async {
    final allNotice = await apiProvider.fetchNotice(dept);
    await addNotice([allNotice, dept]);
  }
}

