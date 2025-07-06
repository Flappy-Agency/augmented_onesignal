@JS('OneSignal')
library;

import 'dart:async';
import 'dart:js_interop' show JS, JSAny;

import 'package:augmented_onesignal_platform_interface/augmented_notification.dart';
import 'package:universal_html/js_util.dart' as js_util;

@JS()
// ignore: non_constant_identifier_names
external JSAny get OneSignal;

bool _foregroundListenerSetup = false;
bool _clickListenerSetup = false;

final _permissionChangeController = StreamController<bool>.broadcast();
final _foregroundNotificationController = StreamController<AugmentedNotification>.broadcast();
final _clickNotificationController = StreamController<AugmentedNotification>.broadcast();

Future<void> initOneSignalJs(String apiKey) {
  if (apiKey.isEmpty) {
    throw Exception('Missing OneSignal API key');
  }

  return _runOneSignalDeferred<void>((os) async {
    final options = js_util.jsify({
      'appId': apiKey,
      'serviceWorkerParam': {'scope': '/onesignal/'},
      'serviceWorkerPath': 'onesignal/OneSignalSDKWorker.js',
    });

    await js_util.promiseToFuture<void>(js_util.callMethod(os, 'init', [options]));
    await _setupPermissionChangeListener();
    await _setupForegroundNotificationListener();
    await _setupClickNotificationListener();
  });
}

Future<bool> hasPushPermissionJs() {
  return _runOneSignalDeferred<bool>((os) async {
    final notifications = js_util.getProperty(os, 'Notifications');
    if (notifications == null) {
      throw Exception('OneSignal.Notifications is not available – did you call init()?');
    }

    final permission = js_util.getProperty(notifications, 'permission');
    return (permission == true);
  });
}

Future<void> requestPushPermissionJs(_) {
  return _runOneSignalDeferred<void>((os) async {
    final notifications = js_util.getProperty(os, 'Notifications');
    if (notifications == null) {
      throw Exception('OneSignal.Notifications is not available – did you call init()?');
    }

    final result = js_util.callMethod(notifications, 'requestPermission', []);
    if (result != null) {
      await js_util.promiseToFuture<void>(result);
    }
  });
}

Stream<bool> get permissionChangeStreamWeb => _permissionChangeController.stream.distinct();

Stream<AugmentedNotification> get foregroundNotificationStreamWeb =>
    _foregroundNotificationController.stream.distinct();

Stream<AugmentedNotification> get clickNotificationStreamWeb => _clickNotificationController.stream;

Future<void> loginJs(String externalId) {
  if (externalId.isEmpty) {
    throw Exception('External ID must not be empty');
  }

  return _runOneSignalDeferred<void>((os) async {
    final result = js_util.callMethod(os, 'login', [externalId]);
    if (result != null) {
      await js_util.promiseToFuture<void>(result);
    }
  });
}

Future<void> logoutJs() {
  return _runOneSignalDeferred<void>((os) async {
    final result = js_util.callMethod(os, 'logout', []);
    if (result != null) {
      await js_util.promiseToFuture<void>(result);
    }
  });
}

Future<void> addTagJs(String key, String value) {
  if (key.isEmpty) throw Exception('Key must not be empty');
  if (value.isEmpty) throw Exception('Value must not be empty');

  return _runOneSignalDeferred<void>((os) async {
    final user = js_util.getProperty(os, 'User');
    if (user == null) throw Exception('OneSignal.User is not available');

    final result = js_util.callMethod(user, 'addTag', [key, value]);
    if (result != null) {
      await js_util.promiseToFuture<void>(result);
    }
  });
}

Future<void> addTagsJs(Map<String, String> tags) {
  if (tags.isEmpty) return Future.value();

  return _runOneSignalDeferred<void>((os) async {
    final user = js_util.getProperty(os, 'User');
    if (user == null) throw Exception('OneSignal.User is not available');

    final jsTags = js_util.jsify(tags);

    final result = js_util.callMethod(user, 'addTags', [jsTags]);
    if (result != null) {
      await js_util.promiseToFuture<void>(result);
    }
  });
}

Future<void> removeTagJs(String key) {
  if (key.isEmpty) throw Exception('Key must not be empty');

  return _runOneSignalDeferred<void>((os) async {
    final user = js_util.getProperty(os, 'User');
    if (user == null) throw Exception('OneSignal.User is not available');

    final result = js_util.callMethod(user, 'removeTag', [key]);
    if (result != null) {
      await js_util.promiseToFuture<void>(result);
    }
  });
}

Future<void> removeTagsJs(List<String> keys) {
  if (keys.isEmpty) return Future.value();

  return _runOneSignalDeferred<void>((os) async {
    final user = js_util.getProperty(os, 'User');
    if (user == null) throw Exception('OneSignal.User is not available');

    final jsKeys = js_util.jsify(keys);

    final result = js_util.callMethod(user, 'removeTags', [jsKeys]);
    if (result != null) {
      await js_util.promiseToFuture<void>(result);
    }
  });
}

Future<void> addUserEmailJs(String email) {
  if (email.isEmpty) throw Exception('Email must not be empty');

  return _runOneSignalDeferred<void>((os) async {
    final user = js_util.getProperty(os, 'User');
    if (user == null) throw Exception('OneSignal.User is not available');

    final result = js_util.callMethod(user, 'addEmail', [email]);
    if (result != null) {
      await js_util.promiseToFuture<void>(result);
    }
  });
}

Future<void> removeUserEmailJs(String email) {
  return _runOneSignalDeferred<void>((os) async {
    final user = js_util.getProperty(os, 'User');
    if (user == null) throw Exception('OneSignal.User is not available');

    final result = js_util.callMethod(user, 'removeEmail', [email]);
    if (result != null) {
      await js_util.promiseToFuture<void>(result);
    }
  });
}

Future<void> _setupPermissionChangeListener() async {
  await _runOneSignalDeferred<void>((os) async {
    final notifications = js_util.getProperty(os, 'Notifications');
    if (notifications == null) {
      throw Exception('OneSignal.Notifications is not available – did you call init()?');
    }

    // Get initial permission state
    final hasPermission = await hasPushPermissionJs();
    _permissionChangeController.add(hasPermission);

    js_util.callMethod(notifications, 'addEventListener', [
      'permissionChange',
      js_util.allowInterop((permission) {
        if (permission is bool) {
          _permissionChangeController.add(permission);
        }
      }),
    ]);
  });
}

Future<void> _setupForegroundNotificationListener() async {
  if (_foregroundListenerSetup) return;
  _foregroundListenerSetup = true;

  await _runOneSignalDeferred<void>((os) async {
    final notifications = js_util.getProperty(os, 'Notifications');
    if (notifications == null) return;

    js_util.callMethod(notifications, 'addEventListener', [
      'foregroundWillDisplay',
      js_util.allowInterop((event) {
        try {
          final notif = js_util.getProperty(event, 'notification');
          if (notif == null) return;

          final rawMap = js_util.dartify(notif) as Map<Object?, Object?>;
          final notifMap = _normalizeMap(rawMap);

          final notificationId = notifMap['notificationId']?.toString() ?? '';
          final title = notifMap['title']?.toString();
          final body = notifMap['body']?.toString();
          final additionalDataMap = notifMap['additionalData'] as Map<String, dynamic>?;
          final launchUrl = notifMap['launchURL']?.toString();

          final augmented = AugmentedNotification(
            notificationId: notificationId,
            title: title,
            body: body,
            additionalData: additionalDataMap,
            launchUrl: launchUrl,
          );

          _foregroundNotificationController.add(augmented);
        } catch (e) {
          // Optionally log error
        }
      }),
    ]);
  });
}

Future<void> _setupClickNotificationListener() async {
  if (_clickListenerSetup) return;
  _clickListenerSetup = true;

  await _runOneSignalDeferred<void>((os) async {
    final notifications = js_util.getProperty(os, 'Notifications');
    if (notifications == null) return;

    js_util.callMethod(notifications, 'addEventListener', [
      'click',
      js_util.allowInterop((event) {
        final notif = js_util.getProperty(event, 'notification');
        if (notif == null) return;

        // Safe parsing
        final rawMap = js_util.dartify(notif) as Map<Object?, Object?>;
        final notifMap = _normalizeMap(rawMap);

        final notificationId = notifMap['notificationId']?.toString() ?? '';
        final title = notifMap['title']?.toString();
        final body = notifMap['body']?.toString();
        final additionalDataMap = notifMap['additionalData'] as Map<String, dynamic>?;
        final launchUrl = notifMap['launchURL']?.toString();

        final augmented = AugmentedNotification(
          notificationId: notificationId,
          title: title,
          body: body,
          additionalData: additionalDataMap,
          launchUrl: launchUrl,
        );

        _clickNotificationController.add(augmented);
      }),
    ]);
  });
}

Future<T> _runOneSignalDeferred<T>(Future<T> Function(JSAny os) action) async {
  final deferred = js_util.getProperty(js_util.globalThis, 'OneSignalDeferred');
  if (deferred == null) {
    throw Exception('OneSignalDeferred is not defined in index.html');
  }

  final completer = Completer<T>();

  js_util.callMethod(deferred, 'push', [
    js_util.allowInterop((os) {
      final future = () async {
        final result = await action(os);
        completer.complete(result);
      }();

      future.catchError((e) {
        completer.completeError(e);
      });
    }),
  ]);

  return completer.future;
}

Map<String, dynamic> _normalizeMap(Map<Object?, Object?> raw) {
  return raw.map((key, value) {
    final k = key?.toString() ?? '';
    dynamic v = value;
    if (v is Map<Object?, Object?>) {
      v = _normalizeMap(v);
    }
    return MapEntry(k, v);
  });
}
