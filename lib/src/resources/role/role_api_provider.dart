import 'dart:convert';
import 'package:edse_app/src/models/role.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RoleApiProvider {
  fetchAllRoles(String forWhich) async {
    try {
      final url =
          "${dotenv.env["API_URL"]}/role/getAllRole?roleFor=" + forWhich;
      final http.Response response = await http.get(Uri.parse(url));
      final roles = json.decode(response.body)["data"];
      final List<RoleModel> rolearr = [];
      for (var i = 0; i < roles.length; i++) {
        rolearr.add(RoleModel.fromJson(roles[i]));
      }
      return rolearr;
    } catch (error) {
      print(error);
      return [];
    }
  }
}