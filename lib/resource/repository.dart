import 'package:assignment_dashboard/const/storage.dart';
import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/model/login_model.dart';
import 'package:localstorage/localstorage.dart';

import 'auth/login_api_provider.dart';


class Repository {
  final LocalStorage _storage = new LocalStorage(TableKey.account.value);
  final loginApiProvider = LoginApiProvider();

  saveToken(String token) => _storage.setItem(FieldKey.token.value, token);
  String getToken() => _storage.getItem(FieldKey.token.value);

  Future<LoginModel> postLogin(String username, String password) => loginApiProvider.postLogin(username, password);

  Future saveAccount(AccountModel accountModel) => _storage.setItem(FieldKey.account.value, accountModel.toJSONEncodable());
  AccountModel getAccount() {
    var accountStorage = _storage.getItem(FieldKey.account.value);
    return accountStorage == null ? null : AccountModel.storage(accountStorage);
  }

  dispose() {
    _storage.dispose();
  }
}