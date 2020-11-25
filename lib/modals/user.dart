class User {
  String _status;
  int _statusCode;
  String _debugMessage;
  bool _result;
  String _message;
  UserInfo _data;

  String get status => _status;
  int get statusCode => _statusCode;
  String get debugMessage => _debugMessage;
  bool get result => _result;
  String get message => _message;
  UserInfo get data => _data;

  User(
      {String status,
      int statusCode,
      String debugMessage,
      bool result,
      String message,
      UserInfo data}) {
    _status = status;
    _statusCode = statusCode;
    _debugMessage = debugMessage;
    _result = result;
    _message = message;
    _data = data;
  }

  User.fromJson(dynamic json) {
    _status = json["status"];
    _statusCode = json["statusCode"];
    _debugMessage = json["debugMessage"];
    _result = json["result"];
    _message = json["message"];
    _data = json["data"] != null ? UserInfo.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["statusCode"] = _statusCode;
    map["debugMessage"] = _debugMessage;
    map["result"] = _result;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data.toJson();
    }
    return map;
  }
}

class UserInfo {
  String _uuid;
  int _active;
  String _avatar;
  String _name;
  String _email;
  String _mobile;
  String _number;
  String _language;
  String _locale;
  String _timezone;
  String _currency;

  String get uuid => _uuid;
  int get active => _active;
  String get avatar => _avatar;
  String get name => _name;
  String get email => _email;
  String get mobile => _mobile;
  String get number => _number;
  String get language => _language;
  String get locale => _locale;
  String get timezone => _timezone;
  String get currency => _currency;

  UserInfo(
      {String uuid,
      int active,
      String avatar,
      String name,
      String email,
      String mobile,
      String number,
      String language,
      String locale,
      String timezone,
      String currency}) {
    _uuid = uuid;
    _active = active;
    _avatar = avatar;
    _name = name;
    _email = email;
    _mobile = mobile;
    _number = number;
    _language = language;
    _locale = locale;
    _timezone = timezone;
    _currency = currency;
  }

  UserInfo.fromJson(dynamic json) {
    _uuid = json["uuid"];
    _active = json["active"];
    _avatar = json["avatar"];
    _name = json["name"];
    _email = json["email"];
    _mobile = json["mobile"];
    _number = json["number"];
    _language = json["language"];
    _locale = json["locale"];
    _timezone = json["timezone"];
    _currency = json["currency"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uuid"] = _uuid;
    map["active"] = _active;
    map["avatar"] = _avatar;
    map["name"] = _name;
    map["email"] = _email;
    map["mobile"] = _mobile;
    map["number"] = _number;
    map["language"] = _language;
    map["locale"] = _locale;
    map["timezone"] = _timezone;
    map["currency"] = _currency;
    return map;
  }
}
