import 'package:assignment_dashboard/const/status.dart';
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/pic_model.dart';
import 'package:assignment_dashboard/util/date_util.dart';
import 'package:intl/intl.dart';

class TaskModel {
  int taskId;
  String taskName;
  String taskDescription;
  DateTime dateStart;
  DateTime dateTarget;
  DateTime dateFinish;
  String division;
  String pic;
  int progress;
  Status status;

  TaskModel(this.taskId, this.taskName, this.taskDescription, this.dateStart, this.dateTarget, this.dateFinish, this.division, this.pic, this.progress, this.status);

  TaskModel.json(Map<String, dynamic> m) {
    taskId = m['task_id'];
    taskName = m['task_name'];
    taskDescription = m['task_description'];
    dateStart = DateUtil.parseFromServer(m['start_date']);
    dateTarget = DateUtil.parseFromServer(m['target_date']);
    dateFinish = DateUtil.parseFromServer(m['finish_date']);
    division = m['division_desc'];
    pic = m['pic'];
    progress = m['progress'];
    status = Status.values[m['status']];
  }

}