import Flutter
import UIKit
import AudioToolbox
import CoreHaptics

@available(iOS 13.0, *)
let hapticManager = HapticEngineManager()
    
public class SwiftVibratePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "vibrate", binaryMessenger: registrar.messenger())
    let instance = SwiftVibratePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch (call.method) {
          case "canVibrate":
      if #available(iOS 13.0, *) {
        result(CHHapticEngine.capabilitiesForHardware().supportsHaptics)
      } else {
        result(false)
      }
      break
          case "loop":
            if #available(iOS 13.0, *) {
            let duration = ((call.arguments as! [String: Any])["duration"]) as! Double;
            let amplitude = (((call.arguments as! [String: Any])["amplitude"]) as! NSNumber).floatValue;    
            hapticManager.createAdvancedPlayer(duration: duration, amplitude: amplitude, result: result)
            }

            case "cancel":
 if #available(iOS 13.0, *) {
             hapticManager.stopAdvancedPlayer()
            }
            break
          default:
              result(FlutterMethodNotImplemented)
      }
    }
}
