
import 'package:assignment_dashboard/model/recent_task_model.dart';
import 'package:flutter/widgets.dart';

class RecentTaskStream {
    RecentTaskState state;
    List<RecentTaskModel> taskList;
    String errorMessage;

    RecentTaskStream({Key key, this.state, this.taskList, this.errorMessage});
}

enum RecentTaskState {
    empty,
    loading,
    success,
    failed
}