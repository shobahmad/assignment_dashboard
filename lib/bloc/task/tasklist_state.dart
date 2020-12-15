
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/task_model.dart';
import 'package:flutter/widgets.dart';

class TaskListStream {
    TaskListState state;
    List<TaskModel> taskList;
    String errorMessage;

    DateTime selectedDate;

    TaskListStream({Key key, this.state, this.taskList, this.errorMessage, this.selectedDate});
}

enum TaskListState {
    empty,
    loading,
    success,
    failed
}