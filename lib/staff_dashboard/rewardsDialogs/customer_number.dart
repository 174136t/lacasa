import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/modals/rewards_model.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/images.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/size_config.dart';

///// logout
class CustomerNumberRewardDialogStaff extends StatefulWidget {
  @override
  _CustomerNumberRewardDialogStaffState createState() =>
      _CustomerNumberRewardDialogStaffState();
}

class _CustomerNumberRewardDialogStaffState
    extends State<CustomerNumberRewardDialogStaff> {
  //saving rewards as consts
  static String REWARD_NAME = 'Welcome (100)';
  static String REWARD_UUID = '025dd7a9-260a-452a-abdc-6615ecc69a79';

  List<String> rewardsList = ["Select Reward", "Welcome (100)"];
  String selectedReward;
  String selectedRewardId = "025dd7a9-260a-452a-abdc-6615ecc69a79";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController customerNumCont = TextEditingController();
  RewardsModel rewardsModel = RewardsModel();

  void getRewards(
    bool shouldReload,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });

      var response = await http.get(
        "${Apis.staffGetRewards}?uuid=${LacasaUser.data.campaignUUID}",
        headers: MyHeaders.header(),
      );
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
        setState(() {
          rewardsModel = RewardsModel.fromJson(jsonResponse);
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
      // startTime();
    }
  }

  void redeemReward(
      bool shouldReload, String rewardId, String customerNumber) async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "uuid": LacasaUser.data.campaignUUID,
        "customer_number": customerNumber,
        "reward": rewardId
      };
      var response = await http.post(
          "${Apis.staffRewardRedeemByCustomerNumber}",
          headers: MyHeaders.header(),
          body: body);
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200) {
        setState(() {
          isLoading = false;
        });
        ShowMessage.showErrorSnackBar(
          _scaffoldKey,
          jsonResponse,
        );
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
//      startTime();
    }
  }

  @override
  void initState() {
    getRewards(true);
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
                  "Claim offer with customer number",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      // fontFamily: 'babas',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: SizeConfig.blockSizeHorizontal * 4),
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
              rewardsModel.data == null
                  ? CircularProgressIndicator()
                  : Column(
                    children: [
                      Container(
                          color: Colors.white,
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Reward",
                            style: TextStyle(
                              // fontFamily: 'popin',
                              color: blackColor.withOpacity(.70),
                            ),
                          ),
                        ),
                      Container(
                          child: Stack(
                            children: <Widget>[
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
                                  items: rewardsModel.data.map((MyReward reward) {
                                    print(reward.title);
                                    return new DropdownMenuItem<String>(
                                      value: reward.title,
                                      child: new Text(reward.title),
                                      onTap: () {
                                        setState(() {
                                          selectedRewardId = reward.uuid;
                                        });
                                      },
                                    );
                                  }).toList(),
                                  // hint: Text("Reward"),
                                  onChanged: (newVal) {
                                    print(newVal);
                                    selectedReward = newVal;
                                    // selectedOfferUID = _activeOffers.data
                                    print(selectedRewardId + " " + selectedReward);
                                    this.setState(() {});
                                  },
                                  value: selectedReward,
                                ),
                              ),
                              // Positioned(
                              //   left: 50,
                              //   top: 3,
                              //   child: Container(
                              //     color: Colors.white,
                              //     alignment: Alignment.topCenter,
                              //     child: Text(
                              //       "Reward",
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
                    ],
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
                            ),
                          ),
                        ),
              Theme(
                data: ThemeData(primaryColor: blackColor),
                child: TextFormField(
                  controller: customerNumCont,
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
                      // labelStyle: TextStyle(fontSize: 18),
                      hintStyle: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * .0175,
                          color: Colors.grey.withOpacity(.60),
                          // fontFamily: 'babas'
                          ),
                      // hintText: "Enter Email"
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
                        children: [
                          CircularProgressIndicator(),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: SizeConfig.blockSizeHorizontal*20,
                              padding: EdgeInsets.all(8),
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
                                  "Close",
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
                              if (customerNumCont.text.isEmpty) {
                                ShowMessage.inSnackBar(_scaffoldKey,
                                    "Please enter customer number", true);
                                return;
                              }
                              if (selectedRewardId == null) {}
                              redeemReward(true, selectedRewardId,
                                  customerNumCont.text.trim());
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
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
                                "REDEEM REWARD",
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
