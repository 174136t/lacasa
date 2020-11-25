import 'package:flutter/material.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/size_config.dart';

///// logout
class QrCodeStaffDialog extends StatefulWidget {
  @override
  _QrCodeStaffDialogState createState() => _QrCodeStaffDialogState();
}

class _QrCodeStaffDialogState extends State<QrCodeStaffDialog> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: SizeConfig.blockSizeHorizontal * 90,
          height: SizeConfig.blockSizeHorizontal * 50,
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
                  "LOGOUT",
                  style: TextStyle(
                      fontFamily: 'babas',
                      color: Colors.black,
                      fontSize: SizeConfig.blockSizeHorizontal * 5),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "Do you really want to LogOut?",
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
                            Navigator.pop(context, false);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: SizeConfig.blockSizeHorizontal * 100,
                            height: SizeConfig.blockSizeVertical * 5,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: blackColor),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              "No",
                              style: TextStyle(
                                  fontFamily: 'babas',
                                  color: Colors.grey,
                                  fontSize: SizeConfig.blockSizeHorizontal * 5),
                            ),
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: SizeConfig.blockSizeHorizontal * 100,
                            height: SizeConfig.blockSizeVertical * 5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: blackColor,
                            ),
                            child: Text(
                              "Yes",
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
