class TaskSummaryModel {
  double qtyBehindSchedule;
  double qtyOnProgress;
  double qtyDone;

  TaskSummaryModel(this.qtyBehindSchedule, this.qtyOnProgress, this.qtyDone);

  bool isEmpty() {
    return this.qtyBehindSchedule == 0 && this.qtyOnProgress == 0 && this.qtyDone == 0;
  }
}