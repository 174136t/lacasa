class RewardsModel {
  String _status;
  int _statusCode;
  String _debugMessage;
  bool _result;
  String _message;
  List<MyReward> _data;

  String get status => _status;
  int get statusCode => _statusCode;
  String get debugMessage => _debugMessage;
  bool get result => _result;
  String get message => _message;
  List<MyReward> get data => _data;

  RewardsModel(
      {String status,
      int statusCode,
      String debugMessage,
      bool result,
      String message,
      List<MyReward> data}) {
    _status = status;
    _statusCode = statusCode;
    _debugMessage = debugMessage;
    _result = result;
    _message = message;
    _data = data;
  }

  RewardsModel.fromJson(dynamic json) {
    _status = json["status"];
    _statusCode = json["statusCode"];
    _debugMessage = json["debugMessage"];
    _result = json["result"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(MyReward.fromJson(v));
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

class MyReward {
  int _id;
  String _uuid;
  int _accountId;
  int _active;
  String _title;
  dynamic _description;
  int _pointsCost;
  int _rewardValue;
  int _numberOfTimesRedeemed;
  String _activeFrom;
  String _expiresAt;
  dynamic _language;
  dynamic _currencyCode;
  dynamic _settings;
  dynamic _tags;
  dynamic _attributes;
  dynamic _meta;
  int _createdBy;
  dynamic _updatedBy;
  String _createdAt;
  String _updatedAt;
  String _titleWithPoints;
  dynamic _mainImage;
  dynamic _mainImageThumb;
  dynamic _image1;
  dynamic _image2;
  dynamic _image3;
  dynamic _image4;
  dynamic _image1Thumb;
  dynamic _image2Thumb;
  dynamic _image3Thumb;
  dynamic _image4Thumb;
  Pivot _pivot;
  List<dynamic> _media;

  int get id => _id;
  String get uuid => _uuid;
  int get accountId => _accountId;
  int get active => _active;
  String get title => _title;
  dynamic get description => _description;
  int get pointsCost => _pointsCost;
  int get rewardValue => _rewardValue;
  int get numberOfTimesRedeemed => _numberOfTimesRedeemed;
  String get activeFrom => _activeFrom;
  String get expiresAt => _expiresAt;
  dynamic get language => _language;
  dynamic get currencyCode => _currencyCode;
  dynamic get settings => _settings;
  dynamic get tags => _tags;
  dynamic get attributes => _attributes;
  dynamic get meta => _meta;
  int get createdBy => _createdBy;
  dynamic get updatedBy => _updatedBy;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get titleWithPoints => _titleWithPoints;
  dynamic get mainImage => _mainImage;
  dynamic get mainImageThumb => _mainImageThumb;
  dynamic get image1 => _image1;
  dynamic get image2 => _image2;
  dynamic get image3 => _image3;
  dynamic get image4 => _image4;
  dynamic get image1Thumb => _image1Thumb;
  dynamic get image2Thumb => _image2Thumb;
  dynamic get image3Thumb => _image3Thumb;
  dynamic get image4Thumb => _image4Thumb;
  Pivot get pivot => _pivot;
  List<dynamic> get media => _media;

  MyReward(
      {int id,
      String uuid,
      int accountId,
      int active,
      String title,
      dynamic description,
      int pointsCost,
      int rewardValue,
      int numberOfTimesRedeemed,
      String activeFrom,
      String expiresAt,
      dynamic language,
      dynamic currencyCode,
      dynamic settings,
      dynamic tags,
      dynamic attributes,
      dynamic meta,
      int createdBy,
      dynamic updatedBy,
      String createdAt,
      String updatedAt,
      String titleWithPoints,
      dynamic mainImage,
      dynamic mainImageThumb,
      dynamic image1,
      dynamic image2,
      dynamic image3,
      dynamic image4,
      dynamic image1Thumb,
      dynamic image2Thumb,
      dynamic image3Thumb,
      dynamic image4Thumb,
      Pivot pivot,
      List<dynamic> media}) {
    _id = id;
    _uuid = uuid;
    _accountId = accountId;
    _active = active;
    _title = title;
    _description = description;
    _pointsCost = pointsCost;
    _rewardValue = rewardValue;
    _numberOfTimesRedeemed = numberOfTimesRedeemed;
    _activeFrom = activeFrom;
    _expiresAt = expiresAt;
    _language = language;
    _currencyCode = currencyCode;
    _settings = settings;
    _tags = tags;
    _attributes = attributes;
    _meta = meta;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _titleWithPoints = titleWithPoints;
    _mainImage = mainImage;
    _mainImageThumb = mainImageThumb;
    _image1 = image1;
    _image2 = image2;
    _image3 = image3;
    _image4 = image4;
    _image1Thumb = image1Thumb;
    _image2Thumb = image2Thumb;
    _image3Thumb = image3Thumb;
    _image4Thumb = image4Thumb;
    _pivot = pivot;
    _media = media;
  }

  MyReward.fromJson(dynamic json) {
    _id = json["id"];
    _uuid = json["uuid"];
    _accountId = json["accountId"];
    _active = json["active"];
    _title = json["title"];
    _description = json["description"];
    _pointsCost = json["pointsCost"];
    _rewardValue = json["rewardValue"];
    _numberOfTimesRedeemed = json["numberOfTimesRedeemed"];
    _activeFrom = json["activeFrom"];
    _expiresAt = json["expiresAt"];
    _language = json["language"];
    _currencyCode = json["currencyCode"];
    _settings = json["settings"];
    _tags = json["tags"];
    _attributes = json["attributes"];
    _meta = json["meta"];
    _createdBy = json["createdBy"];
    _updatedBy = json["updatedBy"];
    _createdAt = json["createdAt"];
    _updatedAt = json["updatedAt"];
    _titleWithPoints = json["titleWithPoints"];
    _mainImage = json["mainImage"];
    _mainImageThumb = json["mainImageThumb"];
    _image1 = json["image1"];
    _image2 = json["image2"];
    _image3 = json["image3"];
    _image4 = json["image4"];
    _image1Thumb = json["image1Thumb"];
    _image2Thumb = json["image2Thumb"];
    _image3Thumb = json["image3Thumb"];
    _image4Thumb = json["image4Thumb"];
    _pivot = json["pivot"] != null ? Pivot.fromJson(json["pivot"]) : null;
    if (json["media"] != null) {
      _media = [];
      json["media"].forEach((v) {
        //_media.add(dynamic.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["uuid"] = _uuid;
    map["accountId"] = _accountId;
    map["active"] = _active;
    map["title"] = _title;
    map["description"] = _description;
    map["pointsCost"] = _pointsCost;
    map["rewardValue"] = _rewardValue;
    map["numberOfTimesRedeemed"] = _numberOfTimesRedeemed;
    map["activeFrom"] = _activeFrom;
    map["expiresAt"] = _expiresAt;
    map["language"] = _language;
    map["currencyCode"] = _currencyCode;
    map["settings"] = _settings;
    map["tags"] = _tags;
    map["attributes"] = _attributes;
    map["meta"] = _meta;
    map["createdBy"] = _createdBy;
    map["updatedBy"] = _updatedBy;
    map["createdAt"] = _createdAt;
    map["updatedAt"] = _updatedAt;
    map["titleWithPoints"] = _titleWithPoints;
    map["mainImage"] = _mainImage;
    map["mainImageThumb"] = _mainImageThumb;
    map["image1"] = _image1;
    map["image2"] = _image2;
    map["image3"] = _image3;
    map["image4"] = _image4;
    map["image1Thumb"] = _image1Thumb;
    map["image2Thumb"] = _image2Thumb;
    map["image3Thumb"] = _image3Thumb;
    map["image4Thumb"] = _image4Thumb;
    if (_pivot != null) {
      map["pivot"] = _pivot.toJson();
    }
    if (_media != null) {
      map["media"] = _media.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Pivot {
  int _campaignId;
  int _rewardId;

  int get campaignId => _campaignId;
  int get rewardId => _rewardId;

  Pivot({int campaignId, int rewardId}) {
    _campaignId = campaignId;
    _rewardId = rewardId;
  }

  Pivot.fromJson(dynamic json) {
    _campaignId = json["campaignId"];
    _rewardId = json["rewardId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["campaignId"] = _campaignId;
    map["rewardId"] = _rewardId;
    return map;
  }
}
