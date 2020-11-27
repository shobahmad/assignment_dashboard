
class LoginModel {
  String token;
  String message;

  LoginModel(this.message);

  LoginModel.fromJson(Map<String, dynamic> parsedJson) {
    token = parsedJson['token'];
    if (parsedJson['detail'] != null) {
      message = parsedJson['detail'];
      return;
    }
    if (parsedJson['email'] != null) {
      message = parsedJson['email'][0];
      return;
    }

    if (parsedJson['password'] != null) {
      message = parsedJson['password'][0];
      return;
    }

  }



}