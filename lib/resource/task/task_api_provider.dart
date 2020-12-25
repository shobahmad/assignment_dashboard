import 'dart:convert';
import 'package:assignment_dashboard/model/task_detail_response_model.dart';
import 'package:assignment_dashboard/model/task_list_response_model.dart';
import 'package:http/http.dart' show Client, Response;
import 'dart:math';

import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/pic_model.dart';
import 'package:assignment_dashboard/model/task_model.dart';
import 'package:assignment_dashboard/const/status.dart';

import '../../app.dart';

class TaskApiProvider {
  Client client = Client();
  final _baseUrl = "http://202.83.121.90:3000";

  Future<TaskListResponseModel> getTaskListByStatus(String month, String userId, String divisionId, String status) async {
    Map data = {
      'request': {
        'month': month,
        'user_id': userId,
        'division_id': divisionId,
        'status': status
      }
    };
    var body = json.encode(data);

    try {
      final response = await client
          .post("$_baseUrl/dashboardtm/tasks/status",
          headers: {"Content-Type": "application/json"}, body: body)
          .catchError((error, stackTrace) {
        throw error;
      });
      if (App.debugHttp) App.alice.onHttpResponse(response);

      if (response == null) {
        return TaskListResponseModel.error('Unexpected for empty result, please try again later');
      }

      if (response.statusCode == 200) {
        return TaskListResponseModel.jsonNoStatus(json.decode(response.body), Status.values[int.parse(status)]);
      }

      return TaskListResponseModel.error(json.decode(response.body)['data']);
    } catch(e, stacktrace) {
      return TaskListResponseModel.error('Error occurred while Communication with Server.\n${stacktrace.toString()}');
    }
  }

  Future<TaskListResponseModel> getTaskListByUser(String month, String userId) async {
    Map data = {
      'request': {
        'month': month,
        'user_id': userId
      }
    };
    var body = json.encode(data);

    try {
      final response = await client
          .post("$_baseUrl/dashboardtm/tasks/user",
          headers: {"Content-Type": "application/json"}, body: body)
          .catchError((error, stackTrace) {
        throw error;
      });
      if (App.debugHttp) App.alice.onHttpResponse(response);

      if (response == null) {
        return TaskListResponseModel.error('Unexpected for empty result, please try again later');
      }

      if (response.statusCode == 200) {
        return TaskListResponseModel.json(json.decode(response.body));
      }

      return TaskListResponseModel.error(json.decode(response.body)['data']);
    } catch(e, stacktrace) {
      return TaskListResponseModel.error('Error occurred while Communication with Server.\n${stacktrace.toString()}');
    }
  }
  Future<TaskListResponseModel> getTaskListByKeywords(String keyword, String userId) async {
    Map data = {
      'request': {
        'keyword': keyword,
        'user_id': userId
      }
    };
    var body = json.encode(data);

    try {
      final response = await client
          .post("$_baseUrl/dashboardtm/tasks/keyword",
          headers: {"Content-Type": "application/json"}, body: body)
          .catchError((error, stackTrace) {
        throw error;
      });
      if (App.debugHttp) App.alice.onHttpResponse(response);

      if (response == null) {
        return TaskListResponseModel.error('Unexpected for empty result, please try again later');
      }

      if (response.statusCode == 200) {
        return TaskListResponseModel.json(json.decode(response.body));
      }

      return TaskListResponseModel.error(json.decode(response.body)['data']);
    } catch(e, stacktrace) {
      return TaskListResponseModel.error('Error occurred while Communication with Server.\n${stacktrace.toString()}');
    }
  }

  Future<TaskDetailResponseModel> getTaskDetail(int taskId, String userId) async {
    Map data = {
      'request': {
        'task_id': taskId.toString()
      }
    };
    var body = json.encode(data);

    try {
      final response = await client
          .post("$_baseUrl/dashboardtm/tasks/id",
          headers: {"Content-Type": "application/json"}, body: body)
          .catchError((error, stackTrace) {
        throw error;
      });
      if (App.debugHttp) App.alice.onHttpResponse(response);

      if (response == null) {
        return TaskDetailResponseModel.error('Unexpected for empty result, please try again later');
      }

      if (response.statusCode == 200) {
        return TaskDetailResponseModel.json(json.decode(response.body), userId);
      }

      return TaskDetailResponseModel.error(json.decode(response.body)['data']);
    } catch(e, stacktrace) {
      return TaskDetailResponseModel.error('Error occurred while Communication with Server.\n${stacktrace.toString()}');
    }
  }
  Future<TaskDetailResponseModel> updateTaskDetail(int taskId, String userId, String progress, String notes) async {
    Map data = {
      'request': {
        'task_id': taskId.toString(),
        'user_id': userId,
        'progress': progress,
        'description': notes
      }
    };
    var body = json.encode(data);

    try {
      final response = await client
          .post("$_baseUrl/dashboardtm/tasks/saveprogress",
          headers: {"Content-Type": "application/json"}, body: body)
          .catchError((error, stackTrace) {
        throw error;
      });
      if (App.debugHttp) App.alice.onHttpResponse(response);

      if (response == null) {
        return TaskDetailResponseModel.error('Unexpected for empty result, please try again later');
      }

      if (response.statusCode == 200) {
        return TaskDetailResponseModel.json(json.decode(response.body), userId);
      }

      return TaskDetailResponseModel.error(json.decode(response.body)['data']);
    } catch(e, stacktrace) {
      return TaskDetailResponseModel.error('Error occurred while Communication with Server.\n${stacktrace.toString()}');
    }
  }



}