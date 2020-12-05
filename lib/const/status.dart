enum Status {
  done,
  due,
  on_progress
}

extension StatusExtension on Status {

  int get value {
    switch (this) {
      case Status.done:
        return 1;
      case Status.due:
        return 2;
      case Status.on_progress:
        return 3;
      default:
        return null;
    }
  }
}
