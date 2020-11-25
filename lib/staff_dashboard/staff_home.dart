import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/dashboard/profile.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/login_screens/login_screen.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/modals/staff_offer_history.dart';
import 'package:lacasa/modals/staff_recent_points.dart' as points;
import 'package:lacasa/staff_dashboard/staff_dashboard.dart';
import 'package:lacasa/staff_dashboard/staff_offers.dart';
import 'package:lacasa/staff_dashboard/staff_points.dart';
import 'package:lacasa/staff_dashboard/staff_reward.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/utils/loader.dart';
import 'package:lacasa/utils/shared.dart';
import 'dart:convert';

import 'package:modal_progress_hud/modal_progress_hud.dart';

var staffScreenMover = 0;

class StaffHome extends StatefulWidget {
  @override
  _StaffHomeState createState() => _StaffHomeState();
}

class _StaffHomeState extends State<StaffHome> {
  var selectTile = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  /*-------------------------------- Methods------------------------------*/
  List<History> _offerHistory = [];
  points.StaffRecentPoints _recentPoints = points.StaffRecentPoints();

  void getOffersHistory(bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });
      var postUri = Uri.parse(
          '${Apis.staffGetOfferHistory}?uuid=${LacasaUser.data.campaignUUID}');
      final request = Request('GET', postUri);

      print('saved uuis:${LacasaUser.data.campaignUUID}');
      request.headers.addAll(MyHeaders.header());

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      Map responseMap = jsonDecode(responseBody);

      if (responseMap['status_code'] == 200 && responseMap['result']) {
        setState(() {
          _offerHistory = [];
          isLoading = false;
        });

        Map history = responseMap['data']['history'];
        print("first" + "$history");

        history.values.forEach((element) {
          print("in loop" + "${element}");
          setState(() {
            _offerHistory.add(History.fromJson(element));
          });
        });

        //AppRoutes.replace(context, Home());

      } else {
        setState(() {
          isLoading = false;
        });
        print(responseMap);
        ShowMessage.showErrorSnackBar(
          _scaffoldKey,
          responseMap,
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

  void getPointsHistory(bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });
      // var body = {"remember": "true"};

      var response = await http.get(
          "${Apis.staffGetRecentPointHistory}?uuid=${LacasaUser.data.campaignUUID}",
          headers: MyHeaders.header());
      var jsonResponse = json.decode(response.body);
      print('response:\n');
      print((response.body));
      print("code:${response.statusCode}");
      if (response.statusCode == 200) {
        if (jsonResponse['status_code'] == 200) {
          setState(() {
            isLoading = false;
            _recentPoints = points.StaffRecentPoints.fromJson(jsonResponse);
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
      // Navigator.pop(context);
    });
  }

  String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}';
  }
  /*----------------------------------------------------------------------*/

  @override
  void initState() {
    getOffersHistory(true);
    // getPointsHistory(true);
    staffScreenMover = 0;
    super.initState();
  }

  Widget _drawer_items(int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                  StaffDashBoard()),
          );
          }
          else if(index == 1){
            print("go to offe");
           Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                  StaffOffers()),
          );
          }
          else if(index == 2){
            print("go to offe");
           Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                  StaffPoints()),
          );
          }
          else if(index == 3){
            print("go to offe");
           Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                  StaffRewards()),
          );
          }
          else if(index == 4){
            print("go to offe");
            if(mounted)
           Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                  Profile()),
          );
          }
          else {
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
          } 
          // else {
          //   staffScreenMover = index;
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
          child: Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 10),
                  child: Text(
                    AppLocalization.of(context)
                        .getTranslatedValues("recent_activities"),
                    style: TextStyle(
                        color: newColor,
                        fontSize: SizeConfig.blockSizeVertical * 5.5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _select_tile(1, "offers"),
                    ),
                    Expanded(
                      flex: 2,
                      child: _select_tile(2, "points"),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                    width: SizeConfig.blockSizeHorizontal * 100,
                    // height: SizeConfig.blockSizeVertical * 25,
                    child: selectTile == 2
                        ? _recentPoints.data == null
                            ? Container()
                            : ListView(
                                children: List.generate(
                                    EmptyList.isTrue(_recentPoints.data.history)
                                        ? 0
                                        : _recentPoints.data.history.length,
                                    (index) {
                                History _history =
                                    _recentPoints.data.history[index];
                                return _activePoints(index, _history);
                              }))
                        : ListView(
                            children: List.generate(
                                EmptyList.isTrue(_offerHistory)
                                    ? 0
                                    : _offerHistory.length, (index) {
                            History _history = _offerHistory[index];
                            print(_offerHistory.length);
                            print(_history.offerTitle);
                            print(_history.description);
                            print(_history.purchaseAmount);
                            print(_history.customerDetails.name);

                            return _activeOffers(index, _history);
                          })),
                  ),
                )
              ],
            ),
          ),
        ));
  }
// Widget _categoryThumbnail(int index, String logo) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 16.0),
//       alignment: FractionalOffset.centerLeft,
//       child: Container(
//         decoration: BoxDecoration(
//           color: index % 2 == 1 ? Color(0xffDBAE0F) : Color(0xff2BA88A),
//           shape: BoxShape.circle,
//         ),
//         padding: EdgeInsets.all(12),
//         child: Container(
//           height: MediaQuery.of(context).size.height * .07,
//           child: Image.asset(
//             logo,
//             color: pureWhite,
//           ),
//         ),
//       ),
//     );
//   }

  Widget _activeOffers(int index, History history) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          // Expanded(
          //   flex: 2,
          //   child: Stack(
          //     alignment: AlignmentDirectional.center,
          //     children: [
          //       // Container(
          //       //   alignment: Alignment.center,
          //       //   child: Container(
          //       //     width: 1,
          //       //     height: 150,
          //       //     color: Colors.grey,
          //       //   ),
          //       // ),
          //       Container(
          //         alignment: Alignment.center,
          //         width: 50,
          //         height: 50,
          //         decoration:
          //             BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          // child: Text(
          //   truncateWithEllipsis(
          //       2, "${history?.customerDetails?.name ?? ""}"),
          //   maxLines: 1,
          //   style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: SizeConfig.blockSizeHorizontal * 6),
          // ),
          //       ),
          //     ],
          //   ),
          // ),

          Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 7),
            child: Container(
              height: SizeConfig.blockSizeVertical * 20,
              decoration: BoxDecoration(
                  color: Color(0xffFCCF3E),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .05,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 9,
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                          decoration: BoxDecoration(color: newYellow),
                          margin: EdgeInsets.symmetric(
                              vertical: SizeConfig.blockSizeVertical * 0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        SizeConfig.blockSizeVertical * 0.5),
                                child: Text(
                                  "${history?.discount ?? 0}% off on ${MyTimeAgo.getByString(history?.createdAt)}",
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        SizeConfig.blockSizeVertical * 0.5),
                                child: Text(
                                  "${history?.customerDetails?.name ?? ""} (${history?.customerDetails?.number ?? ""})",
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        SizeConfig.blockSizeVertical * 0.5),
                                child: Text(
                                  "${history?.offerTitle ?? ""}",
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        SizeConfig.blockSizeVertical * 0.5),
                                child: Text(
                                  '${history?.description ?? ""}',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*5),
            alignment: FractionalOffset.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: newYellow,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffDBAE0F),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .07,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          truncateWithEllipsis(
                              2, "${history?.customerDetails?.name ?? ""}"),
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.blockSizeHorizontal * 6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activePoints(int index, History pointsHistory) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          // Expanded(
          //   flex: 2,
          //   child: Stack(
          //     alignment: AlignmentDirectional.center,
          //     children: [
          //       Container(
          //         alignment: Alignment.center,
          //         child: Container(
          //           width: 1,
          //           height: 150,
          //           color: Colors.grey,
          //         ),
          //       ),
          //       Container(
          //         alignment: Alignment.center,
          //         width: 50,
          //         height: 50,
          //         decoration:
          //             BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
          //         child: Text(
          //           truncateWithEllipsis(
          //               2, "${pointsHistory?.customerDetails?.name}"),
          //           maxLines: 1,
          //           style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               fontSize: SizeConfig.blockSizeHorizontal * 6),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 7),
            child: Container(
              height: SizeConfig.blockSizeVertical * 20,
              decoration: BoxDecoration(
                  color: Color(0xffFCCF3E),
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .05,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: SizeConfig.blockSizeHorizontal * 9,
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: SizeConfig.blockSizeVertical * 0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        SizeConfig.blockSizeVertical * 0.5),
                                child: Text(
                                  "${pointsHistory?.points ?? 0} points (\$${pointsHistory.purchaseAmount ?? 0.00}), ${MyTimeAgo.getByString(pointsHistory?.createdAt)}",
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        SizeConfig.blockSizeVertical * 0.5),
                                child: Text(
                                  "${pointsHistory?.customerDetails?.name ?? ""} (${pointsHistory?.customerDetails?.number})",
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        SizeConfig.blockSizeVertical * 0.5),
                                child: Text(
                                  "${pointsHistory?.rewardTitle ?? ""}",
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical:
                                        SizeConfig.blockSizeVertical * 0.5),
                                child: Text(
                                  '${pointsHistory?.description ?? ""}',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical*5),
            alignment: FractionalOffset.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: newYellow,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffDBAE0F),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .07,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          truncateWithEllipsis(2,
                              "${pointsHistory?.customerDetails?.name ?? ""}"),
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.blockSizeHorizontal * 6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _select_tile(int index, String tile) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectTile = index;
          if (index == 1) {
            getOffersHistory(true);
          } else {
            getPointsHistory(true);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: selectTile == index
                        ? newColor
                        : Colors.grey.withOpacity(.10),
                    width: 3))),
        child: Text(AppLocalization.of(context).getTranslatedValues(tile),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selectTile == index ? newColor : Colors.grey,
            )),
      ),
    );
  }
}
