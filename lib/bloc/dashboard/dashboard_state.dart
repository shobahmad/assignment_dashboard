
import 'package:assignment_dashboard/model/recent_task_model.dart';
import 'package:assignment_dashboard/model/task_summary_model.dart';
import 'package:flutter/widgets.dart';

class DashboardStream {
    DashboardState state;
    DateTime selectedDate;
    RecentTaskModel recentTaskModel;
    TaskSummaryModel taskSummaryModel;

    DashboardStream({Key key, this.state, this.selectedDate, this.recentTaskModel, this.taskSummaryModel});
}

enum DashboardState {
    empty,
    loading,
    success,
    failed
}