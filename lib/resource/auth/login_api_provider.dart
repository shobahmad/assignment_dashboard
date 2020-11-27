import 'dart:convert';
import 'package:assignment_dashboard/model/login_model.dart';
import 'package:http/http.dart' show Client;

import '../../app.dart';

class LoginApiProvider {
//  Alice alice = Alice();
  Client client = Client();
  final _baseUrl = "https://app.wikufest.org/api";


  Future<LoginModel> postLogin(String username, String password) async {
    Map data = {
      'email': username,
      'password': password
    };
    var body = json.encode(data);

    final response = await client.post("$_baseUrl/user/login",
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