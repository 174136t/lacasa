import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lacasa/constants/apis.dart';
import 'package:lacasa/modals/singleton/user.dart';
import 'package:lacasa/modals/user.dart';
import 'package:lacasa/utils/constants/bearer_token.dart';
import 'package:lacasa/utils/shared.dart';

class ApiModal {
  Future getUserInfo(
    _scaffoldKey,
  ) async {
    bool isInternet = await checkInternet();
    if (!isInternet) {
      return {'status': false, 'message': "No internet Connection"};
    }
    try {
      var response = await http.get("${Apis.getCustomerDetails}",
          headers: MyHeaders.header());
      var jsonResponse = json.decode(response.body);
      print('response:\n');
      print((response.body));
      print("code:${response.statusCode}");
      if (response.statusCode == 200) {
        if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
          LacasaUser.data.user = User.fromJson(jsonResponse);
          ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
        } else {
          ShowMessage.showErrorSnackBar(
            _scaffoldKey,
            jsonResponse,
          );
        }
      } else {
        ShowMessage.inDialog('status code: ${response.statusCode} ', true);
      }
    } on SocketException {
      ShowMessage.inDialog('No Internet Connection', true);

      print('No Internet connection');
    } on HttpException catch (error) {
      print(error);
      ShowMessage.inDialog('Couldn\'t find the results', true);
      print("Couldn't find the post");
    } on FormatException catch (error) {
      print(error);
      ShowMessage.inDialog('Bad response format from server', true);
      print("Bad response format");
    } catch (value) {
      print(value);
    }
  }

  Future getStaffUserInfo(_scaffoldKey, String uuid) async {
    bool isInternet = await checkInternet();
    if (!isInternet) {
      return {'status': false, 'message': "No internet Connection"};
    }
    try {
      var response = await http.get("${Apis.staffUserInfo}?uuid=$uuid",
          headers: MyHeaders.header());
      var jsonResponse = json.decode(response.body);
      print('response:\n');
      print((response.body));
      print("code:${response.statusCode}");
      if (response.statusCode == 200) {
        if (jsonResponse['status_code'] == 200 && jsonResponse['result']) {
          LacasaUser.data.user = User.fromJson(jsonResponse);
          ShowMessage.showSuccessSnackBar(_scaffoldKey, jsonResponse);
        } else {
          ShowMessage.showErrorSnackBar(
            _scaffoldKey,
            jsonResponse,
          );
        }
      } else {
        ShowMessage.inDialog('status code: ${response.statusCode} ', true);
      }
    } on SocketException {
      ShowMessage.inDialog('No Internet Connection', true);

      print('No Internet connection');
    } on HttpException catch (error) {
      print(error);
      ShowMessage.inDialog('Couldn\'t find the results', true);
      print("Couldn't find the post");
    } on FormatException catch (error) {
      print(error);
      ShowMessage.inDialog('Bad response format from server', true);
      print("Bad response format");
    } catch (value) {
      print(value);
    }
  }

  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
    return false;
  }
}
