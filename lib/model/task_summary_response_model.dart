import 'package:assignment_dashboard/const/status.dart';

class TaskSummaryResponseModel {
  int status;
  String errorMessage;
  List<TaskSummaryModel> listTaskSummary;

  TaskSummaryResponseModel.json(Map<String, dynamic> m) {
    status = m['status'];

    var error = m['data'] is String;
    errorMessage = error ? m['data'] : null;
    listTaskSummary = [];
    if (error) {
      return;
    }

    for (var i=0; i < m['data'].length; i++) {
      listTaskSummary.add(TaskSummaryModel.json(m['data'][i]));
    }
  }

}

class TaskSummaryModel {
  Status status;
  int jumlah;

  TaskSummaryModel(this.status, this.jumlah);
  TaskSummaryModel.json(Map<String, dynamic> m) {
    status = Status.values[m['status']];
    jumlah = m['jumlah'];
  }

  toJSONEncodable() {
    Map<String, dynamic> m = new Map();
    m['status'] = status.value;
    m['jumlah'] = jumlah;
    return m;
  }
}