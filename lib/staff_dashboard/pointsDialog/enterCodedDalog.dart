import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';
import 'package:http/http.dart' as http;

class EnterCodePointDialogStaff extends StatefulWidget {
  @override
  _EnterCodePointDialogStaffState createState() =>
      _EnterCodePointDialogStaffState();
}

class _EnterCodePointDialogStaffState extends State<EnterCodePointDialogStaff> {
  List<String> expiryOptions = ['hour', 'day', 'week', 'month'];
  String selectedExpiry = 'hour';
  var selectTab = 1;

  TextEditingController generatedCont = TextEditingController();
  TextEditingController amountCont = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /*-------------------------------- Methods------------------------------*/

  void generateCode(
    bool shouldReload,
    String expires,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "uuid": LacasaUser.data.campaignUUID,
        "expires": expires,
        "purchase_amount": amountCont.text,
      };

      var response = await http.post("${Apis.staffGenCodeFromPurchaseAmount}",
          headers: MyHeaders.header(), body: body);
      var jsonResponse = json.decode(response.body);
      print('response:\n');
      print((response.body));
      print("code:${response.statusCode}");
      if (response.statusCode == 200) {
        if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
          setState(() {
            print(jsonResponse['data']['merchant_code']);
            generatedCont.text = jsonResponse['data']['merchant_code'];
            isLoading = false;
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
      Navigator.pop(context);
    });
  }

  /*----------------------------------------------------------------------*/
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: SizeConfig.blockSizeHorizontal * 90,
//          height: selectTab == 1
//              ? SizeConfig.blockSizeHorizontal * 90
//              : SizeConfig.blockSizeHorizontal * 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Center(
                child: Image.asset(
                  mall_english,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(flex: 1, child: _tabs(1, "GENERATE CODE")),
                    Expanded(flex: 1, child: _tabs(2, "ACTIVE CODE")),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              selectTab == 1
                  ? Column(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Generate a code you can give to the customer. This code can be used only once.",
                            style: TextStyle(
                                // fontFamily: 'babas',
                                color: newBlack,
                                fontSize: SizeConfig.blockSizeHorizontal * 4),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.white,
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Purchase Amount",
                            style: TextStyle(
                              // fontFamily: 'popin',
                              fontSize: SizeConfig.blockSizeHorizontal*4,
                              color: blackColor.withOpacity(.70),
                            ),
                          ),
                        ),
                        Theme(
                          data: ThemeData(primaryColor: blackColor),
                          child: TextFormField(
                            controller: amountCont,
                            cursorColor: blackColor,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              BlacklistingTextInputFormatter(RegExp(r'\s')),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                isDense: true,
                                // disabledBorder: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(5),
                                //     borderSide:
                                //         BorderSide(color: Colors.white)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Colors.transparent)),
                                // border: OutlineInputBorder(
                                //     borderRadius: BorderRadius.circular(5),
                                //     borderSide:
                                //         BorderSide(color: Colors.black)),
                                filled: true,
                                fillColor: formColor,
                                // prefixIcon: Icon(
                                //   Icons.attach_money,
                                //   color: Colors.grey,
                                //   size:
                                //       MediaQuery.of(context).size.height * .03,
                                // ),
                                // labelText: "Purchase Amount",
                                // labelStyle: TextStyle(fontSize: 18),
                                hintStyle: TextStyle(
                                  fontSize: MediaQuery.of(context).size.height *
                                      .0175,
                                  color: Colors.grey.withOpacity(.60),
                                  // fontFamily: 'babas'
                                ),
                                // hintText: "Enter Amount "
                                ),
                            onChanged: (va) {
//                              setState(() {
//                                isLoading = false;
//                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: Colors.white,
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Select Expire",
                            style: TextStyle(
                              // fontFamily: 'popin',
                              color: blackColor.withOpacity(.70),
                              fontSize: SizeConfig.blockSizeHorizontal*4,
                            ),
                          ),
                        ),
                        Container(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.blockSizeHorizontal * 6),
                                width: SizeConfig.blockSizeHorizontal * 100,
                                height: SizeConfig.blockSizeHorizontal * 14,
                                decoration: BoxDecoration(
                                  color: formColor,
                                  borderRadius: BorderRadius.circular(20),
                                  // border: Border.all(
                                  //     width: 1, color: blackColor)
                                ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  items: expiryOptions.map((String country) {
                                    return new DropdownMenuItem<String>(
                                      value: country,
                                      child:
                                          new Text('Expires in one ' + country),
                                    );
                                  }).toList(),
                                  hint: Text("Select Catagory"),
                                  onChanged: (newVal) {
                                    selectedExpiry = newVal;
                                    this.setState(() {});
                                    print(newVal);
                                  },
                                  value: selectedExpiry,
                                ),
                              ),
                              // Positioned(
                              //   left: 50,
                              //   top: 3,
                              //   child: Container(
                              //     color: Colors.white,
                              //     alignment: Alignment.topCenter,
                              //     child: Text(
                              //       "Select Expire",
                              //       style: TextStyle(
                              //         fontFamily: 'popin',
                              //         color: blackColor.withOpacity(.70),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (generatedCont.text.isNotEmpty) codeField(),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: SizeConfig.blockSizeHorizontal * 100,
                          child: isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [CircularProgressIndicator()],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        width:
                                            SizeConfig.blockSizeHorizontal * 20,
                                        padding: EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(.40),
                                                  spreadRadius: 1,
                                                  blurRadius: 1)
                                            ],
                                            color: whiteColor,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border:
                                                Border.all(color: newOffer)),
                                        child: Center(
                                          child: Text(
                                            "CLOSE",
                                            style: TextStyle(
                                                color: newOffer,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        generateCode(true, selectedExpiry);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(.40),
                                                spreadRadius: 1,
                                                blurRadius: 1)
                                          ],
                                          color: newOffer,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          "GENERATE",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        )
                      ],
                    )
                  : Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          generatedCont.text.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: codeField(),
                                )
                              : Container(
                                  width: SizeConfig.blockSizeHorizontal * 100,
                                  child: Text("There are no active code"),
                                ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: SizeConfig.blockSizeHorizontal*20,
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.40),
                                      spreadRadius: 1,
                                      blurRadius: 1)
                                ],
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: newOffer,width: 1.5)
                              ),
                              child: Center(
                                child: Text(
                                  "CLOSE",
                                  style: TextStyle(color: newOffer,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget codeField() {
    return Container(
      height: MediaQuery.of(context).size.height * .065,
      // width: MediaQuery.of(context).size.width * .6,
      child: Material(
        elevation: 0.0,
        shadowColor: Colors.black,
        child: GestureDetector(
          onTap: () {
            Clipboard.setData(new ClipboardData(text: generatedCont.text));
            ShowMessage.inSnackBar(_scaffoldKey, "Text Copied", false);
          },
          child: TextFormField(
            controller: generatedCont,
            enabled: false,
            decoration: InputDecoration(
              // filled: true,
              // fillColor: Colors.amber,
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                borderSide: BorderSide(
                    width: MediaQuery.of(context).size.width * .002,
                    color: Colors.blueGrey),
              ),

              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(8)),
              suffixIcon: GestureDetector(
                onTap: () {
                  Clipboard.setData(
                      new ClipboardData(text: generatedCont.text));
                  ShowMessage.inSnackBar(_scaffoldKey, "Text Copied", false);
                },
                child: Image.asset(
                  'assets/images/copy.png',
                  scale: 1.5,
                ),
              ),
              contentPadding: EdgeInsets.all(8),
              hintText: 'Enter 9-digit code',
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabs(int index, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectTab = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 2,
          color: selectTab == index ? newColor : Colors.grey,
        ))),
        child: Text(
          title,
          style: TextStyle(
              color: selectTab == index ? newColor : Colors.grey,
              fontWeight:
                  selectTab == index ? FontWeight.bold : FontWeight.w100,
              fontSize: SizeConfig.blockSizeHorizontal * 4.5),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
