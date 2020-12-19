import 'package:assignment_dashboard/bloc/task/mytask_bloc.dart';
import 'package:assignment_dashboard/bloc/task/tasklist_state.dart';
import 'package:assignment_dashboard/model/month_picker_param.dart';
import 'package:assignment_dashboard/ui/common/field_month_picker.dart';
import 'package:assignment_dashboard/ui/common/list_item_task.dart';
import 'package:assignment_dashboard/ui/taskdetail/task_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyTask extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => TaskListWidgetState();

  const MyTask();
}

class TaskListWidgetState extends State<MyTask> {
  MyTaskBloc bloc;
  DateTime selectedDate;
  @override
  void initState() {
    super.initState();
    bloc = MyTaskBloc();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
     return StreamBuilder(
       stream: bloc.state,
        builder: (context, AsyncSnapshot<TaskListStream> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Task List | ', style: TextStyle(fontSize: 20)),
                  Text('My Task',
                      style: TextStyle(fontSize: 20, color: Colors.white70)),
                ],
              ),
            ),
            body: getBody(snapshot),
          );
        });
  }

  Widget getBody(AsyncSnapshot<TaskListStream> snapshot) {
    if (snapshot.data.state == null ||
        snapshot.data.state == TaskListState.loading) {
      return Center(
          child: SpinKitThreeBounce(
            color: Colors.blue,
            size: 18.0,
          ));
    }

    if (snapshot.data.state == TaskListState.empty) {
      return RefreshIndicator(
        onRefresh: _getData,
        child: ListView(
          shrinkWrap: true,
          children: [
            parameter(snapshot),
            SizedBox(
              height: 24,
            ),
            Center(
              child: ListTile(
                  leading: Icon(Icons.pending_actions, size: 128,),
                  title: Text('\n\No data available')
              ),
            )
          ],
        ),
      );
    }

    if (snapshot.data.state == TaskListState.failed) {
      return RefreshIndicator(
          onRefresh: _getData,
          child: ListView(
            children: [
              parameter(snapshot),
              SizedBox(
                height: 24,
              ),
              Center(
                child: ListTile(
                  leading: Icon(
                    Icons.pending_actions,
                    size: 128,
                  ),
                  title: Text(
                      '\nUnfortunatelly, something went wrong!\n${snapshot.data.errorMessage}\n'),
                  subtitle: Text('Please try again with another parameters'),
                ),
              )
            ],
          ));
    }

    return Column(
      children: [
        parameter(snapshot),
        SizedBox(
          height: 2,
        ),
        Expanded(
          child:
          ListItemTask(
            listTask: snapshot.data.taskList,
            onItemClick: (value) {
              Future.delayed(const Duration(seconds: 0), () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaskDetail(
                          taskId: value.taskId,
                          taskName: value.taskName,
                          taskStatus: value.status,
                        )));
              });
            },
            onPullRefresh:(value) {
              _getData();
            },
          ),
        )
      ],
    );
  }

  Future<void> _getData() async {
    bloc.getTaskListState(selectedDate == null ? DateTime.now() : selectedDate);
  }

  Widget parameter(AsyncSnapshot<TaskListStream> snapshot) {
    return monthPicker(snapshot.data.selectedDate);
  }

  Widget monthPicker(DateTime selectedDate) {
    return FieldMonthPicker(
        param: MonthPickerParam(selectedDate, null),
        onChanged: (param) {
          if (param.selectedDate == null) {
            return;
          }
          this.selectedDate = param.selectedDate;
          _getData();
        });
  }
}