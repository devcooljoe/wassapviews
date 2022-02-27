import 'package:wassapviews/libraries.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' as _priority;

class LocalNotificationService {
  static GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  static final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    final InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );
    notificationsPlugin.initialize(initializationSettings, onSelectNotification: (String? route) async {
      if (route != null) {
        Navigator.pushNamed(_scaffoldKey.currentContext!, route);
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'wassapviews',
          'wassapviews channel',
          importance: Importance.max,
          priority: _priority.Priority.max,
          fullScreenIntent: true,
        ),
      );
      await notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['route'],
      );
    } catch (e) {
      print(e);
    }
  }
}
