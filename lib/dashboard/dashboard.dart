import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lacasa/dashboard/compaign.dart';
import 'package:lacasa/dashboard/earn_points.dart';
import 'package:lacasa/dashboard/home.dart';
import 'package:lacasa/dashboard/offers.dart';
import 'package:lacasa/dashboard/profile.dart';
import 'package:lacasa/dashboard/redeem_points.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/modals/user.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/dialogs.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/size_config.dart';

var screenMover = 0;

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  refresh() {
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
int currentIndex;
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
  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: "press again to exit",
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void initState() {
    user = LacasaUser.data.user.data ?? "";
    super.initState();
    screenMover = 0;
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
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: newWhite,
              key: _scaffoldkey,
//               drawer: PreferredSize(
//                 preferredSize: Size.fromWidth(20),
//                 child: BackdropFilter(
//         filter: new ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
//         child: Container(
//             padding:
//                 EdgeInsets.only(top: SizeConfig.blockSizeVertical * 7),
//             color: drawerBackColor,
//             width: SizeConfig.blockSizeHorizontal * 75,
//             height: SizeConfig.blockSizeVertical * 100,
//             child: Column(
//               children: [
//                 Column(
//                   children: [
// //                          CircularProfileAvatar(
// //                            "${user.avatar}",
// //                            // child: Image.asset(men),
// //                            elevation: 5,
// //                            radius: SizeConfig.blockSizeHorizontal * 15,
// //                          ),
//                     CircleAvatar(
//                       backgroundImage: MemoryImage(profileAvatar),
//                       radius: SizeConfig.blockSizeHorizontal * 15,
//                       backgroundColor: Colors.transparent,
//                     ),
//                     SizedBox(
//                       height: SizeConfig.blockSizeVertical * 2,
//                     ),
//                     Container(
//                       child: Text("${user?.name ?? ""}"),
//                     ),
//                     Container(
//                       child: Text(
//                         "${user?.mobile ?? ""}",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Divider(
//                       thickness: 1,
//                       color: blackColor.withOpacity(.60),
//                     )
//                   ],
//                 ),
//                 SizedBox(
//                   height: SizeConfig.blockSizeVertical * 3,
//                 ),
//                 Column(
//                   children: List.generate(
//                       drawerItemsName.length,
//                       (index) =>
//                           _drawer_items(index, drawerItemsName[index])),
//                 )
//               ],
//             )),
//                 ),
//               ),
        //       appBar: PreferredSize(
        //         child: Container(
        // color: newWhite,
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     GestureDetector(
        //       onTap: () {
        //         setState(() {
        //           _scaffoldkey.currentState.openDrawer();
        //         });
        //       },
        //       child: Container(
        //           color: newWhite,
        //           padding: EdgeInsets.all(25),
        //           margin: EdgeInsets.only(
        //               top: SizeConfig.blockSizeVertical * 3),
        //           child: Image.asset(
        //             drawer,
        //             scale: 1.5,
        //           )),
        //     ),
        //     Container(
        //          padding: EdgeInsets.only(top:25),
        //       // alignment: Alignment.centerRight,
        //       child: Image.asset(
        //         isarabic ? mall_english : mall_english,
        //         height: SizeConfig.blockSizeVertical*8,
        //       ),
        //     )
        //   ],
        // ),
        //         ),
        //         preferredSize: Size.fromHeight(170),
        //       ),
              body: <Widget>[
                 Home(refreshScreen: refresh),
                 Offers(),
                //  EarnPoints(),
                Campaign(),
                // RedeemPoints(),
                 Profile()
              ][currentIndex],
                bottomNavigationBar: BottomNavigationBar(
            backgroundColor:  newColor,
            // color: Colors.pink[400],
            // index: 2,
            items: <BottomNavigationBarItem>[
            
              BottomNavigationBarItem(  
            icon: Icon(Icons.home,),  
            label: 'Home',  
            
            backgroundColor: Colors.white  
          ),  
          BottomNavigationBarItem(  
            icon: Icon(Icons.new_releases_rounded),  
            label: 'Offers',  
            backgroundColor: Colors.white  
          ),  
          BottomNavigationBarItem(  
            icon: Icon(Icons.star),  
            label:'Points',  
            backgroundColor: Colors.white,  
          ),  
           BottomNavigationBarItem(  
            icon: Icon(Icons.account_circle),  
            label: 'Profile',  
            backgroundColor: Colors.white  
          ),  
         
            ],
            onTap: changePage,
             type: BottomNavigationBarType.fixed, 
              elevation: 15  ,
                selectedItemColor: Colors.white,  
                currentIndex: currentIndex,
              unselectedItemColor: tabItemColor,
              unselectedLabelStyle: TextStyle(color:tabItemColor),
              showUnselectedLabels: true,
          ),
        //       screenMover == 0
        // ? Home(refreshScreen: refresh)
        // : screenMover == 4
        //     ? Profile()
        //     : screenMover == 2
        //         ? Campaign(
        //             refreshScreen: refresh,
        //           )
        //         : screenMover == 6
        //             ? EarnPoints()
        //             : screenMover == 3
        //                 ? RedeemPoints()
        //                 : Offers()

                        ),
      ),
    );
  }

  Widget _drawer_items(int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (index == 5) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                    child: LogOut(),
                  );
                });
          } else {
            screenMover = index;
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
