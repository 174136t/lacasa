class ChampaignsModal {
  String _status;
  int _statusCode;
  String _debugMessage;
  bool _result;
  String _message;
  List<Campaign> _data;

  String get status => _status;
  int get statusCode => _statusCode;
  String get debugMessage => _debugMessage;
  bool get result => _result;
  String get message => _message;
  List<Campaign> get data => _data;

  ChampaignsModal(
      {String status,
      int statusCode,
      String debugMessage,
      bool result,
      String message,
      List<Campaign> data}) {
    _status = status;
    _statusCode = statusCode;
    _debugMessage = debugMessage;
    _result = result;
    _message = message;
    _data = data;
  }

  ChampaignsModal.fromJson(dynamic json) {
    _status = json["status"];
    _statusCode = json["statusCode"];
    _debugMessage = json["debugMessage"];
    _result = json["result"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Campaign.fromJson(v));
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

class Campaign {
  String _uuid;
  String _slug;
  String _name;
  dynamic _host;
  String _content;
  String _businessName;
  String _url;
  String _subTitle;
  int _points;
  String _campaignText;
  String _number;
  String _customerSegmentTxt;
  List<Segments> _segments;

  String get uuid => _uuid;
  String get slug => _slug;
  String get name => _name;
  dynamic get host => _host;
  String get content => _content;
  String get businessName => _businessName;
  String get url => _url;
  String get subTitle => _subTitle;
  int get points => _points;
  String get campaignText => _campaignText;
  String get number => _number;
  String get customerSegmentTxt => _customerSegmentTxt;
  List<Segments> get segments => _segments;

  Campaign(
      {String uuid,
      String slug,
      String name,
      dynamic host,
      String content,
      String businessName,
      String url,
      String subTitle,
      int points,
      String campaignText,
      String number,
      String customerSegmentTxt,
      List<Segments> segments}) {
    _uuid = uuid;
    _slug = slug;
    _name = name;
    _host = host;
    _content = content;
    _businessName = businessName;
    _url = url;
    _subTitle = subTitle;
    _points = points;
    _campaignText = campaignText;
    _number = number;
    _customerSegmentTxt = customerSegmentTxt;
    _segments = segments;
  }

  Campaign.fromJson(dynamic json) {
    _uuid = json["uuid"];
    _slug = json["slug"];
    _name = json["name"];
    _host = json["host"];
    _content = json["content"];
    _businessName = json["businessName"];
    _url = json["url"];
    _subTitle = json["subTitle"];
    _points = json["points"];
    _campaignText = json["campaignText"];
    _number = json["number"];
    _customerSegmentTxt = json["customerSegmentTxt"];
    if (json["segments"] != null) {
      _segments = [];
      json["segments"].forEach((v) {
        _segments.add(Segments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["uuid"] = _uuid;
    map["slug"] = _slug;
    map["name"] = _name;
    map["host"] = _host;
    map["content"] = _content;
    map["businessName"] = _businessName;
    map["url"] = _url;
    map["subTitle"] = _subTitle;
    map["points"] = _points;
    map["campaignText"] = _campaignText;
    map["number"] = _number;
    map["customerSegmentTxt"] = _customerSegmentTxt;
    if (_segments != null) {
      map["segments"] = _segments.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Segments {
  int _id;
  String _uuid;
  int _accountId;
  String _name;
  dynamic _meta;
  int _createdBy;
  dynamic _updatedBy;
  int _isCreatedByAdmin;
  String _createdAt;
  String _updatedAt;
  String _businessesText;
  Pivot _pivot;
  List<Businesses> _businesses;

  int get id => _id;
  String get uuid => _uuid;
  int get accountId => _accountId;
  String get name => _name;
  dynamic get meta => _meta;
  int get createdBy => _createdBy;
  dynamic get updatedBy => _updatedBy;
  int get isCreatedByAdmin => _isCreatedByAdmin;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get businessesText => _businessesText;
  Pivot get pivot => _pivot;
  List<Businesses> get businesses => _businesses;

  Segments(
      {int id,
      String uuid,
      int accountId,
      String name,
      dynamic meta,
      int createdBy,
      dynamic updatedBy,
      int isCreatedByAdmin,
      String createdAt,
      String updatedAt,
      String businessesText,
      Pivot pivot,
      List<Businesses> businesses}) {
    _id = id;
    _uuid = uuid;
    _accountId = accountId;
    _name = name;
    _meta = meta;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _isCreatedByAdmin = isCreatedByAdmin;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _businessesText = businessesText;
    _pivot = pivot;
    _businesses = businesses;
  }

  Segments.fromJson(dynamic json) {
    _id = json["id"];
    _uuid = json["uuid"];
    _accountId = json["accountId"];
    _name = json["name"];
    _meta = json["meta"];
    _createdBy = json["createdBy"];
    _updatedBy = json["updatedBy"];
    _isCreatedByAdmin = json["isCreatedByAdmin"];
    _createdAt = json["createdAt"];
    _updatedAt = json["updatedAt"];
    _businessesText = json["businessesText"];
    _pivot = json["pivot"] != null ? Pivot.fromJson(json["pivot"]) : null;
    if (json["businesses"] != null) {
      _businesses = [];
      json["businesses"].forEach((v) {
        _businesses.add(Businesses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["uuid"] = _uuid;
    map["accountId"] = _accountId;
    map["name"] = _name;
    map["meta"] = _meta;
    map["createdBy"] = _createdBy;
    map["updatedBy"] = _updatedBy;
    map["isCreatedByAdmin"] = _isCreatedByAdmin;
    map["createdAt"] = _createdAt;
    map["updatedAt"] = _updatedAt;
    map["businessesText"] = _businessesText;
    if (_pivot != null) {
      map["pivot"] = _pivot.toJson();
    }
    if (_businesses != null) {
      map["businesses"] = _businesses.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Businesses {
  int _id;
  String _uuid;
  int _accountId;
  int _industryId;
  dynamic _industry;
  int _active;
  int _isOnlineBusiness;
  String _name;
  dynamic _shortDescription;
  dynamic _description;
  String _email;
  String _pointRate;
  String _phone;
  dynamic _mobile;
  String _website;
  dynamic _fax;
  dynamic _vatNumber;
  dynamic _idNumber;
  dynamic _bank;
  dynamic _bankId;
  dynamic _ecodeSwift;
  dynamic _iban;
  String _street1;
  dynamic _street2;
  String _city;
  String _state;
  String _postalCode;
  dynamic _countryCode;
  dynamic _zoom;
  dynamic _lat;
  dynamic _lng;
  Content _content;
  Social _social;
  dynamic _settings;
  dynamic _tags;
  dynamic _attributes;
  dynamic _meta;
  int _createdBy;
  int _updatedBy;
  String _createdAt;
  String _updatedAt;
  String _logo;
  Pivot _pivot;
  List<Media> _media;

  int get id => _id;
  String get uuid => _uuid;
  int get accountId => _accountId;
  int get industryId => _industryId;
  dynamic get industry => _industry;
  int get active => _active;
  int get isOnlineBusiness => _isOnlineBusiness;
  String get name => _name;
  dynamic get shortDescription => _shortDescription;
  dynamic get description => _description;
  String get email => _email;
  String get pointRate => _pointRate;
  String get phone => _phone;
  dynamic get mobile => _mobile;
  String get website => _website;
  dynamic get fax => _fax;
  dynamic get vatNumber => _vatNumber;
  dynamic get idNumber => _idNumber;
  dynamic get bank => _bank;
  dynamic get bankId => _bankId;
  dynamic get ecodeSwift => _ecodeSwift;
  dynamic get iban => _iban;
  String get street1 => _street1;
  dynamic get street2 => _street2;
  String get city => _city;
  String get state => _state;
  String get postalCode => _postalCode;
  dynamic get countryCode => _countryCode;
  dynamic get zoom => _zoom;
  dynamic get lat => _lat;
  dynamic get lng => _lng;
  Content get content => _content;
  Social get social => _social;
  dynamic get settings => _settings;
  dynamic get tags => _tags;
  dynamic get attributes => _attributes;
  dynamic get meta => _meta;
  int get createdBy => _createdBy;
  int get updatedBy => _updatedBy;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get logo => _logo;
  Pivot get pivot => _pivot;
  List<Media> get media => _media;

  Businesses(
      {int id,
      String uuid,
      int accountId,
      int industryId,
      dynamic industry,
      int active,
      int isOnlineBusiness,
      String name,
      dynamic shortDescription,
      dynamic description,
      String email,
      String pointRate,
      String phone,
      dynamic mobile,
      String website,
      dynamic fax,
      dynamic vatNumber,
      dynamic idNumber,
      dynamic bank,
      dynamic bankId,
      dynamic ecodeSwift,
      dynamic iban,
      String street1,
      dynamic street2,
      String city,
      String state,
      String postalCode,
      dynamic countryCode,
      dynamic zoom,
      dynamic lat,
      dynamic lng,
      Content content,
      Social social,
      dynamic settings,
      dynamic tags,
      dynamic attributes,
      dynamic meta,
      int createdBy,
      int updatedBy,
      String createdAt,
      String updatedAt,
      String logo,
      Pivot pivot,
      List<Media> media}) {
    _id = id;
    _uuid = uuid;
    _accountId = accountId;
    _industryId = industryId;
    _industry = industry;
    _active = active;
    _isOnlineBusiness = isOnlineBusiness;
    _name = name;
    _shortDescription = shortDescription;
    _description = description;
    _email = email;
    _pointRate = pointRate;
    _phone = phone;
    _mobile = mobile;
    _website = website;
    _fax = fax;
    _vatNumber = vatNumber;
    _idNumber = idNumber;
    _bank = bank;
    _bankId = bankId;
    _ecodeSwift = ecodeSwift;
    _iban = iban;
    _street1 = street1;
    _street2 = street2;
    _city = city;
    _state = state;
    _postalCode = postalCode;
    _countryCode = countryCode;
    _zoom = zoom;
    _lat = lat;
    _lng = lng;
    _content = content;
    _social = social;
    _settings = settings;
    _tags = tags;
    _attributes = attributes;
    _meta = meta;
    _createdBy = createdBy;
    _updatedBy = updatedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _logo = logo;
    _pivot = pivot;
    _media = media;
  }

  Businesses.fromJson(dynamic json) {
    _id = json["id"];
    _uuid = json["uuid"];
    _accountId = json["accountId"];
    _industryId = json["industryId"];
    _industry = json["industry"];
    _active = json["active"];
    _isOnlineBusiness = json["isOnlineBusiness"];
    _name = json["name"];
    _shortDescription = json["shortDescription"];
    _description = json["description"];
    _email = json["email"];
    _pointRate = json["pointRate"];
    _phone = json["phone"];
    _mobile = json["mobile"];
    _website = json["website"];
    _fax = json["fax"];
    _vatNumber = json["vatNumber"];
    _idNumber = json["idNumber"];
    _bank = json["bank"];
    _bankId = json["bankId"];
    _ecodeSwift = json["ecodeSwift"];
    _iban = json["iban"];
    _street1 = json["street1"];
    _street2 = json["street2"];
    _city = json["city"];
    _state = json["state"];
    _postalCode = json["postalCode"];
    _countryCode = json["countryCode"];
    _zoom = json["zoom"];
    _lat = json["lat"];
    _lng = json["lng"];
    _content =
        json["content"] != null ? Content.fromJson(json["content"]) : null;
    _social = json["social"] != null ? Social.fromJson(json["social"]) : null;
    _settings = json["settings"];
    _tags = json["tags"];
    _attributes = json["attributes"];
    _meta = json["meta"];
    _createdBy = json["createdBy"];
    _updatedBy = json["updatedBy"];
    _createdAt = json["createdAt"];
    _updatedAt = json["updatedAt"];
    _logo = json["logo"];
    _pivot = json["pivot"] != null ? Pivot.fromJson(json["pivot"]) : null;
    if (json["media"] != null) {
      _media = [];
      json["media"].forEach((v) {
        _media.add(Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["uuid"] = _uuid;
    map["accountId"] = _accountId;
    map["industryId"] = _industryId;
    map["industry"] = _industry;
    map["active"] = _active;
    map["isOnlineBusiness"] = _isOnlineBusiness;
    map["name"] = _name;
    map["shortDescription"] = _shortDescription;
    map["description"] = _description;
    map["email"] = _email;
    map["pointRate"] = _pointRate;
    map["phone"] = _phone;
    map["mobile"] = _mobile;
    map["website"] = _website;
    map["fax"] = _fax;
    map["vatNumber"] = _vatNumber;
    map["idNumber"] = _idNumber;
    map["bank"] = _bank;
    map["bankId"] = _bankId;
    map["ecodeSwift"] = _ecodeSwift;
    map["iban"] = _iban;
    map["street1"] = _street1;
    map["street2"] = _street2;
    map["city"] = _city;
    map["state"] = _state;
    map["postalCode"] = _postalCode;
    map["countryCode"] = _countryCode;
    map["zoom"] = _zoom;
    map["lat"] = _lat;
    map["lng"] = _lng;
    if (_content != null) {
      map["content"] = _content.toJson();
    }
    if (_social != null) {
      map["social"] = _social.toJson();
    }
    map["settings"] = _settings;
    map["tags"] = _tags;
    map["attributes"] = _attributes;
    map["meta"] = _meta;
    map["createdBy"] = _createdBy;
    map["updatedBy"] = _updatedBy;
    map["createdAt"] = _createdAt;
    map["updatedAt"] = _updatedAt;
    map["logo"] = _logo;
    if (_pivot != null) {
      map["pivot"] = _pivot.toJson();
    }
    if (_media != null) {
      map["media"] = _media.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Media {
  int _id;
  String _modelType;
  int _modelId;
  String _collectionName;
  String _name;
  String _fileName;
  String _mimeType;
  String _disk;
  int _size;
  List<dynamic> _manipulations;
  List<dynamic> _customProperties;
  List<dynamic> _responsiveImages;
  int _orderColumn;
  String _createdAt;
  String _updatedAt;

  int get id => _id;
  String get modelType => _modelType;
  int get modelId => _modelId;
  String get collectionName => _collectionName;
  String get name => _name;
  String get fileName => _fileName;
  String get mimeType => _mimeType;
  String get disk => _disk;
  int get size => _size;
  List<dynamic> get manipulations => _manipulations;
  List<dynamic> get customProperties => _customProperties;
  List<dynamic> get responsiveImages => _responsiveImages;
  int get orderColumn => _orderColumn;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Media(
      {int id,
      String modelType,
      int modelId,
      String collectionName,
      String name,
      String fileName,
      String mimeType,
      String disk,
      int size,
      List<dynamic> manipulations,
      List<dynamic> customProperties,
      List<dynamic> responsiveImages,
      int orderColumn,
      String createdAt,
      String updatedAt}) {
    _id = id;
    _modelType = modelType;
    _modelId = modelId;
    _collectionName = collectionName;
    _name = name;
    _fileName = fileName;
    _mimeType = mimeType;
    _disk = disk;
    _size = size;
    _manipulations = manipulations;
    _customProperties = customProperties;
    _responsiveImages = responsiveImages;
    _orderColumn = orderColumn;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Media.fromJson(dynamic json) {
    _id = json["id"];
    _modelType = json["modelType"];
    _modelId = json["modelId"];
    _collectionName = json["collectionName"];
    _name = json["name"];
    _fileName = json["fileName"];
    _mimeType = json["mimeType"];
    _disk = json["disk"];
    _size = json["size"];
    if (json["manipulations"] != null) {
      _manipulations = [];
      json["manipulations"].forEach((v) {
        //_manipulations.add(dynamic.fromJson(v));
      });
    }
    if (json["customProperties"] != null) {
      _customProperties = [];
      json["customProperties"].forEach((v) {
        //_customProperties.add(dynamic.fromJson(v));
      });
    }
    if (json["responsiveImages"] != null) {
      _responsiveImages = [];
      json["responsiveImages"].forEach((v) {
        // _responsiveImages.add(dynamic.fromJson(v));
      });
    }
    _orderColumn = json["orderColumn"];
    _createdAt = json["createdAt"];
    _updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["modelType"] = _modelType;
    map["modelId"] = _modelId;
    map["collectionName"] = _collectionName;
    map["name"] = _name;
    map["fileName"] = _fileName;
    map["mimeType"] = _mimeType;
    map["disk"] = _disk;
    map["size"] = _size;
    if (_manipulations != null) {
      map["manipulations"] = _manipulations.map((v) => v.toJson()).toList();
    }
    if (_customProperties != null) {
      map["customProperties"] =
          _customProperties.map((v) => v.toJson()).toList();
    }
    if (_responsiveImages != null) {
      map["responsiveImages"] =
          _responsiveImages.map((v) => v.toJson()).toList();
    }
    map["orderColumn"] = _orderColumn;
    map["createdAt"] = _createdAt;
    map["updatedAt"] = _updatedAt;
    return map;
  }
}

class Pivot {
  int _segmentId;
  int _businessId;

  int get segmentId => _segmentId;
  int get businessId => _businessId;

  Pivot({int segmentId, int businessId}) {
    _segmentId = segmentId;
    _businessId = businessId;
  }

  Pivot.fromJson(dynamic json) {
    _segmentId = json["segmentId"];
    _businessId = json["businessId"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["segmentId"] = _segmentId;
    map["businessId"] = _businessId;
    return map;
  }
}

class Social {
  String _text;
  String _vimeo;
  dynamic _medium;
  dynamic _tumblr;
  dynamic _twitter;
  String _youtube;
  String _facebook;
  dynamic _linkedin;
  dynamic _snapchat;
  dynamic _telegram;
  dynamic _whatsapp;
  dynamic _instagram;
  dynamic _pinterest;

  String get text => _text;
  String get vimeo => _vimeo;
  dynamic get medium => _medium;
  dynamic get tumblr => _tumblr;
  dynamic get twitter => _twitter;
  String get youtube => _youtube;
  String get facebook => _facebook;
  dynamic get linkedin => _linkedin;
  dynamic get snapchat => _snapchat;
  dynamic get telegram => _telegram;
  dynamic get whatsapp => _whatsapp;
  dynamic get instagram => _instagram;
  dynamic get pinterest => _pinterest;

  Social(
      {String text,
      String vimeo,
      dynamic medium,
      dynamic tumblr,
      dynamic twitter,
      String youtube,
      String facebook,
      dynamic linkedin,
      dynamic snapchat,
      dynamic telegram,
      dynamic whatsapp,
      dynamic instagram,
      dynamic pinterest}) {
    _text = text;
    _vimeo = vimeo;
    _medium = medium;
    _tumblr = tumblr;
    _twitter = twitter;
    _youtube = youtube;
    _facebook = facebook;
    _linkedin = linkedin;
    _snapchat = snapchat;
    _telegram = telegram;
    _whatsapp = whatsapp;
    _instagram = instagram;
    _pinterest = pinterest;
  }

  Social.fromJson(dynamic json) {
    _text = json["text"];
    _vimeo = json["vimeo"];
    _medium = json["medium"];
    _tumblr = json["tumblr"];
    _twitter = json["twitter"];
    _youtube = json["youtube"];
    _facebook = json["facebook"];
    _linkedin = json["linkedin"];
    _snapchat = json["snapchat"];
    _telegram = json["telegram"];
    _whatsapp = json["whatsapp"];
    _instagram = json["instagram"];
    _pinterest = json["pinterest"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["text"] = _text;
    map["vimeo"] = _vimeo;
    map["medium"] = _medium;
    map["tumblr"] = _tumblr;
    map["twitter"] = _twitter;
    map["youtube"] = _youtube;
    map["facebook"] = _facebook;
    map["linkedin"] = _linkedin;
    map["snapchat"] = _snapchat;
    map["telegram"] = _telegram;
    map["whatsapp"] = _whatsapp;
    map["instagram"] = _instagram;
    map["pinterest"] = _pinterest;
    return map;
  }
}

class Content {
  dynamic _href1;
  dynamic _href2;
  dynamic _href3;
  dynamic _text1;
  dynamic _text2;
  dynamic _text3;

  dynamic get href1 => _href1;
  dynamic get href2 => _href2;
  dynamic get href3 => _href3;
  dynamic get text1 => _text1;
  dynamic get text2 => _text2;
  dynamic get text3 => _text3;

  Content(
      {dynamic href1,
      dynamic href2,
      dynamic href3,
      dynamic text1,
      dynamic text2,
      dynamic text3}) {
    _href1 = href1;
    _href2 = href2;
    _href3 = href3;
    _text1 = text1;
    _text2 = text2;
    _text3 = text3;
  }

  Content.fromJson(dynamic json) {
    _href1 = json["href1"];
    _href2 = json["href2"];
    _href3 = json["href3"];
    _text1 = json["text1"];
    _text2 = json["text2"];
    _text3 = json["text3"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["href1"] = _href1;
    map["href2"] = _href2;
    map["href3"] = _href3;
    map["text1"] = _text1;
    map["text2"] = _text2;
    map["text3"] = _text3;
    return map;
  }
}

class ResponsiveImages {}

class CustomProperties {}
