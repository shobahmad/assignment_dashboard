
class DashboardStream {
    DashboardState state;

    DashboardStream(this.state);
}

enum DashboardState {
    empty,
    loading,
    success,
    failed
}