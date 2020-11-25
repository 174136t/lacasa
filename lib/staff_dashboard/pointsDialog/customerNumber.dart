import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/images.dart';

import 'package:lacasa/utils/size_config.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:http/http.dart' as http;

///// logout
class CustomerNumberPointDialogStaff extends StatefulWidget {
  @override
  _CustomerNumberPointDialogStaffState createState() =>
      _CustomerNumberPointDialogStaffState();
}

class _CustomerNumberPointDialogStaffState
    extends State<CustomerNumberPointDialogStaff> {
  TextEditingController amountCont = TextEditingController();
  TextEditingController customerNumber = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  /*-------------------------------- Methods------------------------------*/

  void creditCustomerWithAmountAndNumber(
    bool shouldReload,
    String customerNum,
    String purchaseAmount,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "uuid": LacasaUser.data.campaignUUID,
        "customer_number": customerNum,
        "purchase_amount": purchaseAmount,
      };

      var response = await http.post("${Apis.staffCreditWithCustomerNumber}",
          headers: MyHeaders.header(), body: body);
      var jsonResponse = json.decode(response.body);
      print('response:\n');
      print((response.body));
      print("code:${response.statusCode}");
      if (response.statusCode == 200) {
        if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
          setState(() {
            // print(jsonResponse['data']['merchant_code']);
            //  generatedCont.text = jsonResponse['data']['merchant_code'];
            isLoading = false;
          });
          ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
          Navigator.pop(context);
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
          // height: SizeConfig.blockSizeVertical * 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  mall_english,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Credit a customer with number",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      // fontFamily: 'babas',
                      color: Colors.black,
                      fontSize: SizeConfig.blockSizeHorizontal * 4,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "Enter the purchase amount and a customer number to credit the customer.",
                  style: TextStyle(
                      // fontFamily: 'babas',
                      color: Colors.grey,
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
                      color: blackColor.withOpacity(.70),
                      fontSize: SizeConfig.blockSizeHorizontal * 5.5),
                ),
              ),
              Theme(
                data: ThemeData(primaryColor: blackColor),
                child: Container(
                  decoration: BoxDecoration(
                      color: formColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: TextFormField(
                    controller: amountCont,
                    cursorColor: blackColor,
                    inputFormatters: [
                      BlacklistingTextInputFormatter(RegExp(r'\s'))
                    ],
                    decoration: InputDecoration(
                        isDense: true,
                        // disabledBorder: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(5),
                        //     borderSide: BorderSide(color: Colors.white)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.transparent)),
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(5),
                        //     borderSide: BorderSide(color: Colors.black)),
                        filled: true,
                        fillColor: formColor,
                        // prefixIcon: Icon(
                        //   Icons.attach_money,
                        //   color: Colors.grey,
                        //   size: MediaQuery.of(context).size.height * .03,
                        // ),
                        // labelText: "Purchase Amount",
                        // labelStyle: TextStyle(fontSize: 18),
                        hintStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .0175,
                          color: Colors.grey.withOpacity(.60),
                          // fontFamily: 'babas'
                        ),
                        // hintText: "Enter Amount"
                        ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                alignment: Alignment.topCenter,
                child: Text(
                  "Customer Number",
                  style: TextStyle(
                      // fontFamily: 'popin',
                      color: blackColor.withOpacity(.70),
                      fontSize: SizeConfig.blockSizeHorizontal * 5.5),
                ),
              ),
              Theme(
                data: ThemeData(primaryColor: blackColor),
                child: TextFormField(
                  controller: customerNumber,
                  cursorColor: blackColor,
                  inputFormatters: [
                    BlacklistingTextInputFormatter(RegExp(r'\s'))
                  ],
                  decoration: InputDecoration(
                      isDense: true,
                      // disabledBorder: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(5),
                      //     borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.transparent)),
                      // border: OutlineInputBorder(
                      //     borderRadius: BorderRadius.circular(5),
                      //     borderSide: BorderSide(color: Colors.black)),
                      filled: true,
                      fillColor: formColor,
                      // prefixIcon: Icon(
                      //   Icons.person,
                      //   color: Colors.grey,
                      //   size: MediaQuery.of(context).size.height * .03,
                      // ),
                      // labelText: "Customer Number",
                      // labelStyle: TextStyle(fontSize: 18),
                      hintStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * .0175,
                        color: Colors.grey.withOpacity(.60),
                        // fontFamily: 'babas'
                      ),
                      // hintText: "Enter number"
                      ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal * 100,
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [CircularProgressIndicator()],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: SizeConfig.blockSizeHorizontal * 20,
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.40),
                                      spreadRadius: 1,
                                      blurRadius: 1)
                                ],
                                color: whiteColor,
                                border: Border.all(color: newOffer, width: 1.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  "CLOSE",
                                  style: TextStyle(color: newOffer,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (amountCont.text.isEmpty) {
                                ShowMessage.inSnackBar(_scaffoldKey,
                                    "Please enter purchase amount", true);
                                return;
                              }
                              if (customerNumber.text.isEmpty) {
                                ShowMessage.inSnackBar(_scaffoldKey,
                                    "Please enter cutomer number", true);
                                return;
                              }
                              creditCustomerWithAmountAndNumber(
                                  true, customerNumber.text, amountCont.text);
                            },
                            child: Container(
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(.40),
                                      spreadRadius: 1,
                                      blurRadius: 1)
                                ],
                                color: newOffer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "CREDIT CUSTOMER",
                                style: TextStyle(color: whiteColor),
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
}
