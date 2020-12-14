import 'package:assignment_dashboard/model/division_model.dart';
/// Flutter code sample for DropdownButton

import 'package:flutter/material.dart';

/// This is the stateful widget that the main application instantiates.
class DivisionPicker extends StatefulWidget {
  final List<DivisionModel> listDivisions;
  final Function onChange;


  const DivisionPicker({Key key, this.listDivisions, this.onChange}) : super(key: key);

  @override
  _DivisionPickerState createState() => _DivisionPickerState();
}

class _DivisionPickerState extends State<DivisionPicker> {
  DivisionModel dropdownValue;

  @override
  void initState() {
    dropdownValue = widget.listDivisions.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<DivisionModel>(
      value: dropdownValue,
      iconSize: 0,
      elevation: 24,
      isExpanded: true,
      underline: Container(
        height: 0,
      ),
      onChanged: (DivisionModel newValue) {
        setState(() {
          if (dropdownValue.divisionId == newValue.divisionId) {
            return;
          }
          dropdownValue = newValue;
          widget.onChange.call(newValue);
        });
      },
      items: widget.listDivisions
          .map((value) => DropdownMenuItem<DivisionModel>(
              value: value, child: Text(value.divisionDesc, style: TextStyle(fontSize: 12),)))
          .toList(),
    );
  }
}
