import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/dashboard/dashboard.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/utils/api_constants/end_point_manager.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/loader.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:lacasa/utils/validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CustomerLogin extends StatefulWidget {
  @override
  _CustomerLoginState createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _mobileCont = TextEditingController();
  TextEditingController _passCont = TextEditingController();
  TextEditingController _otpCont = TextEditingController();
  TextEditingController _newPassCont = TextEditingController();
  TextEditingController _confirmNewPassCont = TextEditingController();
  var _formKey = new GlobalKey<FormState>();
  var _formKey2 = new GlobalKey<FormState>();
  var _formKey3 = new GlobalKey<FormState>();
  bool autoValidate = false;
  bool autoValidate2 = false;
  bool autoValidate3 = false;
  var pageCont = PageController();
  int pageIndex = 0;
  Duration duration = Duration(milliseconds: 300);
  Curve curve = Curves.decelerate;
  ApiModal api = ApiModal();
  /*-------------------------------- Methods------------------------------*/

  void customerLogin(bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "mobile": _mobileCont.text.trim(),
        "password": _passCont.text.trim(),
        "remember": "true"
      };
      var response = await http.post(
        "${Apis.customerLogin}",
        body: body,
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
          api.getUserInfo(_scaffoldKey).then((value) {
            print(LacasaUser.data.user.data.name);
            AppRoutes.replace(context, DashBoard());
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
          });

          ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
          pageCont.animateToPage(2, duration: duration, curve: curve);
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
  void dispose() {
    isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: MyLoader(),
      child: Scaffold(
        backgroundColor: newWhite,
        key: _scaffoldKey,
        appBar: PreferredSize(
          child: Container(
              width: SizeConfig.blockSizeHorizontal * 100,
              child: Row(
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
                        color: newGreen,
                        size: 40,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Image.asset(
                      isarabic ? mall_english : mall_english,
                      // height: SizeConfig.blockSizeVertical*15,
                      scale: 2,
                    ),
                  ),
                ],
              )),
          preferredSize: Size.fromHeight(170),
        ),
        body: Container(
            margin: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical * 5,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 5),
              child: PageView(
                controller: pageCont,
                physics: NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
                children: [
                  loginFormWidget(),
                  getPhoneNumber(),
                  resetPasswordWidget(),
                ],
              ),
            )),
      ),
    );
  }

  Widget loginFormWidget() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidate: autoValidate,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 3,
                    right: SizeConfig.blockSizeHorizontal * 3,
                  ),
                  child: Container(
                    child: Text(
                      AppLocalization.of(context)
                          .getTranslatedValues("cus_log"),
                      style: TextStyle(
                        color: newColor,
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.blockSizeVertical * 6,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 9,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 3,
                    right: SizeConfig.blockSizeHorizontal * 3,
                  ),
                  child: TextFormField(
                    style:
                        TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.2),
                    cursorColor: blackColor,
                    controller: _mobileCont,
                    validator: FieldValidator.validatePhone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      fillColor: newWhite,
                      isDense: true,
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: newTeal)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: newTeal)),
                      // disabledBorder: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(0),
                      //     borderSide: BorderSide(color: Colors.transparent)),
                      // enabledBorder: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(0),
                      //     borderSide:
                      //         BorderSide(color: Colors.transparent)),
                      // focusedBorder: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(0),
                      //     borderSide: BorderSide(color: Colors.grey)),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(0),
                      //     borderSide: BorderSide(color: Colors.red)),
                      filled: true,
                      // contentPadding: EdgeInsets.only(top:MediaQuery.of(context).size.height * .019,),
                      // fillColor: whiteColor,

                      hintStyle: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical * 2.2,
                        color: newBlack,
                      ),
                      hintText: AppLocalization.of(context)
                          .getTranslatedValues("mobile_number"),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 5,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.blockSizeHorizontal * 3,
                    right: SizeConfig.blockSizeHorizontal * 3,
                  ),
                  child: TextFormField(
                    cursorColor: blackColor,
                    controller: _passCont,
//
                    style:
                        TextStyle(fontSize: SizeConfig.blockSizeVertical * 2.2),
                    validator: FieldValidator.validatePassword,
                    decoration: InputDecoration(
                        fillColor: newWhite,
                        isDense: true,
                        // disabledBorder: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(0),
                        //     borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: newTeal)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: newTeal)),
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(0),
                        //     borderSide: BorderSide(color: Colors.white)),
                        filled: true,
                        // contentPadding: EdgeInsets.only(top:MediaQuery.of(context).size.height * .019,),
                        // fillColor: whiteColor,

                        hintStyle: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2.2,
                          color: newBlack,
                          // fontFamily: 'babas'
                        ),
                        hintText: AppLocalization.of(context)
                            .getTranslatedValues("password")),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 1,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    padding: EdgeInsets.only(left: 1, right: 1),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    onPressed: () {
                      pageCont.animateToPage(1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.decelerate);
                    },
                    child: Text(
                      getTranslated(context, 'forgot_password'),
                      style: TextStyle(
                        // fontFamily: 'Monts',
                        fontSize: MediaQuery.of(context).size.height * .0175,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 8,
                ),
                GestureDetector(
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      customerLogin(true);
                    } else {
                      setState(() {
                        autoValidate = true;
                      });
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      width: SizeConfig.blockSizeHorizontal * 60,
                      height: SizeConfig.blockSizeHorizontal * 12,
                      decoration: BoxDecoration(
                          color: newColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        AppLocalization.of(context)
                            .getTranslatedValues('login'),
                        style: TextStyle(
                            color: pureWhite,
                            fontWeight: FontWeight.w700,
                            fontSize: SizeConfig.blockSizeVertical * 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container()
          ],
        ),
      ),
    );
  }

  Widget getPhoneNumber() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey2,
        autovalidate: autoValidate2,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 3,
                right: SizeConfig.blockSizeHorizontal * 3,
              ),
              child: Container(
                child: Text(
                  AppLocalization.of(context)
                      .getTranslatedValues("forgot_password_no_qmark"),
                  style: TextStyle(
                    color: newColor,
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.blockSizeVertical * 6,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 6,
            ),
            _textField(0, "mobile_number", _mobileCont),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 5,
            ),
            GestureDetector(
              onTap: () {
                if (_formKey2.currentState.validate()) {
                  sendResetPassRequest(true);
                  FocusScope.of(context).requestFocus(new FocusNode());
                } else {
                  setState(() {
                    autoValidate2 = true;
                  });
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  width: SizeConfig.blockSizeHorizontal * 60,
                  height: SizeConfig.blockSizeHorizontal * 12,
                  decoration: BoxDecoration(
                      color: newColor, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    AppLocalization.of(context).getTranslatedValues('submit'),
                    style: TextStyle(
                        color: pureWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.blockSizeVertical * 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget resetPasswordWidget() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey3,
        autovalidate: autoValidate3,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.blockSizeHorizontal * 3,
                right: SizeConfig.blockSizeHorizontal * 3,
              ),
              child: Container(
                child: Text(
                  AppLocalization.of(context)
                      .getTranslatedValues("set_new_password"),
                  style: TextStyle(
                    color: newColor,
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.blockSizeVertical * 6,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 4,
            ),
            _textField(3, "otp_code", _otpCont),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 3,
            ),
            _textField(1, "new_password", _newPassCont),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 3,
            ),
            _textField(2, "confirm_new_password", _confirmNewPassCont),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 5,
            ),
            GestureDetector(
              onTap: () {
                if (_formKey3.currentState.validate()) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_otpCont.text == LacasaUser.data.otpCode) {
                    resetPassword(true);
                  } else {
                    ShowMessage.inSnackBar(
                        _scaffoldKey, "OTP code does not match", true);
                  }
                } else {
                  setState(() {
                    autoValidate3 = true;
                  });
                }
              },
              child: Container(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  width: SizeConfig.blockSizeHorizontal * 60,
                  height: SizeConfig.blockSizeHorizontal * 12,
                  decoration: BoxDecoration(
                      color: newColor, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    AppLocalization.of(context).getTranslatedValues('submit'),
                    style: TextStyle(
                        color: pureWhite,
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.blockSizeVertical * 2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(
    int index,
    String hint,
    TextEditingController controller,
  ) {
    return TextFormField(
      cursorColor: blackColor,
      controller: controller,
      validator: index == 2 || index == 1
          ? FieldValidator.validatePassword
          : index == 3
              ? null
              : FieldValidator.validatePhone,
      keyboardType:
          index == 1 ? TextInputType.emailAddress : TextInputType.text,
      //obscureText: index == 3 ? passObsecure : false,
      decoration: InputDecoration(
        fillColor: newWhite,
        isDense: true,
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: newTeal)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: newTeal)),
        // disabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(0),
        //     borderSide: BorderSide(color: Colors.white)),
        // enabledBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(0),
        //     borderSide: BorderSide(color: Colors.grey.withOpacity(.50))),
        // focusedBorder: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(0),
        //     borderSide: BorderSide(color: Colors.grey)),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(0),
        //     borderSide: BorderSide(color: Colors.white)),
        filled: true,
        // contentPadding: EdgeInsets.only(top:MediaQuery.of(context).size.height * .019,),
        // fillColor: whiteColor,

        hintStyle: TextStyle(
          fontSize: SizeConfig.blockSizeVertical * 2.2,
          color: newBlack,
          // fontFamily: 'babas'
        ),
        hintText: AppLocalization.of(context).getTranslatedValues(hint),

//        suffixIcon: index != 3
//            ? null
//            : IconButton(
//          onPressed: () {
//            setState(() {
//              passObsecure = !passObsecure;
//            });
//          },
//          icon: Icon(
//              passObsecure ? Icons.visibility_off : Icons.remove_red_eye),
      ),
    );
  }
}
