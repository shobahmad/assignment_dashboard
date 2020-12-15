import 'package:assignment_dashboard/const/status.dart';
import 'package:assignment_dashboard/const/storage.dart';
import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/login_response_model.dart';
import 'package:assignment_dashboard/model/recent_task_model.dart';
import 'package:assignment_dashboard/model/recent_task_response_model.dart';
import 'package:assignment_dashboard/model/task_dashboard_model.dart';
import 'package:assignment_dashboard/model/task_list_response_model.dart';
import 'package:assignment_dashboard/model/task_model.dart';
import 'package:assignment_dashboard/resource/task/task_api_provider.dart';
import 'package:localstorage/localstorage.dart';

import 'auth/login_api_provider.dart';
import 'dashboard/dashboard_api_provider.dart';


class Repository {
  final LocalStorage _storage = new LocalStorage(TableKey.account.value);
  final loginApiProvider = LoginApiProvider();
  final dashboardApiProvider = DashboardApiProvider();
  final taskApiProvider = TaskApiProvider();

  saveToken(String token) => _storage.setItem(FieldKey.token.value, token);
  String getToken() => _storage.getItem(FieldKey.token.value);

  Future<LoginResponseModel> postLogin(String username, String password) => loginApiProvider.postLogin(username, password);
//
  Future saveAccount(AccountModel accountModel) => _storage.setItem(FieldKey.account.value, accountModel.toJSONEncodable());
  Future clearAccount() => _storage.setItem(FieldKey.account.value, null);
  AccountModel getAccount() {
    var accountStorage = _storage.getItem(FieldKey.account.value);
    return accountStorage == null ? null : AccountModel.json(accountStorage);
  }

  Future<RecentTaskResponseModel> getRecentTask(String userId, bool allTask) => dashboardApiProvider.getRecentTask(userId, allTask);
  Future<List<DivisionModel>> getDivisionList() => dashboardApiProvider.getDivisionList();
  Future<TaskDashboardModel> getTaskSummary(DateTime dateTime, String userId, String divisionId) => dashboardApiProvider.getTaskSummary(dateTime, userId, divisionId);
  Future<TaskListResponseModel> getTaskList(String month, String userId, String divisionId, String status) => taskApiProvider.getTaskListByStatus(month, userId, divisionId, status);
  Future<TaskListResponseModel> getMyTask(String month, String userId, String divisionId) => taskApiProvider.getTaskListByUser(month, userId, divisionId);
  Future<TaskListResponseModel> getTaskByKeywords(String userId, String keyword) => taskApiProvider.getTaskListByKeywords(userId, keyword);


  dispose() {
    _storage.dispose();
  }
}