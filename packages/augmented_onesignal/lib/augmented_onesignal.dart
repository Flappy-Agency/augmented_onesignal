import 'package:augmented_onesignal_platform_interface/augmented_notification.dart';
import 'package:augmented_onesignal_platform_interface/augmented_onesignal_platform_interface.dart';

class AugmentedOneSignal {
  static Future<void> init({required String apiKey}) {
    return AugmentedOneSignalPlatform.instance.init(apiKey: apiKey);
  }

  static Future<bool> hasPushPermission() {
    return AugmentedOneSignalPlatform.instance.hasPushPermission();
  }

  static Future<void> requestPushPermission(bool fallbackToSettings) {
    return AugmentedOneSignalPlatform.instance.requestPushPermission(fallbackToSettings);
  }

  static Stream<bool> permissionChangeStream() {
    return AugmentedOneSignalPlatform.instance.permissionChangeStream();
  }

  static Stream<AugmentedNotification> get foregroundNotificationStream {
    return AugmentedOneSignalPlatform.instance.foregroundNotificationStream;
  }

  static Stream<AugmentedNotification> get clickNotificationStream {
    return AugmentedOneSignalPlatform.instance.clickNotificationStream;
  }

  static Future<void> login(String userId) {
    return AugmentedOneSignalPlatform.instance.login(userId);
  }

  static Future<void> logout() {
    return AugmentedOneSignalPlatform.instance.logout();
  }

  static Future<void> addTag(String key, String value) {
    return AugmentedOneSignalPlatform.instance.addTag(key, value);
  }

  static Future<void> addTags(Map<String, String> tags) {
    return AugmentedOneSignalPlatform.instance.addTags(tags);
  }

  static Future<void> removeTag(String key) {
    return AugmentedOneSignalPlatform.instance.removeTag(key);
  }

  static Future<void> removeTags(List<String> keys) {
    return AugmentedOneSignalPlatform.instance.removeTags(keys);
  }

  static Future<void> addUserEmail(String email) {
    return AugmentedOneSignalPlatform.instance.addUserEmail(email);
  }

  static Future<void> removeUserEmail(String email) {
    return AugmentedOneSignalPlatform.instance.removeUserEmail(email);
  }
}
