import 'dart:async';

import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/task_summary_model.dart';
import 'package:assignment_dashboard/resource/repository.dart';

import 'dashboard_state.dart';

class DashboardBloc {
  final _dashboardStateFetcher = StreamController<DashboardStream>();
  final _repository = Repository();
  Stream<DashboardStream> get state => _dashboardStateFetcher.stream;

  getDashboarddState(DateTime time, DivisionModel divisionModel) async {
    _dashboardStateFetcher.sink.add(DashboardStream(state: DashboardState.loading));

    TaskSummaryModel taskSummaryModel = await _repository.getTaskSummary(time);

    if (taskSummaryModel.isEmpty()) {
      _dashboardStateFetcher.sink.add(DashboardStream(state: DashboardState.empty, selectedDate: time,));
      return;
    }


    List<DivisionModel> listDivisions = await _repository.getDivisionList();
    List<DivisionModel> listSortedDivisions = listDivisions.toList();
    var found = false;
    for (var i = 0; i < listDivisions.length; i++) {
      if (divisionModel == null) {
        break;
      }

      if (divisionModel.id == listDivisions[i].id) {
        listSortedDivisions.removeAt(i);
        found = true;
        break;
      }
    }
    if (found) {
      listSortedDivisions.insert(0, divisionModel);
    }

    _dashboardStateFetcher.sink.add(DashboardStream(
        state: DashboardState.success,
        selectedDate: time,
        recentTaskModel: await _repository.getRecentTask(time),
        taskSummaryModel: taskSummaryModel,
        listDivisionModel: listSortedDivisions
    ));
  }

  dispose() {
    _dashboardStateFetcher.close();
  }
}

final bloc = DashboardBloc();