class TaskDashboardModel {
  double qtyBehindSchedule;
  double qtyOnProgress;
  double qtyDone;
  String errorMessage;

  TaskDashboardModel(this.qtyBehindSchedule, this.qtyOnProgress, this.qtyDone);
  TaskDashboardModel.error(this.errorMessage);

  bool isError() {
    return this.errorMessage != null;
  }

  bool isEmpty() {
    return this.qtyBehindSchedule == 0 && this.qtyOnProgress == 0 && this.qtyDone == 0;
  }
}