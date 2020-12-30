import 'dart:async';

import 'package:assignment_dashboard/bloc/task/task_progress_state.dart';
import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/model/task_detail_response_model.dart';
import 'package:assignment_dashboard/resource/repository.dart';


class TaskProgressBloc {
  final _taskProgressStateFetcher = StreamController<TaskProgressStream>();
  final _repository = Repository();
  Stream<TaskProgressStream> get state => _taskProgressStateFetcher.stream;

  start() {
    _taskProgressStateFetcher.sink.add(TaskProgressStream(state: TaskProgressState.empty));
  }

  postUpdate(int taskId, String progress, String note) async {
    _taskProgressStateFetcher.sink.add(TaskProgressStream(state: TaskProgressState.loading));

    AccountModel accountModel = await _repository.getAccount();
    TaskDetailResponseModel taskDetail = await _repository.updateTaskDetail(taskId, accountModel.userId, progress, note);

    if (taskDetail.message == 'error') {
      _taskProgressStateFetcher.sink.add(TaskProgressStream(state: TaskProgressState.error, errorMessage: taskDetail.errorMessage));
      return;
    }

    _taskProgressStateFetcher.sink.add(TaskProgressStream(state: TaskProgressState.success, errorMessage: ''));

  }
  postDelete(int taskId, String progress) async {
    _taskProgressStateFetcher.sink.add(TaskProgressStream(state: TaskProgressState.loading));

    AccountModel accountModel = await _repository.getAccount();
    TaskDetailResponseModel taskDetail = await _repository.deleteTaskDetail(taskId, accountModel.userId, progress);

    if (taskDetail.message == 'error') {
      _taskProgressStateFetcher.sink.add(TaskProgressStream(state: TaskProgressState.error, errorMessage: taskDetail.errorMessage));
      return;
    }

    _taskProgressStateFetcher.sink.add(TaskProgressStream(state: TaskProgressState.success, errorMessage: ''));

  }

  dispose() {
    _taskProgressStateFetcher.close();
  }
}

final bloc = TaskProgressBloc();