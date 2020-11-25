import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lacasa/dashboard/profile.dart';
import 'package:lacasa/language/language.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/login_screens/login_screen.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/staff_dashboard/claim_QR_token.dart';
import 'package:lacasa/staff_dashboard/staff_home.dart';
import 'package:lacasa/staff_dashboard/staff_offers.dart';
import 'package:lacasa/staff_dashboard/staff_points.dart';
import 'package:lacasa/staff_dashboard/staff_reward.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

var staffScreenMover = 0;

class StaffDashBoard extends StatefulWidget {
  @override
  _StaffDashBoardState createState() => _StaffDashBoardState();
}

class _StaffDashBoardState extends State<StaffDashBoard> {
  refresh() {
    setState(() {});
  }

  void _changedLanguage(Language language) {
    print(language.languageCode);
    Locale _temp;
    switch (language.languageCode) {
      case "en":
        _temp = Locale(language.languageCode, 'US');
        break;
      case "ar":
        _temp = Locale(language.languageCode, 'SA');
        break;
      default:
        _temp = Locale(language.languageCode, 'US');
    }
    MyApp.setLocale(context, _temp);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int currentIndex;
  List<String> drawerItemsName = [
    "staf_home",
    "staf_offer",
    "staf_points",
    "staf_rewards",
    "staf_my_profile",
    "staf_logout",
  ];
  var profileAvatar = Base64Decoder().convert(LacasaUser.data.user.data.avatar
      .replaceAll("data:image/png;base64,", ""));
  @override
  void initState() {
//    getOffersHistory(true);
    super.initState();
    staffScreenMover = 0;
    currentIndex = 0;
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
      print(currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
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
                          CircleAvatar(
                            backgroundImage: MemoryImage(profileAvatar),
                            radius: SizeConfig.blockSizeHorizontal * 15,
                            backgroundColor: Colors.transparent,
                          ),
                          SizedBox(
                            height: SizeConfig.blockSizeVertical * 2,
                          ),
                          Container(
                            child: Text(
                              "${LacasaUser.data.user.data.name ?? ""}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            child: Text(
                              "${LacasaUser.data.user.data.email ?? ""}",
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

          // appBar: PreferredSize(
          //   child: Container(
          //     color: whiteColor,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         GestureDetector(
          //           onTap: () {
          //             setState(() {
          //               _scaffoldKey.currentState.openDrawer();
          //             });
          //           },
          //           child: Container(
          //               color: whiteColor,
          //               padding: EdgeInsets.all(25),
          //               margin: EdgeInsets.only(
          //                   top: SizeConfig.blockSizeVertical * 3),
          //               child: Image.asset(
          //                 drawer,
          //                 scale: 1.5,
          //               )),
          //         ),
          //         Container(
          //           alignment: Alignment.centerRight,
          //           child: Image.asset(
          //             isarabic ? mall_arabic : mall_english,
          //             scale: 1.5,
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          //   preferredSize: Size.fromHeight(170),
          // ),

          body:
              // SmartRefresher(
              //     controller: refreshController,
              //     onRefresh: () async {
              //       await Future.delayed(Duration(seconds: 2));
              //       //getOffersHistory(true);
              //       refreshController.refreshCompleted();
              //     },
              //     child: staffScreenMover == 0
              //         ? StaffHome()
              //         : staffScreenMover == 1
              //             ? StaffOffers(
              //                 refreshScreen: refresh,
              //               )
              //             : staffScreenMover == 2
              //                 ? StaffPoints(
              //                     refreshScreen: refresh,
              //                   )
              //                 : staffScreenMover == 3
              //                     ? StaffRewards(
              //                         refreshScreen: refresh,
              //                       )
              //                     : staffScreenMover == 4
              //                         ? Profile()
              //                         : ClaimQRToken()),
              <Widget>[
            StaffHome(),
            StaffOffers(
              refreshScreen: refresh,
            ),
            StaffPoints(
              refreshScreen: refresh,
            ),
            Profile(
              
            )
          ][currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: newColor,
            // color: Colors.pink[400],
            // index: 2,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  label: 'Home',
                  backgroundColor: Colors.white),
              BottomNavigationBarItem(
                  icon: Icon(Icons.new_releases_rounded),
                  label: 'Offers',
                  backgroundColor: Colors.white),
              BottomNavigationBarItem(
                icon: Icon(Icons.star),
                label: 'Points',
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle),
                  label: 'Profile',
                  backgroundColor: Colors.white),
            ],
            onTap: changePage,
            type: BottomNavigationBarType.fixed,
            elevation: 15,
            selectedItemColor: Colors.white,
            currentIndex: currentIndex,
            unselectedItemColor: tabItemColor,
            unselectedLabelStyle: TextStyle(color: tabItemColor),
            showUnselectedLabels: true,
          ),
        ));
  }

  Widget _drawer_items(int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (index == 5) {
//            isarabic ? isarabic = false : isarabic = true;
//
//            isarabic
//                ? _changedLanguage(Language('عربى', 2, 'ar'))
//                : _changedLanguage(Language('English', 1, 'en'));
//            // showDialog(
//            //     context: context,
//            //     builder: (BuildContext context) {
//            //       return BackdropFilter(
//            //         filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
//            //         child: LogOut(),
//            //       );
//            //     });
            AppRoutes.makeFirst(context, LoginScreen());
          } else {
            staffScreenMover = index;
            AppRoutes.pop(context);
          }
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
