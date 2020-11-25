import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/staff_dashboard/rewardsDialogs/customer_number.dart';
import 'package:lacasa/staff_dashboard/staff_dashboard.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/dialogs.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/my_web_view.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class StaffRewards extends StatefulWidget {
  final Function() refreshScreen;
  StaffRewards({Key key, this.refreshScreen}) : super(key: key);
  @override
  _StaffRewardsState createState() => _StaffRewardsState();
}

class _StaffRewardsState extends State<StaffRewards> {
  Uint8List bytes = Uint8List(0);
  String scanUrl;
  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() {
      scannedQRToken = barcode;
      claimQrScreenName = REDEEM_REWARDS;
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: SizeConfig.blockSizeVertical * 15,
                width: SizeConfig.blockSizeHorizontal * 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                    ),
                    color: newColor),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .05,
                    right: MediaQuery.of(context).size.width * .05,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              AppRoutes.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: pureWhite,
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.blockSizeHorizontal * 5,
                          ),
                          Container(
                            child: Text(
                              AppLocalization.of(context)
                                      .getTranslatedValues("redeem_rewards") ??
                                  "",
                              style: TextStyle(
                                  color: pureWhite,
                                  fontSize: SizeConfig.blockSizeVertical * 4,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .005,
                      ),
                      // Row(
                      //   children: [
                      //     Container(
                      //       width: SizeConfig.blockSizeHorizontal * 80,
                      //       child: Text(
                      //         AppLocalization.of(context).getTranslatedValues(
                      //                 "redeem_rewards_des") ??
                      //             "",
                      //         style: TextStyle(
                      //           fontSize: SizeConfig.blockSizeVertical * 2,
                      //         ),
                      //       ),
                      //     ),
                      //     Container()
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              _earnPointsCards(1, 'qr_code', qrImage,
                  getTranslated(context, 'customer_displays_a_QR')),
              _earnPointsCards(2, 'merchant_enter_code', merchant,
                  getTranslated(context, 'generate_a_code_to_customer')),
              _earnPointsCards(3, 'customer_number', customerNumber,
                  getTranslated(context, "add_points_to_customer")),
            ],
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
              return index == 2
                  ? GenerateCodeDialog()
                  : CustomerNumberRewardDialogStaff();
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

                // shape:

                //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .05,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                      .getTranslatedValues(title) ??
                                  "",
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
                                description ?? "",
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

  Widget _ScanFileDisplay(String scannedResult) {
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
                  scannedResult ?? "scan QR code",
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
                            Navigator.pop(context, false);
                            _launchQRLink(scannedResult);
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
