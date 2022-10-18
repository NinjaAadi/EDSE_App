import 'package:edse_app/src/models/notice.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class NoticeApiProvider {
  Future<List<NoticeModel>> fetchNotice(String forDept) async {
    try {
      final url =
          '${dotenv.env["API_URL"]}/notice/getAllNotice?department=' + forDept;
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final allNotice = json.decode(response.body);

      List<NoticeModel> noticeList = [];
      for (var i = 0; i < allNotice["data"].length; i++) {
        noticeList.add(NoticeModel.fromJson(allNotice["data"][i]));
      }
      return noticeList;
      
    } catch (error) {
      return [];
    }
  }
}
