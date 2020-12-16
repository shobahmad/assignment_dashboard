
import 'package:assignment_dashboard/model/recent_task_model.dart';
import 'package:assignment_dashboard/model/task_detail_model.dart';
import 'package:assignment_dashboard/model/task_detail_response_model.dart';
import 'package:flutter/widgets.dart';

class TaskDetailStream {
    TaskDetailState state;
    TaskDetailModel taskDetail;
    bool allowUpdate;
    String errorMessage;

    TaskDetailStream({Key key, this.state, this.taskDetail, this.errorMessage, this.allowUpdate});
}

enum TaskDetailState {
    loading,
    success,
    error
}