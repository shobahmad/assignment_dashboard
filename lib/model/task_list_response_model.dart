import 'package:assignment_dashboard/const/status.dart';
import 'package:assignment_dashboard/model/task_model.dart';

class TaskListResponseModel {
  String errorMessage;
  List<TaskModel> listTask;

  TaskListResponseModel.error(this.errorMessage);

  TaskListResponseModel.json(Map<String, dynamic> m) {
    var error = m['data'] is String;
    errorMessage = error ? m['data'] : null;
    listTask = [];
    if (error) {
      return;
    }

    for (var i=0; i < m['data'].length; i++) {
      listTask.add(TaskModel.json(m['data'][i]));
    }
  }
}