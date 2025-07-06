# augmented_onesignal_mobile

Mobile (Android/iOS) implementation of [`augmented_onesignal`](https://pub.dev/packages/augmented_onesignal).

This package wraps the excellent [onesignal_flutter](https://pub.dev/packages/onesignal_flutter) plugin to match the `augmented_onesignal_platform_interface`.

## Features

- Initialize OneSignal with your app ID
- Request push permission
- Listen for permission changes
- Stream foreground and click notification events
- Manage tags and user login

## Usage

You **do not need to import this package directly**. Instead, depend on:

```yaml
dependencies:
  augmented_onesignal: ^<latest-version>