import 'dart:async';

import 'package:assignment_dashboard/model/recent_task_model.dart';
import 'package:assignment_dashboard/model/task_summary_model.dart';
import 'package:assignment_dashboard/resource/repository.dart';

import 'dashboard_state.dart';

class DashboardBloc {
  final _dashboardStateFetcher = StreamController<DashboardStream>();
  final _repository = Repository();
  Stream<DashboardStream> get state => _dashboardStateFetcher.stream;

  getDashboarddState(DateTime time) async {
    _dashboardStateFetcher.sink.add(DashboardStream(state: DashboardState.loading));

    TaskSummaryModel taskSummaryModel = await _repository.getTaskSummary(time);

    if (taskSummaryModel.isEmpty()) {
      _dashboardStateFetcher.sink.add(DashboardStream(state: DashboardState.empty, selectedDate: time,));
      return;
    }

    _dashboardStateFetcher.sink.add(DashboardStream(
        state: DashboardState.success,
        selectedDate: time,
        recentTaskModel: await _repository.getRecentTask(time),
        taskSummaryModel: taskSummaryModel));
  }

  dispose() {
    _dashboardStateFetcher.close();
  }
}

final bloc = DashboardBloc();