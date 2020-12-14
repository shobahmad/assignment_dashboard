import 'dart:async';

import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/task_dashboard_model.dart';
import 'package:assignment_dashboard/resource/repository.dart';

import 'dashboard_state.dart';

class DashboardBloc {
  final _dashboardStateFetcher = StreamController<DashboardStream>();
  final _repository = Repository();
  Stream<DashboardStream> get state => _dashboardStateFetcher.stream;

  getDashboardState(DateTime time, DivisionModel divisionModel) async {
    _dashboardStateFetcher.sink.add(DashboardStream(state: DashboardState.loading));

    AccountModel accountModel = _repository.getAccount();
    divisionModel = divisionModel == null ? accountModel.divisions.first : divisionModel;
    TaskDashboardModel taskDashboard = await _repository.getTaskSummary(time, accountModel.userId, divisionModel.divisionId);

    if (taskDashboard.isError()) {
      _dashboardStateFetcher.sink.add(DashboardStream(state: DashboardState.failed, selectedDate: time, taskDashboardModel: taskDashboard));
      return;
    }

    if (taskDashboard.isEmpty()) {
      _dashboardStateFetcher.sink.add(DashboardStream(state: DashboardState.empty, selectedDate: time,));
      return;
    }


    List<DivisionModel> listDivisions = accountModel.divisions;
    List<DivisionModel> listSortedDivisions = listDivisions.toList();
    var found = false;
    for (var i = 0; i < listDivisions.length; i++) {
      if (divisionModel == null) {
        break;
      }

      if (divisionModel.divisionId == listDivisions[i].divisionId) {
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
        taskDashboardModel: taskDashboard,
        listDivisionModel: listSortedDivisions
    ));
  }

  dispose() {
    _dashboardStateFetcher.close();
  }
}

final bloc = DashboardBloc();