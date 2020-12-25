import 'package:assignment_dashboard/model/task_progress_model.dart';
import 'package:assignment_dashboard/util/date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UpdateProgress extends StatefulWidget {

  TaskProgressModel progressModel;
  String taskTitle;
  String taskDescription;

  UpdateProgress(this.progressModel, this.taskTitle, this.taskDescription);

  @override
  State<StatefulWidget> createState() => UpdateProgressState(this.progressModel.progressPercent, this.progressModel.progressDescription);

}

class UpdateProgressState extends State<UpdateProgress> {
  bool _updateTaskEnabled = true;
  int _progressValue;
  String _progressNotes = '';

  UpdateProgressState(this._progressValue, this._progressNotes);

  @override
  Widget build(BuildContext context) {
    return form(true);
  }

  Widget form(bool loading) {
    TextEditingController textProgressController = new TextEditingController(
        text: _progressValue.toString()
    );
    TextEditingController textNotesController = new TextEditingController(text: _progressNotes);

    return Scaffold(
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
            Text(DateUtil.formatToyMdHm(widget.progressModel.datetime), style: TextStyle(
                fontSize: 14)),
            SizedBox(
              height: 16,
            ),
            TextField(
              enabled: !loading,
              onChanged: (value) {
                EasyDebounce.debounce('debouncer1', Duration(milliseconds: 500), () {
                  setState(() {
                    int progressInput = value.trim().isEmpty ? 0 : int.parse(value);
                    _updateTaskEnabled = progressInput <= 100;
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
            ),
            SizedBox(height: 16),
            TextField(
              enabled: !loading,
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
            )
          ],
        ),
      ),
      bottomSheet: loading ? Container(height: 42, child: SpinKitThreeBounce(
        color: Colors.blue,
        size: 18.0,
      ),) : RaisedButton(
        color: Colors.lightBlue,
        textColor: Colors.white,
        onPressed: loading ? null : () {

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListTile(
                title: Text('Update', style: TextStyle(color: Colors.white),),
                trailing: Icon(Icons.check, color: Colors.white,),
              ),
            )
          ],),
      ),
    );
  }

}