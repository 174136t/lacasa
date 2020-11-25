class AllIndustries {
  String _status;
  int _statusCode;
  String _debugMessage;
  bool _result;
  String _message;
  List<Industry> _data;

  String get status => _status;
  int get statusCode => _statusCode;
  String get debugMessage => _debugMessage;
  bool get result => _result;
  String get message => _message;
  List<Industry> get data => _data;

  AllIndustries(
      {String status,
      int statusCode,
      String debugMessage,
      bool result,
      String message,
      List<Industry> data}) {
    _status = status;
    _statusCode = statusCode;
    _debugMessage = debugMessage;
    _result = result;
    _message = message;
    _data = data;
  }

  AllIndustries.fromJson(dynamic json) {
    _status = json["status"];
    _statusCode = json["statusCode"];
    _debugMessage = json["debugMessage"];
    _result = json["result"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Industry.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["statusCode"] = _statusCode;
    map["debugMessage"] = _debugMessage;
    map["result"] = _result;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Industry {
  int _id;
  String _uuid;
  String _name;

  int get id => _id;
  String get uuid => _uuid;
  String get name => _name;

  Industry({int id, String uuid, String name}) {
    _id = id;
    _uuid = uuid;
    _name = name;
  }

  Industry.fromJson(dynamic json) {
    _id = json["id"];
    _uuid = json["uuid"];
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["uuid"] = _uuid;
    map["name"] = _name;
    return map;
  }
}
