

class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? apiToken;
  String? deviceToken;
  String? phone;
  String? address;
  String? bio;
  int? orders;
  String? role;

  User();
  User.fromJSON(Map<String, dynamic> jsonMap) {
    id = jsonMap['id'].toString();
    name = jsonMap['name'];
    orders = jsonMap['orders'];
    email = jsonMap['email'];
    apiToken = jsonMap['token'];
    deviceToken = jsonMap['device_token'];
    role = jsonMap['role'];

  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["password"] = password;
    return map;
  }
}
