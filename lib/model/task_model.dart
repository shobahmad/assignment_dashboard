import 'package:assignment_dashboard/const/status.dart';
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/pic_model.dart';

class TaskModel {
  int id;
  String title;
  DateTime dateStart;
  DateTime dateEnd;
  DivisionModel division;
  PicModel pic;
  double progress;
  Status status;

  TaskModel(this.id, this.title, this.dateStart, this.dateEnd, this.division, this.pic, this.progress, this.status);


}