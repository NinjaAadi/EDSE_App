class NoticeModel {
  late final String id;
  late final String noticeImageURL;
  late final String heading;
  late final String date;
  late final String body;
  late final String department;
  late final String signedBy;
  NoticeModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson["_id"];
    noticeImageURL = parsedJson["noticeImageURL"];
    heading = parsedJson["heading"];
    date = parsedJson["date"];
    body = parsedJson["body"];
    department = parsedJson["department"];
    signedBy = parsedJson["signedBy"];
  }
}
