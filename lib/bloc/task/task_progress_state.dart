
import 'package:assignment_dashboard/model/recent_task_model.dart';
import 'package:assignment_dashboard/model/task_detail_model.dart';
import 'package:assignment_dashboard/model/task_detail_response_model.dart';
import 'package:flutter/widgets.dart';

class TaskProgressStream {
    TaskProgressState state;
    String errorMessage;

    TaskProgressStream({Key key, this.state, this.errorMessage});
}

enum TaskProgressState {
    empty,
    loading,
    success,
    error
}