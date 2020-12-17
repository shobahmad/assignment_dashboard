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

             return Column(
               crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: ProgressChart(
                        percentage:
                        snapshot.data.taskDetail.progressPercent.toDouble()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(
                                    text: DateUtil.formatToyMMMd(snapshot.data.taskDetail.dateStart)),
                                readOnly: true,
                                style: TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Start Date'),
                              ),
                            ),
                            separator(),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(
                                    text: DateUtil.formatToyMMMd(snapshot.data.taskDetail.dateTarget)),
                                readOnly: true,
                                style: TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Target Date'),
                              ),
                            ),
                            separator(),
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(
                                    text: DateUtil.formatToyMMMd(snapshot.data.taskDetail.dateFinish)),
                                readOnly: true,
                                style: TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Finish Date'),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    title: TextField(
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
                snapshot.data.allowUpdate
                    ? inputProgress(snapshot.data.taskDetail.progressPercent)
                    : Container(),
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
                  height: 8,
                ),
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.grey,
                      );
                    },
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          SizedBox(width: 16,),
                          Expanded(
//                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(DateUtil.formatToyMdHms(snapshot.data
                                    .taskDetail.progress[index].datetime), style: TextStyle(
                                    fontSize: 10)),
                                SizedBox(height: 6,),
                                Text(
                                    snapshot.data.taskDetail.progress[index]
                                        .progressDescription,
                                    style: TextStyle(
                                        fontSize: 14, fontWeight: FontWeight.bold)),
                                SizedBox(height: 2,),
                                Text(
                                  '${snapshot.data.taskDetail.progress[index].progressPercent}%',
                                  style: TextStyle(fontSize: 18),
                                )
                              ],
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
                      );
                    },
                    itemCount: snapshot.data.taskDetail.progress.length,
                  ),
                )
              ],
            );
          },
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