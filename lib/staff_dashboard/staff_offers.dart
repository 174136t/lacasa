import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/staff_dashboard/offerDialogs/customerNumberDialogStaff.dart';
import 'package:lacasa/staff_dashboard/staff_dashboard.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/my_web_view.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class StaffOffers extends StatefulWidget {
  final Function() refreshScreen;
  StaffOffers({Key key, this.refreshScreen}) : super(key: key);
  @override
  _StaffOffersState createState() => _StaffOffersState();
}

class _StaffOffersState extends State<StaffOffers> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  String scanUrl;
  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() {
      scannedQRToken = barcode;
      claimQrScreenName = CLAIM_OFFER;
      staffScreenMover = 5;
      widget.refreshScreen();
      // if (scanUrl != null) {
      //   showDialog(
      //       barrierDismissible: true,
      //       context: context,
      //       builder: (BuildContext context) {
      //         return _ScanFileDisplay(scanUrl);
      //       });
      // }
    });
  }

  _launchQRLink(url) async {
    AppRoutes.push(context, MyWebView(url: url));
  }

  void getStaffActiveOffers(bool shouldReload) async {
    try {
      // if (mounted) {
      setState(() {
        isLoading = true;
      });
      // }

      var response = await http.get(
          "${Apis.staffGetActiveOffers}?uuid=${LacasaUser.data.campaignUUID}",
          headers: MyHeaders.header());
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200) {
        // if (mounted)
        setState(() {
          // _offers = AllOffers.fromJson(jsonResponse);
          isLoading = false;
        });
      } else {
        // if (mounted)
        setState(() {
          isLoading = false;
        });
        ShowMessage.showErrorSnackBar(
          _scaffoldKey,
          jsonResponse != null ? jsonResponse : "",
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
      // if (mounted)
        setState(() {
          isLoading = false;
        });
      ShowMessage.inSnackBar(
          _scaffoldKey, value != null ?
           value.toString() 
           : "error", true);
      startTime();
    }
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, () {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    // getStaffActiveOffers(true);
     getStaffActiveOffers(true);
    super.initState();
    // if(mounted)
    // setState(() {
   
    // });
  }

  @override
  void dispose() {
    isLoading = false;
    // startTime().cancel();
    // getStaffActiveOffers(false);
    super.dispose();
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
        preferredSize: Size.fromHeight(150),
      ),
      body: Container(
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * .01),
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
                                  .getTranslatedValues("offers"),
                              style: TextStyle(
                                  color: newColor,
                                  fontSize: SizeConfig.blockSizeVertical * 5,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .005,
                      ),
                      Row(
                        children: [
                          Container(
                            width: SizeConfig.blockSizeHorizontal * 90,
                            child: Text(
                              AppLocalization.of(context)
                                  .getTranslatedValues("cutomer_claim_offer"),
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical * 2,
                              ),
                            ),
                          ),
                          Container()
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .02,
                ),
                _earnPointsCards(1, 'qr_code', qrImage,
                    getTranslated(context, 'customer_displays_a_QR')),
                _earnPointsCards(2, 'customer_number', customerNumber,
                    getTranslated(context, "add_points_to_customer")),
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
          _scan();

          return;
        }
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return CustomerNumberDialogStaff();
            });
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

                // shape:

                //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

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

                      //         height: MediaQuery.of(context).size.height * .05,

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
                                description,
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * .018,
                                  color: index % 2 == 1 ? newBlack : pureWhite,
                                ),
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
            _categoryThumbnail(index, logo)
          ],
        ),
      ),
    );
  }

  Widget _ScanFileDisplay(scannedResult) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: SizeConfig.blockSizeHorizontal * 90,
          height: SizeConfig.blockSizeHorizontal * 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
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
                        border: Border.all(width: 1, color: Colors.black)),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  scanUrl ?? "scan file",
                  style: TextStyle(
                      fontFamily: 'babas',
                      color: Colors.grey,
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
                            _launchQRLink(scannedResult);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: SizeConfig.blockSizeHorizontal * 100,
                            height: SizeConfig.blockSizeVertical * 5,
                            decoration: BoxDecoration(
                              color: blackColor,
                              border: Border.all(width: 1, color: blackColor),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "Use this link",
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
