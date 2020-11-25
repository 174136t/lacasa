import 'package:lacasa/modals/staff_offer_history.dart';

class StaffRecentPoints {
  String _status;
  int _statusCode;
  String _debugMessage;
  bool _result;
  String _message;
  Data _data;

  String get status => _status;
  int get statusCode => _statusCode;
  String get debugMessage => _debugMessage;
  bool get result => _result;
  String get message => _message;
  Data get data => _data;

  StaffRecentPoints(
      {String status,
      int statusCode,
      String debugMessage,
      bool result,
      String message,
      Data data}) {
    _status = status;
    _statusCode = statusCode;
    _debugMessage = debugMessage;
    _result = result;
    _message = message;
    _data = data;
  }

  StaffRecentPoints.fromJson(dynamic json) {
    _status = json["status"];
    _statusCode = json["statusCode"];
    _debugMessage = json["debugMessage"];
    _result = json["result"];
    _message = json["message"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
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

class Data {
  List<History> _history;
  String _businessCurrency;
  String _businessCurrencySymbol;

  List<History> get history => _history;
  String get businessCurrency => _businessCurrency;
  String get businessCurrencySymbol => _businessCurrencySymbol;

  Data(
      {List<History> history,
      String businessCurrency,
      String businessCurrencySymbol}) {
    _history = history;
    _businessCurrency = businessCurrency;
    _businessCurrencySymbol = businessCurrencySymbol;
  }

  Data.fromJson(dynamic json) {
    if (json["history"] != null) {
      _history = [];
      json["history"].forEach((v) {
        _history.add(History.fromJson(v));
      });
    }
    _businessCurrency = json["businessCurrency"];
    _businessCurrencySymbol = json["businessCurrencySymbol"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_history != null) {
      map["history"] = _history.map((v) => v.toJson()).toList();
    }
    map["businessCurrency"] = _businessCurrency;
    map["businessCurrencySymbol"] = _businessCurrencySymbol;
    return map;
  }
}
