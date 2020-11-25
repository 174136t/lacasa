class RedeemRewards {
  String _status;
  int _statusCode;
  String _debugMessage;
  bool _result;
  String _message;
  List<RedeemReward> _data;

  String get status => _status;
  int get statusCode => _statusCode;
  String get debugMessage => _debugMessage;
  bool get result => _result;
  String get message => _message;
  List<RedeemReward> get data => _data;

  RedeemRewards(
      {String status,
      int statusCode,
      String debugMessage,
      bool result,
      String message,
      List<RedeemReward> data}) {
    _status = status;
    _statusCode = statusCode;
    _debugMessage = debugMessage;
    _result = result;
    _message = message;
    _data = data;
  }

  RedeemRewards.fromJson(dynamic json) {
    _status = json["status"];
    _statusCode = json["statusCode"];
    _debugMessage = json["debugMessage"];
    _result = json["result"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(RedeemReward.fromJson(v));
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

class RedeemReward {
  String _uuid;
  String _title;
  dynamic _description;
  String _expiresAt;
  List<dynamic> _images;
  int _expiresInMonths;
  int _points;

  String get uuid => _uuid;
  String get title => _title;
  dynamic get description => _description;
  String get expiresAt => _expiresAt;
  List<dynamic> get images => _images;
  int get expiresInMonths => _expiresInMonths;
  int get points => _points;

  RedeemReward(
      {String uuid,
      String title,
      dynamic description,
      String expiresAt,
      List<dynamic> images,
      int expiresInMonths,
      int points}) {
    _uuid = uuid;
    _title = title;
    _description = description;
    _expiresAt = expiresAt;
    _images = images;
    _expiresInMonths = expiresInMonths;
    _points = points;
  }

  RedeemReward.fromJson(dynamic json) {
    _uuid = json["uuid"];
    _title = json["title"];
    _description = json["description"];
    _expiresAt = json["expires_at"];
    if (json["images"] != null) {
      _images = [];
      json["images"].forEach((v) {
        // _images.add(dynamic.fromJson(v));
      });
    }
    _expiresInMonths = json["expiresInMonths"];
    _points = json["points"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uuid"] = _uuid;
    map["title"] = _title;
    map["description"] = _description;
    map["expires_at"] = _expiresAt;
    if (_images != null) {
      map["images"] = _images.map((v) => v.toJson()).toList();
    }
    map["expiresInMonths"] = _expiresInMonths;
    map["points"] = _points;
    return map;
  }
}

class images {}
