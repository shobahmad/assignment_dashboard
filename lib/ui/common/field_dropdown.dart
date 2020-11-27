import 'package:flutter/material.dart';

class DropdownField extends StatefulWidget {
  final DropDownValue defaultValue;
  final List<DropDownValue> values;
  final String label;
  final Icon icon;
  final bool enabled;
  final ValueChanged<DropDownValue> onChanged;
  DropdownField({Key key, this.defaultValue, this.values, this.label, this.icon, this.enabled = true, this.onChanged}) : super(key: key);

  @override
  _DropdownFieldState createState() => _DropdownFieldState(this.defaultValue);
}

class _DropdownFieldState extends State<DropdownField> {
  DropDownValue value;
  String dropdownValue;

  _DropdownFieldState(this.value);

  @override
  Widget build(BuildContext context) {
    List<String> items = List();
    Map mapValue = Map();
    widget.values.forEach((element) {
      items.add(element.value);
      mapValue.putIfAbsent(element.value, () => element.name);
    });

    if (!widget.enabled) {
      return DropdownButtonFormField<String>(
        value: widget.defaultValue.value,
        decoration: InputDecoration(
            filled: false,
            icon: widget.icon,
            hintText: widget.defaultValue.name,
            labelText: widget.label,
            prefixText: widget.defaultValue.name),
        items: [],
        onChanged: (value) {
        },
      );
    }

    return DropdownButtonFormField<String>(
      value: value.value,
      decoration: InputDecoration(
          filled: false,
          icon: widget.icon,
          hintText: widget.label,
          labelText: widget.label,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          value = DropDownValue(newValue, mapValue[newValue]);
          widget.onChanged.call(value);
        });
      },
      items: items
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Flexible(
            child: Container(
              child: Text(
                mapValue[value],
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      }).toList(),
    );

  }
}


class DropDownValue {
  final String value;
  final String name;

  DropDownValue(this.value, this.name);
}