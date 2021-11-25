import 'dart:async';

import 'package:flutter/services.dart';

class Vibrate {
  MethodChannel _channel = MethodChannel('vibrate');
  Duration defaultVibrationDuration = Duration(milliseconds: 500);

  bool vibrating = false;

  /// Vibrate for 500ms on Android, and for the default time on iOS (about 500ms as well)
  void vibrate({Duration? dur, int amplitude = 1}) {
    dur ??= defaultVibrationDuration;
    int setAmp = amplitude * 255;
    _channel.invokeMethod(
      'vibrate',
      {'duration': dur.inMilliseconds, 'amplitude': setAmp},
    );
  }

  void loop({Duration? dur, double amplitude = 1}) {
    dur ??= defaultVibrationDuration;
    int setAmp = (amplitude * 255).toInt();
    _channel.invokeMethod(
      'loop',
      {'duration': dur.inMilliseconds, 'amplitude': setAmp},
    );
  }

  /// Whether the device can actually vibrate or not
  Future<bool> get canVibrate async {
    final bool isOn = await _channel.invokeMethod('canVibrate');
    return isOn;
  }

  /// Vibrates with [pauses] in between each vibration
  /// Will always vibrate once before the first pause
  /// and once after the last pause

  void stopVibration() {
    _channel.invokeMethod('cancel');
    vibrating = false;
  }

  Future vibrateWithPauses(Iterable<Duration> pauses) async {
    for (final Duration d in pauses) {
      vibrate();
      //Because the native vibration is not awaited, we need to wait for
      //the vibration to end before launching another one
      await Future.delayed(defaultVibrationDuration);
      await Future.delayed(d);
    }
    vibrate();
  }
}
