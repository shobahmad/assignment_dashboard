import 'package:assignment_dashboard/const/status.dart';
import 'package:assignment_dashboard/model/recent_task_model.dart';

class RecentTaskResponseModel {
  int status;
  String errorMessage;
  List<RecentTaskModel> listRecentTask = [];

  RecentTaskResponseModel.error(this.errorMessage);

  RecentTaskResponseModel.json(Map<String, dynamic> m) {
    status = m['status'];

    var error = m['data'] is String;
    errorMessage = error ? m['data'] : null;
    listRecentTask = [];
    if (error) {
      return;
    }

    for (var i=0; i < m['data'].length; i++) {
      listRecentTask.add(RecentTaskModel.json(m['data'][i]));
    }
  }
}