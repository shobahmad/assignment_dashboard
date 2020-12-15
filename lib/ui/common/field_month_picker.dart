import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/month_picker_param.dart';
import 'package:assignment_dashboard/util/date_util.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class FieldMonthPicker extends StatefulWidget {
  final ValueChanged<MonthPickerParam> onChanged;
  MonthPickerParam param;
  
  FieldMonthPicker({Key key, this.param, this.onChanged}) : super(key: key);

  @override
  _FieldMonthPickerState createState() => _FieldMonthPickerState();
}


class _FieldMonthPickerState extends State<FieldMonthPicker> {

  _FieldMonthPickerState();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        title: Text(
          DateUtil.formatToMMMMy(widget.param.selectedDate),
          style: TextStyle(fontSize: 12),
        ),
        leading: Icon(Icons.calendar_today, color: Colors.blue),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          showMonthPicker(
                  context: context,
                  firstDate: DateTime(DateTime.now().year - 1, 5),
                  lastDate: DateTime.now(),
                  initialDate: widget.param.selectedDate)
              .then((date) {
            if (date == null) {
              return;
            }
            widget.onChanged.call(MonthPickerParam(date, widget.param.divisionModel));
          });
        },
      ),
    );
  }
}


class DropDownValue {
  final String value;
  final String name;

  DropDownValue(this.value, this.name);
}