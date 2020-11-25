import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lacasa/login_screens/login_screen.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeAgo;

// global variables
bool isLoading = false;
RefreshController refreshController = RefreshController();
int claimQrScreenName = 0;
String scannedQRToken = '';
const int CLAIM_OFFER = 0;
const int CREDIT_POINTS = 1;
const int REDEEM_REWARDS = 2;

class ShowMessage {
  static void toast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 16,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  static void snackBar(String title, String message, bool progress) {
    Get.snackbar(title, message,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        showProgressIndicator: progress,
        progressIndicatorBackgroundColor: Colors.lightBlueAccent,
        progressIndicatorValueColor:
            AlwaysStoppedAnimation<Color>(Colors.tealAccent),
        borderRadius: 6);
  }

  static void bottomSheet(Widget sheet) {
    Get.bottomSheet(sheet);
  }

  static void ofJson(var jsonResponse) {
    Fluttertoast.showToast(
        msg: jsonResponse['ShortMessage'],
        fontSize: 16,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER);
  }

  static void inDialog(String message, bool isError) {
    Color color = isError ? Colors.redAccent : Colors.green;
    Get.defaultDialog(
        title: '',
        titleStyle: TextStyle(
            fontFamily: 'Monts',
            fontSize: Get.height * 0.0,
            fontWeight: FontWeight.bold),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: Get.height * 0.032,
              backgroundColor: color,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: Get.height * 0.030,
                  child: Icon(
                    isError ? Icons.warning : Icons.done_outline,
                    color: color,
                    size: Get.height * 0.042,
                  )),
            ),
            SizedBox(
              height: Get.height * 0.016,
            ),
            Text(message ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
            SizedBox(height: Get.height * 0.02),
          ],
        ),
        actions: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 16),
                  width: Get.width * .32,
                  height: Get.height * .05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black54),
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontFamily: 'Monts',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.height * .024),
                  ),
                ),
              )
            ],
          )
        ]);
  }

  static void logoutDialog(BuildContext context) {
    Color color = Colors.redAccent;
    Get.defaultDialog(
        barrierDismissible: true,
        title: '',
        titleStyle: TextStyle(
            fontFamily: 'Monts',
            fontSize: Get.height * 0.0,
            fontWeight: FontWeight.bold),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: Get.height * 0.032,
              backgroundColor: color,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: Get.height * 0.030,
                  child: Icon(
                    Icons.warning,
                    color: color,
                    size: Get.height * 0.042,
                  )),
            ),
            SizedBox(
              height: Get.height * 0.016,
            ),
            Text('auth_failed_redirect_to_home',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
            SizedBox(height: Get.height * 0.02),
          ],
        ),
        actions: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              GestureDetector(
                onTap: () => AppRoutes.makeFirst(context, LoginScreen()),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 16),
                  width: Get.width * .32,
                  height: Get.height * .05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black54),
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontFamily: 'Monts',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.height * .024),
                  ),
                ),
              )
            ],
          )
        ]);
  }

  static void ofJsonInDialog(var jsonResponse, bool isError) {
    Color color = isError ? Colors.redAccent : Colors.green;
    Get.defaultDialog(
        title: '',
        titleStyle: TextStyle(
            fontFamily: 'Monts',
            fontSize: Get.height * 0.0,
            fontWeight: FontWeight.bold),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: Get.height * 0.032,
              backgroundColor: color,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: Get.height * 0.030,
                  child: Icon(
                    isError ? Icons.warning : Icons.done_outline,
                    color: color,
                    size: Get.height * 0.042,
                  )),
            ),
            SizedBox(
              height: Get.height * 0.016,
            ),
            Text(jsonResponse['ShortMessage'] ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Monts', fontSize: Get.height * 0.022)),
            SizedBox(height: Get.height * 0.02),
          ],
        ),
        actions: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 16),
                  width: Get.width * .32,
                  height: Get.height * .05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black54),
                  child: Text(
                    'OK',
                    style: TextStyle(
                        fontFamily: 'Monts',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Get.height * .024),
                  ),
                ),
              )
            ],
          )
        ]);
  }

  static void showSuccessSnackBar(var _scaffoldKey, jsonResponse) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(jsonResponse['message'] ?? ""),
      duration: Duration(seconds: 3),
    ));
  }

  static void showErrorSnackBar(var _scaffoldKey, jsonResponse) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.red,
      content: Text(jsonResponse['message'] ?? ""),
      duration: Duration(seconds: 3),
    ));
  }

  static void inSnackBar(var _scaffoldKey, String message, bool isError) {
    Color color = isError ? Colors.red : Colors.green;
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(message),
      duration: Duration(seconds: 3),
    ));
  }
}

class MyTimer {
  static pop(BuildContext context) async {
    var duration = const Duration(seconds: 3);
    return new Timer(duration, () {
      AppRoutes.pop(context);
    });
  }

  static toPage(Function page) async {
    var duration = const Duration(seconds: 3);
    return new Timer(duration, page);
  }
}

class EmptyList {
  static bool isTrue(List list) {
    if (list == null || list.isEmpty) {
      return true;
    } else {
      return false;
    }
  }
}

class MyTimeAgo {
  static String getByString(String strTime) {
    return timeAgo.format(DateTime.parse(strTime));
  }
}
