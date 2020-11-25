import 'package:flutter/material.dart';
import 'package:lacasa/language/language.dart';
import 'package:lacasa/login_screens/login_screen.dart';
import 'package:lacasa/main.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/routes.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:scoped_model/scoped_model.dart';

class SelectLanguage extends StatefulWidget {
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: SizeConfig.blockSizeVertical * 20,
              ),
              Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    "assets/images/language.png",
                    height: MediaQuery.of(context).size.height * 0.35,
                    filterQuality: FilterQuality.high,
                  )),
              SizedBox(
                height: SizeConfig.blockSizeVertical * 5,
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      " اختر لغتلك",
                      style: TextStyle(
                        fontSize: SizeConfig.blockSizeVertical * 3,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 1,
                    ),
                    Text(
                      "Choose your language",
                      style: TextStyle(
                          color: Color(0xff1d1d1d),
                          fontSize: SizeConfig.blockSizeVertical * 2.5,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 4.5,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isarabic = false;
                              });
                              _changedLanguage(Language('English', 1, 'en'));
                              AppRoutes.push(context, LoginScreen());
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: SizeConfig.blockSizeHorizontal * 35,
                              height: SizeConfig.blockSizeHorizontal * 12,
                              decoration: BoxDecoration(
                                  color: newWhite,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: newColor,
                                      width:
                                          SizeConfig.blockSizeVertical * 0.3)),
                              child: Text(
                                "English",
                                style: TextStyle(
                                    color: newColor,
                                    fontSize: SizeConfig.blockSizeVertical * 3,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          ScopedModelDescendant<AppModel>(
                            builder: (context, child, model) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  isarabic = true;
                                });
                                _changedLanguage(Language('عربى', 2, 'ar'));
                                model.changeDirection();
                                AppRoutes.push(context, LoginScreen());
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: SizeConfig.blockSizeHorizontal * 35,
                                height: SizeConfig.blockSizeHorizontal * 12.6,
                                decoration: BoxDecoration(
                                    color: newColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text(
                                  "العربية",
                                  style: TextStyle(
                                      color: newWhite,
                                      fontSize:
                                          SizeConfig.blockSizeVertical * 3,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: SizeConfig.blockSizeVertical * 25,
              )
            ],
          ),
        ),
      ),
    );
  }
}
