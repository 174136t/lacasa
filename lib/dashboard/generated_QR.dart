import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/modals/user.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/utils/shared.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrCode extends StatefulWidget {
  String qrData;
  GenerateQrCode({this.qrData});

  @override
  _GenerateQrCodeState createState() => _GenerateQrCodeState();
}

class _GenerateQrCodeState extends State<GenerateQrCode> {
  UserInfo user = LacasaUser.data.user.data;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController enteredCodeCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
//        appBar: PreferredSize(
//          child: Container(
//            color: Colors.transparent,
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: [
//                GestureDetector(
//                  onTap: () {},
//                  child: Container(
//                      margin: EdgeInsets.only(
//                          left: SizeConfig.blockSizeHorizontal * 10,
//                          top: SizeConfig.blockSizeVertical * 5),
//                      child: Image.asset(
//                        drawer,
//                        scale: 1.5,
//                      )),
//                ),
//                Container(
//                  alignment: Alignment.centerRight,
//                  child: Image.asset(
//                    isarabic ? mall_arabic : mall_english,
//                    scale: 1.5,
//                  ),
//                )
//              ],
//            ),
//          ),
//          preferredSize: Size.fromHeight(170),
//        ),
        body: Center(
          child: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Container(
                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                width: SizeConfig.blockSizeHorizontal * 100,
                height: SizeConfig.blockSizeVertical * 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * .75,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .07,
                            right: MediaQuery.of(context).size.width * .07,
                            top: MediaQuery.of(context).size.height * .03,
                            bottom: MediaQuery.of(context).size.height * .009),
                        child: Column(
                          // mainAxisAlignment: M7inAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                             Center(
                                                child: Image.asset(mall_english,
                                                height:MediaQuery.of(context)
                                                        .size
                                                        .height *0.2 ,),
                                              ),
                            Container(
                              child: Text(
                                AppLocalization.of(context)
                                    .getTranslatedValues("show_qr_merchant"),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            .025,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .015),
                            Text(
                              AppLocalization.of(context)
                                  .getTranslatedValues("get_qr_confirmation"),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * .018,
                                  color: Colors.black54),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .025),
                            Container(
                              height: MediaQuery.of(context).size.height * .3,
                              alignment: Alignment.center,
                              child: Center(
                                child: RepaintBoundary(
                                  key: _scaffoldKey,
                                  child: QrImage(
                                    data: widget.qrData,
                                    size:
                                        MediaQuery.of(context).size.height * .3,
                                    //embeddedImage: AssetImage('assets/applogo/logo.png'),
//                embeddedImageStyle: QrEmbeddedImageStyle(
//                  size: Size.fromHeight(20),
//                ),
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                     width: SizeConfig.blockSizeHorizontal*20,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          border: Border.all(color: newOffer,width: 1.5)
                                                        ),
                                    alignment: Alignment.bottomRight,
                                    // padding: EdgeInsets.only(
                                    //     right:
                                    //         MediaQuery.of(context).size.width *
                                    //             .02),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Center(
                                        child: Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValues("close"),
                                          style: TextStyle(
                                             fontWeight: FontWeight.w800,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .018,
                                              color: newOffer),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
