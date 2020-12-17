import 'dart:convert';
import 'package:assignment_dashboard/model/login_response_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' show Client, Response;

import '../../app.dart';
import 'package:crypto/crypto.dart';

class LoginApiProvider {
  Client client = Client();
  final _baseUrl = "http://202.83.121.90:3000";


  Future<LoginResponseModel> postLogin(String username, String password, String token) async {
    Map data = {
      'request' : {
        'username': username,
        'password': md5.convert(utf8.encode(password)).toString(),
        'fcm_token': token
      }
    };
    var body = json.encode(data);
    try {
      final response = await client
          .post("$_baseUrl/dashboardtm/auth",
              headers: {"Content-Type": "application/json"}, body: body)
          .catchError((error, stackTrace) {
        throw error;
      });
      if (App.debugHttp) App.alice.onHttpResponse(response);

      if (response == null) {
        return LoginResponseModel('Unexpected for empty result, please try again later');
      }

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(json.decode(response.body));
      }

      LoginResponseModel responseBody = LoginResponseModel.fromJson(json.decode(response.body));
      if (responseBody.message != null) {
        return responseBody;
      }

      return LoginResponseModel(response.statusCode.toString() + ':Unexpected result, please try again later');
    } catch(e, stacktrace) {
      return LoginResponseModel('Error occurred while Communication with Server.\n${stacktrace.toString()}');
    }

  }

  Future<LoginResponseModel> postChangePassword(String userId, String password, String newPassword) async {
    Map data = {
      'request' : {
        'user_id': userId,
        'password': md5.convert(utf8.encode(password)).toString(),
        'new_password': md5.convert(utf8.encode(newPassword)).toString()
      }
    };
    var body = json.encode(data);
    try {
      final response = await client
          .post("$_baseUrl/dashboardtm/changepassword",
              headers: {"Content-Type": "application/json"}, body: body)
          .catchError((error, stackTrace) {
        throw error;
      });

      if (App.debugHttp) App.alice.onHttpResponse(response);

      if (response == null) {
        return LoginResponseModel('Unexpected for empty result, please try again later');
      }

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(json.decode(response.body));
      }

      LoginResponseModel responseBody = LoginResponseModel.fromJson(json.decode(response.body));
      if (responseBody.message != null) {
        return responseBody;
      }

      return LoginResponseModel(response.statusCode.toString() + ':Unexpected result, please try again later');
    } catch(e, stacktrace) {
      return LoginResponseModel('Error occurred while Communication with Server.\n${stacktrace.toString()}');
    }

  }
}