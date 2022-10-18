import 'package:flutter/rendering.dart';

class TransportModel {
  late final String id;
  late final String address;
  late final String pinCode;
  TransportModel.fromJson(Map<String, dynamic> parsedJson) {
    id = parsedJson['_id'];
    address = parsedJson['address'];
    pinCode = parsedJson['pinCode'];
  }
}
