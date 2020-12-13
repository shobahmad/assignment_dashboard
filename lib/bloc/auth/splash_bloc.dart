import 'dart:async';

import 'package:assignment_dashboard/bloc/auth/splash_state.dart';
import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/resource/repository.dart';


class SplashBloc {
  final _loginStateFetcher = StreamController<SplashState>();
  final _repository = Repository();

  Stream<SplashState> get state => _loginStateFetcher.stream;

  getSplashState() async {
    _loginStateFetcher.sink.add(SplashState.loading);
    Future.delayed(const Duration(seconds: 2), () async {
      AccountModel account = _repository.getAccount();

      if (account != null) {
        _loginStateFetcher.sink.add(SplashState.authorized);
        return;
      }

      _loginStateFetcher.sink.add(SplashState.unauthorized);
    });

  }

  dispose() {
    _loginStateFetcher.close();
  }
}

final bloc = SplashBloc();