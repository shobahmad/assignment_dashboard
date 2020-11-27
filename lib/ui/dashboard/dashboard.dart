import 'package:assignment_dashboard/bloc/dashboard/dashboard_bloc.dart';
import 'package:assignment_dashboard/bloc/dashboard/dashboard_state.dart';
import 'package:assignment_dashboard/model/recent_task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import 'assignment_chart.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DashboardScreenState();
  }
}

class DashboardScreenState extends State<DashboardScreen> {
  var bloc;
  @override
  void initState() {
    super.initState();
    bloc = DashboardBloc();
    bloc.getDashboarddState(DateTime.now());
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('User Name'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Task List'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Search'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      )),
      body: StreamBuilder(
        stream: bloc.state,
        builder: (context, AsyncSnapshot<DashboardStream> snapshot) {
          if (snapshot.data.state == null || snapshot.data.state == DashboardState.loading) {
            return Center(
                child: SpinKitThreeBounce(
              color: Colors.blue,
              size: 18.0,
            ));
          }

          if (snapshot.data.state == DashboardState.empty) {
            return Column(
              children: [
                monthPicker(snapshot.data.selectedDate),
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
          if (snapshot.data.state == DashboardState.success) {
            return Column(
              children: [
                monthPicker(snapshot.data.selectedDate),
                SizedBox(
                  height: 2,
                ),
                recentTask(snapshot.data.recentTaskModel),
                SizedBox(
                  height: 2,
                ),
                AssignmentChart(
                    qtyBehindSchedule:
                        snapshot.data.taskSummaryModel.qtyBehindSchedule,
                    qtyDone: snapshot.data.taskSummaryModel.qtyDone,
                    qtyOnProgress: snapshot.data.taskSummaryModel.qtyOnProgress)
              ],
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget monthPicker(DateTime selectedDate) {
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
            bloc.getDashboarddState(date);
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
                  : recentTaskModel.time +
                  ' - ' +
                  recentTaskModel.message,
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
}