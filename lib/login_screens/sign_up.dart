import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/dashboard/home.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/loader.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/dashboard/dashboard.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/utils/validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _mobileCont = TextEditingController();
  TextEditingController _passCont = TextEditingController();
  TextEditingController _nameCont = TextEditingController();
  TextEditingController _emailCont = TextEditingController();
  var _formKey = new GlobalKey<FormState>();
  bool autoValidate = false;
  bool agreedTerms = false;
  bool passObsecure = false;
  /*-------------------------------- Methods------------------------------*/

  void signUp(bool shouldReload) async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "name": _nameCont.text,
        "email": _emailCont.text.trim(),
        "mobile": _mobileCont.text,
        "password": _passCont.text.trim(),
        "terms": agreedTerms ? "1" : "0",
        "is_global_campaign_signup": "1",
        "locale": "en-US",
        "language": "en",
        "timezone": "Asia/Kolkata",
      };
      var response = await http.post(
        "${Apis.signup}",
        body: body,
      );
      var jsonResponse = json.decode(response.body);
      print('response:\n');
      print((response.body));
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
        ShowMessage.inSnackBar(
          _scaffoldKey,
          "${jsonResponse['data']['email'] ?? ""}"
          "${jsonResponse['data']['mobile'] ?? ""}",
          true,
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
                        top: 8,
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
                    padding: const EdgeInsets.only(top:8.0),
                    child: Image.asset(
                      isarabic ? mall_english : mall_english,
                      scale: 2,
                    ),
                  ),
                ],
              )),
          preferredSize: Size.fromHeight(170),
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 5,
          ),
          child: Form(
            key: _formKey,
            autovalidate: autoValidate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          AppLocalization.of(context)
                              .getTranslatedValues('customer_login'),
                          style: TextStyle(
                            color: newColor,
                              fontWeight: FontWeight.w600,
                            fontSize: SizeConfig.blockSizeVertical * 6,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 4,
                      ),
                      _textField(0, "your_name", _nameCont),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      _textField(1, "your_email", _emailCont),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      _textField(2, "mobile_number", _mobileCont),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      _textField(3, "enter_password", _passCont),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 1.5,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                agreedTerms = !agreedTerms;
                              });
                            },
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      agreedTerms = !agreedTerms;
                                    });
                                  },
                                  icon: Icon(agreedTerms
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank),
                                ),
                                Text(AppLocalization.of(context)
                                    .getTranslatedValues('i_agree'),style: TextStyle(
                                      fontSize: SizeConfig.blockSizeVertical*1.9,
                                      fontWeight: FontWeight.w600
                                    ),),
                              ],
                            ),
                          ),
                          Text(
                            AppLocalization.of(context)
                                .getTranslatedValues('terms_condition'),
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: newOffer,
                                fontSize: SizeConfig.blockSizeVertical*1.9,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            if (agreedTerms) {
                              signUp(true);
                            } else {
                              ShowMessage.inSnackBar(_scaffoldKey,
                                  "Please accepts terms and policy", true);
                            }
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
                                      .getTranslatedValues('sign_up') ??
                                  "",
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
                Container()
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _textField(
    int index,
    String hint,
    TextEditingController controller,
  ) {
    return TextFormField(
       style: TextStyle(fontSize: SizeConfig.blockSizeVertical*2.2),
      cursorColor: blackColor,
      controller: controller,
      validator: index == 3
          ? FieldValidator.validatePassword
          : index == 2
              ? FieldValidator.validatePhone
              : FieldValidator.validateBlank,
      keyboardType:
          index == 1 ? TextInputType.emailAddress : TextInputType.text,
      obscureText: index == 3 ? passObsecure : false,
      decoration: InputDecoration(
        fillColor: newWhite,
        isDense: true,
        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: newTeal)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: newTeal)),
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
                      ),
        hintText: AppLocalization.of(context).getTranslatedValues(hint),

        suffixIcon: index != 3
            ? null
            : IconButton(
                onPressed: () {
                  setState(() {
                    passObsecure = !passObsecure;
                  });
                },
                icon: Icon(
                    passObsecure ? Icons.visibility_off : Icons.remove_red_eye,color: newColor,),
              ),
      ),
    );
  }
}
