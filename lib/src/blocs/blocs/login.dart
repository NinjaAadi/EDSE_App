import 'dart:async';
import 'package:edse_app/src/cache/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'dart:convert';

class LoginBloc {
  //Initialize the class for login cache
  final loginCache = LoginCache();
  final _loginController = BehaviorSubject<Map<String, String>>();

  //Getters for adding values
  Function(Map<String, String>) get addLoginCredentials =>
      _loginController.sink.add;

  //Getters for the stream
  Stream<Map<String, String>> get loginStream =>
      _loginController.stream.transform(_loginCredentialTransformer());

  //Last chanded value
  Map<String, String> finalCredentials = {};

  //Transformers
  _loginCredentialTransformer() {
    return ScanStreamTransformer(
        (Map<String, String> cache, Map<String, String> data, index) {
      data.forEach((key, value) => cache[key] = value);
      finalCredentials = cache;
      return cache;
    }, <String, String>{
      "Id": "",
      "Password": "",
      "For": "",
      "isLoading": "false"
    });
  }

  //Login function
  login() async {
    if (finalCredentials == {} || finalCredentials == null) {
      return {"success": false, "messege": "Please provide valid credentials!"};
    }
    //Validate the for object as it is necessary
    if (finalCredentials["For"] == null || finalCredentials["For"] == "") {
      return {
        "success": false,
        "messege": "Please provide a valid type for login!"
      };
    }
    final finalUrl =
        '${dotenv.env["API_URL"]}/login/${finalCredentials["For"]}?${finalCredentials["For"]}Id=${finalCredentials["Id"]}&password=${finalCredentials["Password"]}';
    try {
      await addLoginCredentials({"isLoading": "true"});
      http.Response response = await http.get(
        Uri.parse(finalUrl),
        headers: {"Content-Type": "application/json"},
      );
      await addLoginCredentials({"isLoading": "false"});

      //Update the hive details if the login is successful

      if (jsonDecode(response.body)["success"] == true) {
        loginCache.storeLoginData(finalCredentials["Id"],
            jsonDecode(response.body)["data"], finalCredentials["For"]);
      }
      return jsonDecode(response.body);
    } catch (error) {
      print(error);
      await addLoginCredentials({"isLoading": "false"});
      return {"success": false, "messege": "Server error!"};
    }
  }
}
