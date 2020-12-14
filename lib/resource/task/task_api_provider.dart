import 'dart:convert';
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

    final response = await client
        .post("$_baseUrl/dashboardtm/tasks/status",
        headers: {"Content-Type": "application/json"}, body: body)
        .catchError((error, stackTrace) {
      return TaskListResponseModel.error(
          'Error occurred while Communication with Server. ${error.toString()}\n${stackTrace.toString()}');
    });
    App.alice.onHttpResponse(response);

    if (response == null) {
      return TaskListResponseModel.error('Unexpected for empty result, please try again later');
    }

    if (response.statusCode == 200) {
      return TaskListResponseModel.json(json.decode(response.body));
    }

    return TaskListResponseModel.error(json.decode(response.body)['data']);
  }

  Future<List<TaskModel>> getTaskList() async {
    return Future.delayed(const Duration(seconds: 1), () async {
      List<TaskModel> taskList = [];
      var i = 1;
      var random = new Random();
      while(taskList.length < random.nextInt(25).toDouble()) {
        var dateNow   = DateTime.now();
        var dateStart = dateNow.add(Duration(days: random.nextInt(30)));
        var dateEnd   = dateStart.add(Duration(days: random.nextInt(30)));

        var status = Status.values[random.nextInt(3)];

        taskList.add(TaskModel(
            i,
            'Lorem ipsum dolor sit amet ' + i.toString(),
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit ' + i.toString(),
            dateStart,
            dateEnd,
            dateEnd,
            'Tech',
            'Frodo Bagins',
            random.nextInt(100)));
        i++;
      }
      return taskList;
    });
  }
}