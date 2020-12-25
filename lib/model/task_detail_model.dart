import 'package:assignment_dashboard/model/task_progress_model.dart';
import 'package:assignment_dashboard/util/date_util.dart';

class TaskDetailModel {
  int taskId;
  String taskName;
  String taskDescription;
  DateTime dateStart;
  DateTime dateTarget;
  DateTime dateFinish;
  String pic;
  String division;
  String category;
  List<TaskProgressModel> progress;
  int progressPercent = 0;

  TaskDetailModel(this.taskId, this.taskName, this.taskDescription, this.dateStart, this.dateTarget, this.dateFinish, this.pic, this.progress, this.division, this.category);

  TaskDetailModel.json(Map<String, dynamic> m, String userId) {
    taskId = m['task_id'];
    taskName = m['task_name'];
    taskDescription = m['task_description'];
    dateStart = DateUtil.parseFromServer(m['start_date']);
    dateTarget = DateUtil.parseFromServer(m['target_date']);
    dateFinish = DateUtil.parseFromServer(m['finish_date']);
    pic = m['pic'];
    division = m['division_desc'];
    category = m['category'];
    progress = [];

    for (var i=0; i < m['progress'].length; i++) {
      TaskProgressModel progressModel = TaskProgressModel.json(m['progress'][i]);

      progressModel.editable = progressModel.userId == userId;
      progress.add(progressModel);

      if (i == 0) {
        progressPercent = progressModel.progressPercent;
      }
    }

  }

}