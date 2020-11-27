import 'package:assignment_dashboard/bloc/dashboard/dashboard_bloc.dart';
import 'package:assignment_dashboard/bloc/dashboard/dashboard_state.dart';
import 'package:flutter/material.dart';

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
    bloc.getDashboarddState();
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
            Widget header = Container();

            return Container(
              color: Colors.white,
              child: Center(
                child: Text('Dashboard Chart'),
              ),
            );
        },
      ),
    );
  }
}