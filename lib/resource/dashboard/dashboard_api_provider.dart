import 'dart:io';

import 'package:assignment_dashboard/const/status.dart';
import 'package:assignment_dashboard/model/recent_task_response_model.dart';
import 'package:assignment_dashboard/model/task_summary_response_model.dart';
import 'package:http/http.dart' show Client, Response;

import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/recent_task_model.dart';
import 'package:assignment_dashboard/model/task_dashboard_model.dart';

import '../../app.dart';
import 'dart:convert';

class DashboardApiProvider {
  Client client = Client();
  final _baseUrl = "http://202.83.121.90:3000";

  Future<RecentTaskResponseModel> getRecentTask(DateTime dateTime, String userId, bool allTask) async {
    Map data = {
      'request': {
        'type': allTask ? '1' : '0',
        'user_id': userId
      }
    };
    var body = json.encode(data);

    final response = await client
        .post("$_baseUrl/dashboardtm/recentupdates",
        headers: {"Content-Type": "application/json"}, body: body)
        .catchError((error, stackTrace) {
      return RecentTaskResponseModel.error(
          'Error occurred while Communication with Server. ${error.toString()}\n${stackTrace.toString()}');
    });
    App.alice.onHttpResponse(response);

    if (response == null) {
      return RecentTaskResponseModel.error('Unexpected for empty result, please try again later');
    }

    if (response.statusCode == 200) {
      return RecentTaskResponseModel.json(json.decode(response.body));
    }

    return RecentTaskResponseModel.error(json.decode(response.body)['data']);
  }

  Future<TaskDashboardModel> getTaskSummary(DateTime dateTime, String userId, String divisionId) async {
    Map data = {
      'request': {
        'month': dateTime.month,
        'user_id': userId,
        'division_id': divisionId
      }
    };
    var body = json.encode(data);

    final response = await client
        .post("$_baseUrl/dashboardtm/tasks",
            headers: {"Content-Type": "application/json"}, body: body)
        .catchError((error, stackTrace) {
      return TaskDashboardModel.error(
          'Error occurred while Communication with Server. ${error.toString()}\n${stackTrace.toString()}');
    });
    App.alice.onHttpResponse(response);

    if (response == null) {
      return TaskDashboardModel.error(
          'Unexpected for empty result, please try again later');
    }

    var decodedData = json.decode(response.body)['data'];
    if (decodedData is String) {
      return TaskDashboardModel.error(decodedData);
    }

    double qtyBehindSchedule = 0;
    double qtyOnProgress = 0;
    double qtyDone = 0;

    if (response.statusCode != 200) {
      return TaskDashboardModel.error("Unexpected (" +
          response.statusCode.toString() +
          ") for empty result, please try again later");
    }

    for (var i = 0; i < decodedData.length; i++) {
      TaskSummaryModel taskSummaryModel = TaskSummaryModel.json(decodedData[i]);
      if (taskSummaryModel.status == Status.behind_schedule) {
        qtyBehindSchedule += taskSummaryModel.jumlah;
      }
      if (taskSummaryModel.status == Status.on_progress) {
        qtyOnProgress += taskSummaryModel.jumlah;
      }
      if (taskSummaryModel.status == Status.finish) {
        qtyDone += taskSummaryModel.jumlah;
      }
    }

    return TaskDashboardModel(qtyBehindSchedule, qtyOnProgress, qtyDone);
  }

  Future<List<DivisionModel>> getDivisionList() async {
    return Future.delayed(const Duration(seconds: 1), () async {
      List<DivisionModel> result = [];
      int i = 0;
      while(i < 5) {
         i++;
         result.add(DivisionModel("00"+ i.toString(), "Division" + i.toString()));
      }
      return result;
    });
  }



}