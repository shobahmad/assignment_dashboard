import 'dart:convert';

import 'package:assignment_dashboard/const/storage.dart';
import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/login_response_model.dart';
import 'package:assignment_dashboard/model/recent_task_response_model.dart';
import 'package:assignment_dashboard/model/task_dashboard_model.dart';
import 'package:assignment_dashboard/model/task_detail_response_model.dart';
import 'package:assignment_dashboard/model/task_list_response_model.dart';
import 'package:assignment_dashboard/resource/task/task_api_provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth/login_api_provider.dart';
import 'dashboard/dashboard_api_provider.dart';


class Repository {
  final LocalStorage _storage = new LocalStorage(TableKey.account.value);
  final loginApiProvider = LoginApiProvider();
  final dashboardApiProvider = DashboardApiProvider();
  final taskApiProvider = TaskApiProvider();

  saveToken(String token) => _storage.setItem(FieldKey.token.value, token);
  String getToken() => _storage.getItem(FieldKey.token.value);

  Future<LoginResponseModel> postLogin(String username, String password, String token) => loginApiProvider.postLogin(username, password, token);
  Future<LoginResponseModel> postChangePassword(String userId, String password, String newPassword) => loginApiProvider.postChangePassword(userId, password, newPassword);
//

  Future<AccountModel> getAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String accountStorage = prefs.get(FieldKey.account.value);
    return accountStorage == null ? null : AccountModel.json(json.decode(accountStorage));
  }
  Future saveAccount(AccountModel accountModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String account = json.encode(accountModel.toJSONEncodable());
    prefs.setString(FieldKey.account.value, account);
  }
  Future clearAccount() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(FieldKey.account.value, null);
  } 
  

  Future<TaskDashboardModel> getTaskSummary(DateTime dateTime, String userId, String divisionId) => dashboardApiProvider.getTaskSummary(dateTime, userId, divisionId);
  Future<List<DivisionModel>> getDivisionList() => dashboardApiProvider.getDivisionList();
  Future<RecentTaskResponseModel> getRecentTask(String userId, bool allTask) => dashboardApiProvider.getRecentTask(userId, allTask);

  Future<TaskListResponseModel> getTaskList(String month, String userId, String divisionId, String status) => taskApiProvider.getTaskListByStatus(month, userId, divisionId, status);
  Future<TaskListResponseModel> getMyTask(String month, String userId) => taskApiProvider.getTaskListByUser(month, userId);
  Future<TaskListResponseModel> getTaskByKeywords(String keyword, String userId) => taskApiProvider.getTaskListByKeywords(keyword, userId);
  Future<TaskDetailResponseModel> getTaskDetail(int taskId, String userId) => taskApiProvider.getTaskDetail(taskId, userId);
  Future<TaskDetailResponseModel> updateTaskDetail(int taskId, String userId, String progress, String notes) => taskApiProvider.updateTaskDetail(taskId, userId, progress, notes);


  dispose() {
    _storage.dispose();
  }
}