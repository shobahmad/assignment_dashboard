import 'dart:async';

import 'package:assignment_dashboard/bloc/task/tasklist_state.dart';
import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/model/task_list_response_model.dart';
import 'package:assignment_dashboard/resource/repository.dart';


class SearchTaskBloc {
  final _tasklistStateFetcher = StreamController<TaskListStream>();
  final _repository = Repository();
  Stream<TaskListStream> get state => _tasklistStateFetcher.stream;

  getTaskListState(String keyword) async {
    _tasklistStateFetcher.sink.add(TaskListStream(state: TaskListState.loading));
    AccountModel accountModel = await _repository.getAccount();

    TaskListResponseModel taskList = await _repository.getTaskByKeywords(keyword, accountModel.userId);

    if (taskList == null || taskList.listTask.isEmpty) {
      _tasklistStateFetcher.sink.add(TaskListStream(state: TaskListState.empty));
      return;
    }

    if (taskList.errorMessage != null) {
      _tasklistStateFetcher.sink.add(TaskListStream(state: TaskListState.failed, errorMessage: taskList.errorMessage));
      return;
    }

    _tasklistStateFetcher.sink.add(TaskListStream(
        state: TaskListState.success,
        taskList: taskList.listTask));
  }

  dispose() {
    _tasklistStateFetcher.close();
  }
}

final bloc = SearchTaskBloc();