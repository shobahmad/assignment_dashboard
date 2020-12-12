import 'package:assignment_dashboard/const/storage.dart';
import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/login_model.dart';
import 'package:assignment_dashboard/model/recent_task_model.dart';
import 'package:assignment_dashboard/model/task_model.dart';
import 'package:assignment_dashboard/model/task_summary_model.dart';
import 'package:assignment_dashboard/resource/profile/profile_api_provider.dart';
import 'package:assignment_dashboard/resource/task/task_api_provider.dart';
import 'package:localstorage/localstorage.dart';

import 'auth/login_api_provider.dart';
import 'dashboard/dashboard_api_provider.dart';


class Repository {
  final LocalStorage _storage = new LocalStorage(TableKey.account.value);
  final loginApiProvider = LoginApiProvider();
  final dashboardApiProvider = DashboardApiProvider();
  final profileApiProvider = ProfileApiProvider();
  final taskApiProvider = TaskApiProvider();

  saveToken(String token) => _storage.setItem(FieldKey.token.value, token);
  String getToken() => _storage.getItem(FieldKey.token.value);

  Future<LoginModel> postLogin(String username, String password) => loginApiProvider.postLogin(username, password);
//
//  Future saveAccount(AccountModel accountModel) => _storage.setItem(FieldKey.account.value, accountModel.toJSONEncodable());
//  AccountModel getAccount() {
//    var accountStorage = _storage.getItem(FieldKey.account.value);
//    return accountStorage == null ? null : AccountModel.storage(accountStorage);
//  }

  Future<RecentTaskModel> getRecentTask(DateTime dateTime) => dashboardApiProvider.getRecentTask(dateTime);
  Future<List<DivisionModel>> getDivisionList() => dashboardApiProvider.getDivisionList();
  Future<TaskSummaryModel> getTaskSummary(DateTime dateTime) => dashboardApiProvider.getTaskSummary(dateTime);
  Future<List<TaskModel>> getTaskList() => taskApiProvider.getTaskList();
  Future<AccountModel> getProfile() => profileApiProvider.getAccount();


  dispose() {
    _storage.dispose();
  }
}