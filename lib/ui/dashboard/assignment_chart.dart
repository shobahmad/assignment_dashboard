import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class AssignmentChart extends StatefulWidget {
  final double qtyBehindSchedule;
  final double qtyOnProgress;
  final double qtyDone;

  const AssignmentChart({Key key, this.qtyBehindSchedule, this.qtyOnProgress, this.qtyDone}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AssignmentChartState();
}

class AssignmentChartState extends State<AssignmentChart> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: PieChart(
        PieChartData(
            pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
              setState(() {
                if (pieTouchResponse.touchInput is FlLongPressEnd ||
                    pieTouchResponse.touchInput is FlPanEnd) {
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
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 14 : 12;
      final double radius = isTouched ? 110 : 100;
      final double widgetSize = isTouched ? 65 : 50;

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.orange,
            value: widget.qtyOnProgress,
            title: '     On Progress',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              widget.qtyOnProgress.toInt().toString(),
              size: widgetSize,
              borderColor: Colors.orange,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: widget.qtyDone,
            title: 'Done',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              widget.qtyDone.toInt().toString(),
              size: widgetSize,
              borderColor: Colors.green,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: widget.qtyBehindSchedule,
            title: '  Behind\n      Schedule',
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
            badgeWidget: _Badge(
              widget.qtyBehindSchedule.toInt().toString(),
              size: widgetSize,
              borderColor: Colors.red,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          return null;
      }
    });
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final double size;
  final Color borderColor;

  const _Badge(
      this.label, {
        Key key,
        @required this.size,
        @required this.borderColor,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Text(this.label),
      ),
    );
  }
}