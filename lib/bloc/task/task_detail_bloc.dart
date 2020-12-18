import 'dart:async';

import 'package:assignment_dashboard/bloc/task/recent_task_state.dart';
import 'package:assignment_dashboard/bloc/task/task_detail_state.dart';
import 'package:assignment_dashboard/bloc/task/tasklist_state.dart';
import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/recent_task_response_model.dart';
import 'package:assignment_dashboard/model/task_detail_response_model.dart';
import 'package:assignment_dashboard/model/task_list_response_model.dart';
import 'package:assignment_dashboard/resource/repository.dart';


class TaskDetailBloc {
  final _taskDetailStateFetcher = StreamController<TaskDetailStream>();
  final _repository = Repository();
  Stream<TaskDetailStream> get state => _taskDetailStateFetcher.stream;

  getTaskDetailState(int taskId) async {
    _taskDetailStateFetcher.sink.add(TaskDetailStream(state: TaskDetailState.loading));

    TaskDetailResponseModel taskDetail = await _repository.getTaskDetail(taskId);

    if (taskDetail.errorMessage != null) {
      _taskDetailStateFetcher.sink.add(TaskDetailStream(state: TaskDetailState.error, errorMessage: taskDetail.errorMessage));
      return;
    }

    AccountModel accountModel = await _repository.getAccount();
    List<String> pics = taskDetail.taskDetailModel.pic.split(",");
    _taskDetailStateFetcher.sink.add(TaskDetailStream(
        state: TaskDetailState.success,
        taskDetail: taskDetail.taskDetailModel,
        allowUpdate: pics.contains(accountModel.userId) && taskDetail.taskDetailModel.progressPercent < 100));
  }

  postUpdate(int taskId, String progress, String note) async {
    _taskDetailStateFetcher.sink.add(TaskDetailStream(state: TaskDetailState.loading));

    AccountModel accountModel = await _repository.getAccount();
    TaskDetailResponseModel taskDetail = await _repository.updateTaskDetail(taskId, accountModel.userId, progress, note);

    if (taskDetail.message == 'error') {
      _taskDetailStateFetcher.sink.add(TaskDetailStream(state: TaskDetailState.error, errorMessage: taskDetail.errorMessage));
      return;
    }

    getTaskDetailState(taskId);
  }

  dispose() {
    _taskDetailStateFetcher.close();
  }
}

final bloc = TaskDetailBloc();