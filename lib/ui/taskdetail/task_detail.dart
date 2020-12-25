import 'package:assignment_dashboard/bloc/task/task_detail_bloc.dart';
import 'package:assignment_dashboard/bloc/task/task_detail_state.dart';
import 'package:assignment_dashboard/const/status.dart';
import 'package:assignment_dashboard/ui/tasklist/progress_chart.dart';
import 'package:assignment_dashboard/util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:easy_debounce/easy_debounce.dart';

class TaskDetail extends StatefulWidget {
  final int taskId;
  final String taskName;
  final Status taskStatus;

  @override
  State<StatefulWidget> createState() => TaskListWidgetState();

  const TaskDetail({Key key, this.taskId, this.taskName, this.taskStatus});
}

class TaskListWidgetState extends State<TaskDetail> {
  TaskDetailBloc bloc;
  bool _updateTaskEnabled = true;
  int _progressValue;
  String _progressNotes = '';
  bool _autoComplete = false;
  Status _status;

  @override
  void initState() {
    super.initState();
    bloc = TaskDetailBloc();
    _status = widget.taskStatus;
    _getData();
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
               return RefreshIndicator(
                 onRefresh: _getData,
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.pending_actions,
                        size: 128,
                      ),
                      title: Text(
                          '\nUnfortunatelly, something went wrong!\n${snapshot.data.errorMessage}\n'),
                      subtitle: Text('Please try again later'),
                    )
                  ],
                ),
              );
            }

             return RefreshIndicator(
               onRefresh: _getData,
               child: ListView(
                 shrinkWrap: true,
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: ListTile(
                       leading: ProgressChart(
                           percentage:
                           snapshot.data.taskDetail.progressPercent.toDouble(),
                       status: _status,),
                       title: Column(
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
                       subtitle: Column(
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Expanded(
                                 child: TextField(
                                   controller: TextEditingController(
                                       text:
                                       snapshot.data.taskDetail.division),
                                   enabled: false,
                                   maxLines: null,
                                   style: TextStyle(fontSize: 12),
                                   decoration: InputDecoration(
                                       border: InputBorder.none,
                                       labelText: 'Division'),
                                 ),
                               ),
                               Expanded(
                                 child: TextField(
                                   controller: TextEditingController(
                                       text: snapshot.data.taskDetail.pic),
                                   enabled: false,
                                   maxLines: null,
                                   style: TextStyle(fontSize: 12),
                                   decoration: InputDecoration(
                                       prefixIcon: Icon(Icons.person_pin),
                                       border: InputBorder.none,
                                       labelText: 'PIC'),
                                 ),
                               )
                             ],
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Expanded(
                                 child: TextField(
                                   controller: TextEditingController(
                                       text:
                                       snapshot.data.taskDetail.category),
                                   enabled: false,
                                   maxLines: null,
                                   style: TextStyle(fontSize: 12),
                                   decoration: InputDecoration(
                                       border: InputBorder.none,
                                       labelText: 'Category'),
                                 ),
                               ),
                               Expanded(
                                 child: Container(),
                               )
                             ],
                           )
                         ],
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
                   ListView.separated(
                     shrinkWrap: true,
                     physics: NeverScrollableScrollPhysics(),
                     separatorBuilder: (context, index) {
                       return Divider(
                         color: Colors.grey,
                       );
                     },
                     itemBuilder: (context, index) {
                       return Row(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           SizedBox(width: 16,),
                           Expanded(
//                            width: 200,
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(DateUtil.formatToyMdHm(snapshot.data
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
                               maxLines: null,
                               style: TextStyle(fontSize: 12),
                               decoration: InputDecoration(
                                   prefixIcon: Icon(Icons.person_pin),
                                   border: InputBorder.none,
                                   labelText: 'PIC'),
                             ),
                           ),
                           snapshot.data.taskDetail.progress[index].editable
                              ? FlatButton(
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {

                                  },
                                )
                              : Container()
                        ],
                       );
                     },
                     itemCount: snapshot.data.taskDetail.progress.length,
                   )
                 ],
               ),
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

  Widget inputProgress(int minValue) {
    TextEditingController textProgressController = new TextEditingController(
        text: (_progressValue == null ? minValue + 1 : _progressValue)
            .toString()
    );
    TextEditingController textNotesController = new TextEditingController(text: _progressNotes);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8,),
        SizedBox(height: 0.3, child: Container(decoration: BoxDecoration(color: Colors.grey),),),
        SizedBox(height: 2,),
        SizedBox(height: 8,),
        Text('    Update Progress', style: TextStyle(color: Colors.green, fontSize: 16),),
        SizedBox(height: 8,),
        Row(
          children: [
            Checkbox(
                value: _autoComplete,
                onChanged: (value) {
                  if (!value) {
                    setState(() {
                      _autoComplete = false;
                      _updateTaskEnabled = true;
                      _progressValue = minValue + 1;
                      _progressNotes = '';
                    });
                    return;
                  }

                  setState(() {
                    _autoComplete = true;
                    _updateTaskEnabled = true;
                    _progressValue = 100;
                    _progressNotes = 'The task has been completed';

                  });

                }),
            Text('Complete this task')
          ],
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 75,
                child: TextField(
                  onChanged: (value) {
                    EasyDebounce.debounce('debouncer1', Duration(milliseconds: 500), () {
                      setState(() {
                        int progressInput = value.trim().isEmpty ? 0 : int.parse(value);
                        _updateTaskEnabled = progressInput > minValue && progressInput <= 100;
                        _progressValue = progressInput;
                      });
                    });
                  },
                  controller: textProgressController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      filled: false,
                      suffix: Text('%'),
                      hintText: 'Progress',
                      labelText: 'Progress',
                      errorText: _updateTaskEnabled ? null : 'Invalid value'
                  ),
                ),),
              SizedBox(width: 6,),
              Expanded(child:
              TextField(
                controller: textNotesController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    filled: false,
                    labelText: 'Progress Information / Issue',
                    hintText: 'Type your progress update here'),
              ),
              ),
              SizedBox(
                width: 6,
              ),
              FloatingActionButton(
                child: Icon(Icons.send),
                onPressed: _updateTaskEnabled ? () {
                  if (int.parse(textProgressController.text) == 100) {
                    _status = Status.finish;
                  }
                  bloc.postUpdate(widget.taskId, textProgressController.text, textNotesController.text);
                } : null,

              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> _getData() async {
    bloc.getTaskDetailState(widget.taskId);
  }
}