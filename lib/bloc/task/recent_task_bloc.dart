import 'dart:async';

import 'package:assignment_dashboard/bloc/task/recent_task_state.dart';
import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/model/recent_task_response_model.dart';
import 'package:assignment_dashboard/resource/repository.dart';


class RecentTaskBloc {
  final _recentTaskStateFetcher = StreamController<RecentTaskStream>();
  final _repository = Repository();
  Stream<RecentTaskStream> get state => _recentTaskStateFetcher.stream;

  getRecentTaskState() async {
    _recentTaskStateFetcher.sink.add(RecentTaskStream(state: RecentTaskState.loading));
    AccountModel accountModel = await _repository.getAccount();

    RecentTaskResponseModel taskList = await _repository.getRecentTask(accountModel.userId, true);

    if (taskList.errorMessage != null) {
      _recentTaskStateFetcher.sink.add(RecentTaskStream(state: RecentTaskState.failed, errorMessage: taskList.errorMessage));
      return;
    }

    if (taskList == null || taskList.listRecentTask.isEmpty) {
      _recentTaskStateFetcher.sink.add(RecentTaskStream(state: RecentTaskState.empty));
      return;
    }

    _recentTaskStateFetcher.sink.add(RecentTaskStream(
        state: RecentTaskState.success,
        taskList: taskList.listRecentTask));
  }

  dispose() {
    _recentTaskStateFetcher.close();
  }
}

final bloc = RecentTaskBloc();