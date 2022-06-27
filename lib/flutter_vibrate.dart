import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class Vibrate {
  MethodChannel _channel = MethodChannel('vibrate');
  Duration defaultVibrationDuration = Duration(milliseconds: 500);

  Future<bool> loop({int frequency = 30, double amplitude = 1}) async {
    bool feedback = false;
    if (Platform.isIOS) {
      double getTime = (((1000 / frequency / 2) * 1000) / 1000000);
      feedback = await _channel.invokeMethod(
        'loop',
        {'duration': getTime, 'amplitude': amplitude},
      );
    } else {
      //Android
      int setAmp = amplitude.toInt();
      int getTime = (1000 / frequency ~/ 2);
      setAmp = (amplitude * 255).toInt();
      feedback = await _channel.invokeMethod(
        'loop',
        {'duration': getTime, 'amplitude': setAmp},
      );
    }
    int cycleTime = ((1000 / frequency / 2) * 1000).toInt();
    await Future.delayed(Duration(microseconds: cycleTime));
    return feedback;
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
  }
}
