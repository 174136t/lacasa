import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lacasa/language/select_language.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/routes.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
        () => AppRoutes.makeFirst(context, SelectLanguage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(splash_back), fit: BoxFit.cover)),
          child: Image.asset(splash_logo,  height:
                                  MediaQuery.of(context).size.height * 0.35,filterQuality: FilterQuality.high,),),
    );
  }
}
