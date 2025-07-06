# augmented_onesignal

A **Flutter federated plugin** providing a unified, platform-agnostic API for OneSignal push notifications.

Supports:

- ✅ Android
- ✅ iOS
- ✅ Web

## Features

- Initialize OneSignal with your app ID
- Request push permission
- Listen for permission changes
- Stream foreground and click notification events
- Manage tags and user login
- Manage user email

## Getting started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  augmented_onesignal: ^<latest-version>
```

## 🧭 Basic Usage
```dart
import 'package:augmented_onesignal/augmented_onesignal.dart';

await AugmentedOneSignal.init(apiKey: '<YOUR_ONESIGNAL_APP_ID>');
await AugmentedOneSignal.requestPushPermission();

AugmentedOneSignal.permissionChangeStream().listen((hasPermission) {
  // React to permission changes
});

AugmentedOneSignal.foregroundNotificationStream.listen((notification) {
  // Handle notification while app is in foreground
});

AugmentedOneSignal.clickNotificationStream.listen((notification) {
  // Handle notification click
});
```

## ⚙️ Platform-specific setup

### ✅ Android & iOS

•	Make sure you follow OneSignal’s official setup guide for native configuration.
•	Our plugin augments the existing OneSignal Flutter SDK but requires that your project is correctly set up with:
•	Correct app ID
•	Firebase Cloud Messaging
•	iOS capabilities (Push Notifications, Background Modes)

### ✅ Web Setup

To use OneSignal Web Push with this plugin.

1️⃣ Import OneSignal SDK in web/index.html

```html
<script src="https://cdn.onesignal.com/sdks/web/v16/OneSignalSDK.page.js" async></script>
<script>
    window.OneSignalDeferred = window.OneSignalDeferred || [];
</script>
```

✅ Explanation:
•	The first script loads the OneSignal Web SDK.
•	The second script initializes OneSignalDeferred, which is required for our plugin to queue calls before OneSignal finishes loading.

Without these lines, Web support will not work correctly.

2️⃣ Include the Service Worker

To enable push notifications on Web, OneSignal requires a Service Worker.

✅ Add OneSignal’s Service Worker to your project

```agsl
web/
  index.html
  onesignal/
    OneSignalSDKWorker.js
```

Make sure the `OneSignalSDKWorker.js` file is located in the `web/onesignal/` directory.
Here is the content of the `OneSignalSDKWorker.js` file:

```javascript
importScripts("https://cdn.onesignal.com/sdks/web/v16/OneSignalSDK.sw.js");
```

## 📌 Notes
•	On Android and iOS, this plugin uses the official onesignal_flutter package under the hood.
•	On Web, it directly wraps the OneSignal JavaScript SDK using Dart’s JS interop.
