import '../../models/class.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class AllClassApiProvider {
  Future<List<ClassModel>> fetchClasses(String teacherId) async {
    try {
      final url =
          '${dotenv.env["API_URL"]}/class/getClass?teacherId=' + teacherId;
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final allClass = json.decode(response.body);
      List<ClassModel> classList = [];
      for (var i = 0; i < allClass["data"].length; i++) {
        classList.add(ClassModel.fromJson(allClass["data"][i]));
      }
      return classList;
    } catch (error) {
      return [];
    }
  }
  

  //Function to fetch all classes
  Future<List<ClassModel>> fetchAllClasses() async {
    try {
      final url = '${dotenv.env["API_URL"]}/class/getAllClass';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final allClass = json.decode(response.body);
      List<ClassModel> classList = [];
      for (var i = 0; i < allClass["data"].length; i++) {
        classList.add(ClassModel.fromJson(allClass["data"][i]));
      }

      return classList;
    } catch (error) {
      print(error);
      return [];
    }
  }

  //Function to fetch a class by id
  dynamic fetchClassById(String classId) async {
    try {
      final url =
          '${dotenv.env["API_URL"]}/class/getClassById?classId=' + classId;
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final classData = json.decode(response.body);
      print(classData);
      final currClass = classData["data"] == null
          ? null
          : ClassModel.fromJson(classData["data"]);

      return currClass;
    } catch (error) {
      print(error);
      return null;
    }
  }
}
