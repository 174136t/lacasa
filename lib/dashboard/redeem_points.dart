import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/dashboard/reward_redeem_options.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/redeem_rewards.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/dialogs.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/loader.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RedeemPoints extends StatefulWidget {
  @override
  _RedeemPointsState createState() => _RedeemPointsState();
}

class _RedeemPointsState extends State<RedeemPoints> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /*-------------------------------- Methods------------------------------*/
  RedeemRewards _rewards = RedeemRewards();

  void getAvailableRewards() async {
    try {
      setState(() {
        isLoading = true;
      });

      var response = await http.get(
          "${Apis.getRedeemRewards}?uuid=${LacasaUser.data.campaignUUID}",
          headers: MyHeaders.header());
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
        setState(() {
          _rewards = RedeemRewards.fromJson(jsonResponse);

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
    }
  }

  // startTime() async {
  //   var _duration = new Duration(seconds: 2);
  //   return new Timer(_duration, () {
  //     Navigator.pop(context);
  //   });
  // }

  /*----------------------------------------------------------------------*/

  @override
  void initState() {
    getAvailableRewards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
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
        preferredSize: Size.fromHeight(170),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        color: Colors.transparent,
        progressIndicator: MyLoader(),
        child: Container(
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * .03),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .05,
                      right: MediaQuery.of(context).size.width * .05,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  AppLocalization.of(context)
                                      .getTranslatedValues("reward"),
                                  style: TextStyle(
                                      color: newColor,
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 5.5,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container()
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .005,
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text(
                                  AppLocalization.of(context)
                                      .getTranslatedValues("earn_point_reward"),
                                  style: TextStyle(
                                    fontSize: SizeConfig.blockSizeVertical * 2,
                                  ),
                                ),
                              ),
                              Container()
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .02,
                          ),
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 100,
                            decoration: BoxDecoration(
                                color: Colors.grey[400].withOpacity(0.8),
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Image.asset(
                                    'assets/images/searchnew.png',
                                    // scale: 5,
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.fill,
                                  ),
                                  Text(
                                    "  Search Rewards",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeVertical * 2.5,
                                        color: newBlack.withOpacity(0.6)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  Column(
                    children: List.generate(
                        EmptyList.isTrue(_rewards.data)
                            ? 0
                            : _rewards.data.length, (index) {
                      var reward = _rewards.data[index];
                      return _earnPointsCards(1, reward);
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _earnPointsCards(int index, RedeemReward reward) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeVertical * 0.5,
          horizontal: MediaQuery.of(context).size.width * .025),
      child: Card(
        color: newOffer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: MediaQuery.of(context).size.width * .27,
                // height: MediaQuery.of(context).size.height * .12,
                decoration: BoxDecoration(
                    color: newOffer,
                    borderRadius: isarabic
                        ? BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            topRight: Radius.circular(10))
                        : BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset("assets/images/newreward.png"),
                )
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                // Text(
                //   "${reward?.points ?? ""}",
                //   style: TextStyle(
                //       fontSize: MediaQuery.of(context).size.height * .03,
                //       color: Color(0xff6E798C),
                //       fontWeight: FontWeight.bold),
                // ),
                // Text(
                //   AppLocalization.of(context).getTranslatedValues("point"),
                //   style: TextStyle(
                //       fontSize: MediaQuery.of(context).size.height * .02,
                //       color: Color(0xff6E798C),
                //       fontWeight: FontWeight.bold),
                // ),
                //   ],
                // ),
                ),
            Container(
              width: MediaQuery.of(context).size.width * .65,
              // height: MediaQuery.of(context).size.height * .12,
              decoration: BoxDecoration(
                  color: newOffer,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .02,
                        left: MediaQuery.of(context).size.width * .02,
                        right: MediaQuery.of(context).size.width * .02),
                    child: Text(
                      reward.title ?? "",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .02,
                          color: pureWhite,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .005,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .03,
                            right: MediaQuery.of(context).size.width * .01),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (BuildContext context) {
                                  return RedeemRewardOptions(
                                      rewardUUID: reward.uuid);
                                });
                          },
                          child: Container(
                            // height: MediaQuery.of(context).size.height * .03,
                            alignment: Alignment.bottomRight,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: newColor,width: 1.5)
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalization.of(context)
                                      .getTranslatedValues("redeem"),
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              .018,
                                      color: newColor,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
