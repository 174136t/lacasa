import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/dashboard/generated_QR.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/modals/user.dart';
import 'package:lacasa/splash/splash.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/globals.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:qr_flutter/qr_flutter.dart';

///// logout
class LogOut extends StatefulWidget {
  @override
  _LogOutState createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: SizeConfig.blockSizeHorizontal * 90,
          height: SizeConfig.blockSizeHorizontal * 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: whiteColor,
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
                        border: Border.all(width: 1, color: blackColor)),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: blackColor,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  AppLocalization.of(context).getTranslatedValues('logout'),
                  style: TextStyle(
                      fontFamily: 'babas',
                      color: blackColor,
                      fontSize: SizeConfig.blockSizeHorizontal * 5),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  AppLocalization.of(context)
                      .getTranslatedValues('want_to_logout'),
                  style: TextStyle(
                      fontFamily: 'babas',
                      color: blackColor,
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
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: SizeConfig.blockSizeHorizontal * 100,
                            height: SizeConfig.blockSizeVertical * 5,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: blackColor),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              AppLocalization.of(context)
                                  .getTranslatedValues('no'),
                              style: TextStyle(
                                  fontFamily: 'babas',
                                  color: blackColor,
                                  fontSize: SizeConfig.blockSizeHorizontal * 5),
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => Splash()),
                                (Route<dynamic> route) => false);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: SizeConfig.blockSizeHorizontal * 100,
                            height: SizeConfig.blockSizeVertical * 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: blackColor,
                            ),
                            child: Text(
                              AppLocalization.of(context)
                                  .getTranslatedValues('yes'),
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

////

/// claim offer dialog

class ClaimOfferDialog extends StatefulWidget {
  String offerUUID;
  ClaimOfferDialog({this.offerUUID});
  @override
  _ClaimOfferDialogState createState() =>
      _ClaimOfferDialogState(offerUUID: offerUUID);
}

class _ClaimOfferDialogState extends State<ClaimOfferDialog> {
  String offerUUID;
  _ClaimOfferDialogState({this.offerUUID});
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static String URL =
      'https://nqatlacasa.herokuapp.com/api/v1/staff/offer/validateQrCodeFormData';
  // 'https://beta.nqat.me/campaign/iphase-vX/staff#/offers/link?token=';
  String qrData = '';
  void onGenerateQRCode(bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "uuid": LacasaUser.data.campaignUUID,
        "offer": offerUUID,
      };
      print(body);
      var response = await http.post("${Apis.getClaimOfferToken}",
          headers: MyHeaders.header(), body: body);
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
        setState(() {
          isLoading = false;
          qrData = URL + jsonResponse['data']['token'];
          print('sending :$qrData \n');
        });

        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return GenerateQrCode(
                qrData: qrData,
              );
            });
      } else {
        setState(() {
          isLoading = false;
        });
        ShowMessage.showErrorSnackBar(
          _scaffoldKey,
          jsonResponse,
        );
      }
    } on SocketException {
      ShowMessage.inDialog('No Internet Connection', true);
      setState(() {
        isLoading = false;
      });
      print('No Internet connection');
    } on HttpException catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
      ShowMessage.inDialog('Couldn\'t find the results', true);
      print("Couldn't find the post");
    } on FormatException catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
      ShowMessage.inDialog('Bad response format from server', true);
      print("Bad response format");
    } catch (value) {
      setState(() {
        isLoading = false;
      });
      ShowMessage.inSnackBar(_scaffoldKey, value.toString(), true);
    }
  }

  Widget _categoryThumbnail() {
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 24),
      // alignment: FractionalOffset.center,
      child: Container(
        decoration: BoxDecoration(
          color: dialogCardColor,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff04896b),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  // color: Color(0xffd9d9d9),
                  shape: BoxShape.circle,
                ),
                // padding: EdgeInsets.all(12),
                child: Container(
                    height: MediaQuery.of(context).size.height * .05,
                    child: Center(child: Image.asset("assets/images/i.png"))),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              width: SizeConfig.blockSizeHorizontal * 80,
              height: SizeConfig.blockSizeVertical * 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: dialogCardColor),
              child: isLoading
                  ? Center(
                      child: Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator()),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 10,
                        ),
                        Container(
                          // margin: EdgeInsets.only(

                          //     left: SizeConfig.blockSizeHorizontal * 5),

                          alignment: Alignment.center,

                          child: Text(
                            AppLocalization.of(context)
                                .getTranslatedValues('claim_offer'),
                            style: TextStyle(

                                // fontFamily: 'babas',

                                color: newColor,
                                fontWeight: FontWeight.w900,
                                fontSize: SizeConfig.blockSizeHorizontal * 5),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            onGenerateQRCode(true);
                          },
                          child: Container(
                            // margin: EdgeInsets.symmetric(

                            //     horizontal: SizeConfig.blockSizeHorizontal * 10),

                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // SizedBox(

                                    //   height: SizeConfig.blockSizeHorizontal * 5,

                                    //   child: Image.asset(

                                    //     star,

                                    //   ),

                                    // ),

                                    // SizedBox(

                                    //   width: SizeConfig.blockSizeHorizontal * 3,

                                    // ),

                                    Expanded(
                                      child: Container(
                                        // height:
                                        //     SizeConfig.blockSizeVertical * 8,

                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.blockSizeHorizontal *
                                                    5),

                                        // width: SizeConfig.blockSizeHorizontal*90,

                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: newOffer, width: 2)),

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    AppLocalization.of(context)
                                                        .getTranslatedValues(
                                                            'qr_code'),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: SizeConfig
                                                                .blockSizeHorizontal *
                                                            4),
                                                  ),
                                                  Text(
                                                    AppLocalization.of(context)
                                                        .getTranslatedValues(
                                                            'qr_code_merchant'),
                                                    style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .blockSizeHorizontal *
                                                            3),
                                                  )
                                                ],
                                              ),
                                              Image.asset(
                                                qrImage,
                                                color: newBlack,
                                                filterQuality:
                                                    FilterQuality.high,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Divider(

                                //   color: Colors.grey,

                                //   thickness: 1,

                                // )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 3,
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return EarnPointsDialog(
                                      isCustomerNumberClicked: true);
                                });
                          },
                          child: Container(
                            // margin: EdgeInsets.symmetric(

                            //     horizontal: SizeConfig.blockSizeHorizontal * 10),

                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // SizedBox(

                                    //   height: SizeConfig.blockSizeHorizontal * 5,

                                    //   child: Image.asset(

                                    //     star,

                                    //   ),

                                    // ),

                                    // SizedBox(

                                    //   width: SizeConfig.blockSizeHorizontal * 3,

                                    // ),

                                    Expanded(
                                      child: Container(
                                        // height:
                                        //     SizeConfig.blockSizeVertical * 8,

                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.blockSizeHorizontal *
                                                    5),

                                        // width: SizeConfig.blockSizeHorizontal*90,

                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: newOffer, width: 2)),

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    AppLocalization.of(context)
                                                        .getTranslatedValues(
                                                            'customer_number'),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: SizeConfig
                                                                .blockSizeHorizontal *
                                                            4),
                                                  ),
                                                  Container(
                                                    width: SizeConfig
                                                            .blockSizeHorizontal *
                                                        50,
                                                    child: Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .getTranslatedValues(
                                                              'customer_number_merhcnat'),
                                                      style: TextStyle(
                                                          fontSize: SizeConfig
                                                                  .blockSizeHorizontal *
                                                              3),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Image.asset(
                                                customerNumber,
                                                color: newBlack,
                                                filterQuality:
                                                    FilterQuality.high,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        _categoryThumbnail()
      ],
    );
  }
}

/////////////// new

class EarnPointsDialog extends StatefulWidget {
  bool isQrClicked;
  bool isEnterCodeClicked;
  bool isMerhcantClicked;
  bool isCustomerNumberClicked;
  bool isRedeemed;
  EarnPointsDialog(
      {this.isQrClicked = false,
      this.isEnterCodeClicked = false,
      this.isMerhcantClicked = false,
      this.isCustomerNumberClicked = false,
      this.isRedeemed = false});

  @override
  _EarnPointsDialogState createState() => _EarnPointsDialogState();
}

class _EarnPointsDialogState extends State<EarnPointsDialog> {
  UserInfo user = LacasaUser.data.user.data;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController enteredCodeCont = TextEditingController();

  /*-------------------------------- Methods------------------------------*/

  void verifyMerchantCode(bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });
      var header = {
        "Authorization": "bearer " + BEARER_TOKEN,
        "Content-Type": "application/x-www-form-urlencoded"
      };
      print("bearer " + BEARER_TOKEN);
      var body = {
        "uuid": customerCampaignUUID,
        "code": enteredCodeCont.text.trim(),
        "purchase_amount": "10",
      };
      print("body: $body");
      print('header:$header');
      var response = await http.post("${Apis.processMerchantEntry}",
          headers: header, body: body);
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200) {
        setState(() {
          isLoading = false;
        });

        //AppRoutes.replace(context, Home());

      } else {
        setState(() {
          isLoading = false;
        });
        ShowMessage.showErrorSnackBar(
          _scaffoldKey,
          jsonResponse,
        );
      }
    } on SocketException {
      ShowMessage.inDialog('No Internet Connection', true);
      setState(() {
        isLoading = false;
      });
      print('No Internet connection');
    } on HttpException catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
      ShowMessage.inDialog('Couldn\'t find the results', true);
      print("Couldn't find the post");
    } on FormatException catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
      ShowMessage.inDialog('Bad response format from server', true);
      print("Bad response format");
    } catch (value) {
      setState(() {
        isLoading = false;
      });
      ShowMessage.inSnackBar(_scaffoldKey, value.toString(), true);
      startTime();
    }
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, () {
      Navigator.pop(context);
    });
  }

  /*----------------------------------------------------------------------*/
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
            child: SingleChildScrollView(
              child: Container(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                  width: SizeConfig.blockSizeHorizontal * 100,
                  height: SizeConfig.blockSizeVertical * 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.isRedeemed
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.blockSizeHorizontal * 10),
                              // height: MediaQuery.of(context).size.height * .5,
                              width: SizeConfig.blockSizeHorizontal * 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white,
                              ),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .02,
                                      // right: MediaQuery.of(context).size.width * .07,
                                      top: MediaQuery.of(context).size.height *
                                          .03,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              .009),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .03,
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .05,
                                            bottom: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .01),
                                        child: Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValues(
                                                  "redeem_reward"),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .017,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      list(1, 'qr_code', qrImage,
                                          'show_qr_code'),
                                      list(2, 'merchant_enter_code', merchant,
                                          'give_phone'),
                                      list(3, 'customer_number', customerNumber,
                                          'provide_number'),
                                    ],
                                  )),
                            )
                          : widget.isQrClicked
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * .75,
                                  width: MediaQuery.of(context).size.width * .8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                .07,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                .07,
                                        top:
                                            MediaQuery.of(context).size.height *
                                                .03,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                .009),
                                    child: Column(
                                      // mainAxisAlignment: M7inAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Center(
                                          child: Image.asset(
                                            mall_english,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            AppLocalization.of(context)
                                                .getTranslatedValues(
                                                    "show_qr_merchant"),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .025,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .015),
                                        Text(
                                          AppLocalization.of(context)
                                              .getTranslatedValues(
                                                  "get_qr_confirmation"),
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .018,
                                              color: Colors.black54),
                                          textAlign: TextAlign.left,
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .025),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .3,
                                          alignment: Alignment.center,
                                          child: Center(
                                            child: RepaintBoundary(
                                              key: _scaffoldKey,
                                              child: QrImage(
                                                data: LacasaUser
                                                    .data.user.data.uuid,
                                                size: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .4,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                width: SizeConfig
                                                        .blockSizeHorizontal *
                                                    20,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    border: Border.all(
                                                        color: newOffer,
                                                        width: 1.5)),
                                                alignment:
                                                    Alignment.bottomRight,
                                                padding: EdgeInsets.only(
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .02),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    AppLocalization.of(context)
                                                        .getTranslatedValues(
                                                            "close"),
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .018,
                                                        color: newOffer),
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
                              : widget.isEnterCodeClicked ||
                                      widget.isMerhcantClicked ||
                                      widget.isCustomerNumberClicked
                                  ? SingleChildScrollView(
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .55,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .8,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            color: Colors.white),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .03,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .03,
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .03,
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .02),
                                          child: Column(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Center(
                                                child: Image.asset(
                                                  mall_english,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                                ),
                                              ),
                                              Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        widget
                                                                .isCustomerNumberClicked
                                                            ? AppLocalization
                                                                    .of(context)
                                                                .getTranslatedValues(
                                                                    "customer_number")
                                                            : widget
                                                                    .isMerhcantClicked
                                                                ? AppLocalization.of(
                                                                        context)
                                                                    .getTranslatedValues(
                                                                        "let_merchant_code")
                                                                : AppLocalization.of(
                                                                        context)
                                                                    .getTranslatedValues(
                                                                        "enter_code"),
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                .025,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Container()
                                                    ],
                                                  )),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .015),
                                              Row(
                                                children: [
                                                  Container(
                                                    alignment: isarabic
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                    width: SizeConfig
                                                            .blockSizeHorizontal *
                                                        60,
                                                    child: Text(
                                                      widget
                                                              .isCustomerNumberClicked
                                                          ? AppLocalization.of(
                                                                  context)
                                                              .getTranslatedValues(
                                                                  "give_phone")
                                                          : widget
                                                                  .isMerhcantClicked
                                                              ? AppLocalization
                                                                      .of(
                                                                          context)
                                                                  .getTranslatedValues(
                                                                      "hand_over_device")
                                                              : AppLocalization
                                                                      .of(
                                                                          context)
                                                                  .getTranslatedValues(
                                                                      "code_merchant_below"),
                                                      style: TextStyle(
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .018,
                                                          color:
                                                              Colors.black87),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  Container()
                                                ],
                                              ),
                                              SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .02),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .065,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: formColor),
                                                // width: MediaQuery.of(context).size.width * .6,
                                                child: Center(
                                                  child: TextFormField(
                                                    controller: enteredCodeCont,
                                                    decoration: InputDecoration(
                                                      // filled: true,
                                                      // fillColor: Colors.amber,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    2)),
                                                        borderSide: BorderSide(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .002,
                                                            color: Colors
                                                                .transparent),
                                                      ),
                                                      // focusedBorder:
                                                      //     OutlineInputBorder(
                                                      //   borderRadius:
                                                      //       BorderRadius.all(
                                                      //           Radius.circular(2)),
                                                      //   borderSide: BorderSide(
                                                      //       width: 1,
                                                      //       color:
                                                      //           Colors.transparent),
                                                      // ),
                                                      // errorBorder:
                                                      //     OutlineInputBorder(
                                                      //   borderRadius:
                                                      //       BorderRadius.all(
                                                      //           Radius.circular(5)),
                                                      //   borderSide: BorderSide(
                                                      //       width: 1,
                                                      //       color:
                                                      //           Colors.transparent),
                                                      // ),
                                                      // focusedErrorBorder:
                                                      //     OutlineInputBorder(
                                                      //   borderRadius:
                                                      //       BorderRadius.all(
                                                      //           Radius.circular(5)),
                                                      //   borderSide: BorderSide(
                                                      //       width: 1,
                                                      //       color:
                                                      //           Colors.transparent),
                                                      // ),
                                                      // border: OutlineInputBorder(
                                                      //     borderSide: BorderSide(
                                                      //         color: Colors
                                                      //             .transparent),
                                                      //     borderRadius:
                                                      //         BorderRadius.circular(
                                                      //             8))
                                                      // ,
                                                      suffixIcon: widget
                                                              .isCustomerNumberClicked
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                Clipboard.setData(
                                                                    new ClipboardData(
                                                                        text: user
                                                                            .number));
                                                                ShowMessage.inSnackBar(
                                                                    _scaffoldKey,
                                                                    "Text Copied",
                                                                    false);
                                                              },
                                                              child:
                                                                  Image.asset(
                                                                'assets/images/copy.png',
                                                                scale: 1.5,
                                                                // color: newBlack,
                                                              ),
                                                            )
                                                          : null,
                                                      contentPadding: EdgeInsets.only(
                                                          left: widget
                                                                  .isCustomerNumberClicked
                                                              ? MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .2
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .05),
                                                      hintText: widget
                                                              .isCustomerNumberClicked
                                                          ? '${user?.number}'
                                                          : 'Enter 9-digit code',
                                                      hintStyle: TextStyle(
                                                          fontWeight: widget
                                                                  .isCustomerNumberClicked
                                                              ? FontWeight.bold
                                                              : FontWeight
                                                                  .normal,
                                                          color:
                                                              widget.isCustomerNumberClicked
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .black38,
                                                          fontSize: widget
                                                                  .isCustomerNumberClicked
                                                              ? MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  .02
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  .017),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              widget.isCustomerNumberClicked
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        width: SizeConfig
                                                                .blockSizeHorizontal *
                                                            20,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            border: Border.all(
                                                                color: newOffer,
                                                                width: 1.5)),
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        // padding: EdgeInsets.only(
                                                        //     right: MediaQuery.of(
                                                        //                 context)
                                                        //             .size
                                                        //             .width *
                                                        //         .02),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Center(
                                                            child: Text(
                                                              AppLocalization.of(
                                                                      context)
                                                                  .getTranslatedValues(
                                                                      "close"),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      .018,
                                                                  color:
                                                                      newOffer),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            .4,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            .03,
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .1,
                                                          ),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      MaterialButton(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                    padding: EdgeInsets.only(
                                                                        left: 0,
                                                                        top: 0,
                                                                        bottom:
                                                                            0),
                                                                    onPressed:
                                                                        () {
                                                                      verifyMerchantCode(
                                                                          true);
//                                                              Fluttertoast
//                                                                  .showToast(
//                                                                      msg:
//                                                                          'Your code is verified successfuly');
//                                                              AppRoutes.pop(
//                                                                  context);
                                                                    },
                                                                    color:
                                                                        newOffer,
                                                                    child: Text(
                                                                      AppLocalization.of(
                                                                              context)
                                                                          .getTranslatedValues(
                                                                              "verify"),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w800,
                                                                          fontSize: MediaQuery.of(context).size.height *
                                                                              .018,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                      MaterialButton(
                                                                    elevation:
                                                                        0,
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            left:
                                                                                0),
                                                                    onPressed:
                                                                        () {
                                                                      AppRoutes.pop(
                                                                          context);
                                                                    },
                                                                    color: Colors
                                                                        .white,
                                                                    child: Text(
                                                                      AppLocalization.of(
                                                                              context)
                                                                          .getTranslatedValues(
                                                                              "close"),
                                                                      style: TextStyle(
                                                                          fontSize: MediaQuery.of(context).size.height *
                                                                              .018,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container()
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }

  Widget list(int index, String title, String logo, String description) {
    return GestureDetector(
      onTap: () {
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return index == 1
                  ? EarnPointsDialog(isQrClicked: true)
                  : index == 2
                      ? EarnPointsDialog(isMerhcantClicked: true)
                      : EarnPointsDialog(isCustomerNumberClicked: true);
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * .06),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .04,
                    child: Image.asset(
                      logo,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppLocalization.of(context).getTranslatedValues(title),
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * .019,
                            color: Color(0xff081F32),
                            fontWeight: FontWeight.bold),
                      ),
                      Container()
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        AppLocalization.of(context)
                            .getTranslatedValues(description),
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * .018,
                            color: Color(0xff081F32).withOpacity(.60),
                            height: MediaQuery.of(context).size.height * .0025),
                        overflow: TextOverflow.clip,
                      ),
                      Container()
                    ],
                  ),
                  Divider(
                    color: index == 3 ? Colors.white : Colors.grey,
                    height: index == 3
                        ? MediaQuery.of(context).size.height * .03
                        : MediaQuery.of(context).size.height * .06,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

////////

class StaffPointsDialog extends StatefulWidget {
  bool isQrClicked;
  bool isEnterCodeClicked;
  bool isMerhcantClicked;
  bool isCustomerNumberClicked;
  bool isRedeemed;
  bool isClaimOffers;
  StaffPointsDialog(
      {this.isQrClicked = false,
      this.isEnterCodeClicked = false,
      this.isMerhcantClicked = false,
      this.isCustomerNumberClicked = false,
      this.isRedeemed = false,
      this.isClaimOffers});

  @override
  _StaffPointsDialogState createState() => _StaffPointsDialogState();
}

class _StaffPointsDialogState extends State<StaffPointsDialog> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
            width: SizeConfig.blockSizeHorizontal * 100,
            height: SizeConfig.blockSizeVertical * 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.isRedeemed
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 10),
                        // height: MediaQuery.of(context).size.height * .5,
                        width: SizeConfig.blockSizeHorizontal * 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                        ),
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * .02,
                                // right: MediaQuery.of(context).size.width * .07,
                                top: MediaQuery.of(context).size.height * .03,
                                bottom:
                                    MediaQuery.of(context).size.height * .009),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .03,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              .01),
                                  child: Text(
                                    AppLocalization.of(context)
                                        .getTranslatedValues("redeem_reward"),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                .017,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                list(1, 'qr_code', qrImage, 'show_qr_code'),
                                list(2, 'merchant_enter_code', merchant,
                                    'give_phone'),
                                list(3, 'customer_number', customerNumber,
                                    'provide_number'),
                              ],
                            )),
                      )
                    : widget.isQrClicked
                        ? Container(
                            height: MediaQuery.of(context).size.height * .55,
                            width: MediaQuery.of(context).size.width * .7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * .07,
                                  // right: MediaQuery.of(context).size.width * .07,
                                  top: MediaQuery.of(context).size.height * .03,
                                  bottom: MediaQuery.of(context).size.height *
                                      .009),
                              child: Column(
                                // mainAxisAlignment: M7inAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    AppLocalization.of(context)
                                        .getTranslatedValues(
                                            "show_qr_merchant"),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                .025,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .015),
                                  Text(
                                    AppLocalization.of(context)
                                        .getTranslatedValues(
                                            "get_qr_confirmation"),
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                .018,
                                        color: Colors.black54),
                                    textAlign: TextAlign.left,
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .025),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                .08),
                                    child: Image.asset(
                                      qrCode,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .3,
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.bottomRight,
                                      padding: EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .02),
                                      child: Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValues("close"),
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .018,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : widget.isEnterCodeClicked ||
                                widget.isMerhcantClicked ||
                                widget.isCustomerNumberClicked
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * .32,
                                width: MediaQuery.of(context).size.width * .7,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Colors.white),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .03,
                                      right: MediaQuery.of(context).size.width *
                                          .03,
                                      top: MediaQuery.of(context).size.height *
                                          .03,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              .02),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          children: [
                                            Text(
                                              widget.isCustomerNumberClicked
                                                  ? AppLocalization.of(context)
                                                      .getTranslatedValues(
                                                          "customer_number")
                                                  : widget.isMerhcantClicked
                                                      ? AppLocalization.of(
                                                              context)
                                                          .getTranslatedValues(
                                                              "let_merchant_code")
                                                      : AppLocalization.of(
                                                              context)
                                                          .getTranslatedValues(
                                                              "enter_code"),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          .025,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Container()
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .015),
                                      Container(
                                          child: Row(
                                        children: [
                                          Container(
                                            alignment: isarabic
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            width:
                                                SizeConfig.blockSizeHorizontal *
                                                    60,
                                            child: Text(
                                              widget.isCustomerNumberClicked
                                                  ? AppLocalization.of(context)
                                                      .getTranslatedValues(
                                                          "give_phone")
                                                  : widget.isMerhcantClicked
                                                      ? AppLocalization.of(
                                                              context)
                                                          .getTranslatedValues(
                                                              "hand_over_device")
                                                      : AppLocalization.of(
                                                              context)
                                                          .getTranslatedValues(
                                                              "code_merchant_below"),
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          .018,
                                                  color: Colors.black87),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Container()
                                        ],
                                      )),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .02),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .065,
                                        // width: MediaQuery.of(context).size.width * .6,
                                        child: Material(
                                          elevation: 10.0,
                                          shadowColor: Colors.black,
                                          child: TextFormField(
                                            enabled:
                                                !widget.isCustomerNumberClicked,
                                            decoration: InputDecoration(
                                              // filled: true,
                                              // fillColor: Colors.amber,
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(2)),
                                                borderSide: BorderSide(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .002,
                                                    color: Colors.black87),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(2)),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.transparent),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.transparent),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: Colors.transparent),
                                              ),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          Colors.transparent),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              suffixIcon:
                                                  widget.isCustomerNumberClicked
                                                      ? Image.asset(
                                                          'assets/images/copy.png',
                                                          scale: 1.5,
                                                        )
                                                      : null,
                                              contentPadding: EdgeInsets.only(
                                                  left: widget
                                                          .isCustomerNumberClicked
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .2
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          .05),
                                              hintText:
                                                  widget.isCustomerNumberClicked
                                                      ? '747-567-123'
                                                      : 'Enter 9-digit code',
                                              hintStyle: TextStyle(
                                                  fontWeight: widget
                                                          .isCustomerNumberClicked
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                                  color: widget
                                                          .isCustomerNumberClicked
                                                      ? Colors.black
                                                      : Colors.black38,
                                                  fontSize: widget
                                                          .isCustomerNumberClicked
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          .02
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          .017),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      widget.isCustomerNumberClicked
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                padding: EdgeInsets.only(
                                                    right:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            .02),
                                                child: Text(
                                                  AppLocalization.of(context)
                                                      .getTranslatedValues(
                                                          "close"),
                                                  style: TextStyle(
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .018,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .4,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .03,
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        .1,
                                                  ),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: MaterialButton(
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 0,
                                                                    top: 0,
                                                                    bottom: 0),
                                                            onPressed: () {
                                                              Fluttertoast
                                                                  .showToast(
                                                                      msg:
                                                                          'Your code is verified successfuly');
                                                              AppRoutes.pop(
                                                                  context);
                                                            },
                                                            color: Colors.blue,
                                                            child: Text(
                                                              AppLocalization.of(
                                                                      context)
                                                                  .getTranslatedValues(
                                                                      "verify"),
                                                              style: TextStyle(
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      .018,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: MaterialButton(
                                                            elevation: 0,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 0),
                                                            onPressed: () {
                                                              AppRoutes.pop(
                                                                  context);
                                                            },
                                                            color: Colors.white,
                                                            child: Text(
                                                              AppLocalization.of(
                                                                      context)
                                                                  .getTranslatedValues(
                                                                      "close"),
                                                              style: TextStyle(
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      .018,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                ),
                              )
                            : Container()
              ],
            )),
      ),
    );
  }

  Widget list(int index, String title, String logo, String description) {
    return GestureDetector(
      onTap: () {
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return index == 1
                  ? StaffPointsDialog(isQrClicked: true)
                  : index == 2
                      ? StaffPointsDialog(isMerhcantClicked: true)
                      : StaffPointsDialog(isCustomerNumberClicked: true);
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * .06),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .04,
                    child: Image.asset(
                      logo,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * .019,
                        color: Color(0xff081F32),
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        description,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * .018,
                            color: Color(0xff081F32).withOpacity(.60),
                            height: MediaQuery.of(context).size.height * .0025),
                        overflow: TextOverflow.clip,
                      ),
                      Container()
                    ],
                  ),
                  Divider(
                    color: index == 3 ? Colors.white : Colors.grey,
                    height: index == 3
                        ? MediaQuery.of(context).size.height * .03
                        : MediaQuery.of(context).size.height * .06,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClaimOfferWithCustomer extends StatefulWidget {
  @override
  _ClaimOfferWithCustomerState createState() => _ClaimOfferWithCustomerState();
}

class _ClaimOfferWithCustomerState extends State<ClaimOfferWithCustomer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              height: MediaQuery.of(context).size.height * .35,
              width: MediaQuery.of(context).size.width * .75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .03,
                    right: MediaQuery.of(context).size.width * .03,
                    top: MediaQuery.of(context).size.height * .03,
                    bottom: MediaQuery.of(context).size.height * .02),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          AppLocalization.of(context)
                              .getTranslatedValues("claim_customer_number"),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.height * .018,
                              fontWeight: FontWeight.bold),
                        ),
                        Container()
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .005),
                    Row(
                      children: [
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 65,
                          child: Text(
                            AppLocalization.of(context)
                                .getTranslatedValues("claim_customer_des"),
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * .016,
                                color: Colors.black87),
                          ),
                        ),
                        Container()
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * .02),
                    Container(
                      height: MediaQuery.of(context).size.height * .065,
                      // width: MediaQuery.of(context).size.width * .6,
                      child: Material(
                        elevation: 10.0,
                        shadowColor: Colors.black,
                        child: TextFormField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            // filled: true,
                            // fillColor: Colors.amber,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              borderSide: BorderSide(
                                  width:
                                      MediaQuery.of(context).size.width * .002,
                                  color: Colors.black87),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.transparent),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.transparent),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.transparent),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: MediaQuery.of(context).size.height * .065,
                      // width: MediaQuery.of(context).size.width * .6,
                      child: Material(
                        elevation: 10.0,
                        shadowColor: Colors.black,
                        child: TextFormField(
                          decoration: InputDecoration(
                            // filled: true,
                            // fillColor: Colors.amber,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              borderSide: BorderSide(
                                  width:
                                      MediaQuery.of(context).size.width * .002,
                                  color: Colors.black87),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.transparent),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.transparent),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.transparent),
                            ),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(8)),

                            hintText: AppLocalization.of(context)
                                .getTranslatedValues("customer_number"),
                            hintStyle: TextStyle(
                                color: Colors.black38,
                                fontSize:
                                    MediaQuery.of(context).size.height * .017),
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * .6,
                        height: MediaQuery.of(context).size.height * .03,
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * .1,
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.only(
                                        left: 0, top: 0, bottom: 0),
                                    onPressed: () {
                                      AppRoutes.pop(context);
                                    },
                                    color: Colors.blue,
                                    child: Text(
                                      AppLocalization.of(context)
                                          .getTranslatedValues("claim_offer"),
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .012,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: MaterialButton(
                                    elevation: 0,
                                    padding: EdgeInsets.only(left: 0),
                                    onPressed: () {
                                      AppRoutes.pop(context);
                                    },
                                    color: Colors.white,
                                    child: Text(
                                      AppLocalization.of(context)
                                          .getTranslatedValues("close"),
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .018,
                                          color: Colors.black),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class GenerateCodeDialog extends StatefulWidget {
  String option;
  GenerateCodeDialog({this.option = ''});

  @override
  _GenerateCodeDialogState createState() => _GenerateCodeDialogState();
}

class _GenerateCodeDialogState extends State<GenerateCodeDialog> {
  List<String> expiryOptions = ['hour', 'day', 'week', 'month'];
  String selectedExpiry = 'hour';
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController generatedCont = TextEditingController();

  /*-------------------------------- Methods------------------------------*/

  void generateCode(
    bool shouldReload,
    String expires,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "uuid": LacasaUser.data.campaignUUID,
        "expires": expires,
      };

      var response = await http.post("${Apis.staffGenerateMerchantCode}",
          headers: MyHeaders.header(), body: body);
      var jsonResponse = json.decode(response.body);
      print('response:\n');
      print((response.body));
      print("code:${response.statusCode}");
      if (response.statusCode == 200) {
        if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
          setState(() {
            print(jsonResponse['data']['merchant_code']);
            generatedCont.text = jsonResponse['data']['merchant_code'];
            isLoading = false;
          });
//          api
//              .getStaffUserInfo(_scaffoldKey, selectedCampaign.campUuid)
//              .then((value) {
//            print(LacasaUser.data.user.data.name);
//            LacasaUser.data.campaignUUID = selectedCampaign.campUuid;
//            AppRoutes.replace(context, StaffDashBoard());
//          });
        } else {
          setState(() {
            isLoading = false;
          });
          ShowMessage.showErrorSnackBar(
            _scaffoldKey,
            jsonResponse,
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        ShowMessage.inDialog('status code: ${response.statusCode} ', true);
      }
    } on SocketException {
      ShowMessage.inDialog('No Internet Connection', true);
      setState(() {
        isLoading = false;
      });
      print('No Internet connection');
    } on HttpException catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
      ShowMessage.inDialog('Couldn\'t find the results', true);
      print("Couldn't find the post");
    } on FormatException catch (error) {
      print(error);
      setState(() {
        isLoading = false;
      });
      ShowMessage.inDialog('Bad response format from server', true);
      print("Bad response format");
    } catch (value) {
      setState(() {
        isLoading = true;
      });
      print(value);
    }
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, () {
      Navigator.pop(context);
    });
  }

  /*----------------------------------------------------------------------*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        body: Container(
            padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
            width: SizeConfig.blockSizeHorizontal * 100,
            height: SizeConfig.blockSizeVertical * 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 10),
                  // height: MediaQuery.of(context).size.height * .5,
                  width: SizeConfig.blockSizeHorizontal * 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              mall_english,
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * .03,
                                bottom:
                                    MediaQuery.of(context).size.height * .01),
                            child: Text(
                              AppLocalization.of(context).getTranslatedValues(
                                      "generate_code_to_enter") ??
                                  "",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.height * .02,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * .03,
                                bottom:
                                    MediaQuery.of(context).size.height * .01),
                            child: Text(
                              AppLocalization.of(context).getTranslatedValues(
                                      "You_can_use_this_code") ??
                                  "",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.height * .017,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                              child: Text(
                            'Please select campaign',
                            style: TextStyle(
                                fontSize: SizeConfig.blockSizeHorizontal * 5),
                          )),
                          selectExpiryTime(),
                          SizedBox(
                            height: 20,
                          ),
                          if (generatedCont.text.isNotEmpty) codeField(),
                          SizedBox(
                            height: 20,
                          ),
                          isLoading ? CircularProgressIndicator() : actions(),
                        ],
                      )),
                )
              ],
            )),
      ),
    );
  }

  Widget selectExpiryTime() {
    return DropdownButtonFormField(
      // hint: ,
      dropdownColor: Colors.white,
      isExpanded: true,
      decoration: InputDecoration(
        fillColor: formColor,
        prefixIcon: Icon(Icons.calendar_today),
        contentPadding: EdgeInsets.all(8),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.transparent)),
      ),
      isDense: true,
      iconSize: 20,
      items: List.generate(expiryOptions.length, (index) {
        return DropdownMenuItem(
          value: expiryOptions[index],
          child: Text('Expires is on ${expiryOptions[index]}'),
          onTap: () {
            setState(() {
              selectedExpiry = expiryOptions[index];
              print(selectedExpiry);
            });
          },
        );
      }),
      onChanged: (val) {
//          selectedCampaign = val;
//          print(selectedCampaign.uuid.trim());
      },
    );
  }

  Widget actions() {
    return Padding(
      padding: EdgeInsets.only(
          // left: MediaQuery.of(context).size.width * .1,
          ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GestureDetector(
          onTap: () {
            AppRoutes.pop(context);
          },
          child: Container(
            width: SizeConfig.blockSizeHorizontal * 20,
            decoration: BoxDecoration(
                border: Border.all(color: newOffer, width: 1.5),
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    AppLocalization.of(context).getTranslatedValues("close"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * .018,
                        color: newOffer)),
              ),
            ),
          ),
        ),
        MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: EdgeInsets.only(left: 0, top: 0, bottom: 0),
          onPressed: () {
            generateCode(true, selectedExpiry);
          },
          color: newOffer,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalization.of(context).getTranslatedValues("generate_code"),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height * .018,
                  color: Colors.white),
            ),
          ),
        ),
        // SizedBox(width: 1,),
      ]),
    );
  }

  Widget codeField() {
    return Container(
      height: MediaQuery.of(context).size.height * .065,
      // width: MediaQuery.of(context).size.width * .6,
      child: GestureDetector(
        onTap: () {
          Clipboard.setData(new ClipboardData(text: generatedCont.text));
          ShowMessage.inSnackBar(_scaffoldKey, "Text Copied", false);
        },
        child: TextFormField(
          controller: generatedCont,
          enabled: false,
          decoration: InputDecoration(
            fillColor: formColor,
            // filled: true,
            // fillColor: Colors.amber,
            // disabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.all(Radius.circular(0)),
            //   borderSide: BorderSide(
            //       width: MediaQuery.of(context).size.width * .002,
            //       color: Colors.blueGrey),
            // ),

            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(20)),
            suffixIcon: GestureDetector(
              onTap: () {
                Clipboard.setData(new ClipboardData(text: generatedCont.text));
                ShowMessage.inSnackBar(_scaffoldKey, "Text Copied", false);
              },
              child: Image.asset(
                'assets/images/copy.png',
                scale: 1.5,
              ),
            ),
            contentPadding: EdgeInsets.all(8),
            hintText: 'Enter 9-digit code',
          ),
        ),
      ),
    );
  }
}
