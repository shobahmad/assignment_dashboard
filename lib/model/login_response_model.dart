
import 'package:assignment_dashboard/model/account_model.dart';

class LoginResponseModel {
  int status;
  String message;
  String errorMessage;
  AccountModel data;

  LoginResponseModel(this.errorMessage);

  LoginResponseModel.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson['status'] != null) {
      status = parsedJson['status'];
    }
    if (parsedJson['message'] != null) {
      message = parsedJson['message'];
    }

    if (parsedJson['data'] is String) {
      errorMessage = parsedJson['data'];
      return;
    }

    data = AccountModel.json(parsedJson['data']);
  }



}