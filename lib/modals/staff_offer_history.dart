class History {
  dynamic _rewardTitle;
  String _offerTitle;
  dynamic _purchaseAmount;
  String _discount;
  int _points;
  String _createdAt;
  List<dynamic> _segmentDetails;
  Customer_details _customerDetails;
  String _pointsInCurrency;
  String _icon;
  String _color;
  String _description;

  dynamic get rewardTitle => _rewardTitle;
  String get offerTitle => _offerTitle;
  dynamic get purchaseAmount => _purchaseAmount;
  String get discount => _discount;
  int get points => _points;
  String get createdAt => _createdAt;
  List<dynamic> get segmentDetails => _segmentDetails;
  Customer_details get customerDetails => _customerDetails;
  String get pointsInCurrency => _pointsInCurrency;
  String get icon => _icon;
  String get color => _color;
  String get description => _description;

  History(
      {dynamic rewardTitle,
      String offerTitle,
      dynamic purchaseAmount,
      String discount,
      int points,
      String createdAt,
      List<dynamic> segmentDetails,
      Customer_details customerDetails,
      String pointsInCurrency,
      String icon,
      String color,
      String description}) {
    _rewardTitle = rewardTitle;
    _offerTitle = offerTitle;
    _purchaseAmount = purchaseAmount;
    _discount = discount;
    _points = points;
    _createdAt = createdAt;
    _segmentDetails = segmentDetails;
    _customerDetails = customerDetails;
    _pointsInCurrency = pointsInCurrency;
    _icon = icon;
    _color = color;
    _description = description;
  }

  History.fromJson(dynamic json) {
    _rewardTitle = json["reward_title"];
    _offerTitle = json["offer_title"];
    _purchaseAmount = json["purchase_amount"];
    _discount = json["discount"];
    _points = json["points"];
    _createdAt = json["created_at"];
    if (json["segment_details"] != null) {
      _segmentDetails = [];
      json["segment_details"].forEach((v) {
        // _segmentDetails.add(dynamic.fromJson(v));
      });
    }
    _customerDetails = json["customer_details"] != null
        ? Customer_details.fromJson(json["customer_details"])
        : null;
    _pointsInCurrency = json["points_in_currency"];
    _icon = json["icon"];
    _color = json["color"];
    _description = json["description"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["reward_title"] = _rewardTitle;
    map["offer_title"] = _offerTitle;
    map["purchase_amount"] = _purchaseAmount;
    map["discount"] = _discount;
    map["points"] = _points;
    map["created_at"] = _createdAt;
    if (_segmentDetails != null) {
      map["segment_details"] = _segmentDetails.map((v) => v.toJson()).toList();
    }
    if (_customerDetails != null) {
      map["customer_details"] = _customerDetails.toJson();
    }
    map["points_in_currency"] = _pointsInCurrency;
    map["icon"] = _icon;
    map["color"] = _color;
    map["description"] = _description;
    return map;
  }
}

class Customer_details {
  String _name;
  int _points;
  String _number;

  String get name => _name;
  int get points => _points;
  String get number => _number;

  Customer_details({String name, int points, String number}) {
    _name = name;
    _points = points;
    _number = number;
  }

  Customer_details.fromJson(dynamic json) {
    _name = json["name"];
    _points = json["points"];
    _number = json["number"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    map["points"] = _points;
    map["number"] = _number;
    return map;
  }
}
