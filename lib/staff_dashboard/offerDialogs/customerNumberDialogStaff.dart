import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/modals/staff_active_offers.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';

///// logout
class CustomerNumberDialogStaff extends StatefulWidget {
  @override
  _CustomerNumberDialogStaffState createState() =>
      _CustomerNumberDialogStaffState();
}

TextEditingController customerNumberCont = TextEditingController();

class _CustomerNumberDialogStaffState extends State<CustomerNumberDialogStaff> {
  static String OFFER_NAME = "End Summer Discount";
  static String OFFER_UUID = "7b598058-22cb-4911-9a05-81a41ce9616e";
  List<String> offersList = [
    "Select Offer",
    // OFFER_NAME,
  ];

  String selectedOffer;
  String selectedOfferUID = OFFER_UUID;

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  StaffActiveOffers _activeOffers = StaffActiveOffers();
  /*-----------------------------------------------------------------------*/

  void getAvailableOffers(
    bool shouldReload,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });

      var response = await http.get(
        "${Apis.staffGetActiveOffers}?uuid=${LacasaUser.data.campaignUUID}",
        headers: MyHeaders.header(),
      );
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
        setState(() {
          // ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
          // startTime();
          _activeOffers = StaffActiveOffers.fromJson(jsonResponse);
          _activeOffers.data.forEach((element) {
            offersList.add(element.name);
          });
          // offersList.add(_activeOffers.data.where((element) => false));
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

  void claimOfferByCustomerNumber(
    bool shouldReload,
    String customerNumber,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "uuid": LacasaUser.data.campaignUUID,
        "customer_number": customerNumber,
        "offer": selectedOfferUID,
      };
      var response = await http.post("${Apis.staffClaimOfferByCustomerNumber}",
          headers: MyHeaders.header(), body: body);
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
        setState(() {
          ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
          startTime();
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

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, () {
      Navigator.pop(context);
    });
  }

  /*-----------------------------------------------------------------------*/
  @override
  void initState() {
    getAvailableOffers(
      true,
    );
    super.initState();
  }

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
            borderRadius: BorderRadius.circular(15),
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
                  "Claim offer with customer number",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      // fontFamily: 'babas',
                      color: Colors.black,
                      fontSize: SizeConfig.blockSizeHorizontal * 5,
                      fontWeight: FontWeight.w900),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.topCenter,
                child: Text(
                  "Select an offer and enter a customer number to claim an offer for the customer.",
                  style: TextStyle(
                      // fontFamily: 'babas',
                      color: Colors.black,
                      fontSize: SizeConfig.blockSizeHorizontal * 4),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    EmptyList.isTrue(_activeOffers.data)
                        ? CircularProgressIndicator()
                        : Column(
                          children: [
                            Container(
                        color: Colors.white,
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Offer",
                          style: TextStyle(
                            // fontFamily: 'popin',
                            color: blackColor.withOpacity(.70),
                            fontSize: SizeConfig.blockSizeHorizontal*5.5
                          ),
                        ),
                      ),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.blockSizeHorizontal * 6),
                                width: SizeConfig.blockSizeHorizontal * 100,
                                height: SizeConfig.blockSizeHorizontal * 14,
                                decoration: BoxDecoration(
                                  color: formColor,
                                    borderRadius: BorderRadius.circular(20),
                                    // border:
                                    //     Border.all(width: 1, color: blackColor)
                                        ),
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  items:
                                      _activeOffers.data.map((ActiveOffer offer) {
                                    print(offer.name);
                                    return new DropdownMenuItem<String>(
                                      value: offer.name,
                                      child: new Text(offer.name),
                                      onTap: () {
                                        setState(() {
                                          selectedOfferUID = offer.uuid;
                                        });
                                      },
                                    );
                                  }).toList(),
                                  hint: Text("Select Category"),
                                  onChanged: (newVal) {
                                    selectedOffer = newVal;
                                    // selectedOfferUID = _activeOffers.data
                                    print(selectedOffer + " " + selectedOfferUID);
                                    this.setState(() {});
                                  },
                                  value: selectedOffer,
                                ),
                              ),
                          ],
                        ),
                    // Positioned(
                    //   left: 50,
                    //   top: 3,
                    //   child: Container(
                    //     color: Colors.white,
                    //     alignment: Alignment.topCenter,
                    //     child: Text(
                    //       "Offer",
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
               Container(
                        color: Colors.white,
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Customer Number",
                          style: TextStyle(
                            // fontFamily: 'popin',
                            color: blackColor.withOpacity(.70),
                            fontSize: SizeConfig.blockSizeHorizontal*5.5
                          ),
                        ),
                      ),
              Theme(
                data: ThemeData(primaryColor: blackColor),
                child: TextFormField(
                  controller: customerNumberCont,
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
                          borderSide:
                              BorderSide(color: Colors.transparent)),
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
                      labelStyle: TextStyle(fontSize: 18),
                      hintStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .0175,
                          color: Colors.grey.withOpacity(.60),
                          fontFamily: 'babas'),
                      hintText: "Enter Number"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal * 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: SizeConfig.blockSizeHorizontal*20,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(.40),
                                spreadRadius: 1,
                                blurRadius: 1)
                          ],
                          border: Border.all(color: newOffer,width: 1.5),
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Close",
                            style: TextStyle(color: newOffer,fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ),
                     SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (customerNumberCont.text.isEmpty) {
                          ShowMessage.inSnackBar(_scaffoldKey,
                              "Please enter customer number", true);
                        }
                        claimOfferByCustomerNumber(
                            true, customerNumberCont.text);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
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
                          "Claim Offer",
                          style: TextStyle(color: whiteColor,fontWeight: FontWeight.w900),
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
