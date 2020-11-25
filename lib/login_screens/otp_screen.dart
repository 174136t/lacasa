import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/login_screens/customer_login.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:lacasa/utils/validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Otp extends StatefulWidget {
  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  bool isPassSet = false;
  TextEditingController _mobileCont = TextEditingController();

  TextEditingController _otpCont = TextEditingController();
  TextEditingController _newPassCont = TextEditingController();
  TextEditingController _confirmNewPassCont = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  /*-------------------------------- Methods------------------------------*/

  void sendResetPassRequest(bool shouldReload) async {
    try {
      if (shouldReload) {
        setState(() {
          isLoading = true;
        });
      }
      var body = {
        "mobile": _mobileCont.text.trim(),
      };
      var response = await http.post(
        "${Apis.forgotPassword}",
        body: body,
      );
      var jsonResponse = json.decode(response.body);
      print('response:\n');
      print((response.body));
      print("code:${response.statusCode}");
      if (response.statusCode == 200) {
        if (jsonResponse['status_code'] == 200) {
          setState(() {
            print(jsonResponse['data']);
            LacasaUser.data.otpCode = jsonResponse['data']['otp'];
            LacasaUser.data.passwordResetToken = jsonResponse['data']['token'];
            isLoading = false;
            isPassSet = true;
          });

          ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
          // pageCont.animateToPage(2, duration: duration, curve: curve);
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
        isLoading = false;
      });
      print(value);
    }
  }

  void resetPassword(bool shouldReload) async {
    try {
      if (shouldReload) {
        setState(() {
          isLoading = true;
        });
      }
      var body = {
        "token": LacasaUser.data.passwordResetToken,
        "password": _newPassCont.text.trim(),
      };
      var response = await http.post(
        "${Apis.resetPassword}",
        body: body,
      );
      var jsonResponse = json.decode(response.body);
      print('response:\n');
      print((response.body));
      print("code:${response.statusCode}");
      if (response.statusCode == 200) {
        if (jsonResponse['status_code'] == 200) {
          setState(() {
            isLoading = false;
          });
          ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
          startTime();
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
      AppRoutes.makeFirst(context, CustomerLogin());
    });
  }

  /*----------------------------------------------------------------------*/
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: newColor,
        key: _scaffoldKey,
        appBar: PreferredSize(
          child: Container(
              width: SizeConfig.blockSizeHorizontal * 100,
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          AppRoutes.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.blockSizeHorizontal * 5,
                              right: SizeConfig.blockSizeHorizontal * 5),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: newWhite,
                            size: 40,
                          ),
                        ),
                      )
                      // Image.asset(
                      //   isarabic ? mall_arabic : mall_english,
                      //   scale: 1.5,
                      // ),
                    ],
                  ),
                ],
              )),
          preferredSize: Size.fromHeight(150),
        ),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: CircularProgressIndicator(
            backgroundColor: newColor,
          ),
          color: Colors.transparent,
          child: SingleChildScrollView(
              child:
                  isPassSet ? _set_password_screen() : _get_mobile_number()),
        ));
  }

  Widget _get_mobile_number() {
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 3,
                      right: SizeConfig.blockSizeHorizontal * 5),
                  child: Container(
                    child: Text(
                      AppLocalization.of(context)
                          .getTranslatedValues('enter_mobile_number'),
                      style: GoogleFonts.montserrat(
                         color: pureWhite,
                          fontWeight: FontWeight.w500,
                           fontSize: SizeConfig.blockSizeVertical * 6,
                      ) 
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 4,
                ),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 92,
                  decoration: BoxDecoration(
                      color: pureWhite,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 7,
                          right: SizeConfig.blockSizeHorizontal * 7,
                        ),
                        child: Text(
                          AppLocalization.of(context)
                              .getTranslatedValues('example'),
                          style:GoogleFonts.montserrat(
                         color: blackColor,
                          fontWeight: FontWeight.w400,
                           fontSize: SizeConfig.blockSizeVertical * 2.2,
                      )  ,)
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 7,
                          right: SizeConfig.blockSizeHorizontal * 7,
                        ),
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: formColor),
                          child: Center(
                            child: TextFormField(
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: SizeConfig.blockSizeVertical * 5),
                              keyboardType: TextInputType.phone,
                              cursorColor: blackColor,
                              controller: _mobileCont,
                              validator: FieldValidator.validateBlank,
                              decoration: InputDecoration(
                                fillColor: formColor,
                                isDense: true,
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                filled: true,
                                // contentPadding: EdgeInsets.only(top:MediaQuery.of(context).size.height * .019,),
                                // fillColor: whiteColor,

                                // hintStyle: TextStyle(
                                //     fontSize:
                                //         MediaQuery.of(context).size.height * .0175,
                                //     color: Colors.grey.withOpacity(.60),
                                //     fontFamily: 'babas'),
                                // hintText: "Mobile Number"
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 6,
                      ),
                      GestureDetector(
                        onTap: () {
                          sendResetPassRequest(true);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Container(
                            alignment: Alignment.center,
                            width: SizeConfig.blockSizeHorizontal * 60,
                            height: SizeConfig.blockSizeHorizontal * 14,
                            decoration: BoxDecoration(
                                color: newColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              AppLocalization.of(context)
                                  .getTranslatedValues('get_otp'),
                              style: TextStyle(
                                  color: pureWhite,
                                  fontSize: SizeConfig.blockSizeVertical * 2.5,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 10,
          ),
          // GestureDetector(
          //   onTap: () {
          //     AppRoutes.pop(context);
          //   },
          //   child: Container(
          //     padding: EdgeInsets.symmetric(
          //         vertical: SizeConfig.blockSizeVertical * 3),
          //     margin: EdgeInsets.symmetric(
          //         horizontal: SizeConfig.blockSizeHorizontal * 20),
          //     alignment: Alignment.center,
          //     child: Text(
          //       AppLocalization.of(context).getTranslatedValues('back_screen'),
          //       style: TextStyle(
          //         fontSize: SizeConfig.blockSizeHorizontal * 4,
          //       ),
          //     ),
          //   ),
          // ),
          // Container()
        ],
      ),
    );
  }

  Widget _set_password_screen() {
    return Container(
      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 3,
                      right: SizeConfig.blockSizeHorizontal * 5),
                  child: Container(
                    child: Text(
                      AppLocalization.of(context)
                          .getTranslatedValues('set_password'),
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 6,
                          color: pureWhite,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 4,
                ),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 92,
                  decoration: BoxDecoration(
                      color: pureWhite,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 7,
                          right: SizeConfig.blockSizeHorizontal * 7,
                        ),
                        child: Text(
                          // AppLocalization.of(context)
                          //     .getTranslatedValues('example'),
                          "OTP Code",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2,
                              color: blackColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 7,
                          right: SizeConfig.blockSizeHorizontal * 7,
                        ),
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: formColor),
                          child: Center(
                            child: TextFormField(
                              cursorColor: blackColor,
                              controller: _otpCont,
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: SizeConfig.blockSizeVertical * 4),
                              validator: FieldValidator.validateBlank,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                fillColor: formColor,
                                isDense: true,
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                filled: true,
                                // contentPadding: EdgeInsets.only(top:MediaQuery.of(context).size.height * .019,),
                                // fillColor: whiteColor,

                                // hintStyle: TextStyle(
                                //     fontSize: MediaQuery.of(context).size.height * .0175,
                                //     color: Colors.grey.withOpacity(.60),
                                //     fontFamily: 'babas'),
                                // hintText: "OTP Code"
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 2,
                      ),
                       Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 7,
                          right: SizeConfig.blockSizeHorizontal * 7,
                        ),
                        child: Text(
                          // AppLocalization.of(context)
                          //     .getTranslatedValues('example'),
                          "Password",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2,
                              color: blackColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 7,
                          right: SizeConfig.blockSizeHorizontal * 7,
                        ),
                        child: Container(
                          height: SizeConfig.blockSizeVertical * 8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: formColor),
                          child: Center(
                            child: TextFormField(
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: SizeConfig.blockSizeVertical * 4),
                              cursorColor: blackColor,
                              controller: _newPassCont,
                              validator: FieldValidator.validatePassword,
                              decoration: InputDecoration(
                                  fillColor: formColor,
                                  isDense: true,
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  filled: true,
                                  // contentPadding: EdgeInsets.only(top:MediaQuery.of(context).size.height * .019,),
                                  // fillColor: whiteColor,

                                  // hintStyle: TextStyle(
                                  //     fontSize:
                                  //         MediaQuery.of(context).size.height *
                                  //             .0175,
                                  //     color: Colors.grey.withOpacity(.60),
                                  //     fontFamily: 'babas'),
                                  // hintText: "Password"
                                  ),
                            ),
                          ),
                        ),
                      ),
                       SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),
                 Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 7,
                          right: SizeConfig.blockSizeHorizontal * 7,
                        ),
                        child: Text(
                          // AppLocalization.of(context)
                          //     .getTranslatedValues('example'),
                          "Confirm Password",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 2,
                              color: blackColor,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                Padding(
                 padding: EdgeInsets.only(
                          left: SizeConfig.blockSizeHorizontal * 7,
                          right: SizeConfig.blockSizeHorizontal * 7,
                        ),
                  child: Container(
                      height: SizeConfig.blockSizeVertical * 8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: formColor),
                    child: Center(
                      child: TextFormField(
                         style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: SizeConfig.blockSizeVertical * 4),
                        cursorColor: blackColor,
                        controller: _confirmNewPassCont,
                        validator: FieldValidator.validatePassword,
                        decoration: InputDecoration(
                            fillColor: formColor,
                            isDense: true,
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.transparent)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.transparent)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Colors.transparent)),
                            filled: true,
                            // contentPadding: EdgeInsets.only(top:MediaQuery.of(context).size.height * .019,),
                            // fillColor: whiteColor,

                            // hintStyle: TextStyle(
                            //     fontSize: MediaQuery.of(context).size.height * .0175,
                            //     color: Colors.grey.withOpacity(.60),
                            //     fontFamily: 'babas'),
                            // hintText: "Confirm Password"
                            ),
                      ),
                    ),
                  ),
                ),
                  SizedBox(
                  height: SizeConfig.blockSizeVertical * 5,
                ),
                GestureDetector(
                  onTap: () {
                    resetPassword(true);
                    // AppRoutes.push(context, DashBoard());
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      width: SizeConfig.blockSizeHorizontal * 60,
                      height: SizeConfig.blockSizeHorizontal * 14,
                      decoration: BoxDecoration(
                          color: newColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        AppLocalization.of(context)
                            .getTranslatedValues('confirm_continue'),
                        style: TextStyle(
                            color: pureWhite,
                            fontSize: SizeConfig.blockSizeVertical * 2.5),
                      ),
                    ),
                  ),
                ),
                 SizedBox(
                        height: SizeConfig.blockSizeVertical * 2,
                      ),

                    ],
                  ),
                ),
               
              
              ],
            ),
          ),
          Container()
        ],
      ),
    );
  }
}
