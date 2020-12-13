import 'dart:convert';
import 'package:assignment_dashboard/model/login_model.dart';
import 'package:http/http.dart' show Client;

import '../../app.dart';
import 'package:crypto/crypto.dart';

class LoginApiProvider {
  Client client = Client();
  final _baseUrl = "http://202.83.121.90:3000";


  Future<LoginModel> postLogin(String username, String password) async {
    Map data = {
      'request' : {
        'username': username,
        'password': md5.convert(utf8.encode(password)).toString(),
        'fcm_token': 'xxx'
      }
    };
    var body = json.encode(data);

    final response = await client.post("$_baseUrl/dashboardtm/auth",
        headers: {"Content-Type": "application/json"}, body: body);

    App.alice.onHttpResponse(response);

    if (response == null) {
      return LoginModel('Unexpected for empty result, please try again later');
    }

    if (response.statusCode == 200) {
      return LoginModel.fromJson(json.decode(response.body));
    }

    LoginModel responseBody = LoginModel.fromJson(json.decode(response.body));
    if (responseBody.message != null) {
      return responseBody;
    }

    return LoginModel(response.statusCode.toString() + ':Unexpected result, please try again later');
  }
}