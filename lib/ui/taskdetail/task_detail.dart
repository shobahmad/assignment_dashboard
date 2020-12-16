import 'package:assignment_dashboard/bloc/task/mytask_bloc.dart';
import 'package:assignment_dashboard/bloc/task/task_detail_bloc.dart';
import 'package:assignment_dashboard/bloc/task/task_detail_state.dart';
import 'package:assignment_dashboard/bloc/task/tasklist_state.dart';
import 'package:assignment_dashboard/model/month_picker_param.dart';
import 'package:assignment_dashboard/ui/common/field_month_picker.dart';
import 'package:assignment_dashboard/ui/common/list_item_task.dart';
import 'package:assignment_dashboard/ui/tasklist/progress_chart.dart';
import 'package:assignment_dashboard/util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TaskDetail extends StatefulWidget {
  final int taskId;
  final String taskName;

  @override
  State<StatefulWidget> createState() => TaskListWidgetState();

  const TaskDetail({Key key, this.taskId, this.taskName});
}

class TaskListWidgetState extends State<TaskDetail> {
  TaskDetailBloc bloc;
  @override
  void initState() {
    super.initState();
    bloc = TaskDetailBloc();
    bloc.getTaskDetailState(widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text(widget.taskName),
       ),
       body: StreamBuilder(
           stream: bloc.state,
           builder: (context, AsyncSnapshot<TaskDetailStream> snapshot) {
             if (snapshot.data.state == null ||
                 snapshot.data.state == TaskDetailState.loading) {
               return Center(
                   child: SpinKitThreeBounce(
                     color: Colors.blue,
                     size: 18.0,
                   ));
             }

             if (snapshot.data.state == TaskDetailState.error) {
               return
                 Center(
                   child: ListTile(
                     leading: Icon(Icons.pending_actions, size: 128,),
                     title: Text('\nUnfortunatelly, something went wrong!\n${snapshot.data.errorMessage}\n'),
                     subtitle: Text('Please try again later'),
                   ),
                 );
             }

             return ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: ProgressChart(
                      percentage:
                          snapshot.data.taskDetail.progressPercent.toDouble()),
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              controller: TextEditingController(
                                  text: DateUtil.formatToyMMMd(
                                      snapshot.data.taskDetail.dateStart)),
                              readOnly: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Start Date'),
                            ),
                            TextField(
                              controller: TextEditingController(
                                  text: DateUtil.formatToyMMMd(
                                      snapshot.data.taskDetail.dateTarget)),
                              readOnly: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Target Date'),
                            ),
                            TextField(
                              controller: TextEditingController(
                                  text: DateUtil.formatToyMMMd(
                                      snapshot.data.taskDetail.dateFinish)),
                              readOnly: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Finish Date'),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(
                              text: snapshot.data.taskDetail.pic),
                          readOnly: true,
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
                ),
                ListTile(
                  title: Text(snapshot.data.taskDetail.taskName,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(snapshot.data.taskDetail.taskDescription,
                      style:
                          TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                ),
                SizedBox(
                  height: 0.3,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '    Recent updates',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
                SizedBox(
                  height: 2,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey,
                    );
                  },
                  itemBuilder: (context, index) {
                    return ListTile(
                      subtitle: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                snapshot.data.taskDetail.progress[index]
                                    .progressDescription,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text(
                              '${snapshot.data.taskDetail.progress[index].progressPercent}%',
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                  text: DateUtil.formatToyMdHms(snapshot.data
                                      .taskDetail.progress[index].datetime)),
                              readOnly: true,
                              maxLines: 2,
                              style: TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.date_range),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController(
                                  text: snapshot
                                      .data.taskDetail.progress[index].userId),
                              readOnly: true,
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
                    );
                  },
                  itemCount: snapshot.data.taskDetail.progress.length,
                ),
                snapshot.data.allowUpdate
                    ? inputProgress(snapshot.data.taskDetail.progressPercent)
                    : Container()
              ],
            );
          },
       )
     );
  }

  Widget inputProgress(int progress) {
    TextEditingController textProgressController = new TextEditingController(text:progress.toString());
    TextEditingController textNotesController = new TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8,),
        SizedBox(height: 0.3, child: Container(decoration: BoxDecoration(color: Colors.grey),),),
        SizedBox(height: 2,),
        SizedBox(height: 8,),
        Text('    Update Progress', style: TextStyle(color: Colors.green, fontSize: 16),),
        SizedBox(height: 8,),
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                child: TextField(
                  maxLength: 3,
                  controller: textProgressController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      filled: false,
                      suffix: Text('%'),
                      hintText: 'Progress',
                      labelText: 'Progress'),
                ),),
              SizedBox(width: 6,),
              Expanded(child:
              TextField(
                maxLength: 255,
                controller: textNotesController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    filled: false,
                    hintText: 'Notes',
                    labelText: 'Notes'),
              ),
              ),
              SizedBox(
                width: 6,
              ),
              FloatingActionButton(
                child: Icon(Icons.send),
                onPressed: () {
                  bloc.postUpdate(widget.taskId, textProgressController.text, textNotesController.text);
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}