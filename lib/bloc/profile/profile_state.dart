
import 'package:assignment_dashboard/model/account_model.dart';
import 'package:flutter/widgets.dart';

class ProfileStream {
    ProfileState state;
    AccountModel accountModel;

    ProfileStream({Key key, this.state, this.accountModel});
}

enum ProfileState {
    empty,
    loading,
    success,
    failed
}