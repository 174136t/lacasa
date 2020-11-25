import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/dashboard/dashboard.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/champaigns_modal.dart' as cm;
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/globals.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/loader.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Campaign extends StatefulWidget {
  final Function() refreshScreen;
  Campaign({Key key, this.refreshScreen}) : super(key: key);
  @override
  _CampaignState createState() => _CampaignState(refreshScreen: refreshScreen);
}

class _CampaignState extends State<Campaign> {
  final Function() refreshScreen;
  _CampaignState({Key key, this.refreshScreen});
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  refresh() {
    setState(() {});
  }

  /*-------------------------------- Methods------------------------------*/
  cm.ChampaignsModal campaigns = cm.ChampaignsModal();

  void getCampaigns(bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });

      var response =
          await http.get("${Apis.getCampaigns}", headers: MyHeaders.header());
      var jsonResponse = json.decode(response.body);
      print((response.body));

      if (jsonResponse['status_code'] == 200) {
        setState(() {
          campaigns = cm.ChampaignsModal.fromJson(jsonResponse);
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

//  void getOffers(bool shouldReload) async {
//    try {
//      setState(() {
//        isLoading = true;
//      });
//
//      var response =
//      await http.get("${Apis.getAllOffers}", headers: MyHeaders.header());
//      var jsonResponse = json.decode(response.body);
//      print('header= ${MyHeaders.header()}');
//      print((response.body));
//      print("code:${response.statusCode}");
//
//      if (jsonResponse['status_code'] == 200) {
//        setState(() {
//          _offers = AllOffers.fromJson(jsonResponse);
//          isLoading = false;
//        });
//      } else {
//        setState(() {
//          isLoading = false;
//        });
//        ShowMessage.showErrorSnackBar(
//          _scaffoldKey,
//          jsonResponse,
//        );
//      }
//    } on SocketException {
//      ShowMessage.inDialog('No Internet Connection', true);
//      setState(() {
//        isLoading = false;
//      });
//      print('No Internet connection');
//    } on HttpException catch (error) {
//      print(error);
//      setState(() {
//        isLoading = false;
//      });
//      ShowMessage.inDialog('Couldn\'t find the results', true);
//      print("Couldn't find the post");
//    } on FormatException catch (error) {
//      print(error);
//      setState(() {
//        isLoading = false;
//      });
//      ShowMessage.inDialog('Bad response format from server', true);
//      print("Bad response format");
//    } catch (value) {
//      setState(() {
//        isLoading = false;
//      });
//      ShowMessage.inSnackBar(_scaffoldKey, value.toString(), true);
//      startTime();
//    }
//  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, () {
      Navigator.pop(context);
    });
  }

  /*----------------------------------------------------------------------*/
  @override
  void initState() {
    getCampaigns(true);
    super.initState();
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
        preferredSize: Size.fromHeight(170),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Text(
                                AppLocalization.of(context)
                                    .getTranslatedValues("all_campaign"),
                                style: TextStyle(
                                  color: newColor,
                                    fontSize: SizeConfig.blockSizeVertical * 4.5,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container()
                          ],
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical*5,),
                        Container(
                width: SizeConfig.blockSizeHorizontal * 100,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      SizedBox(width: 10,),
                      Image.asset(
                          'assets/images/searchnew.png',
                          // scale: 5,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.fill,
                        ),
                      Text(
                        "  Search Campaigns",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 2.5,
                            color: newBlack.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  Column(
                    children: List.generate(
                        EmptyList.isTrue(campaigns.data)
                            ? 0
                            : campaigns.data.length, (index) {
                      cm.Campaign _campaign = campaigns.data[index];
                      return _earnPointsCards(_campaign, index);
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

  Widget _earnPointsCards(
    cm.Campaign campaign,
    int index,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeVertical * 0.5,
          horizontal: MediaQuery.of(context).size.width * .025),
      child: Card(
        color: newYellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                  width: MediaQuery.of(context).size.width * .27,
                  height: MediaQuery.of(context).size.height * .12,
                  decoration: BoxDecoration(
                      color: newYellow,
                      borderRadius: isarabic
                          ? BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10))
                          : BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10))),
                  child: Container(

                    child: Image.asset(
                      'assets/images/camp.png',
                      // scale: 7,
                      fit: BoxFit.fill,
                    ),
                  )),
            ),
            Expanded(
                          child: Container(
                // width: MediaQuery.of(context).size.width * .65,
                // height: MediaQuery.of(context).size.height * .12,
                decoration: BoxDecoration(
                    color:newYellow,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .02,
                          left: MediaQuery.of(context).size.width * .02),
                      child: Text(
                        '${campaign.name ?? ""}',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * .03,
                            color: Color(0xff081F32),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .01,
                          left: MediaQuery.of(context).size.width * .02),
                      child: Text(
                        '${campaign.subTitle ?? ""}',
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * .015,
                            color: Color(0xff081F32),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .005,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                               setState(() {
                                  customerCampaignUUID = campaign.uuid;
                                  print(customerCampaignUUID);
                                  screenMover = 6;
                                  widget.refreshScreen();
                                });
                            },
                                                    child: Container(
                                                      width: SizeConfig.blockSizeHorizontal*20,
                              // height: MediaQuery.of(context).size.height * .03,
                              alignment: Alignment.bottomRight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: newOffer,width: 1.5)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    AppLocalization.of(context)
                                        .getTranslatedValues("join"),
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.height * .014,
                                        color: newOffer,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
