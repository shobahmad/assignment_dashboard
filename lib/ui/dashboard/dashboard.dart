import 'package:assignment_dashboard/bloc/dashboard/dashboard_bloc.dart';
import 'package:assignment_dashboard/bloc/dashboard/dashboard_state.dart';
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/recent_task_model.dart';
import 'package:assignment_dashboard/ui/dashboard/profile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'assignment_chart.dart';
import 'division_picker.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardScreenState();
  }
}

class DashboardScreenState extends State<DashboardScreen> {
  var dashboardBloc;
  @override
  void initState() {
    super.initState();
    dashboardBloc = DashboardBloc();
    dashboardBloc.getDashboardState(DateTime.now(), null);
  }

  @override
  void dispose() {
    dashboardBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      drawer: ProfileDrawer(),
      body: StreamBuilder(
        stream: dashboardBloc.state,
        builder: (context, AsyncSnapshot<DashboardStream> snapshot) {
          if (snapshot.data == null || snapshot.data.state == null || snapshot.data.state == DashboardState.loading) {
            return Center(
                child: SpinKitThreeBounce(
              color: Colors.blue,
              size: 18.0,
            ));
          }

          if (snapshot.data.state == DashboardState.empty) {
            return Column(
              children: [
                monthPicker(snapshot.data.selectedDate, snapshot.data.listDivisionModel.first),
                SizedBox(
                  height: 2,
                ),
                recentTask(snapshot.data.recentTaskModel),
                SizedBox(
                  height: 24,
                ),
                Center(
                  child: ListTile(
                    leading: Icon(Icons.pending_actions, size: 128,),
                    title: Text('\n\nThere is no assigmment for selected month!'),
                    subtitle: Text('Please choose another month'),
                  ),
                )
              ],
            );
          }

          if (snapshot.data.state == DashboardState.failed) {
            return Column(
              children: [
                monthPicker(snapshot.data.selectedDate, snapshot.data.listDivisionModel == null ? null : snapshot.data.listDivisionModel.first),
                SizedBox(
                  height: 2,
                ),
                division(snapshot.data.listDivisionModel, snapshot.data.selectedDate),
                SizedBox(
                  height: 2,
                ),
                recentTask(snapshot.data.recentTaskModel),
                SizedBox(
                  height: 24,
                ),
                Center(
                  child: ListTile(
                    leading: Icon(Icons.pending_actions, size: 128,),
                    title: Text('\nUnfortunatelly, something went wrong!\n${snapshot.data.taskDashboardModel.errorMessage}'),
                    subtitle: Text('Please try again later'),
                  ),
                )
              ],
            );
          }
          if (snapshot.data.state == DashboardState.success) {
            return Column(
              children: [
                monthPicker(snapshot.data.selectedDate, snapshot.data.listDivisionModel.first),
                SizedBox(
                  height: 2,
                ),
                division(snapshot.data.listDivisionModel, snapshot.data.selectedDate),
                SizedBox(
                  height: 2,
                ),
                recentTask(snapshot.data.recentTaskModel),
                SizedBox(
                  height: 2,
                ),
                AssignmentChart(
                    qtyBehindSchedule:
                        snapshot.data.taskDashboardModel.qtyBehindSchedule,
                    qtyDone: snapshot.data.taskDashboardModel.qtyDone,
                    qtyOnProgress: snapshot.data.taskDashboardModel.qtyOnProgress,
                    month: snapshot.data.selectedDate.month.toString(),
                    divisionId: snapshot.data.listDivisionModel.first.divisionId,
                )
              ],
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget monthPicker(DateTime selectedDate, DivisionModel divisionModel) {
    return Card(
      color: Colors.white,
      child: ListTile(
        title: Text(new DateFormat('MMMM y')
            .format(selectedDate)),
        leading: Icon(Icons.calendar_today),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          showMonthPicker(
              context: context,
              firstDate: DateTime(DateTime.now().year - 1, 5),
              lastDate: DateTime.now(),
              initialDate: selectedDate
          ).then((date) {
            if (date == null) {
              return;
            }
            dashboardBloc.getDashboardState(date, divisionModel);
          });
        },
      ),
    );
  }

  Widget recentTask(RecentTaskModel recentTaskModel) {
    return Card(
        color: Colors.white,
        child: ListTile(
          title: Text(
              recentTaskModel == null
                  ? 'No new task updates'
                  : recentTaskModel.datetime +
                  ' - ' +
                  recentTaskModel.description,
              style: TextStyle(
                  color: recentTaskModel == null
                      ? Colors.blueGrey
                      : Colors.green,
                  fontSize: 16)),
          leading: Icon(Icons.assignment,
              color: recentTaskModel == null
                  ? Colors.blueGrey
                  : Colors.green),
          onTap: () {},
        ));
  }

  Widget division(List<DivisionModel> listDivisions, DateTime selectedDate) {
    return Card(
        color: Colors.white,
        child: ListTile(
            title: DivisionPicker(listDivisions: listDivisions, onChange: (selectedDivision) {
              dashboardBloc.getDashboardState(selectedDate, selectedDivision);
            },),
            leading: Icon(Icons.group),
            trailing: Icon(Icons.chevron_right)));
  }
}