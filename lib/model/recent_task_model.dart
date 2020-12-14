import 'package:assignment_dashboard/util/date_util.dart';

class RecentTaskModel {
  DateTime datetime;
  String usedId;
  String description;

  RecentTaskModel(this.datetime, this.usedId, this.description);

  RecentTaskModel.json(Map<String, dynamic> m) {
    datetime = DateUtil.parseFromServer(m['datetime']);
    usedId = m['user_id'];
    description = m['description'];
  }
}