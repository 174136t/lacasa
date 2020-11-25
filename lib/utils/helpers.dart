//import 'dart:async';
//import 'dart:convert';
//import 'dart:io';
//
//import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:get/get.dart';
//import 'package:http/http.dart' as http;
//import 'package:lacasa/constants/apis.dart';
//import 'package:lacasa/localization/app_localization.dart';
//import 'package:lacasa/login_screens/login_screen.dart';
//import 'package:lacasa/utils/constants/bearer_token.dart';
//import 'package:lacasa/utils/routes.dart';
//
///* ----------------- Global variable for loading state -------------------- */
//bool isLoading = false;
///* ------------------------------------------------------------------------ */
//
//class ShowMessage {
//  static void toast(String msg) {
//    Fluttertoast.showToast(
//        msg: msg,
//        fontSize: 16,
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.CENTER);
//  }
//
//  static void snackBar(String title, String message, bool progress) {
//    Get.snackbar(title, message,
//        backgroundColor: Colors.black,
//        colorText: Colors.white,
//        showProgressIndicator: progress,
//        progressIndicatorBackgroundColor: Colors.lightBlueAccent,
//        progressIndicatorValueColor:
//            AlwaysStoppedAnimation<Color>(Colors.tealAccent),
//        borderRadius: 6);
//  }
//
//  static void bottomSheet(Widget sheet) {
//    Get.bottomSheet(sheet);
//  }
//
//  static void ofJson(var jsonResponse) {
//    Fluttertoast.showToast(
//        msg: jsonResponse['ShortMessage'],
//        fontSize: 16,
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.CENTER);
//  }
//
//  static void inDialog(String message, bool isError) {
//    Color color = isError ? Colors.redAccent : Colors.green;
//    Get.defaultDialog(
//        title: '',
//        titleStyle: TextStyle(
//            fontFamily: 'Monts',
//            fontSize: Get.height * 0.0,
//            fontWeight: FontWeight.bold),
//        content: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisSize: MainAxisSize.min,
//          children: [
//            CircleAvatar(
//              radius: Get.height * 0.032,
//              backgroundColor: color,
//              child: CircleAvatar(
//                  backgroundColor: Colors.white,
//                  radius: Get.height * 0.030,
//                  child: Icon(
//                    isError ? Icons.warning : Icons.done_outline,
//                    color: color,
//                    size: Get.height * 0.042,
//                  )),
//            ),
//            SizedBox(
//              height: Get.height * 0.016,
//            ),
//            Text(message ?? "",
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
//            SizedBox(height: Get.height * 0.02),
//          ],
//        ),
//        actions: [
//          Wrap(
//            alignment: WrapAlignment.center,
//            spacing: 8,
//            runSpacing: 8,
//            children: [
//              GestureDetector(
//                onTap: () => Get.back(),
//                child: Container(
//                  alignment: Alignment.center,
//                  margin: EdgeInsets.only(bottom: 16),
//                  width: Get.width * .32,
//                  height: Get.height * .05,
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(10),
//                      color: Colors.black),
//                  child: Text(
//                    'OK',
//                    style: TextStyle(
//                        fontFamily: 'Monts',
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold,
//                        fontSize: Get.height * .024),
//                  ),
//                ),
//              )
//            ],
//          )
//        ]);
//  }
//
//  static void guestDialog(BuildContext context) {
//    Color color = Colors.redAccent;
//    Get.defaultDialog(
//        title: '',
//        titleStyle: TextStyle(
//            fontFamily: 'Monts',
//            fontSize: Get.height * 0.0,
//            fontWeight: FontWeight.bold),
//        content: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisSize: MainAxisSize.min,
//          children: [
//            CircleAvatar(
//              radius: Get.height * 0.032,
//              backgroundColor: color,
//              child: CircleAvatar(
//                  backgroundColor: Colors.white,
//                  radius: Get.height * 0.030,
//                  child: Icon(
//                    Icons.warning,
//                    color: color,
//                    size: Get.height * 0.042,
//                  )),
//            ),
//            SizedBox(
//              height: Get.height * 0.016,
//            ),
//            Text(getTranslated(context, "you_have_to_login") ?? "",
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
//            SizedBox(height: Get.height * 0.02),
//          ],
//        ),
//        actions: [
//          Wrap(
//            alignment: WrapAlignment.center,
//            spacing: 8,
//            runSpacing: 8,
//            children: [
//              GestureDetector(
//                onTap: () => AppRoutes.makeFirst(context, LoginScreen()),
//                child: Container(
//                  alignment: Alignment.center,
//                  margin: EdgeInsets.only(bottom: 16),
//                  width: Get.width * .32,
//                  height: Get.height * .05,
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(10),
//                      color: Colors.black),
//                  child: Text(
//                    'OK',
//                    style: TextStyle(
//                        fontFamily: 'Monts',
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold,
//                        fontSize: Get.height * .024),
//                  ),
//                ),
//              )
//            ],
//          )
//        ]);
//  }
//
//  static void logoutDialog(BuildContext context) {
//    Color color = Colors.redAccent;
//    Get.defaultDialog(
//        barrierDismissible: true,
//        title: '',
//        titleStyle: TextStyle(
//            fontFamily: 'Monts',
//            fontSize: Get.height * 0.0,
//            fontWeight: FontWeight.bold),
//        content: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisSize: MainAxisSize.min,
//          children: [
//            CircleAvatar(
//              radius: Get.height * 0.032,
//              backgroundColor: color,
//              child: CircleAvatar(
//                  backgroundColor: Colors.white,
//                  radius: Get.height * 0.030,
//                  child: Icon(
//                    Icons.warning,
//                    color: color,
//                    size: Get.height * 0.042,
//                  )),
//            ),
//            SizedBox(
//              height: Get.height * 0.016,
//            ),
//            Text(getTranslated(context, 'auth_failed_redirect_to_home') ?? "",
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
//            SizedBox(height: Get.height * 0.02),
//          ],
//        ),
//        actions: [
//          Wrap(
//            alignment: WrapAlignment.center,
//            spacing: 8,
//            runSpacing: 8,
//            children: [
//              GestureDetector(
//                onTap: () => AppRoutes.makeFirst(context, LoginScreen()),
//                child: Container(
//                  alignment: Alignment.center,
//                  margin: EdgeInsets.only(bottom: 16),
//                  width: Get.width * .32,
//                  height: Get.height * .05,
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(10),
//                      color: Colors.black),
//                  child: Text(
//                    'OK',
//                    style: TextStyle(
//                        fontFamily: 'Monts',
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold,
//                        fontSize: Get.height * .024),
//                  ),
//                ),
//              )
//            ],
//          )
//        ]);
//  }
//
//  static void ofJsonInDialog(var jsonResponse, bool isError) {
//    Color color = isError ? Colors.redAccent : Colors.green;
//    Get.defaultDialog(
//        title: '',
//        titleStyle: TextStyle(
//            fontFamily: 'Monts',
//            fontSize: Get.height * 0.0,
//            fontWeight: FontWeight.bold),
//        content: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisSize: MainAxisSize.min,
//          children: [
//            CircleAvatar(
//              radius: Get.height * 0.032,
//              backgroundColor: color,
//              child: CircleAvatar(
//                  backgroundColor: Colors.white,
//                  radius: Get.height * 0.030,
//                  child: Icon(
//                    isError ? Icons.warning : Icons.done_outline,
//                    color: color,
//                    size: Get.height * 0.042,
//                  )),
//            ),
//            SizedBox(
//              height: Get.height * 0.016,
//            ),
//            Text(jsonResponse['ShortMessage'] ?? "",
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
//            SizedBox(height: Get.height * 0.02),
//          ],
//        ),
//        actions: [
//          Wrap(
//            alignment: WrapAlignment.center,
//            spacing: 8,
//            runSpacing: 8,
//            children: [
//              GestureDetector(
//                onTap: () => Get.back(),
//                child: Container(
//                  alignment: Alignment.center,
//                  margin: EdgeInsets.only(bottom: 16),
//                  width: Get.width * .32,
//                  height: Get.height * .05,
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(10),
//                      color: Colors.black),
//                  child: Text(
//                    'OK',
//                    style: TextStyle(
//                        fontFamily: 'Monts',
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold,
//                        fontSize: Get.height * .024),
//                  ),
//                ),
//              )
//            ],
//          )
//        ]);
//  }
//
//  static void customDialog(String title, String message, String buttonName,
//      Function onPressed, bool isError) {
//    Color color = isError ? Colors.redAccent : Colors.green;
//    Get.defaultDialog(
//        title: '',
//        titleStyle: TextStyle(
//            fontFamily: 'Monts',
//            fontSize: Get.height * 0.0,
//            color: color,
//            fontWeight: FontWeight.bold),
//        content: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisSize: MainAxisSize.min,
//          children: [
//            Text(
//              '$title',
//              style: TextStyle(
//                  fontFamily: 'Monts',
//                  fontSize: Get.height * 0.03,
//                  color: color,
//                  fontWeight: FontWeight.bold),
//            ),
//            SizedBox(
//              height: Get.height * 0.016,
//            ),
//            Text("$message",
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
//            SizedBox(height: Get.height * 0.02),
//          ],
//        ),
//        actions: [
//          Wrap(
//            alignment: WrapAlignment.center,
//            spacing: 8,
//            runSpacing: 8,
//            children: [
//              GestureDetector(
//                onTap: () {
//                  if (onPressed == null) {
//                    Get.back();
//                  } else {
//                    onPressed();
//                  }
//                },
//                child: Container(
//                  alignment: Alignment.center,
//                  margin: EdgeInsets.only(bottom: 16),
//                  width: Get.width * .32,
//                  height: Get.height * .05,
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(10),
//                      color: Colors.black),
//                  child: Text(
//                    '$buttonName',
//                    style: TextStyle(
//                        fontFamily: 'Monts',
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold,
//                        fontSize: Get.height * .024),
//                  ),
//                ),
//              )
//            ],
//          )
//        ]);
//  }
//
//  static void customDialogOfJson(String title, var jsonResponse,
//      String buttonName, Function onPressed, bool isError) {
//    Color color = isError ? Colors.redAccent : Colors.green;
//    Get.defaultDialog(
//        title: '$title',
//        titleStyle: TextStyle(
//            fontFamily: 'Monts',
//            fontSize: Get.height * 0.0,
//            color: color,
//            fontWeight: FontWeight.bold),
//        content: Column(
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisSize: MainAxisSize.min,
//          children: [
////            CircleAvatar(
////              radius: Get.height * 0.032,
////              backgroundColor: color,
////              child: CircleAvatar(
////                  backgroundColor: Colors.white,
////                  radius: Get.height * 0.030,
////                  child: Icon(
////                    isError ? Icons.warning : Icons.done_outline,
////                    color: color,
////                    size: Get.height * 0.042,
////                  )),
////            ),
//            Text(
//              '$title',
//              style: TextStyle(
//                  fontFamily: 'Monts',
//                  fontSize: Get.height * 0.03,
//                  color: color,
//                  fontWeight: FontWeight.bold),
//            ),
//            SizedBox(
//              height: Get.height * 0.016,
//            ),
//            Text(jsonResponse['ShortMessage'] ?? "",
//                textAlign: TextAlign.center,
//                style: TextStyle(
//                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
//            SizedBox(height: Get.height * 0.02),
//          ],
//        ),
//        actions: [
//          Wrap(
//            alignment: WrapAlignment.center,
//            spacing: 8,
//            runSpacing: 8,
//            children: [
//              GestureDetector(
//                onTap: () {
//                  if (onPressed == null) {
//                    Get.back();
//                  } else {
//                    onPressed();
//                  }
//                },
//                child: Container(
//                  alignment: Alignment.center,
//                  margin: EdgeInsets.only(bottom: 16),
//                  width: Get.width * .32,
//                  height: Get.height * .05,
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(10),
//                      color: Colors.black),
//                  child: Text(
//                    '$buttonName',
//                    style: TextStyle(
//                        fontFamily: 'Monts',
//                        color: Colors.white,
//                        fontWeight: FontWeight.bold,
//                        fontSize: Get.height * .024),
//                  ),
//                ),
//              )
//            ],
//          )
//        ]);
//  }
//
//  static void showSuccessSnackBar(var _scaffoldKey, jsonResponse) {
//    _scaffoldKey.currentState.showSnackBar(SnackBar(
//      backgroundColor: Colors.green,
//      content: Text(jsonResponse['ShortMessage'] ?? ""),
//      duration: Duration(seconds: 3),
//    ));
//  }
//
//  static void showErrorSnackBar(var _scaffoldKey, jsonResponse) {
//    _scaffoldKey.currentState.showSnackBar(SnackBar(
//      backgroundColor: Colors.red,
//      content: Text(jsonResponse['ShortMessage'] ?? ""),
//      duration: Duration(seconds: 3),
//    ));
//  }
//
//  static void inSnackBar(var _scaffoldKey, String message, bool isError) {
//    Color color = isError ? Colors.red : Colors.green;
//    _scaffoldKey.currentState.showSnackBar(SnackBar(
//      backgroundColor: color,
//      content: Text(message),
//      duration: Duration(seconds: 3),
//    ));
//  }
//}
//
//bool validateEmail(String value) {
//  Pattern pattern =
//      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//  RegExp regex = new RegExp(pattern);
//  if (!regex.hasMatch(value))
//    return false;
//  else
//    return true;
//}
//
//void showSnackBar(String title, String message) {
//  Get.snackbar(title, message,
//      backgroundColor: Colors.orange, colorText: Colors.white);
//}
//
//class ShowError {
//  static void show(int status) {
//    switch (status) {
//      case 200:
//        {
//          ShowMessage.toast('Request to the server failed');
//        }
//        break;
//    }
//  }
//}
//
//class GetNav {
//  static void to(Widget page) {
//    Get.to(page,
//        transition: Transition.cupertino,
//        duration: Duration(milliseconds: 400),
//        opaque: true);
//  }
//}
//
//
//
//class NotificationSender {
//  static void push(
//    String fcmToken,
//    String body,
//    String title,
//  ) async {
//    await http.post(
//      'https://fcm.googleapis.com/fcm/send',
//      headers: <String, String>{
//        'Content-Type': 'application/json',
//        'Authorization':
//            'key=AAAATNo2KJo:APA91bEgNvOl3MezZt5mshhDQqg1TGSqaINZS53Nyg6xPakugX1jKA4LXrKoW9hGMHddtHstafhWQyQG4VXm7uJXgKhI8xrKw-jfm7VnpWoJgpBHhH2jlbDgyHAY0vzvJGHz44u9GCH8',
//      },
//      body: jsonEncode(
//        <String, dynamic>{
//          'notification': <String, dynamic>{'body': '$body', 'title': '$title'},
//          'priority': 'high',
//          'data': <String, dynamic>{
//            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//            'id': '5',
//            "sound": "default",
//            'status': 'done'
//          },
//          'to': fcmToken,
//        },
//      ),
//    );
//  }
//}
//
//class ShowLottie extends StatelessWidget {
//  final String lottiePath;
//  ShowLottie({this.lottiePath});
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: SizedBox(
//        width: Get.width,
//        height: Get.height * 0.7,
//        // child: Lottie.asset(lottiePath),
//      ),
//    );
//  }
//}
//
//String getUserType(int id) {
//  switch (id) {
//    case 0:
//      return 'Customer';
//      break;
//    case 1:
//      return 'Merchant';
//      break;
//    default:
//      return 'Undefined';
//      break;
//  }
//}
//
//String getOrderStatus(int id) {
//  switch (id) {
//    case 0:
//      return 'Pending';
//      break;
//    case 1:
//      return 'Inprocess';
//      break;
//    case 2:
//      return 'Delivered';
//      break;
//    case 3:
//      return 'Canceled';
//      break;
//  }
//}
//
//String getSelectedLang(int id) {
//  switch (id) {
//    case 0:
//      return 'عربي';
//      break;
//    case 1:
//      return 'English';
//      break;
//    default:
//      return 'Undefined';
//      break;
//  }
//}
//
//String getPaymentMethod(int id) {
//  switch (id) {
//    case 0:
//      return 'K NET';
//      break;
//    case 1:
//      return 'Credit Card';
//      break;
//    case 2:
//      return 'COD';
//      break;
//    default:
//      return 'Undefined';
//      break;
//  }
//}
