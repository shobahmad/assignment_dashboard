
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/task_model.dart';
import 'package:flutter/widgets.dart';

class TaskListStream {
    TaskListState state;
    List<TaskModel> taskList;
    String errorMessage;

    DateTime selectedDate;
    DivisionModel selectedDivisionModel;
    List<DivisionModel> listDivisionModel;

    TaskListStream({Key key, this.state, this.taskList, this.errorMessage, this.selectedDate, this.selectedDivisionModel, this.listDivisionModel});
}

enum TaskListState {
    empty,
    loading,
    success,
    failed
}