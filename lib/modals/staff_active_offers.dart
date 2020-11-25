class StaffActiveOffers {
  String _status;
  int _statusCode;
  String _debugMessage;
  bool _result;
  String _message;
  List<ActiveOffer> _data;

  String get status => _status;
  int get statusCode => _statusCode;
  String get debugMessage => _debugMessage;
  bool get result => _result;
  String get message => _message;
  List<ActiveOffer> get data => _data;

  StaffActiveOffers(
      {String status,
      int statusCode,
      String debugMessage,
      bool result,
      String message,
      List<ActiveOffer> data}) {
    _status = status;
    _statusCode = statusCode;
    _debugMessage = debugMessage;
    _result = result;
    _message = message;
    _data = data;
  }

  StaffActiveOffers.fromJson(dynamic json) {
    _status = json["status"];
    _statusCode = json["statusCode"];
    _debugMessage = json["debugMessage"];
    _result = json["result"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(ActiveOffer.fromJson(v));
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

class ActiveOffer {
  String _uuid;
  String _name;
  String _discount;
  int _numberOfTimesClaimed;
  int _numberOfTimesCustomerCanUse;
  String _expiresAt;
  String _segmentsText;
  List<dynamic> _segments;

  String get uuid => _uuid;
  String get name => _name;
  String get discount => _discount;
  int get numberOfTimesClaimed => _numberOfTimesClaimed;
  int get numberOfTimesCustomerCanUse => _numberOfTimesCustomerCanUse;
  String get expiresAt => _expiresAt;
  String get segmentsText => _segmentsText;
  List<dynamic> get segments => _segments;

  ActiveOffer(
      {String uuid,
      String name,
      String discount,
      int numberOfTimesClaimed,
      int numberOfTimesCustomerCanUse,
      String expiresAt,
      String segmentsText,
      List<dynamic> segments}) {
    _uuid = uuid;
    _name = name;
    _discount = discount;
    _numberOfTimesClaimed = numberOfTimesClaimed;
    _numberOfTimesCustomerCanUse = numberOfTimesCustomerCanUse;
    _expiresAt = expiresAt;
    _segmentsText = segmentsText;
    _segments = segments;
  }

  ActiveOffer.fromJson(dynamic json) {
    _uuid = json["uuid"];
    _name = json["name"];
    _discount = json["discount"];
    _numberOfTimesClaimed = json["numberOfTimesClaimed"];
    _numberOfTimesCustomerCanUse = json["numberOfTimesCustomerCanUse"];
    _expiresAt = json["expiresAt"];
    _segmentsText = json["segmentsText"];
    if (json["segments"] != null) {
      _segments = [];
      json["segments"].forEach((v) {
        //_segments.add(dynamic.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uuid"] = _uuid;
    map["name"] = _name;
    map["discount"] = _discount;
    map["numberOfTimesClaimed"] = _numberOfTimesClaimed;
    map["numberOfTimesCustomerCanUse"] = _numberOfTimesCustomerCanUse;
    map["expiresAt"] = _expiresAt;
    map["segmentsText"] = _segmentsText;
    if (_segments != null) {
      map["segments"] = _segments.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
