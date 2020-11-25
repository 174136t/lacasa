class StaffCampaigns {
  String _status;
  int _statusCode;
  String _debugMessage;
  bool _result;
  String _message;
  List<StaffCampaign> _data;

  String get status => _status;
  int get statusCode => _statusCode;
  String get debugMessage => _debugMessage;
  bool get result => _result;
  String get message => _message;
  List<StaffCampaign> get data => _data;

  StaffCampaigns(
      {String status,
      int statusCode,
      String debugMessage,
      bool result,
      String message,
      List<StaffCampaign> data}) {
    _status = status;
    _statusCode = statusCode;
    _debugMessage = debugMessage;
    _result = result;
    _message = message;
    _data = data;
  }

  StaffCampaigns.fromJson(dynamic json) {
    _status = json["status"];
    _statusCode = json["statusCode"];
    _debugMessage = json["debugMessage"];
    _result = json["result"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(StaffCampaign.fromJson(v));
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

class StaffCampaign {
  String _campUuid;
  String _name;

  String get campUuid => _campUuid;
  String get name => _name;

  StaffCampaign({String campUuid, String name}) {
    _campUuid = campUuid;
    _name = name;
  }

  StaffCampaign.fromJson(dynamic json) {
    _campUuid = json["camp_uuid"];
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["camp_uuid"] = _campUuid;
    map["name"] = _name;
    return map;
  }
}
