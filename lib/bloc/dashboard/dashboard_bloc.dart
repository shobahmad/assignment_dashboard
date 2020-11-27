import 'dart:async';

import 'dashboard_state.dart';

class DashboardBloc {
  final _dashboardStateFetcher = StreamController<DashboardStream>();

  Stream<DashboardStream> get state => _dashboardStateFetcher.stream;

  getDashboarddState() async {
    _dashboardStateFetcher.sink.add(DashboardStream(DashboardState.loading));
    Future.delayed(const Duration(seconds: 2), () async {
      _dashboardStateFetcher.sink.add(DashboardStream(DashboardState.success));
    });
  }

  dispose() {
    _dashboardStateFetcher.close();
  }
}

final bloc = DashboardBloc();