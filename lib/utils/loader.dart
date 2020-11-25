import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyLoader extends StatefulWidget {
  final Color color;

  MyLoader({this.color = Colors.redAccent});

  @override
  _MyLoaderState createState() => _MyLoaderState();
}

class _MyLoaderState extends State<MyLoader> {
  @override
  void initState() {
    // startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: SpinKitFadingCircle(
            color: widget.color,
          ),
        ),
      ),
    );
  }

//  void inDialog(String message, bool isError) {
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
//                onTap: () {
//                  Get.back();
//                  setState(() {
//                    _timer.cancel();
//                  });
//                },
//                child: Container(
//                  alignment: Alignment.center,
//                  margin: EdgeInsets.only(bottom: 16),
//                  width: Get.width * .32,
//                  height: Get.height * .05,
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(10),
//                      color: AppColor.btn),
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
}
