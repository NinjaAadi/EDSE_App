import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../models/transport.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:async';

class TransportApiProvider {
  //Function to fetch all the transports
  Future<List<TransportModel>> fetchTransports() async {
    try {
      final String url =
          "${dotenv.env["API_URL"]}/transport/getAllTransportAddress";
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );
      final transports = json.decode(response.body);
      List<TransportModel> transportList = [];
      for (var i = 0; i < transports["data"].length; i++) {
        transportList.add(TransportModel.fromJson(transports["data"][i]));
      }
      return transportList;
    } catch (error) {
      return [];
    }
  }

  //Function to fetch all the transports based on the pin code
  Future<List<TransportModel>> fetchTransportByPincode(String pinCode) async {
    try {
      final String url =
          "${dotenv.env["API_URL"]}/transport/searchTransportAddress?pinCode=" +
              pinCode;
      http.Response response = await http
          .get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      final transports = json.decode(response.body);
      List<TransportModel> transportList = [];
      for (var i = 0; i < transports["data"].length; i++) {
        transportList.add(TransportModel.fromJson(transports["data"][i]));
      }
      return transportList;
    } catch (error) {
      return [];
    }
  }
}
