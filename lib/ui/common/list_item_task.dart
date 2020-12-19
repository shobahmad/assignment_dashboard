import 'package:assignment_dashboard/model/task_model.dart';
import 'package:assignment_dashboard/ui/tasklist/progress_chart.dart';
import 'package:assignment_dashboard/util/date_util.dart';
import 'package:flutter/material.dart';

class ListItemTask extends StatefulWidget {
  final ValueChanged<TaskModel> onItemClick;
  final ValueChanged<String> onPullRefresh;
  final List<TaskModel> listTask;

  ListItemTask({Key key, this.listTask, this.onItemClick, this.onPullRefresh}) : super(key: key);

  @override
  _ListItemTaskState createState() => _ListItemTaskState();
}

class _ListItemTaskState extends State<ListItemTask> {

  _ListItemTaskState();

  Future<void> _getData() async {
    widget.onPullRefresh.call('');
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _getData,
      child: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey,
          );
        },
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: ProgressChart(
                  percentage: widget.listTask[index].progress == null
                      ? 0.0
                      : widget.listTask[index].progress.toDouble()),
              title: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                                text: DateUtil.formatToyMMMd(widget.listTask[index].dateStart)),
                            enabled: false,
                            style: TextStyle(fontSize: 10),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Start Date'),
                          ),
                        ),
                        separator(),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                                text: DateUtil.formatToyMMMd(widget.listTask[index].dateTarget)),
                            enabled: false,
                            style: TextStyle(fontSize: 10),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Target Date'),
                          ),
                        ),
                        separator(),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                                text: DateUtil.formatToyMMMd(widget.listTask[index].dateFinish)),
                            enabled: false,
                            style: TextStyle(fontSize: 10),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Finish Date'),
                          ),
                        )
                      ],
                    ),
                    Text(widget.listTask[index].taskName,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8,),
                    Text(widget.listTask[index].taskDescription,
                        style: TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                                text:
                                widget.listTask[index].division),
                            enabled: false,
                            maxLines: 2,
                            style: TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Division'),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(
                                text: widget.listTask[index].pic),
                            enabled: false,
                            maxLines: 2,
                            style: TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person_pin),
                                border: InputBorder.none,
                                labelText: 'PIC'),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                widget.onItemClick.call(widget.listTask[index]);
              },
            ),
          );
        },
        itemCount: widget.listTask == null ? 0 : widget.listTask.length,
      )
    );
  }

  Widget separator() {
    return Row(
      children: [
        SizedBox(width: 4,),
        SizedBox(
          width: 1,
          height: 25,
          child: Container(
            decoration: BoxDecoration(color: Colors.grey),
          ),
        ),
        SizedBox(width: 8,)
      ],
    );
  }
}
