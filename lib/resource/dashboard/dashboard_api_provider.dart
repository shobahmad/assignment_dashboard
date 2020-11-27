import 'dart:math';

import 'package:assignment_dashboard/model/recent_task_model.dart';
import 'package:assignment_dashboard/model/task_summary_model.dart';

class DashboardApiProvider {
  Future<RecentTaskModel> getRecentTask(DateTime dateTime) async {
    return Future.delayed(const Duration(seconds: 1), () async {
      if (dateTime.month == 1) {
        return null;
      }
      return RecentTaskModel(123, '15:24', 'New task updated by Teguh');
    });
  }

  Future<TaskSummaryModel> getTaskSummary(DateTime dateTime) async {
    var random = new Random();
    return Future.delayed(const Duration(seconds: 1), () async {
      if (dateTime.month == 1) {
        return TaskSummaryModel(0,0,0);
      }
      return TaskSummaryModel(random.nextInt(100).toDouble(),
          random.nextInt(100).toDouble(), random.nextInt(100).toDouble());
    });
  }
}