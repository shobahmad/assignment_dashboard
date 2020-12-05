import 'dart:async';

import 'package:assignment_dashboard/bloc/task/tasklist_state.dart';
import 'package:assignment_dashboard/model/task_model.dart';
import 'package:assignment_dashboard/resource/repository.dart';


class TaskListBloc {
  final _tasklistStateFetcher = StreamController<TaskListStream>();
  final _repository = Repository();
  Stream<TaskListStream> get state => _tasklistStateFetcher.stream;

  getTaskListState() async {
    _tasklistStateFetcher.sink.add(TaskListStream(state: TaskListState.loading));

    List<TaskModel> taskList = await _repository.getTaskList();

    if (taskList == null || taskList.isEmpty) {
      _tasklistStateFetcher.sink.add(TaskListStream(state: TaskListState.empty));
      return;
    }

    _tasklistStateFetcher.sink.add(TaskListStream(
        state: TaskListState.success,
        taskList: taskList));
  }

  dispose() {
    _tasklistStateFetcher.close();
  }
}

final bloc = TaskListBloc();