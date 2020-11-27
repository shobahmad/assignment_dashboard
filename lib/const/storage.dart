enum TableKey {
  account
}

extension TableKeyExtension on TableKey {

  String get value {
    switch (this) {
      case TableKey.account:
        return 'account';
      default:
        return null;
    }
  }
}

enum FieldKey {
  account,
  token,
  user
}

extension FieldKeyExtension on FieldKey {

  String get value {
    switch (this) {
      case FieldKey.account:
        return 'account';
      case FieldKey.token:
        return 'token';
      case FieldKey.user:
        return 'user';
      default:
        return null;
    }
  }
}