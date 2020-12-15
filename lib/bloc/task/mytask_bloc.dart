import 'dart:async';

import 'package:assignment_dashboard/bloc/task/tasklist_state.dart';
import 'package:assignment_dashboard/model/account_model.dart';
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/task_list_response_model.dart';
import 'package:assignment_dashboard/resource/repository.dart';


class MyTaskBloc {
  final _tasklistStateFetcher = StreamController<TaskListStream>();
  final _repository = Repository();
  Stream<TaskListStream> get state => _tasklistStateFetcher.stream;

  getTaskListState(DateTime selectedDate, DivisionModel divisionModel) async {
    _tasklistStateFetcher.sink.add(TaskListStream(state: TaskListState.loading));
    AccountModel accountModel = _repository.getAccount();

    TaskListResponseModel taskList = await _repository.getMyTask(selectedDate.month.toString(), accountModel.userId, divisionModel == null ? accountModel.divisions.first.divisionId : divisionModel.divisionId);

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

    if (taskList.errorMessage != null) {
      _tasklistStateFetcher.sink.add(TaskListStream(
          state: TaskListState.failed,
          errorMessage: taskList.errorMessage,
          selectedDate: selectedDate,
          listDivisionModel: listSortedDivisions));
      return;
    }

    if (taskList == null || taskList.listTask.isEmpty) {
      _tasklistStateFetcher.sink.add(TaskListStream(
          state: TaskListState.empty,
          taskList: [],
          selectedDate: selectedDate,
          selectedDivisionModel: divisionModel == null
              ? accountModel.divisions.first
              : divisionModel,
          listDivisionModel: listSortedDivisions));
      return;
    }

    _tasklistStateFetcher.sink.add(TaskListStream(
        state: TaskListState.success,
        taskList: taskList.listTask,
        selectedDate: selectedDate,
        selectedDivisionModel: divisionModel == null
            ? accountModel.divisions.first
            : divisionModel,
        listDivisionModel: listSortedDivisions));
  }

  dispose() {
    _tasklistStateFetcher.close();
  }
}

final bloc = MyTaskBloc();