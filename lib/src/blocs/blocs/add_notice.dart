import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rxdart/rxdart.dart';

class AddNoticeBloc {
  final _addNoticeController = BehaviorSubject<Map<String, dynamic>>();
  final _submitButtonController = BehaviorSubject<String>();
  Map<String, dynamic> finalResponse = {
    "file": nullptr,
    "heading": "",
    "date": "",
    "body": "",
    "signedBy": "",
    "forWhich": ""
  };
  //Sink adn stream of notice controller
  get addNotice => _addNoticeController.sink.add;
  get addNoticeStream =>
      _addNoticeController.stream.transform(_addNoticeTransformer());

  //Sink and stream of submit button
  get setButtonValue => _submitButtonController.sink.add;
  get buttonValueStream => _submitButtonController.stream;

  _addNoticeTransformer() {
    return ScanStreamTransformer(
        (Map<String, dynamic> cache, Map<String, dynamic> data, index) {
      print(data);
      data.forEach((key, value) {
        cache[key] = value;
      });
      finalResponse = cache;
      return cache;
    }, <String, dynamic>{
      "file": nullptr,
      "heading": "",
      "date": "",
      "body": "",
      "signedBy": "",
      "forWhich": ""
    });
  }

  //Submit function
  submitNotice() async {
    try {
      setButtonValue("Loading");
      if (finalResponse["file"] == nullptr) {
        setButtonValue("good");
        return {"success": false, "messege": "Please provide a notice photo"};
      }
      print(finalResponse);
      final url =
          "${dotenv.env["API_URL"]}/notice/addNotice?department=${finalResponse["forWhich"]}";
      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(http.MultipartFile(
          'file',
          finalResponse["file"].readAsBytes().asStream(),
          finalResponse["file"].lengthSync(),
          filename: finalResponse["file"].path.split("/").last));
      finalResponse.forEach((key, value) {
        if (key != "file" && key != "forWhich") {
          request.fields[key] = value;
        }
      });
      http.Response response =
          await http.Response.fromStream(await request.send());
      setButtonValue("Good");
      print(json.decode(response.body));
      return json.decode(response.body);
    } catch (error) {
      print(error);
      setButtonValue("Good");
      return {"success": false, "messege": "Server error"};
    }
  }
}
