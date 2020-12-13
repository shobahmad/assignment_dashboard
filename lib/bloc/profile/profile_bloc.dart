import 'dart:async';

import 'package:assignment_dashboard/bloc/profile/profile_state.dart';
import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/resource/repository.dart';


class ProfileBloc {
  final _profileStateFetcher = StreamController<ProfileStream>();
  final _repository = Repository();
  Stream<ProfileStream> get state => _profileStateFetcher.stream;

  getProfileState() async {
    _profileStateFetcher.sink.add(ProfileStream(state: ProfileState.loading));

    AccountModel accountModel = _repository.getAccount();

    if (accountModel == null) {
      _profileStateFetcher.sink.add(ProfileStream(state: ProfileState.empty));
      return;
    }

    _profileStateFetcher.sink.add(ProfileStream(
        state: ProfileState.success,
        accountModel: accountModel));
  }

  dispose() {
    _profileStateFetcher.close();
  }
}

final bloc = ProfileBloc();