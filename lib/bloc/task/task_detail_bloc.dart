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
      _taskDetailStateFetcher.sink.add(TaskDetailStream(state: TaskDetailState.failed, errorMessage: taskDetail.errorMessage));
      return;
    }

    _taskDetailStateFetcher.sink.add(TaskDetailStream(
        state: TaskDetailState.success,
        taskDetail: taskDetail.taskDetailModel));
  }

  dispose() {
    _taskDetailStateFetcher.close();
  }
}

final bloc = TaskDetailBloc();