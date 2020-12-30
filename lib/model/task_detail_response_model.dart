import 'package:assignment_dashboard/const/status.dart';
import 'package:assignment_dashboard/model/task_detail_model.dart';
import 'package:assignment_dashboard/model/task_model.dart';

class TaskDetailResponseModel {
  String errorMessage;
  String message;
  TaskDetailModel taskDetailModel;

  TaskDetailResponseModel.error(this.errorMessage);

  TaskDetailResponseModel.json(Map<String, dynamic> m, String userId) {
    message = m['message'];
    var error = message != 'success';
    errorMessage = error ? m['data'] : null;

    taskDetailModel = TaskDetailModel.json(m['data'][0], userId);
  }
}