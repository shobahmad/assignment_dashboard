import 'dart:math';

import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/pic_model.dart';
import 'package:assignment_dashboard/model/task_model.dart';
import 'package:assignment_dashboard/const/status.dart';

class TaskApiProvider {
  Future<List<TaskModel>> getTaskList() async {
    return Future.delayed(const Duration(seconds: 1), () async {
      List<TaskModel> taskList = [];
      var i = 1;
      var random = new Random();
      while(taskList.length < random.nextInt(25).toDouble()) {
        var dateNow   = DateTime.now();
        var dateStart = dateNow.add(Duration(days: random.nextInt(30)));
        var dateEnd   = dateStart.add(Duration(days: random.nextInt(30)));

        var division = DivisionModel(1, 'Tech');
        var pic = PicModel(1, 'Frodo Bagins');

        var status = Status.values[random.nextInt(3)];

        taskList.add(TaskModel(
            i,
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit ' + i.toString(),
            dateStart,
            dateEnd,
            division,
            pic,
            random.nextInt(100).toDouble(),
            status));
        i++;
      }
      return taskList;
    });
  }
}