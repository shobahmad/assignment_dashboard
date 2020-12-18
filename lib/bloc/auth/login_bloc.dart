import 'dart:async';

import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/model/login_response_model.dart';
import 'package:assignment_dashboard/resource/repository.dart';

import 'login_state.dart';


class LoginBloc {
  final _loginStateFetcher = StreamController<LoginStream>();

  final _repository = Repository();

  Stream<LoginStream> get state => _loginStateFetcher.stream;

  postLogin(var username, var password) async {
    _loginStateFetcher.sink.add(LoginStream(LoginState.loading, ''));
    LoginResponseModel loginModel = await _repository.postLogin(username.trim(), password, _repository.getToken());

    if (loginModel == null) {
      _loginStateFetcher.sink.add(LoginStream(LoginState.failed, 'Unfortunatelly, unexpected result'));
      return;
    }
    if (loginModel.errorMessage != null) {
      _loginStateFetcher.sink.add(LoginStream(LoginState.failed, loginModel.errorMessage));
      return;
    }

//    _repository.saveAccount(loginModel.data);
    _repository.saveAccount(loginModel.data);

    _loginStateFetcher.sink.add(LoginStream(LoginState.success, ''));
  }

  postChangePassword(String password, String newPassword) async {
    _loginStateFetcher.sink.add(LoginStream(LoginState.loading, ''));
    AccountModel accountModel = await _repository.getAccount();
    LoginResponseModel loginModel = await _repository.postChangePassword(accountModel.userId, password, newPassword);

    if (loginModel == null) {
      _loginStateFetcher.sink.add(LoginStream(LoginState.failed, 'Unfortunatelly, unexpected result'));
      return;
    }
    if (loginModel.message != 'success') {
      _loginStateFetcher.sink.add(LoginStream(LoginState.failed, loginModel.errorMessage));
      return;
    }

    _loginStateFetcher.sink.add(LoginStream(LoginState.success, ''));
  }

  dispose() {
    _loginStateFetcher.close();
  }
}

final bloc = LoginBloc();