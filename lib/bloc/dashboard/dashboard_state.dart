
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/recent_task_model.dart';
import 'package:assignment_dashboard/model/task_summary_model.dart';
import 'package:flutter/widgets.dart';

class DashboardStream {
    DashboardState state;
    DateTime selectedDate;
    RecentTaskModel recentTaskModel;
    TaskSummaryModel taskSummaryModel;
    List<DivisionModel> listDivisionModel;

    DashboardStream({Key key, this.state, this.selectedDate, this.recentTaskModel, this.taskSummaryModel, this.listDivisionModel});
}

enum DashboardState {
    empty,
    loading,
    success,
    failed
}