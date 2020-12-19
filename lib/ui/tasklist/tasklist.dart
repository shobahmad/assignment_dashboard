import 'package:assignment_dashboard/bloc/task/tasklist_bloc.dart';
import 'package:assignment_dashboard/bloc/task/tasklist_state.dart';
import 'package:assignment_dashboard/const/status.dart';
import 'package:assignment_dashboard/ui/common/list_item_task.dart';
import 'package:assignment_dashboard/ui/taskdetail/task_detail.dart';
import 'package:assignment_dashboard/util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TaskList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => TaskListWidgetState();

  final String divisionId;
  final int status;

  final DateTime selectedDate;
  final String divisionDescription;

  const TaskList({Key key,this.selectedDate, this.divisionId, this.status, this.divisionDescription});
}

class TaskListWidgetState extends State<TaskList> {
  TaskListBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = TaskListBloc();
    _getData();
  }
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('   Task List | ', style: TextStyle(fontSize: 20)),
                Text(Status.values[widget.status].description,
                    style: TextStyle(fontSize: 20, color: Colors.white70)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: TextField(
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                  textAlignVertical: TextAlignVertical.center,
                  enabled: false,
                  controller: TextEditingController(
                      text: DateUtil.formatToMMMMy(widget.selectedDate)),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.white70,
                        size: 14,
                      ),
                      border: InputBorder.none),
                )),
                Expanded(
                    child: TextField(
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                  textAlignVertical: TextAlignVertical.center,
                  enabled: false,
                  controller:
                      TextEditingController(text: widget.divisionDescription),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.group,
                        color: Colors.white70,
                        size: 14,
                      ),
                      border: InputBorder.none),
                )),
              ],
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: bloc.state,
        builder: (context, AsyncSnapshot<TaskListStream> snapshot) {
          if (snapshot.data.state == null ||
              snapshot.data.state == TaskListState.loading) {
            return Center(
                child: SpinKitThreeBounce(
              color: Colors.blue,
              size: 18.0,
            ));
          }
          if (snapshot.data.state == TaskListState.failed) {
            return RefreshIndicator(
              onRefresh: _getData,
              child: ListView(
                children: [
                  Center(
                    child: ListTile(
                      leading: Icon(Icons.pending_actions, size: 128,),
                      title: Text('\nUnfortunatelly, something went wrong!\n${snapshot.data.errorMessage}\n'),
                      subtitle: Text('Please try again later'),
                    ),
                  )
                ],
              ),
            );
          }

          return ListItemTask(
            listTask: snapshot.data.taskList,
            onItemClick: (value) {
              Future.delayed(
                const Duration(seconds: 0),
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TaskDetail(
                              taskId: value.taskId,
                              taskName: value.taskName,
                              taskStatus: value.status)));
                },
              );
            },
            onPullRefresh: (value) => _getData(),
          );
        },
      ),
    );
  }

  Future<void> _getData() async {
    bloc.getTaskListState(widget.selectedDate.month.toString(), widget.divisionId, widget.status.toString());
  }


}