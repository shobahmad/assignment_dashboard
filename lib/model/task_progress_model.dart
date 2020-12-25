import 'package:assignment_dashboard/util/date_util.dart';

class TaskProgressModel {
  int taskId;
  int progressPercent;
  String userId;
  DateTime datetime;
  String progressDescription;
  bool editable;


  TaskProgressModel(this.taskId, this.progressPercent, this.userId,
      this.datetime, this.progressDescription, this.editable);

  TaskProgressModel.json(Map<String, dynamic> m) {
    taskId = m['task_id'];
    progressPercent = m['progress_percent'];
    userId = m['user_id'];
    progressDescription = m['progress_description'];
    datetime = DateUtil.parseFromServer(m['datetime']);
  }

}