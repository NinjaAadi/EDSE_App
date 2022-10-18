import 'package:hive/hive.dart';

class LoginCache {
  void storeLoginData(String? id, String jwt, String? forDept) {
    var loginObj = Hive.box('loginObj');
    loginObj.put('id', id);
    loginObj.put('jwt', jwt);
    loginObj.put('forDept', forDept);
    
  }

  void logout() {
    var loginObj = Hive.box('loginObj');
    loginObj.deleteFromDisk();
  }
}
