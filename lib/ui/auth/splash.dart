import 'package:assignment_dashboard/bloc/auth/splash_bloc.dart';
import 'package:assignment_dashboard/bloc/auth/splash_state.dart';
import 'package:assignment_dashboard/ui/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

import 'login.dart';

SplashBloc bloc;

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    bloc = SplashBloc();
    bloc.getSplashState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: bloc.state,
        builder: (context, AsyncSnapshot<SplashState> snapshot) {
          if (snapshot.hasData && snapshot.data == SplashState.authorized) {
            Future.delayed(const Duration(seconds: 0), () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardScreen()));
            });
            return Container();
          }
          if (snapshot.hasData && snapshot.data == SplashState.unauthorized) {
            Future.delayed(const Duration(seconds: 0), () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            });
          }
          return Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Image(
                          image: AssetImage('assets/images/logo.png'),
                          width: 128))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}