import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/dashboard/dashboard.dart';
import 'package:lacasa/dashboard/earn_points.dart';
import 'package:lacasa/dashboard/profile.dart';
import 'package:lacasa/dashboard/redeem_points.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/all_industries.dart';
import 'package:lacasa/modals/all_offers.dart';
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

var screenMover = 0;

class Offers extends StatefulWidget {
  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  AllOffers offers = AllOffers();
  bool isOfferList = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List colors = [Colors.blueGrey, Colors.yellow, Colors.purple, Colors.red];
  Random random = new Random();
  int colorIndex = 0;
  /*-------------------------------- Methods------------------------------*/
  AllIndustries _industries = AllIndustries();
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
          _industries = AllIndustries.fromJson(jsonResponse);
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
      // startTime();
    }
  }

  void getOffersByIndustry(String uuid, bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });
//      var params = {
//        "uuid" = "$uuid",
//      };

      var response = await http.get(
        "${Apis.getOffersByIndustry}?uuid=$uuid",
      );
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");
      if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
        setState(() {
          offers = AllOffers.fromJson(jsonResponse);
          isOfferList = true;
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
      ShowMessage.inSnackBar(
          _scaffoldKey,
          // 'Sorry! There are no offers at the moment!',
          value.toString(),

          true);
      // startTime();
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
          offers = AllOffers.fromJson(jsonResponse);

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
      ShowMessage.inSnackBar(_scaffoldKey,
      'Sorry! There are no offers at the moment!',
      //  value.toString(), 
       true);
      // startTime();
    }
  }

  // startTime() async {
  //   var _duration = new Duration(seconds: 2);
  //   return new Timer(_duration, () {
  //     Navigator.pop(context);
  //   });
  // }

  /*----------------------------------------------------------------------*/
  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    if (isOfferList) {
      setState(() {
        isOfferList = false;
      });
      return Future.value(false);
    }
    return Future.value(false);
  }

  @override
  void initState() {
    user = LacasaUser.data.user.data ?? "";
    getAllIndustries(true);
    getOffers(true);
    screenMover = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          backgroundColor: newWhite,
          key: _scaffoldKey,
          drawer: PreferredSize(
            preferredSize: Size.fromWidth(20),
            child: BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: Container(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
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
                        margin: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 3),
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
          body: ModalProgressHUD(
            inAsyncCall: isLoading,
            progressIndicator: MyLoader(),
            child: isOfferList ? _offersList() : _allAvailableOffers(),
          )),
    );
  }

  Widget _allAvailableOffers() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 5),
          child: Column(
            children: [
              Container(
                child: Text(
                  AppLocalization.of(context)
                      .getTranslatedValues("browse_lacasa_offers"),
                  style: TextStyle(
                      color: newColor,
                      fontSize: SizeConfig.blockSizeVertical * 5.5,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isOfferList = true;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        width: SizeConfig.blockSizeHorizontal * 100,
                        height: SizeConfig.blockSizeVertical * 15,
                        decoration: BoxDecoration(
                            color: Color(0xff33678A),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          AppLocalization.of(context)
                              .getTranslatedValues("offer_home"),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.blockSizeVertical * 1.9),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      alignment: Alignment.center,
                      width: SizeConfig.blockSizeHorizontal * 100,
                      height: SizeConfig.blockSizeVertical * 15,
                      decoration: BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                const Color(0xFFF095FF),
                                const Color(0xFFACB6E5),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        AppLocalization.of(context)
                            .getTranslatedValues("supermarket"),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: SizeConfig.blockSizeVertical * 1.9),
                      ),
                    ),
                  ),
                ],
              ),
              Wrap(
                children: List.generate(
                    EmptyList.isTrue(_industries.data)
                        ? 0
                        : _industries.data.length, (index) {
                  Industry industry = _industries.data[index];
                  return industryCard(index, industry);
                }),
              ),

//              Row(
//                children: [
//                  Expanded(
//                    flex: 1,
//                    child: Container(
//                      margin: EdgeInsets.all(5),
//                      alignment: Alignment.center,
//                      width: SizeConfig.blockSizeHorizontal * 100,
//                      height: SizeConfig.blockSizeVertical * 15,
//                      decoration: BoxDecoration(
//                          color: Colors.blue,
//                          borderRadius: BorderRadius.circular(10)),
//                      child: Text(
//                        AppLocalization.of(context)
//                            .getTranslatedValues("health_beauty"),
//                        style: TextStyle(color: Colors.white),
//                      ),
//                    ),
//                  ),
//                  Expanded(
//                    flex: 1,
//                    child: Container(
//                      margin: EdgeInsets.all(5),
//                      alignment: Alignment.center,
//                      width: SizeConfig.blockSizeHorizontal * 100,
//                      height: SizeConfig.blockSizeVertical * 15,
//                      decoration: BoxDecoration(
//                          color: Colors.green,
//                          borderRadius: BorderRadius.circular(10)),
//                      child: Text(
//                        AppLocalization.of(context)
//                            .getTranslatedValues("optics"),
//                        style: TextStyle(color: Colors.white),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _offersList() {
    return Container(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 5),
          child: Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: EdgeInsets.all(0),
                    // visualDensity: VisualDensity.compact,
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      setState(() {
                        isOfferList = false;
                      });
                    },
                  ),
                  Container(
                    child: Text(
                      AppLocalization.of(context)
                          .getTranslatedValues('all_offers'),
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 4.5,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 6,
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
                        "  Search Offers",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 2.5,
                            color: newBlack.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
              ),
              Column(
                children: List.generate(
                    EmptyList.isTrue(offers.data) ? 0 : offers.data.length,
                    (index) {
                  Offer offer = offers.data[index];
                  return _offer_detail_card(offer, index);
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _offer_detail_card(Offer offer, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: newWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                  spreadRadius: 0.0,
                  offset: Offset(2.0, 2.0), // shadow direction: bottom right
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: SizeConfig.blockSizeHorizontal * 100,
                        height: SizeConfig.blockSizeVertical * 13,
                        decoration: BoxDecoration(
                            color: cardDetailColor,
                            borderRadius: isarabic
                                ? BorderRadius.only(
                                    // bottomRight: Radius.circular(20),
                                    topRight: Radius.circular(20))
                                : BorderRadius.only(
                                    // bottomLeft: Radius.circular(20),
                                    topLeft: Radius.circular(20))),
                        child: Image.asset(
                          'assets/images/offernew.png',
                          // scale: 5,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        // margin: EdgeInsets.symmetric(
                        //     vertical: SizeConfig.blockSizeVertical * 0.5),
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 4,
                            vertical: SizeConfig.blockSizeVertical * 1),
                        width: SizeConfig.blockSizeHorizontal * 100,
                        height: SizeConfig.blockSizeVertical * 13,
                        decoration: BoxDecoration(
                            color: newYellow,
                            borderRadius: isarabic
                                ? BorderRadius.only(
                                    // bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(20))
                                : BorderRadius.only(
                                    // bottomRight: Radius.circular(10),
                                    topRight: Radius.circular(20))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                children: [
                                  Text(
                                    "${offer.name} ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            SizeConfig.blockSizeVertical * 1.8),
                                  ),
                                  Text(
                                    "${offer.name ?? ""} ",
                                    style: TextStyle(
                                        fontSize: SizeConfig.blockSizeVertical *
                                            1.75),
                                  ),
                                ],
                              ),
                            ),

                            // Container(
                            //   alignment: Alignment.centerRight,
                            //   child: GestureDetector(
                            //     onTap: () {
                            //       showDialog(
                            //           context: context,
                            //           builder: (BuildContext context) {
                            //             return BackdropFilter(
                            //               filter: ImageFilter.blur(
                            //                   sigmaX: 0.5, sigmaY: 0.5),
                            //               child: ClaimOfferDialog(
                            //                 offerUUID: offer.uuid,
                            //               ),
                            //             );
                            //           });
                            //     },
                            //     child: Container(
                            //       alignment: Alignment.center,
                            //       width: SizeConfig.blockSizeHorizontal * 30,
                            //       height: SizeConfig.blockSizeVertical * 3,
                            //       decoration: BoxDecoration(
                            //         color: Colors.green,
                            //         borderRadius: BorderRadius.circular(5),
                            //       ),
                            //       child: Text(
                            //         AppLocalization.of(context)
                            //             .getTranslatedValues('claim'),
                            //         style: TextStyle(
                            //             color: whiteColor,
                            //             fontSize: SizeConfig.blockSizeVertical * 1.4),
                            //       ),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      color: newWhite),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "1 month ago",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 1.5),
                      ),
                      Container(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 0.5, sigmaY: 0.5),
                                      child: ClaimOfferDialog(
                                        offerUUID: offer.uuid,
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: SizeConfig.blockSizeHorizontal * 25,
                              // height: SizeConfig.blockSizeVertical * 3,
                              decoration: BoxDecoration(
                                  color: newWhite,
                                  borderRadius: BorderRadius.circular(25),
                                  border:
                                      Border.all(color: newOffer, width: 1.5)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalization.of(context)
                                      .getTranslatedValues('claim'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: newOffer,
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 1.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget industryCard(int index, Industry industry) {
    colorIndex = random.nextInt(4);
    return GestureDetector(
      onTap: () {
        getOffersByIndustry(industry.uuid, true);
      },
      child: Container(
        margin: EdgeInsets.all(5),
        alignment: Alignment.center,
        width: SizeConfig.blockSizeHorizontal * (index == 0 ? 100 : 42),
        height: SizeConfig.blockSizeVertical * 20,
        decoration: BoxDecoration(
            // color: colors[colorIndex],
            gradient: index % 5 == 0
                ? new LinearGradient(
                    colors: [
                      const Color(0xFF9ABDAB),
                      const Color(0xFF48B1BF),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)
                : index % 5 == 1
                    ? new LinearGradient(
                        colors: [
                          const Color(0xFFFC7B7B),
                          const Color(0xFFA6C1FF),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp)
                    : index % 5 == 2
                        ? new LinearGradient(
                            colors: [
                              const Color(0xFF64A1FF),
                              const Color(0xFFBBFCFE),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp)
                        : index % 5 == 3
                            ? new LinearGradient(
                                colors: [
                                  const Color(0xFF33678A),
                                  const Color(0xFF33678A),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp)
                            : new LinearGradient(
                                colors: [
                                  const Color(0xFFF095FF),
                                  const Color(0xFFACB6E5),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          "${industry.name}",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig.blockSizeVertical * 1.9),
        ),
      ),
    );
  }

  Widget _drawer_items(int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashBoard()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Offers()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EarnPoints()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RedeemPoints()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
          } else if (index == 5) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                    child: LogOut(),
                  );
                });
          }
          // else {
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
}
