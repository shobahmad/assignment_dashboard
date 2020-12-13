import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class ProgressChart extends StatefulWidget {
  final double percentage;

  const ProgressChart({Key key, this.percentage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProgressChartState();
}

class ProgressChartState extends State<ProgressChart> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: PieChart(
        PieChartData(
            pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
              setState(() {
                if (pieTouchResponse.touchInput is FlPanEnd) {
                  touchedIndex = -1;
                } else {
                  touchedIndex = pieTouchResponse.touchedSectionIndex;
                }
              });
            }),
            borderData: FlBorderData(
              show: false,
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 0,
            sections: showingSections()),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 12 : 10;
      final double radius = isTouched ? 32 : 28;

      switch (i) {
        case 1:
          return PieChartSectionData(
            color: Colors.greenAccent,
            value: widget.percentage,
            title: widget.percentage.toInt().toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xff000000)),
            badgeWidget: Container()
          );
        case 0:
          return PieChartSectionData(
            color: const Color(0xFFCFD8DC),
            value: 100 - widget.percentage,
            title: (100 - widget.percentage).toInt().toString() + '%',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xFFCFD8DC)),
          badgeWidget: Container()
          );
        default:
          return null;
      }
    });
  }
}