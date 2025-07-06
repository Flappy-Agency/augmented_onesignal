import 'augmented_notification.dart';

abstract class AugmentedOneSignalPlatform {
  static AugmentedOneSignalPlatform instance = DefaultAugmentedOneSignalPlatform();

  Future<void> init({required String apiKey});

  Future<bool> hasPushPermission();

  Future<void> requestPushPermission(bool fallbackToSettings);

  Stream<bool> permissionChangeStream();

  Stream<AugmentedNotification> get foregroundNotificationStream;

  Stream<AugmentedNotification> get clickNotificationStream;

  Future<void> login(String userId);

  Future<void> logout();

  Future<void> addTag(String key, String value);

  Future<void> addTags(Map<String, String> tags);

  Future<void> removeTag(String key);

  Future<void> removeTags(List<String> keys);

  Future<void> addUserEmail(String email);

  Future<void> removeUserEmail(String email);
}

/// Default implementation = throws UnsupportedError everywhere
class DefaultAugmentedOneSignalPlatform implements AugmentedOneSignalPlatform {
  @override
  Future<void> init({required String apiKey}) {
    throw UnsupportedError('No implementation found for init()');
  }

  @override
  Future<bool> hasPushPermission() {
    throw UnsupportedError('No implementation found for hasPushPermission()');
  }

  @override
  Future<void> requestPushPermission(bool fallbackToSettings) {
    throw UnsupportedError('No implementation found for requestPushPermission()');
  }

  @override
  Stream<bool> permissionChangeStream() {
    throw UnimplementedError();
  }

  @override
  Stream<AugmentedNotification> get foregroundNotificationStream => throw UnimplementedError();

  @override
  Stream<AugmentedNotification> get clickNotificationStream => throw UnimplementedError();

  @override
  Future<void> login(String userId) => throw UnimplementedError();

  @override
  Future<void> logout() => throw UnimplementedError();

  @override
  Future<void> addTag(String key, String value) => throw UnimplementedError();

  @override
  Future<void> addTags(Map<String, String> tags) => throw UnimplementedError();

  @override
  Future<void> removeTag(String key) => throw UnimplementedError();

  @override
  Future<void> removeTags(List<String> keys) => throw UnimplementedError();

  @override
  Future<void> addUserEmail(String email) => throw UnimplementedError();

  @override
  Future<void> removeUserEmail(String email) => throw UnimplementedError();
}
