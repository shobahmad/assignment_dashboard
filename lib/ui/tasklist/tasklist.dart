import 'package:assignment_dashboard/bloc/task/tasklist_bloc.dart';
import 'package:assignment_dashboard/bloc/task/tasklist_state.dart';
import 'package:assignment_dashboard/ui/tasklist/progress_chart.dart';
import 'package:assignment_dashboard/util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class TaskList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => TaskListWidgetState();

  final String month;
  final String divisionId;
  final String status;

  TaskList(this.month, this.divisionId, this.status);
}

class TaskListWidgetState extends State<TaskList> {
  var bloc;
  @override
  void initState() {
    super.initState();
    bloc = TaskListBloc();
    bloc.getTaskListState(widget.month, widget.divisionId, widget.status);
  }
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("Task List"),
       ),
       body: StreamBuilder(
         stream: bloc.state,
         builder: (context, AsyncSnapshot<TaskListStream> snapshot) {
           if (snapshot.data.state == null || snapshot.data.state == TaskListState.loading) {
             return Center(
                 child: SpinKitThreeBounce(
                   color: Colors.blue,
                   size: 18.0,
                 ));
           }

           return ListView.separated(
             separatorBuilder: (context, index) {
               return Divider(
                 color: Colors.grey,
               );
             },
             itemBuilder: (context, index) {
               return Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ListTile(
                   leading: ProgressChart(percentage: snapshot.data.taskList[index].progress.toDouble()),
                   title: Container(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Expanded(
                               child: TextField(
                                 controller:
                                 TextEditingController(text: DateUtil.formatToyMMMd(snapshot.data.taskList[index].dateStart)),
                                 readOnly: true,
                                 style: TextStyle(fontSize: 12),
                                 decoration: InputDecoration(
                                     border: InputBorder.none,
                                     labelText: 'Start Date'),
                               ),
                             ),
                             Expanded(
                               child: TextField(
                                 controller:
                                 TextEditingController(text: DateUtil.formatToyMMMd(snapshot.data.taskList[index].dateTarget)),
                                 readOnly: true,
                                 style: TextStyle(fontSize: 12),
                                 decoration: InputDecoration(
                                     border: InputBorder.none,
                                     labelText: 'Target Date'),
                               ),
                             ),
                             Expanded(
                               child: TextField(
                                 controller:
                                 TextEditingController(text: DateUtil.formatToyMMMd(snapshot.data.taskList[index].dateFinish)),
                                 readOnly: true,
                                 style: TextStyle(fontSize: 12),
                                 decoration: InputDecoration(
                                     border: InputBorder.none,
                                     labelText: 'Finish Date'),
                               ),
                             )
                           ],
                         ),
                         Text(snapshot.data.taskList[index].taskName,
                             style: TextStyle(
                                 fontSize: 18, fontWeight: FontWeight.bold)),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             Expanded(
                               child: TextField(
                                 controller:
                                 TextEditingController(text: snapshot.data.taskList[index].division),
                                 readOnly: true,
                                 style: TextStyle(fontSize: 12),
                                 decoration: InputDecoration(
                                     border: InputBorder.none,
                                     labelText: 'Division'),
                               ),
                             ),
                             Expanded(
                               child: TextField(
                                 controller:
                                 TextEditingController(text: snapshot.data.taskList[index].pic),
                                 readOnly: true,
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
                   onTap: () {},
                 ),
               );
             },
             itemCount: snapshot.data == null || snapshot.data.taskList == null ? 0 : snapshot.data.taskList.length,
           );
         },
       ),
     );
  }

}