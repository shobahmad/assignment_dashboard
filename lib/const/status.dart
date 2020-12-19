enum Status {
  on_progress,
  finish,
  behind_schedule,
  unknown
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
      case Status.unknown:
        return 3;
      default:
        return null;
    }
  }
  String get description {
    switch (this) {
      case Status.on_progress:
        return 'On Progress';
      case Status.finish:
        return 'Finish';
      case Status.behind_schedule:
        return 'Behind Schedule';
      case Status.unknown:
        return 'Unknown';
      default:
        return null;
    }
  }
}
