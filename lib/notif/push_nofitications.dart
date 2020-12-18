import 'package:assignment_dashboard/resource/repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      var repository = Repository();
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      print("FirebaseMessaging token: $token");
      repository.saveToken(token);

      _initialized = true;
    }
  }
  Future<void> resetToken() async {
    await _firebaseMessaging.deleteInstanceID();
    var repository = Repository();
    String token = await _firebaseMessaging.getToken();
    print("FirebaseMessaging token: $token");
    repository.saveToken(token);
  }

}