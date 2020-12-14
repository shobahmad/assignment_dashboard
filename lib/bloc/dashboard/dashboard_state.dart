
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/recent_task_response_model.dart';
import 'package:assignment_dashboard/model/task_dashboard_model.dart';
import 'package:flutter/widgets.dart';

class DashboardStream {
    DashboardState state;
    DateTime selectedDate;
    RecentTaskResponseModel recentTaskModel;
    TaskDashboardModel taskDashboardModel;
    List<DivisionModel> listDivisionModel;

    DashboardStream({Key key, this.state, this.selectedDate, this.recentTaskModel, this.taskDashboardModel, this.listDivisionModel});
}

enum DashboardState {
    empty,
    loading,
    success,
    failed
}