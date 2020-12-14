enum Status {
  on_progress,
  finish,
  behind_schedule,
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
  String get description {
    switch (this) {
      case Status.on_progress:
        return 'On Progress';
      case Status.finish:
        return 'Done';
      case Status.behind_schedule:
        return 'Behind Schedule';
      default:
        return null;
    }
  }
}
