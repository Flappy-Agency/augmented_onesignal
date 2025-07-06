# augmented_onesignal_platform_interface

This package defines the common platform interface for the [`augmented_onesignal`](https://pub.dev/packages/augmented_onesignal) plugin.

It contains the abstract class and shared models that must be implemented by platform-specific packages.

## Features

- Defines the `AugmentedOneSignalPlatform` interface
- Contains shared model objects like `AugmentedNotification`

## Usage

This package is **not intended for direct use in apps**. It is a support package for federated implementations:

- [`augmented_onesignal_mobile`](https://pub.dev/packages/augmented_onesignal_mobile)
- [`augmented_onesignal_web`](https://pub.dev/packages/augmented_onesignal_web)