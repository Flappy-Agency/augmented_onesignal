package com.example.augmented_onesignal_mobile

import io.flutter.embedding.engine.plugins.FlutterPlugin

class AugmentedOnesignalMobilePlugin : FlutterPlugin {
  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    AugmentedOneSignalMobile.registerWith()
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    // No-op
  }
}