import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/login_screens/customer_login.dart';
import 'package:lacasa/login_screens/otp_screen.dart';
import 'package:lacasa/login_screens/sign_up.dart';
import 'package:lacasa/login_screens/staff_login.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/staff_dashboard/staff_dashboard.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/size_config.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: newWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Container(
            width: SizeConfig.blockSizeHorizontal * 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Image.asset(
                  isarabic ? mall_english : mall_english,
                  scale: 2,
                ),
              ],
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: SizeConfig.blockSizeVertical * 3),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalization.of(context)
                          .getTranslatedValues('welcome_to'),
                      style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 5,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AppLocalization.of(context)
                              .getTranslatedValues('lacasa_deals'),
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeVertical * 5,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: SizeConfig.blockSizeHorizontal * 2,
                        ),
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: SizeConfig.blockSizeVertical * 2,
                              width: SizeConfig.blockSizeVertical * 2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: newGreen),
                            ),
                            SizedBox(
                              height: SizeConfig.blockSizeVertical * 0.5,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        AppLocalization.of(context)
                            .getTranslatedValues('if_received_messsage'),
                        style: TextStyle(
                          fontSize: SizeConfig.blockSizeVertical * 2.5,
                        ),textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        AppRoutes.push(context, Otp());
                      },
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: SizeConfig.blockSizeHorizontal * 60,
                          height: SizeConfig.blockSizeHorizontal * 12,
                          decoration: BoxDecoration(
                              color: newWhite,
                              border: Border.all(color: newColor, width: 2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            AppLocalization.of(context)
                                .getTranslatedValues('verify_account'),
                            style: TextStyle(
                                color: newColor,
                                fontSize: SizeConfig.blockSizeVertical * 2.2,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 3,
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          AppLocalization.of(context).getTranslatedValues('or'),
                          style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 2.2,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical * 3,
                      ),
                      GestureDetector(
                        onTap: () => AppRoutes.push(context, SignUp()),
                        child: Container(
                          alignment: Alignment.center,
                          width: SizeConfig.blockSizeHorizontal * 60,
                          height: SizeConfig.blockSizeHorizontal * 12,
                          decoration: BoxDecoration(
                              color: newWhite,
                              border: Border.all(color: newColor, width: 2),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            AppLocalization.of(context)
                                .getTranslatedValues('create_account'),
                            style: TextStyle(
                                color: newColor,
                                fontSize: SizeConfig.blockSizeVertical * 2.2,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(
              //       horizontal: SizeConfig.blockSizeHorizontal * 10),
              //   margin: EdgeInsets.only(
              //     bottom: SizeConfig.blockSizeVertical * 5,
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             LacasaUser.data.isStaff = false;
              //           });
              //           AppRoutes.push(context, CustomerLogin());
              //         },
              //         child: Container(
              //           alignment: Alignment.center,
              //           width: SizeConfig.blockSizeHorizontal * 37,
              //           height: SizeConfig.blockSizeHorizontal * 10,
              //           decoration: BoxDecoration(
              //               color: buttonColor,
              //               borderRadius: BorderRadius.circular(5)),
              //           child: Text(
              //             AppLocalization.of(context)
              //                 .getTranslatedValues('login_account'),
              //             style: TextStyle(
              //                 color: whiteColor,
              //                 fontSize: SizeConfig.blockSizeVertical * 1.5),
              //           ),
              //         ),
              //       ),
              //       GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             LacasaUser.data.isStaff = true;
              //           });
              //           AppRoutes.push(context, StaffLogin());
              //           //AppRoutes.push(context, StaffDashBoard());
              //         },
              //         child: Container(
              //           alignment: Alignment.center,
              //           width: SizeConfig.blockSizeHorizontal * 37,
              //           height: SizeConfig.blockSizeHorizontal * 10,
              //           decoration: BoxDecoration(
              //               color: buttonColor,
              //               borderRadius: BorderRadius.circular(5)),
              //           child: Text(
              //             AppLocalization.of(context)
              //                 .getTranslatedValues('staff_login'),
              //             style: TextStyle(
              //                 color: whiteColor,
              //                 fontSize: SizeConfig.blockSizeVertical * 1.5),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.blue,
        height: SizeConfig.blockSizeVertical * 10,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  LacasaUser.data.isStaff = false;
                });
                AppRoutes.push(context, CustomerLogin());
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 10,
                width: SizeConfig.blockSizeHorizontal * 50,
                color: newColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalization.of(context)
                            .getTranslatedValues('customer'),
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: SizeConfig.blockSizeVertical * 2.5,fontWeight: FontWeight.w500),
                      ),
                      Text(
                        AppLocalization.of(context)
                            .getTranslatedValues('loginn'),
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: SizeConfig.blockSizeVertical * 2.5,fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  LacasaUser.data.isStaff = true;
                });
                AppRoutes.push(context, StaffLogin());
                //AppRoutes.push(context, StaffDashBoard());
              },
              child: Container(
                height: SizeConfig.blockSizeVertical * 10,
                width: SizeConfig.blockSizeHorizontal * 50,
                color: newGreen,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalization.of(context)
                            .getTranslatedValues('staff'),
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: SizeConfig.blockSizeVertical * 2.5,fontWeight: FontWeight.w500),
                      ),
                       Text(
                        AppLocalization.of(context)
                            .getTranslatedValues('loginn'),
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: SizeConfig.blockSizeVertical * 2.5,fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
