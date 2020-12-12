enum Status {
  finish,
  behind_schedule,
  on_progress
}

extension StatusExtension on Status {

  int get value {
    switch (this) {
      case Status.finish:
        return 1;
      case Status.behind_schedule:
        return 2;
      case Status.on_progress:
        return 0;
      default:
        return null;
    }
  }
}
