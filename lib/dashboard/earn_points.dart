import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/dashboard/generated_QR.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/modals/user.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/dialogs.dart';
import 'package:lacasa/utils/globals.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../main.dart';

class EarnPoints extends StatefulWidget {
  @override
  _EarnPointsState createState() => _EarnPointsState();
}

class _EarnPointsState extends State<EarnPoints> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /*-------------------------------- Methods------------------------------*/

  void getAllIndustries(bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });

      var response = await http.get("${Apis.getAllIndustries}",
          headers: MyHeaders.header());
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

  static String URL =
      'https://beta.nqat.me/campaign/iphase-vX/staff#/points/link?token=';
  String qrData = '';
  void onGenerateQRCode(bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "uuid": customerCampaignUUID,
        // "reward": rewardUUID,
      };
      print(body);
      var headers = {
        "Authorization": "bearer " + BEARER_TOKEN,
        "Content-Type": "application/x-www-form-urlencoded"
      };
      print(headers);
      var response = await http.post("${Apis.customerEarnGetPointsQrToken}",
          headers: headers, body: body);
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

  /*----------------------------------------------------------------------*/
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: newWhite,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        color: newColor,
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
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
                        left: SizeConfig.blockSizeHorizontal * 7),
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
                                    .getTranslatedValues("earn_points"),
                                style: TextStyle(
                                    color: pureWhite,
                                    fontSize: SizeConfig.blockSizeVertical * 4,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        // Container(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .05,
                    right: MediaQuery.of(context).size.width * .05,
                  ),
                  child: Container(
                    color: newWhite,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .005,
                        ),
                        // Row(
                        //   children: [
                        //     Container(
                        //       child: Text(
                        //         AppLocalization.of(context)
                        //             .getTranslatedValues("get_points_spend"),
                        //         style: TextStyle(
                        //           fontSize: SizeConfig.blockSizeVertical * 2,
                        //         ),
                        //       ),
                        //     ),
                        //     Container()
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                ),
                _earnPointsCards(1, 'qr_code', qrImage, 'qr_code_des'),
                _earnPointsCards(2, 'enter_code', enter, 'enter_code_des'),
                _earnPointsCards(3, 'merchant_enter_code', merchant,
                    'merchant_enter_code_des'),
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
          onGenerateQRCode(true);
        } else if (index == 3 || index == 2) {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return MerchantEnterCode(
                  isMerchantEnter: index == 3,
                );
              });
        } else {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return EarnPointsDialog(isCustomerNumberClicked: true);
              });
        }
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

                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20)),
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

                      //         height: MediaQuery.of(context).size.height * .07,

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
                                overflow: TextOverflow.clip,
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
            _categoryThumbnail(index, logo),
          ],
        ),
      ),
    );
  }
}

class MerchantEnterCode extends StatefulWidget {
  bool isMerchantEnter;
  String rewardUUID;
  MerchantEnterCode({this.rewardUUID, this.isMerchantEnter = false});
  @override
  _MerchantEnterCodeState createState() =>
      _MerchantEnterCodeState(isMerchantEnter: isMerchantEnter);
}

class _MerchantEnterCodeState extends State<MerchantEnterCode> {
  bool isMerchantEnter;
  String rewardUUID;
  _MerchantEnterCodeState({this.rewardUUID, this.isMerchantEnter});
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
        "purchase_amount": "1",
      };
      print("body: $body");
      print('header:$header');
      var response = await http.post("${Apis.customerEarnProcessMerchantEntry}",
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
                      Container(
                        height: MediaQuery.of(context).size.height * .55,
                        width: MediaQuery.of(context).size.width * .8,
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
                              Center(
                                child: Image.asset(
                                  mall_english,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                ),
                              ),
                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValues(isMerchantEnter
                                                ? "let_merchant_code"
                                                : "enter_code"),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .025,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container()
                                    ],
                                  )),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      .015),
                              Row(
                                children: [
                                  Container(
                                    alignment: isarabic
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    width: SizeConfig.blockSizeHorizontal * 60,
                                    child: Text(
                                      AppLocalization.of(context)
                                          .getTranslatedValues(isMerchantEnter
                                              ? "hand_over_device"
                                              : "code_merchant_below"),
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .018,
                                          color: Colors.black87),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Container()
                                ],
                              ),
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * .065,
                                // width: MediaQuery.of(context).size.width * .6,
                                decoration: BoxDecoration(
                                    color: formColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: TextFormField(
                                  controller: enteredCodeCont,
                                  decoration: InputDecoration(
                                    // filled: true,
                                    // fillColor: Colors.amber,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
                                      borderSide: BorderSide(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .002,
                                          color: Colors.transparent),
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
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(8)),

                                    contentPadding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                .2),

                                    hintText: 'Enter 9-digit code',
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black38,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                .017),
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width * .4,
                                  height:
                                      MediaQuery.of(context).size.height * .03,
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          .1,
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: OutlineButton(
                                              // elevation: 0,
                                              borderSide: BorderSide(
                                                  color: newOffer, width: 1.5),
                                              shape: new RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          30.0)),
                                              padding: EdgeInsets.only(left: 0),
                                              onPressed: () {
                                                AppRoutes.pop(context);
                                              },
                                              color: Colors.white,
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
                                                    color: newOffer),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: MaterialButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              padding: EdgeInsets.only(
                                                  left: 0, top: 0, bottom: 0),
                                              onPressed: () {
                                                if (enteredCodeCont
                                                    .text.isEmpty) {
                                                  ShowMessage.inSnackBar(
                                                      _scaffoldKey,
                                                      "Please enter the code",
                                                      true);
                                                  return;
                                                }
                                                verifyMerchantCode(true);
                                              },
                                              color: newOffer,
                                              child: Text(
                                                AppLocalization.of(context)
                                                    .getTranslatedValues(
                                                        "verify"),
                                                style: TextStyle(
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .018,
                                                    color: Colors.white),
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
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
