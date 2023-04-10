import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notification = FlutterLocalNotificationsPlugin();

class SimpleNotificataion {
  Future showNotification({int id = 0, String? title, String? body, String? payload}) async {
    return notification.show(
      id, //identify notification uniquely
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  Future _notificationDetails() async {
    //specify how the notification will look like in android and ios
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          //in android, our notification  is linked to a channel
          'pushnotificationapp',
          'pushnotificationappchannel',
          channelDescription: 'channel.description',
          ledColor: Color.fromARGB(255, 111, 178, 255),
          ledOffMs: 1,
          ledOnMs: 1,
          icon: 'logo',
          color: Color.fromARGB(255, 111, 178, 255),
          colorized: true,
          largeIcon: DrawableResourceAndroidBitmap('logo'),
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails());
  }
}
