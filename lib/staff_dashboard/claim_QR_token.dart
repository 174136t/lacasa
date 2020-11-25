import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/localization/app_localization.dart';
import 'package:lacasa/modals/rewards_model.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/modals/staff_active_offers.dart';
import 'package:lacasa/utils/colors.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/loader.dart';
import 'package:lacasa/utils/shared.dart';
import 'package:lacasa/utils/validator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ClaimQRToken extends StatefulWidget {
  @override
  _ClaimQRTokenState createState() => _ClaimQRTokenState();
}

class _ClaimQRTokenState extends State<ClaimQRToken> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isClaimed = false;
  String selectedOfferUID = '';
  String selectedOffer;
  String selectedReward;
  String selectedRewardID = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController amountCont = TextEditingController();
  StaffActiveOffers _activeOffers = StaffActiveOffers();
  RewardsModel rewardsModel = RewardsModel();
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
            // offersList.add(element.name);
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

  void getAvailableRewards(
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
      startTime();
    }
  }

  void claimOfferByQRToken() async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "uuid": LacasaUser.data.campaignUUID,
        "offer": selectedOfferUID,
        "token": scannedQRToken.split('=').last,
      };
      print(body);
      var response = await http.post("${Apis.staffValidateOfferQR}",
          headers: MyHeaders.header(), body: body);
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
        setState(() {
          ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
          isClaimed = true;
          // getAvailableRewards(true);
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
      //startTime();
    }
  }

  void creditPointsOnPurchaseByQRToken() async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "uuid": LacasaUser.data.campaignUUID,
        "purchase_amount": amountCont.text,
        "token": scannedQRToken.split("=").last,
      };
      print(body);
      var response = await http.post("${Apis.staffValidatePointsQR}",
          headers: MyHeaders.header(), body: body);
      var jsonResponse = json.decode(response.body);

      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
        setState(() {
          ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
          isClaimed = true;
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
      //startTime();
    }
  }

  void redeemRewardByQRToken() async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "uuid": LacasaUser.data.campaignUUID,
        "reward": selectedRewardID,
        "token": scannedQRToken.split("=").last,
      };
      print(body);
      var response = await http.post("${Apis.staffValidateRedeemRewardQR}",
          headers: MyHeaders.header(), body: body);
      var jsonResponse = json.decode(response.body);
      print('header= ${MyHeaders.header()}');
      print((response.body));
      print("code:${response.statusCode}");

      if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
        setState(() {
          ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
          isClaimed = true;
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
      //startTime();
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
    getAvailableOffers(true);
    getAvailableRewards(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: MyLoader(),
        color: Colors.transparent,
        child: Container(
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * .05,
                  right: MediaQuery.of(context).size.width * .05,
                  top: MediaQuery.of(context).size.height * .05,
                ),
                child: isClaimed
                    ? claimedThanks()
                    : Container(
                        child: claimQrScreenName == CLAIM_OFFER
                            ? claimOffer()
                            : claimQrScreenName == CREDIT_POINTS
                                ? creditPoints()
                                : redeemRewards(),
                      )),
          ),
        ),
      ),
    );
  }

  Widget claimOffer() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            getAvailableOffers(true);
          },
          child: Text(
            getTranslated(
              context,
              'claim_offer_for_this_customer',
            ),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Text(getTranslated(context, 'you_can_claim_the_offers')),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        Container(
          margin: EdgeInsets.only(left: width * 0.1),
          child: Text(
            'Select an offer',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.7)),
          ),
        ),
        _activeOffers.data == null
            ? Center(child: CircularProgressIndicator())
            : Container(
                margin:
                    EdgeInsets.symmetric(vertical: 10, horizontal: width * 0.1),
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                // width: width * 0.100,
                // height: height * 0.14,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(width: 1, color: blackColor)),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: SizedBox(),
                  items: _activeOffers.data.map((ActiveOffer offer) {
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              claimOfferByQRToken();
            },
            child: Container(
              alignment: Alignment.center,
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "Claim Offer",
                style: TextStyle(color: whiteColor, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget claimedThanks() {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Text(claimQrScreenName == CLAIM_OFFER
            ? getTranslated(
                    context, 'you_have_successfully_claimed_the_offer') ??
                ""
            : claimQrScreenName == CREDIT_POINTS
                ? 'You have successfully credited points to the customer'
                : 'You have successfully credited points to the customer'),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        Text(
          getTranslated(context, 'thank_you') ?? "",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget redeemRewards() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Redeem Rewards for Customer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Text("You can redeem the reward below"),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        Container(
          margin: EdgeInsets.only(left: width * 0.1),
          child: Text(
            'Reward',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.7)),
          ),
        ),
        rewardsModel.data == null
            ? CircularProgressIndicator()
            : Container(
                margin:
                    EdgeInsets.symmetric(vertical: 10, horizontal: width * 0.1),
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                // width: width * 0.100,
                // height: height * 0.14,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(width: 1, color: blackColor)),
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
                          selectedRewardID = reward.uuid;
                        });
                      },
                    );
                  }).toList(),
                  hint: Text("Reward"),
                  onChanged: (newVal) {
                    print(newVal);
                    selectedReward = newVal;
                    // selectedOfferUID = _activeOffers.data
                    print(selectedRewardID + " " + selectedReward);
                    this.setState(() {});
                  },
                  value: selectedReward,
                ),
              ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              if (selectedRewardID.isEmpty) {
                ShowMessage.inSnackBar(
                    _scaffoldKey, "Please select reward first", true);
              }
              redeemRewardByQRToken();
            },
            child: Container(
              alignment: Alignment.center,
              width: 140,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "Redeem Reward",
                style: TextStyle(color: whiteColor, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget creditPoints() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Credit Points for this customer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Text("You can credit points for this customer below"),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.08,
        ),
        Container(
          margin: EdgeInsets.only(left: width * 0.1),
          child: Text(
            'Enter Purchase Amount',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.7)),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: width * 0.1),
          child: TextFormField(
            cursorColor: blackColor,
            controller: amountCont,
            validator: FieldValidator.validateBlank,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              fillColor: Colors.white,
              isDense: true,
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: Colors.white)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: Colors.black)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide(color: Colors.white)),
              filled: true,
              // contentPadding: EdgeInsets.only(top:MediaQuery.of(context).size.height * .019,),
              // fillColor: whiteColor,

              hintStyle: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * .0175,
                  color: Colors.grey.withOpacity(.60),
                  fontFamily: 'babas'),
              hintText: "Purchase Amount",
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.attach_file_sharp),
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              if (amountCont.text.isEmpty) {
                ShowMessage.inSnackBar(
                    _scaffoldKey, "Purchase amount is required", true);
                return;
              }
              creditPointsOnPurchaseByQRToken();
            },
            child: Container(
              alignment: Alignment.center,
              width: 120,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "Credit Points",
                style: TextStyle(color: whiteColor, fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
