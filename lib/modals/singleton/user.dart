import 'package:lacasa/modals/user.dart';

class LacasaUser {
  // singleton
  static final LacasaUser _singleton = LacasaUser._internal();
  factory LacasaUser() => _singleton;
  LacasaUser._internal();
  static LacasaUser get data => _singleton;
  User user;
  String passwordResetToken = '';
  String otpCode = '';
  String campaignUUID = '';
  bool isStaff = false;
//  String Id;
//  String ProfileImageUrl = '';
//  String PhoneNumber = '';
//  String Username = '';
//  String Email = '';
//  dynamic Address = '';
//  String DeviceNumber = '';
//  String DeviceToken = '';
//  String DeviceFCM = '';
//  String AssignBranchId = '';
//  int UserType = 0;
//  bool IsEmailVerified = false;
//  bool NotificationEnabled = false;
//  bool OrderAuthenticationEnabled = false;
}
