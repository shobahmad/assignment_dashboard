import 'package:assignment_dashboard/bloc/dashboard/dashboard_bloc.dart';
import 'package:assignment_dashboard/bloc/dashboard/dashboard_state.dart';
import 'package:assignment_dashboard/model/division_model.dart';
import 'package:assignment_dashboard/model/recent_task_model.dart';
import 'package:assignment_dashboard/ui/dashboard/profile_drawer.dart';
import 'package:assignment_dashboard/util/date_util.dart';
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
  DashboardBloc dashboardBloc;
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
                recentTask([]),
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
                recentTask([]),
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
            return ListView(
              shrinkWrap: true,
              children: [
                monthPicker(snapshot.data.selectedDate, snapshot.data.listDivisionModel.first),
                SizedBox(
                  height: 2,
                ),
                division(snapshot.data.listDivisionModel, snapshot.data.selectedDate),
                SizedBox(
                  height: 2,
                ),
                recentTask(snapshot.data.recentTaskModel.listRecentTask),
                SizedBox(
                  height: 2,
                ),
                AssignmentChart(
                    qtyBehindSchedule:
                        snapshot.data.taskDashboardModel.qtyBehindSchedule,
                    qtyDone: snapshot.data.taskDashboardModel.qtyDone,
                    qtyOnProgress:
                        snapshot.data.taskDashboardModel.qtyOnProgress,
                    selectedDate: snapshot.data.selectedDate,
                    divisionId:
                        snapshot.data.listDivisionModel.first.divisionId,
                  divisionDescription: snapshot.data.listDivisionModel.first.divisionDesc,
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
        title: Text(DateUtil.formatToMMMMy(selectedDate)),
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

  Widget recentTask(List<RecentTaskModel> recentTaskModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8,),
        Text(' Recent updates', style: TextStyle(color: Colors.green, fontSize: 16),),
        SizedBox(height: 2,),
        Card(
            color: Colors.white,
            child: recentTaskList(recentTaskModel))
      ],
    );
  }

  Widget recentTaskList(List<RecentTaskModel> recentTaskModel) {
    if (recentTaskModel.isEmpty) {
      return ListTile(
        title: Text('No new recent updates',
            style: TextStyle(color: Colors.blueGrey, fontSize: 16)),
        leading: Icon(Icons.assignment, color: Colors.blueGrey),
      );
    }

    return Column(
      children: [
        ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.grey,
            );
          },
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                  controller: TextEditingController(
                      text: recentTaskModel[index].description),
                  readOnly: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText:
                      DateUtil.formatToyMMMd(recentTaskModel[index].datetime),
                      helperText: 'by ${recentTaskModel[index].usedId}',
                      prefixIcon: Icon(Icons.assignment, color: Colors.green,)
                  )),
            );
          },
          itemCount: recentTaskModel.length,
        ),
        SizedBox(height: 0.3, child: Container(decoration: BoxDecoration(color: Colors.grey),),),
        ListTile(
          title: Text('View all recent updates',
              style: TextStyle(color: Colors.green, fontSize: 12)),
          trailing: Icon(Icons.chevron_right),
          onTap: () {

          },
        )
      ],
    );
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