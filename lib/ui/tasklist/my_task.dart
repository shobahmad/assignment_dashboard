import 'package:assignment_dashboard/bloc/task/mytask_bloc.dart';
import 'package:assignment_dashboard/bloc/task/tasklist_state.dart';
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/month_picker_param.dart';
import 'package:assignment_dashboard/ui/common/field_month_picker.dart';
import 'package:assignment_dashboard/ui/common/list_item_task.dart';
import 'package:assignment_dashboard/ui/dashboard/division_picker.dart';
import 'package:assignment_dashboard/ui/tasklist/progress_chart.dart';
import 'package:assignment_dashboard/util/date_util.dart';
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
  @override
  void initState() {
    super.initState();
    bloc = MyTaskBloc();
    bloc.getTaskListState(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
     return StreamBuilder(
       stream: bloc.state,
        builder: (context, AsyncSnapshot<TaskListStream> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text('My Task'),
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
      return Column(
        children: [
          parameter(snapshot),
          SizedBox(
            height: 24,
          ),
          Center(
            child: ListTile(
              leading: Icon(Icons.pending_actions, size: 128,),
              title: Text('\n\nThere is no assigmment for selected parameters!'),
              subtitle: Text('Please choose another parameters'),
            ),
          )
        ],
      );
    }

    if (snapshot.data.state == TaskListState.failed) {
      return Column(
        children: [
          parameter(snapshot),
          SizedBox(
            height: 24,
          ),
          Center(
            child: ListTile(
              leading: Icon(Icons.pending_actions, size: 128,),
              title: Text('\nUnfortunatelly, something went wrong!\n${snapshot.data.errorMessage}\n'),
              subtitle: Text('Please try again with another parameters'),
            ),
          )
        ],
      );
    }

    return Column(
      children: [
        parameter(snapshot),
        SizedBox(
          height: 2,
        ),
        ListItemTask(listTask: snapshot.data.taskList, onItemClick: (value) {
          print('Click ${value.taskName}');
          },)
      ],
    );
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

          bloc.getTaskListState(param.selectedDate);
        });
  }
}