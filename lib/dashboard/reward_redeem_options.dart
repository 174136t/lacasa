import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/dashboard/generated_QR.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/modals/user.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/dialogs.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RedeemRewardOptions extends StatefulWidget {
  String rewardUUID;
  RedeemRewardOptions({
    this.rewardUUID,
  });

  @override
  _RedeemRewardOptionsState createState() =>
      _RedeemRewardOptionsState(rewardUUID: rewardUUID);
}

class _RedeemRewardOptionsState extends State<RedeemRewardOptions> {
  String rewardUUID;
  _RedeemRewardOptionsState({
    this.rewardUUID,
  });
  UserInfo user = LacasaUser.data.user.data;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController enteredCodeCont = TextEditingController();

  /*-------------------------------- Methods------------------------------*/

  static String URL =
      'https://nqatlacasa.herokuapp.com/api/v1/staff#/rewards/link?token=';
  // 'https://beta.nqat.me/campaign/iphase-vX/staff#/rewards/link?token=';
  String qrData = '';
  void onGenerateQRCode(bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "uuid": LacasaUser.data.campaignUUID,
        "reward": rewardUUID,
      };
      print(body);
      var headers = {
        "Authorization": "bearer " + BEARER_TOKEN,
        "Content-Type": "application/x-www-form-urlencoded"
      };
      print(headers);
      var response = await http.post("${Apis.getRedeemRewardQrToken}",
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
        "uuid": LacasaUser.data.user.data.uuid,
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

  Widget _categoryThumbnail() {
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 20),
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

  /*----------------------------------------------------------------------*/
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Stack(
        children: [
          Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Center(
              child: ModalProgressHUD(
                inAsyncCall: isLoading,
                child: Container(
                    padding:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
                    width: SizeConfig.blockSizeHorizontal * 100,
                    // height: SizeConfig.blockSizeVertical * 100,
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
                            color: dialogCardColor,
                          ),

                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * .03,
                                  right:
                                      MediaQuery.of(context).size.width * .03,
                                  top: MediaQuery.of(context).size.height * .03,
                                  bottom: MediaQuery.of(context).size.height *
                                      .009),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: SizeConfig.blockSizeVertical * 5,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width *
                                                .03,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                .03,
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                .01),
                                    child: Center(
                                      child: Text(
                                        AppLocalization.of(context)
                                            .getTranslatedValues(
                                                "redeem_reward"),
                                        style: TextStyle(
                                            color: newColor,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .05,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.blockSizeVertical * 3,
                                  ),
                                  list(1, 'qr_code', qrImage, 'show_qr_code'),
                                  list(2, 'merchant_enter_code', merchant,
                                      'give_phone'),
                                  list(3, 'customer_number', customerNumber,
                                      'provide_number'),
                                ],
                              )),
                        )
                      ],
                    )),
              ),
            ),
          ),
          _categoryThumbnail()
        ],
      ),
    );
  }

  Widget list(int index, String title, String logo, String description) {
    return GestureDetector(
      onTap: () {
        if (index == 1) {
          onGenerateQRCode(true);
        } else if (index == 2) {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return MerchantEnterCode(
                  rewardUUID: rewardUUID,
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
        // showDialog(
        //     barrierDismissible: true,
        //     context: context,
        //     builder: (BuildContext context) {
        //       return index == 1
        //           ? RedeemRewardOptions(isQrClicked: true)
        //           : index == 2
        //               ? RedeemRewardOptions(isMerhcantClicked: true)
        //               : RedeemRewardOptions(isCustomerNumberClicked: true);
        //     });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // color: Colors.red,
          // height: SizeConfig.blockSizeVertical*10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: newOffer, width: 2)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                              AppLocalization.of(context)
                                  .getTranslatedValues(title),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * .019,
                                  color: Color(0xff081F32),
                                  fontWeight: FontWeight.bold),
                            ),
                            Container()
                          ],
                        ),
                        // Row(
                        //   children: [
                        Text(
                          AppLocalization.of(context)
                              .getTranslatedValues(description),
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * .018,
                              color: Color(0xff081F32).withOpacity(.60),
                              height:
                                  MediaQuery.of(context).size.height * .0025),
                          overflow: TextOverflow.clip,
                        ),
                        // Container()
                        //   ],
                        // ),
                        // Divider(
                        //   color: index == 3 ? Colors.white : Colors.grey,
                        //   height: index == 3
                        //       ? MediaQuery.of(context).size.height * .03
                        //       : MediaQuery.of(context).size.height * .06,
                        // )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * .04,
                        child: Image.asset(
                          logo,
                          color: newBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MerchantEnterCode extends StatefulWidget {
  String rewardUUID;
  MerchantEnterCode({this.rewardUUID});
  @override
  _MerchantEnterCodeState createState() => _MerchantEnterCodeState();
}

class _MerchantEnterCodeState extends State<MerchantEnterCode> {
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
        "uuid": LacasaUser.data.campaignUUID,
        "code": enteredCodeCont.text.trim(),
        "reward": widget.rewardUUID,
      };
      print("body: $body");
      print('header:$header');
      var response = await http.post("${Apis.processMerchantEntryReward}",
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
                                            .getTranslatedValues(
                                                "let_merchant_code"),
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
                                          .getTranslatedValues(
                                              "hand_over_device"),
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
                                                verifyMerchantCode(true);
//                                                              Fluttertoast
//                                                                  .showToast(
//                                                                      msg:
//                                                                          'Your code is verified successfuly');
//                                                              AppRoutes.pop(
//                                                                  context);
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
