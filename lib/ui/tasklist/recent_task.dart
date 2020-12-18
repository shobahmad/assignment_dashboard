import 'package:assignment_dashboard/bloc/task/recent_task_bloc.dart';
import 'package:assignment_dashboard/bloc/task/recent_task_state.dart';
import 'package:assignment_dashboard/util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RecentTask extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => TaskListWidgetState();

}

class TaskListWidgetState extends State<RecentTask> {
  RecentTaskBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = RecentTaskBloc();
    _getData();
  }
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        title: Text('Recent Updates'),
      ),
      body: StreamBuilder(
        stream: bloc.state,
        builder: (context, AsyncSnapshot<RecentTaskStream> snapshot) {
          if (snapshot.data.state == null ||
              snapshot.data.state == RecentTaskState.loading) {
            return Center(
                child: SpinKitThreeBounce(
              color: Colors.blue,
              size: 18.0,
            ));
          }

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
                  child: TextField(
                      controller: TextEditingController(
                          text: snapshot.data.taskList[index].description),
                      readOnly: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText:
                          DateUtil.formatToyMdHm(snapshot.data.taskList[index].datetime),
                          prefixIcon: Icon(Icons.assignment, color: Colors.green,)
                      )),
                );
              },
              itemCount: snapshot.data.taskList.length,
            ),
          );
        },
      ),
    );
  }

  Future<void> _getData() async {
    bloc.getRecentTaskState();
  }

}