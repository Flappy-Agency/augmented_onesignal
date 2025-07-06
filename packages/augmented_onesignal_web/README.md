# augmented_onesignal_web

Web implementation of [`augmented_onesignal`](https://pub.dev/packages/augmented_onesignal).

It integrates directly with the [OneSignal Web SDK](https://documentation.onesignal.com/docs/web-push-sdk-setup) using JS interop.

## Features

- Initialize OneSignal on web with your app ID
- Request push permission
- Listen for permission changes
- Stream foreground and click notification events
- Manage tags and user login

## Usage

You **do not need to import this package directly**. Instead, depend on:

```yaml
dependencies:
augmented_onesignal: ^<latest-version>