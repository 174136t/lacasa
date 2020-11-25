import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/modals/user.dart';
import 'package:lacasa/utils/api_constants/end_point_manager.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:lacasa/utils/validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController name_cont = TextEditingController();
  TextEditingController email_cont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController oldPass = TextEditingController();
  TextEditingController currentPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmNewPass = TextEditingController();
  final GlobalKey<FormState> _formKey_profile = GlobalKey<FormState>();
  bool autoValidation_profile = false;
  var selectTile = 1;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  UserInfo currentUser = LacasaUser.data.user.data;
  UserInfo user;
  ApiModal api = ApiModal();
  /*-------------------------------- Methods------------------------------*/

  void changePassword(String oldPassword, String newPassword) async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "name": currentUser.name,
        "email": currentUser.email,
        "locale": currentUser.locale,
        "language": currentUser.language,
        "timezone": currentUser.timezone,
        "new_password": newPassword,
        "current_password": oldPassword,
      };
      print(body);
      var response = await http.post("${Apis.staffUpdateProfile}",
          body: body, headers: MyHeaders.header());
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
        ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
        setState(() {
          //UserInfo user = UserInfo.fromJson(jsonResponse['data']);
          // refreshAuthToken(true);
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

  void updateStaffProfile() async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "name": name_cont.text,
        "email": email_cont.text,
        "locale": "en-US",
        "language": "en",
        "timezone": "Asia/Kolkata",
        "new_password": oldPass.text,
        "current_password": currentPass.text,
      };
      print(body);
      var response = await http.post("${Apis.staffUpdateProfile}",
          body: body, headers: MyHeaders.header());
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
        ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
        setState(() {
          //UserInfo user = UserInfo.fromJson(jsonResponse['data']);
          refreshAuthToken(true);
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

  void updateStaffPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "name": user.name,
        "email": user.email,
        "locale": "en-US",
        "language": "en",
        "timezone": "Asia/Kolkata",
        "new_password": confirmNewPass.text,
        "current_password": oldPass.text,
      };
      print(body);
      var response = await http.post("${Apis.staffUpdateProfile}",
          body: body, headers: MyHeaders.header());
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
        ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
        setState(() {
          //UserInfo user = UserInfo.fromJson(jsonResponse['data']);
          refreshAuthToken(true);
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

  void refreshAuthToken(bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });

      var response = await http.get(
        LacasaUser.data.isStaff
            ? "${Apis.staffRefreshAuthToken}"
            : "${Apis.customerRefreshAuthToken}",
      );
      var jsonResponse = json.decode(response.body);
      print('response:\n');
      print((response.body));
      print("code:${response.statusCode}");
      if (response.statusCode == 200) {
        if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
          setState(() {
            print(jsonResponse['data']['token']);
            BEARER_TOKEN = jsonResponse['data']['token'];
            isLoading = false;
          });
          if (LacasaUser.data.isStaff) {
            getStaffInfo();
          } else {}
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

  getStaffInfo() {
    api
        .getStaffUserInfo(_scaffoldKey, LacasaUser.data.campaignUUID)
        .then((value) {
      print(LacasaUser.data.user.data.name);
      setState(() {
        isLoading = false;
      });
      // LacasaUser.data.campaignUUID = selectedCampaign.campUuid;
      //AppRoutes.replace(context, StaffDashBoard());
    });
  }

  getCustInfo() {
    api.getUserInfo(_scaffoldKey).then((value) {
      setState(() {
        isLoading = false;
      });
      // print(LacasaUser.data.user.data.name);
      // AppRoutes.replace(context, DashBoard());
    });
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
    user = LacasaUser.data.user.data;
    name_cont.text = user.name ?? "";
    phoneCont.text = user.mobile ?? "";
    email_cont.text = user.email ?? "";
//    pass_cont.text = "";
    super.initState();
    selectTile = 1;
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
                      margin: EdgeInsets.only(
                          top: SizeConfig.blockSizeVertical * 3),
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
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Container(
                child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 1,
                ),
                 Container(
                   margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*8),
                   alignment: Alignment.topLeft,
                    child: Text(
                      AppLocalization.of(context)
                          .getTranslatedValues('profile'),
                      style: TextStyle(
                        color: newColor,
                          fontSize: SizeConfig.blockSizeVertical * 4.5,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                Container(
                  width: SizeConfig.blockSizeHorizontal * 100,
                  height: SizeConfig.blockSizeHorizontal * 13,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: _select_tile(1, "profile"),
                      ),
                      Expanded(
                        flex: 5,
                        child: _select_tile(2, "change_password"),
                      ),
                    ],
                  ),
                ),
                selectTile == 1
                    ? Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 5),
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 10),
                        child: Column(
                          children: [
                            Container(
                              width: SizeConfig.blockSizeHorizontal * 60,
                              height: SizeConfig.blockSizeVertical * 25,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0,
                                    spreadRadius: 0.0,
                                    offset: Offset(2.0,
                                        2.0), // shadow direction: bottom right
                                  )
                                ],
                                color: pureWhite,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    // color: Colors.red,
                                    width: SizeConfig.blockSizeHorizontal * 60,
                                    height: SizeConfig.blockSizeVertical * 18,
                                    child: Image.asset(
                                      "assets/images/pro.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                      height: SizeConfig.blockSizeVertical * 7,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                // margin: EdgeInsets.symmetric(
                                                //     horizontal: SizeConfig
                                                //             .blockSizeHorizontal *
                                                //         5),
                                                child: Expanded(
                                                  child: Text(
                                                    "   ${user.name ?? ""}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: SizeConfig
                                                                .blockSizeVertical *
                                                            2.2),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                // margin: EdgeInsets.symmetric(
                                                //     horizontal: SizeConfig
                                                //             .blockSizeHorizontal *
                                                //         5),
                                                child: Expanded(
                                                  child: Padding(
                                                    padding:  EdgeInsets.only(left:8.0),
                                                    child: Text(
                                                      LacasaUser.data.isStaff
                                                          ? user.email ?? ""
                                                          : "   ${user.mobile ?? ""}",
                                                      style: TextStyle(
                                                          fontSize: SizeConfig
                                                                  .blockSizeVertical *
                                                              1.8,
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                             
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            _spacer(2, 0),
                            _text_field(
                                1,
                                name_cont,
                                FieldValidator.validatename,
                                "Enter Name",
                                "your_name"),
                            _spacer(1, 0),
                            LacasaUser.data.isStaff
                                ? Container()
                                : _text_field(
                                    2,
                                    phoneCont,
                                    FieldValidator.validatePhone,
                                    "Enter Mobile Number",
                                    "mobile_number"),
                            _spacer(1, 0),
                            _text_field(
                                3,
                                email_cont,
                                FieldValidator.validateEmail,
                                "Enter Email",
                                "your_email"),
                            _spacer(1, 0),
                            _text_field(
                                4,
                                currentPass,
                                FieldValidator.validatePassword,
                                "Enter Password",
                                "current_password"),
                            _spacer(3, 0),
                            GestureDetector(
                              onTap: () {
                                updateStaffProfile();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: SizeConfig.blockSizeHorizontal * 60,
                                height: SizeConfig.blockSizeHorizontal * 14,
                                decoration: BoxDecoration(
                                    color: newWhite,
                                    border:
                                        Border.all(color: newColor, width: 2),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Text(
                                  AppLocalization.of(context)
                                      .getTranslatedValues("update"),
                                  style: TextStyle(
                                      color: newColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4),
                                ),
                              ),
                            ),
                            SizedBox(height: SizeConfig.blockSizeVertical*10,)
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical * 5),
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 10),
                        child: Column(
                          children: [
                            _text_field(1, oldPass, FieldValidator.validatename,
                                "your_old_Password", "your_old_Password"),
                            _spacer(1, 0),
                            _text_field(
                                1,
                                newPass,
                                FieldValidator.validateEmail,
                                "your_new_Password",
                                "your_new_Password"),
                            _spacer(1, 0),
                            _text_field(
                                1,
                                confirmNewPass,
                                FieldValidator.validatePassword,
                                "your_new_Password",
                                "confirm_Password"),
                            _spacer(4, 0),
                            GestureDetector(
                              onTap: () {
                                if (newPass.text != confirmNewPass.text) {
                                  ShowMessage.inSnackBar(_scaffoldKey,
                                      "new passwords mismatch", true);
                                  return;
                                }
                                changePassword(oldPass.text, newPass.text);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: SizeConfig.blockSizeHorizontal * 60,
                                height: SizeConfig.blockSizeHorizontal * 14,
                                decoration: BoxDecoration(
                                  border: Border.all(color: newColor,width: 2),
                                    color: newWhite,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Text(
                                  AppLocalization.of(context)
                                      .getTranslatedValues("update"),
                                  style: TextStyle(
                                      color: newColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 4),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget _spacer(double h, double w) {
    return SizedBox(
      width: SizeConfig.blockSizeHorizontal * w,
      height: SizeConfig.blockSizeVertical * h,
    );
  }

  Widget _select_tile(int index, String tile) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectTile = index;
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
        child: Text(
          AppLocalization.of(context).getTranslatedValues(tile),
          style: TextStyle(
              color: selectTile == index ? newColor : Colors.grey,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _text_field(int index, TextEditingController controller,
      Function validator, String hint, String lable) {
    return TextFormField(
      style: TextStyle(color: newBlack),
      controller: controller,
      cursorColor: blackColor,
      validator: validator,
      decoration: InputDecoration(
        isDense: true,
        enabled: index == 2 && phoneCont.text.isNotEmpty
            ? false
            : index == 3 && email_cont.text.isNotEmpty
                ? false
                : true,
        // disabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(5),
        //     borderSide: BorderSide(color: blackColor.withOpacity(.50))),
        enabledBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: newWhite)),
        focusedBorder: OutlineInputBorder(
            // borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: newWhite)),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(5),
        //     borderSide: BorderSide(color: Colors.white)),
        filled: true,
        fillColor: newWhite,
        labelStyle: TextStyle(
          color: newBlack,
          fontWeight: FontWeight.w900,
          fontSize: MediaQuery.of(context).size.height * .025,
        ),
        labelText: AppLocalization.of(context).getTranslatedValues(lable),
        hintStyle: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .0175,
          color: newBlack,
        ),
        hintText: index == 4
            ? "*****"
            : AppLocalization.of(context).getTranslatedValues(hint),
      ),
    );
  }
}
