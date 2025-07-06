import 'dart:async';

import 'package:augmented_onesignal_platform_interface/augmented_notification.dart';
import 'package:augmented_onesignal_platform_interface/augmented_onesignal_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/web_onesignal.dart';

class AugmentedOneSignalWeb extends AugmentedOneSignalPlatform {
  static void registerWith(Registrar registrar) {
    AugmentedOneSignalPlatform.instance = AugmentedOneSignalWeb();
  }

  @override
  Future<void> init({required String apiKey}) {
    return initOneSignalJs(apiKey);
  }

  @override
  Future<bool> hasPushPermission() {
    return hasPushPermissionJs();
  }

  @override
  Future<void> requestPushPermission(bool fallbackToSettings) {
    return requestPushPermissionJs(fallbackToSettings);
  }

  @override
  Stream<bool> permissionChangeStream() {
    return permissionChangeStreamWeb;
  }

  @override
  Stream<AugmentedNotification> get foregroundNotificationStream =>
      foregroundNotificationStreamWeb;

  @override
  Stream<AugmentedNotification> get clickNotificationStream =>
      clickNotificationStreamWeb;

  @override
  Future<void> login(String userId) => loginJs(userId);

  @override
  Future<void> logout() => logoutJs();

  @override
  Future<void> addTag(String key, String value) => addTagJs(key, value);

  @override
  Future<void> addTags(Map<String, String> tags) => addTagsJs(tags);

  @override
  Future<void> removeTag(String key) => removeTagJs(key);

  @override
  Future<void> removeTags(List<String> keys) => removeTagsJs(keys);

  @override
  Future<void> addUserEmail(String email) => addUserEmailJs(email);

  @override
  Future<void> removeUserEmail(String email) => removeUserEmailJs(email);
}
