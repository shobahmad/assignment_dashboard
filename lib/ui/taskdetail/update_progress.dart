import 'package:assignment_dashboard/bloc/task/task_progress_bloc.dart';
import 'package:assignment_dashboard/bloc/task/task_progress_state.dart';
import 'package:assignment_dashboard/model/task_progress_model.dart';
import 'package:assignment_dashboard/util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class UpdateProgress extends StatefulWidget {

  final TaskProgressModel progressModel;
  final String taskTitle;
  final String taskDescription;
  final ValueChanged<String> onDone;
  final bool allowDelete;

  UpdateProgress({Key key, this.progressModel, this.taskTitle, this.taskDescription, this.onDone, this.allowDelete});

  @override
  State<StatefulWidget> createState() => UpdateProgressState(this.progressModel.progressPercent, this.progressModel.progressDescription);

}

class UpdateProgressState extends State<UpdateProgress> {
  int _progressValue;
  String _progressNotes = '';
  TaskProgressBloc bloc;

  UpdateProgressState(this._progressValue, this._progressNotes);

  @override
  void initState() {
    super.initState();
    bloc = TaskProgressBloc();
    bloc.start();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.state,
        builder: (context, AsyncSnapshot<TaskProgressStream> snapshot) {
          if (snapshot.data == null) {
            return form(false, false, null);
          }
          if (snapshot.data.state == null) {
            return form(false, false, null);
          }
          if (snapshot.data.state == TaskProgressState.loading) {
            return form(true, false, null);
          }

          if (snapshot.data.state == TaskProgressState.error) {
            return form(false, false, snapshot.data.errorMessage);
          }

          if (snapshot.data.state == TaskProgressState.success) {
            return form(false, true, null);
          }


          return form(false, false, null);
    });
  }

  Widget form(bool loading, bool success, String errorMessage) {
    TextEditingController textProgressController = new TextEditingController(
        text: _progressValue.toString() + '%'
    );
    TextEditingController textNotesController = new TextEditingController(text: _progressNotes);

    return WillPopScope(
      onWillPop: () async {
        widget.onDone.call('');
        return true;
      },

      child: Scaffold(
        appBar: AppBar(title: Text('Update Progress')),
        body: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(widget.taskTitle,
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Text(widget.taskDescription,
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
                height: 24,
              ),
              ListTile(
                title: Text(DateUtil.formatToyMdHm(widget.progressModel.datetime), style: TextStyle(
                    fontSize: 14)),
                subtitle: TextField(
                  enabled: false,
                  controller: textProgressController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: false,
                      hintText: 'Progress',
                      labelText: 'Progress'
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(height: 16),
              TextField(
                  enabled: !loading && !success,
                  controller: textNotesController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                      filled: false,
                      labelText: 'Progress Information / Issue',
                      hintText: 'Type your progress update here',
                      errorText: errorMessage)
              ),
              SizedBox(height: 28),
              success ? Center(child: Lottie.asset(
                'assets/animation/success-tick.json',
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),
              ) : Container(),
              errorMessage != null ? Center(child: Lottie.asset(
                'assets/animation/failed-cross.json',
                width: 100,
                height: 100,
                fit: BoxFit.fill,
              ),) : Container()
            ],
          ),
        ),
        bottomSheet: loading ? Container(height: 42, child: SpinKitThreeBounce(
          color: Colors.blue,
          size: 18.0,
        ),) : widget.allowDelete && !success ? Row(
          children: [
            Expanded(child: RaisedButton(
              color: Colors.redAccent,
              textColor: Colors.white,
              onPressed: loading ? null : () {
                bloc.postDelete(widget.progressModel.taskId, _progressValue.toString());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Delete', style: TextStyle(color: Colors.white),),
                      trailing: Icon(Icons.delete, color: Colors.white,),
                    ),
                  )
                ],),
            ),),
            SizedBox(width: 1,),
            Expanded(child: RaisedButton(
              color: Colors.lightBlue,
              textColor: Colors.white,
              onPressed: loading ? null : () {
                if (success) {
                  widget.onDone.call('');
                  Navigator.pop(context);
                  return;
                }
                setState(() {
                  _progressNotes = textNotesController.text.toString();
                });
                bloc.postUpdate(widget.progressModel.taskId, _progressValue.toString(), textNotesController.text.toString());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(success ? 'Done' : 'Update', style: TextStyle(color: Colors.white),),
                      trailing: Icon(success ? Icons.check : Icons.send, color: Colors.white,),
                    ),
                  )
                ],),
            ),)
          ],
        ) : RaisedButton(
          color: Colors.lightBlue,
          textColor: Colors.white,
          onPressed: loading ? null : () {
            if (success) {
              widget.onDone.call('');
              Navigator.pop(context);
              return;
            }
            setState(() {
              _progressNotes = textNotesController.text.toString();
            });
            bloc.postUpdate(widget.progressModel.taskId, _progressValue.toString(), textNotesController.text.toString());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: ListTile(
                  title: Text(success ? 'Done' : 'Update', style: TextStyle(color: Colors.white),),
                  trailing: Icon(success ? Icons.check : Icons.send, color: Colors.white,),
                ),
              )
            ],),
        ),
      ),
    );
  }


}