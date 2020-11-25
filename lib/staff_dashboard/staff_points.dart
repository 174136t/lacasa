import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/staff_dashboard/pointsDialog/customerNumber.dart';
import 'package:lacasa/staff_dashboard/pointsDialog/enterCodedDalog.dart';
import 'package:lacasa/staff_dashboard/staff_dashboard.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/my_web_view.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class StaffPoints extends StatefulWidget {
  final Function() refreshScreen;
  StaffPoints({Key key, this.refreshScreen}) : super(key: key);
  @override
  _StaffPointsState createState() => _StaffPointsState();
}

class _StaffPointsState extends State<StaffPoints> {
  Uint8List bytes = Uint8List(0);
  String scanUrl;
  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() {
      scannedQRToken = barcode;
      claimQrScreenName = CREDIT_POINTS;
      staffScreenMover = 5;
      widget.refreshScreen();
    });
  }

  _launchQRLink(url) async {
    AppRoutes.push(context, MyWebView(url: url));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: newWhite,
      appBar: PreferredSize(
        child: Container(
          color: newWhite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                // onTap: () {
                //   setState(() {
                //     _scaffoldKey.currentState.openDrawer();
                //   });
                // },
                child: Container(
                    color: newWhite,
                    padding: EdgeInsets.all(25),
                    margin:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                    child: Image.asset(
                      drawer,
                      scale: 1.5,
                      color: newWhite,
                    )),
              ),
              Container(
                padding: EdgeInsets.only(top: 25),
                // alignment: Alignment.centerRight,
                child: Image.asset(
                  isarabic ? mall_english : mall_english,
                  height: SizeConfig.blockSizeVertical * 8,
                ),
              )
            ],
          ),
        ),
        preferredSize: Size.fromHeight(150),
      ),
      body: Container(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .05,
                    right: MediaQuery.of(context).size.width * .05,
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          AppLocalization.of(context)
                              .getTranslatedValues("customer_points"),
                          style: TextStyle(
                              color: newColor,
                              fontSize: SizeConfig.blockSizeVertical * 5,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .005,
                      ),
                      Row(
                        children: [
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 90,
                            child: Text(
                              AppLocalization.of(context)
                                  .getTranslatedValues("customer_points_des"),
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical * 2,
                              ),
                            ),
                          ),
                          Container()
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                _earnPointsCards(1, 'qr_code', qrImage, 'qr_code_des'),
                _earnPointsCards(2, 'enter_code', enter, 'enter_code_des'),
                _earnPointsCards(
                    3, 'merchant_enter_code', merchant, 'enter_code_des'),
                _earnPointsCards(4, 'customer_number', customerNumber,
                    'customer_number_des'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _categoryThumbnail(int index, String logo) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0),
      alignment: FractionalOffset.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          color: index % 2 == 1 ? Color(0xffDBAE0F) : Color(0xff2BA88A),
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(12),
        child: Container(
          height: MediaQuery.of(context).size.height * .07,
          child: Image.asset(
            logo,
            color: pureWhite,
          ),
        ),
      ),
    );
  }

  Widget _earnPointsCards(
      int index, String title, String logo, String description) {
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          _scan();

          return;
        }
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return 
              index == 2
              ? EnterCodePointDialogStaff()
              : index == 3
                  ? EnterCodePointDialogStaff()
                  : CustomerNumberPointDialogStaff();
            });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * .01,
            horizontal: MediaQuery.of(context).size.width * .025),
        child: Stack(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10),
              child: Container(
                height: SizeConfig.blockSizeVertical * 15,
                decoration: BoxDecoration(
                    color:
                        index % 2 == 1 ? Color(0xffFCCF3E) : Color(0xff04896B),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .05,
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Expanded(
                      //   flex: 1,
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //         height: MediaQuery.of(context).size.height * .05,
                      //         child: Image.asset(
                      //           logo,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.only(
                      //     right: MediaQuery.of(context).size.width * .05,
                      //     left: MediaQuery.of(context).size.width * .03,
                      //   ),
                      //   child: Container(
                      //     height: MediaQuery.of(context).size.height * .15,
                      //     width: MediaQuery.of(context).size.width * .002,
                      //     color: Color(0xffD2D2D2),
                      //   ),
                      // ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 10,
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalization.of(context)
                                  .getTranslatedValues(title),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * .025,
                                  color: index % 2 == 1 ? newBlack : pureWhite,
                                  fontWeight: FontWeight.w900),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .005,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .55,
                              child: Text(
                                AppLocalization.of(context)
                                    .getTranslatedValues(description),
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * .018,
                                  color: index % 2 == 1 ? newBlack : pureWhite,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _categoryThumbnail(index, logo)
          ],
        ),
      ),
    );
  }

  Widget _ScanFileDisplay(scannedResult) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: SizeConfig.blockSizeHorizontal * 90,
          height: SizeConfig.blockSizeHorizontal * 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 5, top: 5),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    AppRoutes.pop(context);
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.black)),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  scanUrl ?? "scan file",
                  style: TextStyle(
                      fontFamily: 'babas',
                      color: Colors.grey,
                      fontSize: SizeConfig.blockSizeHorizontal * 4),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 7),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            _launchQRLink(scannedResult);
                            Navigator.pop(context, false);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: SizeConfig.blockSizeHorizontal * 100,
                            height: SizeConfig.blockSizeVertical * 5,
                            decoration: BoxDecoration(
                              color: blackColor,
                              border: Border.all(width: 1, color: blackColor),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "Use this link",
                              style: TextStyle(
                                  fontFamily: 'babas',
                                  color: whiteColor,
                                  fontSize: SizeConfig.blockSizeHorizontal * 5),
                            ),
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
