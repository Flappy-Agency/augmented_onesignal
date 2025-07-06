import 'dart:async';

import 'package:augmented_onesignal_platform_interface/augmented_notification.dart';
import 'package:augmented_onesignal_platform_interface/augmented_onesignal_platform_interface.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AugmentedOneSignalMobile extends AugmentedOneSignalPlatform {
  static void registerWith() {
    AugmentedOneSignalPlatform.instance = AugmentedOneSignalMobile();
  }

  final _permissionChangeController = StreamController<bool>.broadcast();
  final _foregroundNotificationController =
      StreamController<AugmentedNotification>.broadcast();
  final _clickNotificationController =
      StreamController<AugmentedNotification>.broadcast();

  @override
  Future<void> init({required String apiKey}) async {
    OneSignal.initialize(apiKey);
    final hasPermission = await hasPushPermission();
    _permissionChangeController.add(hasPermission);
    OneSignal.Notifications.addPermissionObserver((hasPushPermission) {
      _permissionChangeController.add(hasPushPermission);
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      _foregroundNotificationController.add(
        AugmentedNotification(
          notificationId: event.notification.notificationId,
          title: event.notification.title,
          body: event.notification.body,
          additionalData: event.notification.additionalData,
          launchUrl: event.notification.launchUrl,
        ),
      );
    });

    OneSignal.Notifications.addClickListener((event) {
      _clickNotificationController.add(
        AugmentedNotification(
          notificationId: event.notification.notificationId,
          title: event.notification.title,
          body: event.notification.body,
          additionalData: event.notification.additionalData,
          launchUrl: event.notification.launchUrl,
        ),
      );
    });
  }

  @override
  Future<bool> hasPushPermission() async {
    final permissionNative = await OneSignal.Notifications.permissionNative();
    return permissionNative == OSNotificationPermission.authorized;
  }

  @override
  Future<void> requestPushPermission(bool fallbackToSettings) {
    return OneSignal.Notifications.requestPermission(fallbackToSettings);
  }

  @override
  Stream<bool> permissionChangeStream() => _permissionChangeController.stream;

  @override
  Stream<AugmentedNotification> get foregroundNotificationStream =>
      _foregroundNotificationController.stream;

  @override
  Stream<AugmentedNotification> get clickNotificationStream =>
      _clickNotificationController.stream;

  @override
  Future<void> login(String userId) {
    return OneSignal.login(userId);
  }

  @override
  Future<void> logout() {
    return OneSignal.logout();
  }

  @override
  Future<void> addTag(String key, String value) {
    return OneSignal.User.addTagWithKey(key, value);
  }

  @override
  Future<void> addTags(Map<String, String> tags) {
    return OneSignal.User.addTags(tags);
  }

  @override
  Future<void> removeTag(String key) {
    return OneSignal.User.removeTag(key);
  }

  @override
  Future<void> removeTags(List<String> keys) {
    return OneSignal.User.removeTags(keys);
  }

  @override
  Future<void> addUserEmail(String email) {
    return OneSignal.User.addEmail(email);
  }

  @override
  Future<void> removeUserEmail(String email) {
    return OneSignal.User.removeEmail(email);
  }
}
