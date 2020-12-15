import 'package:assignment_dashboard/const/status.dart';
import 'package:assignment_dashboard/model/task_detail_model.dart';
import 'package:assignment_dashboard/model/task_model.dart';

class TaskDetailResponseModel {
  String errorMessage;
  TaskDetailModel taskDetailModel;

  TaskDetailResponseModel.error(this.errorMessage);

  TaskDetailResponseModel.json(Map<String, dynamic> m) {
    var error = m['data'] is String;
    errorMessage = error ? m['data'] : null;

    taskDetailModel = TaskDetailModel.json(m['data'][0]);
  }
}