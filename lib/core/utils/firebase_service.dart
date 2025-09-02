import 'dart:async';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_planner/core/utils/common_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';

@pragma('vm:entry-point')
Future<void> onBackGroundHandler(RemoteMessage msg) async {
  appDebugPrint("push Notification title ${msg.toString()}");
}

void showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'default_channel_id',
        'Default Channel',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: DarwinNotificationDetails(),
  );

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
    payload: 'item x',
  );
}

// Local notifications setup
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FirebaseService {
  FirebaseService();

  static Future<User?> signInWithGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      // ensure signed out first
      await googleSignIn.signOut();
      // Start the Google sign-in flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final userCredential = await auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error in Google Sign-In: $e");
      return null;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fireBaseUserChange() {
    return FirebaseFirestore.instance
        .collection('day-plan')
        .where('uID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchInit() async {
    final snapShot = await FirebaseFirestore.instance
        .collection('day-plan')
        .where('uID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    return snapShot;
  }

  // for notification
  static Future<void> initFirebaseMessage() async {
    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitSettings =
    DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid, iOS: iosInitSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onBackgroundMessage(onBackGroundHandler);

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    messaging.requestPermission(alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      appDebugPrint(
        'Foreground message received: ${message.notification?.title}',
      );
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      appDebugPrint('Notification opened: ${message.notification?.title}');
    });
    // get token
    if (Platform.isAndroid) {
      String? token = await FirebaseMessaging.instance.getToken();
      appDebugPrint("FCM Token (Android): $token");
    } else if (Platform.isIOS) {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      appDebugPrint("APNS Token: $apnsToken");
      if (apnsToken != null) {
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        appDebugPrint("FCM Token (iOS): $fcmToken");
      }
    }
  }
}
