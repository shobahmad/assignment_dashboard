
import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/model/task_model.dart';
import 'package:flutter/widgets.dart';

class TaskListStream {
    TaskListState state;
    List<TaskModel> taskList;

    TaskListStream({Key key, this.state, this.taskList});
}

enum TaskListState {
    empty,
    loading,
    success,
    failed
}