import 'package:assignment_dashboard/bloc/profile/profile_bloc.dart';
import 'package:assignment_dashboard/bloc/profile/profile_state.dart';
import 'package:assignment_dashboard/ui/auth/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileDrawer extends StatefulWidget {
  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {

  ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();

    profileBloc = ProfileBloc();
    profileBloc.getProfileState();
  }

  @override
  void dispose() {
    super.dispose();
    profileBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: profileBloc.state,
      builder: (context, AsyncSnapshot<ProfileStream> snapshot) {
        if (snapshot.data.state == null ||
            snapshot.data.state == ProfileState.loading) {
          return Drawer(
            child: Center(
                child: SpinKitThreeBounce(
                  color: Colors.blue,
                  size: 18.0,
                )),
          );
        }

        if (snapshot.data.state == ProfileState.logout) {
          Future.delayed(const Duration(seconds: 0), () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScreen()));
          });
          return Container();
        }

        return Drawer(
          child: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: <Widget>[
                        DrawerHeader(
                          margin: EdgeInsets.all(0.0),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.person, size: 48),
                                SizedBox(height: 8),
                                Text(snapshot.data.accountModel.getName())
                              ],
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.assignment),
                          title: Text("Task List"),
                          onTap: () {
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.search),
                          title: Text("Search"),
                          onTap: () {},
                        ),
                        const Expanded(child: SizedBox()),
                        const Divider(height: 1.0, color: Colors.grey),
                        ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: Text("Logout"),
                          onTap: () {
                            profileBloc.logout();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
