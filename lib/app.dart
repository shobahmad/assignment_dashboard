import 'package:alice/alice.dart';
import 'package:flutter/material.dart';
import 'package:assignment_dashboard/resource/repository.dart';
import 'package:assignment_dashboard/ui/auth/splash.dart';

import 'notif/push_nofitications.dart';

class App extends StatefulWidget {
  static Alice alice = Alice();
  static bool debugHttp = true;

  @override
  State<StatefulWidget> createState() {
    return AppState();
  }

}

class AppState extends State<App> {
  final _repository = Repository();

  @override
  void initState() {
    PushNotificationsManager().init();
    super.initState();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: App.alice.getNavigatorKey(),
      theme: ThemeData.light(),
      home: Scaffold(
        body: SplashScreen(),
      ),
    );
  }

}
