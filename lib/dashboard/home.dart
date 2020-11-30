import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/dashboard/dashboard.dart';
import 'package:lacasa/dashboard/earn_points.dart';
import 'package:lacasa/dashboard/offers.dart';
import 'package:lacasa/dashboard/profile.dart';
import 'package:lacasa/dashboard/redeem_points.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/all_offers.dart';
import 'package:lacasa/modals/champaigns_modal.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/modals/user.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/dialogs.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/loader.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

var screenMover = 0;

class Home extends StatefulWidget {
  final Function() refreshScreen;
  Home({Key key, this.refreshScreen}) : super(key: key);
  @override
  _HomeState createState() => _HomeState(refreshScreen: refreshScreen);
}

class _HomeState extends State<Home> {
  final Function() refreshScreen;
  _HomeState({Key key, @required this.refreshScreen});
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> drawerItemsName = [
    "home",
    "offers",
    "earn_points",
    "redeem_points",
    "my_profile",
    "logout",
  ];
  UserInfo user;
  var profileAvatar = Base64Decoder().convert(LacasaUser.data.user.data.avatar
      .replaceAll("data:image/png;base64,", ""));

  Widget _drawer_items(int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                  DashBoard()),
          );
          }
          else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                  Offers()),
          );
          }
          else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                  EarnPoints()),
          );
          }
         else if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                  RedeemPoints()),
          );
          }
          else if (index == 4) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                  Profile()),
          );
          }
          else if(index==5){
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                    child: LogOut(),
                  );
                });
          }
          //  else {
          //   screenMover = index;
          //   AppRoutes.pop(context);
          // }
        });
      },
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.5),
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeVertical * 5,
        ),
        child: Row(
          children: [
            Image.asset(
              star,
              scale: 4,
            ),
            SizedBox(
              width: SizeConfig.blockSizeHorizontal * 2,
            ),
            Text(
              AppLocalization.of(context).getTranslatedValues(title),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.blockSizeHorizontal * 4),
            )
          ],
        ),
      ),
    );
  }

  DateTime currentBackPressTime;
  refresh() {
    setState(() {});
  }

  /*-------------------------------- Methods------------------------------*/
  ChampaignsModal campaigns = ChampaignsModal();
  AllOffers _offers = AllOffers();
  void getCampaigns(bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });

      var response =
          await http.get("${Apis.getCampaigns}", headers: MyHeaders.header());
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
        setState(() {
          campaigns = ChampaignsModal.fromJson(jsonResponse);
          LacasaUser.data.campaignUUID = campaigns.data[0].uuid;
          print('\n cust uuid = ${LacasaUser.data.campaignUUID}\n');
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

  void getOffers(bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });

      var response =
          await http.get("${Apis.getAllOffers}", headers: MyHeaders.header());
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200) {
        setState(() {
          _offers = AllOffers.fromJson(jsonResponse);
          isLoading = false;
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
  void initState() {
    user = LacasaUser.data.user.data ?? "";
    getCampaigns(true);
    getOffers(true);
    screenMover = 0;
    super.initState();
  }

  @override
  void dispose() {
    isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: newWhite,
      drawer: PreferredSize(
        preferredSize: Size.fromWidth(20),
        child: BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
          child: Container(
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
              color: drawerBackColor,
              width: SizeConfig.blockSizeHorizontal * 75,
              height: SizeConfig.blockSizeVertical * 100,
              child: Column(
                children: [
                  Column(
                    children: [
//                          CircularProfileAvatar(
//                            "${user.avatar}",
//                            // child: Image.asset(men),
//                            elevation: 5,
//                            radius: SizeConfig.blockSizeHorizontal * 15,
//                          ),
                      CircleAvatar(
                        backgroundImage: MemoryImage(profileAvatar),
                        radius: SizeConfig.blockSizeHorizontal * 15,
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 2,
                      ),
                      Container(
                        child: Text("${user?.name ?? ""}"),
                      ),
                      Container(
                        child: Text(
                          "${user?.mobile ?? ""}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: blackColor.withOpacity(.60),
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  Column(
                    children: List.generate(
                        drawerItemsName.length,
                        (index) =>
                            _drawer_items(index, drawerItemsName[index])),
                  )
                ],
              )),
        ),
      ),
      appBar: PreferredSize(
        child: Container(
          color: newWhite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _scaffoldKey.currentState.openDrawer();
                  });
                },
                child: Container(
                    color: newWhite,
                    padding: EdgeInsets.all(25),
                    margin:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                    child: Image.asset(
                      drawer,
                      scale: 1.5,
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
      body: SmartRefresher(
        controller: refreshController,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 2));
          getCampaigns(true);
          getOffers(true);
          refreshController.refreshCompleted();
        },
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: MyLoader(),
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 5),
              child: campaigns.data != null
                  ? Column(
                      children: [
                        Container(
                          // margin: EdgeInsets.only(
                          //     left: SizeConfig.blockSizeHorizontal * 5),
                          child: Text(
                            // "lacsa hbgjhfb fhdbdhfbf",
                            AppLocalization.of(context)
                                .getTranslatedValues('LACASA_deals'),
                            style: TextStyle(
                                color: newColor,
                                fontSize:
                                    SizeConfig.blockSizeVertical * 5.5,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalization.of(context)
                                    .getTranslatedValues('new_offer'),
                                style: TextStyle(
                                    color: newOffer,
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 2.5,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  screenMover = 1;
                                  widget.refreshScreen();
                                });
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalization.of(context)
                                      .getTranslatedValues('browse_offers'),
                                  style: TextStyle(
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 1.9,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 1,
                        ),
                        Container(
                          // alignment: Alignment.center,
                          width: SizeConfig.blockSizeHorizontal * 100,
                          height: SizeConfig.blockSizeVertical * 30,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: List.generate(
                                EmptyList.isTrue(_offers.data)
                                    ? 0
                                    : _offers?.data?.length, (index) {
                              Offer _offer = _offers.data[index];
                              return _offersCard(_offer, index);
                            }),
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalization.of(context)
                                    .getTranslatedValues('new_campaigns'),
                                style: TextStyle(
                                    color: newOffer,
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 2.5,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                AppLocalization.of(context)
                                    .getTranslatedValues('browse_campaigns'),
                                style: TextStyle(
                                    fontSize:
                                        SizeConfig.blockSizeVertical * 1.9,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 1,
                        ),
                        Container(
                          // alignment: Alignment.center,
                          width: SizeConfig.blockSizeHorizontal * 100,
                          height: SizeConfig.blockSizeVertical * 30,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: List.generate(
                                campaigns != null ? campaigns.data.length : 0,
                                (index) => _campaignCard(index)),
                          ),
                        )
                      ],
                    )
                  : Container(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _campaignCard(int index) {
    var campaign = campaigns.data[index];
    return GestureDetector(
      onTap: () {},
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: SizeConfig.blockSizeHorizontal * 35,
                height: SizeConfig.blockSizeVertical * 25,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.50),
                          spreadRadius: 1,
                          blurRadius: 1)
                    ],
                    // borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: AssetImage(item), fit: BoxFit.cover)),
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal * 35,
                margin: EdgeInsets.only(top: 4),
                child: Text(
                  "${campaign?.name ?? ""}",
                  style:
                      TextStyle(fontSize: SizeConfig.blockSizeVertical * 1.9),
                ),
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal * 35,
                margin: EdgeInsets.only(top: 4),
                child: Text(
                  "${campaign?.businessName ?? ""}",
                  style:
                      TextStyle(fontSize: SizeConfig.blockSizeVertical * 1.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _offersCard(Offer offer, int index) {
    //var champaign = campaigns.data[index];
    return GestureDetector(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: SizeConfig.blockSizeHorizontal * 35,
                height: SizeConfig.blockSizeVertical * 25,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(.50),
                          spreadRadius: 1,
                          blurRadius: 1)
                    ],
                    // borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: AssetImage(item), fit: BoxFit.cover)),
              ),
              Container(
                margin: EdgeInsets.only(top: 4),
                width: SizeConfig.blockSizeHorizontal * 35,
                child: Text(
                  //"${champaign?.name ?? ""}",
                  "${offer.name ?? ""}",
                  style:
                      TextStyle(fontSize: SizeConfig.blockSizeVertical * 1.9),
                ),
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal * 35,
                child: Text(
                  //"${champaign?.businessName}",
                  "${offer.segmentsText ?? ""}",
                  style:
                      TextStyle(fontSize: SizeConfig.blockSizeVertical * 1.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
